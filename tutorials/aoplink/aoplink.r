library(SPARQL)
library(flextable)
library(igraph)
# library(networkD3)

## # Installing the SPARQL package from the source file.
## install.packages("path_to_the_file", repos=NULL, type="source")

aop_id <- 37

# SPARQL endpoint URLs
aopwikisparql       <- "https://aopwiki.cloud.vhp4safety.nl/sparql/"
aopdbsparql         <- "http://aopdb.rdf.bigcat-bioinformatics.org/sparql/"
wikipathwayssparql  <- "http://sparql.wikipathways.org/sparql/"

# ChemIdConvert URL
chemidconvert <- "https://chemidconvert.cloud.douglasconnect.com/v1/"

# BridgeDB base URL
bridgedb <- "http://bridgedb.cloud.vhp4safety.nl/"


# Defining all variables as ontology terms present in AOP-Wiki RDF.
title                       <- "dc:title"
webpage                     <- "foaf:page"
creator                     <- "dc:creator"
abstract                    <- "dcterms:abstract"
key_event                   <- "aopo:has_key_event"
molecular_initiating_event  <- "aopo:has_molecular_initiating_event"
adverse_outcome             <- "aopo:has_adverse_outcome"
key_event_relationship      <- "aopo:has_key_event_relationship"
stressor                    <- "ncit:C54571"

# Creating the list of all terms of interest.
list_of_terms <- c(title, webpage, creator, abstract, key_event, 
                   molecular_initiating_event, adverse_outcome, key_event_relationship,
                   stressor)

# Creating a data frame to store the query results. 
aop_info <- data.frame("term"=list_of_terms, "properties"=NA)

# Making the queries for each terms in the selected AOP.
for (i in 1:length(list_of_terms)) {
  term  <- list_of_terms[i] 
  query <- paste0('PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
                  SELECT (group_concat(distinct ?item;separator=";") as ?items)
                  WHERE{
                  ?AOP_URI a aopo:AdverseOutcomePathway;', term, ' ?item.
                  FILTER (?AOP_URI = aop:', aop_id, ')}'
)
  res <- SPARQL(aopwikisparql, query)
  aop_info[i, "properties"] <- res$results$items
}

flextable(aop_info)

key_events <- aop_info[aop_info$term == "aopo:has_key_event", "properties"]
key_events <- unlist(strsplit(key_events, ";"))

mies      <- c()
kes       <- c()
aos       <- c()
kers      <- c()
ke_title  <- list()
# ke_rel    <- list()

for(i in 1:length(key_events)) {
  key_event <- key_events[i]
  
  query <- paste0('SELECT ?MIE_ID ?KE_ID ?AO_ID ?KER_ID ?KE_Title
    WHERE{
    ?KE_URI a aopo:KeyEvent; dcterms:isPartOf ?AOP_URI.
    ?AOP_URI aopo:has_key_event ?KE_URI2; aopo:has_molecular_initiating_event ?MIE_URI; aopo:has_adverse_outcome ?AO_URI; aopo:has_key_event_relationship ?KER_URI.
    ?KE_URI2 rdfs:label ?KE_ID; dc:title ?KE_Title. 
    ?MIE_URI rdfs:label ?MIE_ID.
    ?AO_URI rdfs:label ?AO_ID.
    ?KER_URI rdfs:label ?KER_ID.    
    FILTER (?KE_URI = <', key_event, '>)}
    ') 
  
  res <- SPARQL(aopwikisparql, query)
  res <- res$results
  
  mies  <- append(mies, unique(res$MIE_ID))
  kes   <- append(kes, unique(res$KE_ID))
  aos   <- append(aos, unique(res$AO_ID))
  kers  <- append(kers, unique(res$KER_ID))
  
  ke_title[[i]] <- tapply(res$KE_Title, res$KE_ID, function(x) x[1])
}

mies  <- unique(mies)
kes   <- unique(kes)
aos   <- unique(aos)
kers  <- unique(kers)

# ke_title <- unique(unlist(ke_title))
ke_title <- data.frame("key_event" = names(unlist(ke_title)), 
                  "title" = unlist(ke_title))
ke_title <- ke_title[!duplicated(ke_title), ]
ke_title

# Listing all intermediate KEs that are not MIEs or AOs. 
kes_intermediate <- kes[!(kes %in% mies) & !(kes %in% aos)]

# Creating the AOP plot
# library(SPARQL)
pathway <- list()
for (i in 1:length(kers)) {
  ker   <- kers[i]
  query <- paste0('SELECT ?KE_UP_ID ?KE_DOWN_ID 
                WHERE{
                ?KER_URI a aopo:KeyEventRelationship; rdfs:label ?KER_ID; aopo:has_upstream_key_event ?KE_UP_URI; aopo:has_downstream_key_event ?KE_DOWN_URI.
                ?KE_UP_URI rdfs:label ?KE_UP_ID.
                ?KE_DOWN_URI rdfs:label ?KE_DOWN_ID.
                FILTER (?KER_ID = "', ker, '")}')
  # tmp <- SPARQL(aopwikisparql, query)
  # pathway[[i]] <- tmp$results
  pathway[[i]] <- SPARQL(aopwikisparql, query)$results
  names(pathway)[i] <- ker
}

pathway_plot <- make_graph(edges=unlist(pathway))

pathway_color <- rep(NA, length(names(V(pathway_plot))))
pathway_color[names(V(pathway_plot)) %in% mies]              <- "green"
pathway_color[names(V(pathway_plot)) %in% kes_intermediate]  <- "yellow"
pathway_color[names(V(pathway_plot)) %in% aos]               <- "red"
V(pathway_plot)$color <- pathway_color
par(mar = c(0, 0, 0, 0))
plot(pathway_plot)

# A very basic interactive graph can be created in RStudio with:
# networkD3::simpleNetwork(as.data.frame(matrix(unlist(pathway), 
#                                               byrow=TRUE, ncol=2)))

query <- paste0('PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
                SELECT ?CAS_ID (fn:substring(?CompTox,33) as ?CompTox_ID) ?Chemical_name
                WHERE{
                ?AOP_URI a aopo:AdverseOutcomePathway; ncit:C54571 ?Stressor.
                ?Stressor aopo:has_chemical_entity ?Chemical.
                ?Chemical cheminf:000446 ?CAS_ID; dc:title ?Chemical_name.
                OPTIONAL {?Chemical cheminf:000568 ?CompTox.}
                FILTER (?AOP_URI = aop:', aop_id, ')}
                ')

res <- SPARQL(aopwikisparql, query)
res <- res$results[, c("Chemical_name", "CAS_ID", "CompTox_ID")]

# List of compounds.
res

# CAS-IDs of the compounds
res$CAS_ID
