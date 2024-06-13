
################################################################################
### AOPLink: Extracting and analyzing data related to an AOP of interest

# This is an R script to replicate the AOPLink workflow presented here:
# https://github.com/OpenRiskNet/notebooks/blob/master/AOPLink/Extracting%20and%20analysing%20data%20related%20to%20an%20AOP%20of%20interest.ipynb
################################################################################


################################################################################
### Installing and loading the SPARQL package

# Note that the SPARQL package is available on CRAN only in the archive. So, one
# needs to download the .tar.gz file from the archives (here version 1.16 is 
# used) and install the package from the source file.

# Installing the SPARQL package from the source file. 
# install.packages("path_to_the_file", repos=NULL, type="source")

# Loading the SPARQL package
library(SPARQL)
library(httr)
library(png)
library(magick)
library(flextable)
library(igraph)
library(networkD3)
library(tidyverse)
library(RColorBrewer)
library(ggrepel)
################################################################################


################################################################################
### Defining the AOP of interest

# State the number of the AOP of interest as indicated on AOP-Wiki. Here we use
# AOP with the id number of 37 (https://aopwiki.org/aops/37).
aop_id <- 37
################################################################################


################################################################################
### Setting the service URLs

# SPARQL endpoint URLs.
aopwikisparql       <- "https://aopwiki.cloud.vhp4safety.nl/sparql/"
aopdbsparql         <- "https://aopdb.rdf.bigcat-bioinformatics.org/sparql/"
wikipathwayssparql  <- "https://sparql.wikipathways.org/sparql/"

# ChemIdConvert and CDK Depict URLs.
chemidconvert <- "https://chemidconvert.cloud.douglasconnect.com/v1/"
cdkdepict     <- "https://cdkdepict.cloud.vhp4safety.nl/"

# BridgeDB base URL.
bridgedb <- "https://bridgedb.cloud.vhp4safety.nl/"

# EdelweissData API URL.
edelweiss_api_url <- "https://api.staging.kit.cloud.douglasconnect.com"
################################################################################


################################################################################
### AOP-Wiki RDF

## Creating the overview table

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

### Generating AOP Network

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
pathway <- list()
for (i in 1:length(kers)) {
  ker   <- kers[i]
  query <- paste0('SELECT ?KE_UP_ID ?KE_DOWN_ID 
                WHERE{
                ?KER_URI a aopo:KeyEventRelationship; rdfs:label ?KER_ID; aopo:has_upstream_key_event ?KE_UP_URI; aopo:has_downstream_key_event ?KE_DOWN_URI.
                ?KE_UP_URI rdfs:label ?KE_UP_ID.
                ?KE_DOWN_URI rdfs:label ?KE_DOWN_ID.
                FILTER (?KER_ID = "', ker, '")}')
  pathway[[i]] <- SPARQL(aopwikisparql, query)$results
  names(pathway)[i] <- ker
}

pathway_plot <- make_graph(edges=unlist(pathway))

pathway_color <- rep(NA, length(names(V(pathway_plot))))
pathway_color[names(V(pathway_plot)) %in% mies]              <- "green"
pathway_color[names(V(pathway_plot)) %in% kes_intermediate]  <- "yellow"
pathway_color[names(V(pathway_plot)) %in% aos]               <- "red"
V(pathway_plot)$color <- pathway_color
plot(pathway_plot)

# An interactive graph. 
# https://r-graph-gallery.com/network-interactive.html
# simpleNetwork(as.data.frame(matrix(unlist(pathway), byrow=TRUE, ncol=2)))
simpleNetwork(as.data.frame(matrix(unlist(pathway), byrow=TRUE, ncol=2)), 
              opacity=1, linkColour="orange", nodeColour="green", fontSize=12)

# Also see https://kateto.net/network-visualization

## Query all chemicals that are part of the selected AOP
query <- paste0('PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
                SELECT ?CAS_ID (fn:substring(?CompTox,33) as ?CompTox_ID) ?Chemical_name
                WHERE{
                ?AOP_URI a aopo:AdverseOutcomePathway; ncit:C54571 ?Stressor.
                ?Stressor aopo:has_chemical_entity ?Chemical.
                ?Chemical cheminf:000446 ?CAS_ID; dc:title ?Chemical_name.
                OPTIONAL {?Chemical cheminf:000568 ?CompTox.}
                FILTER (?AOP_URI = aop:', aop_id, ')}
                ')
# Note that the above query is slightly different from the original one. One  
# needs to change "cheminf:CHEMINF_000xxx" to ""cheminf:000xxx" to get the query 
# run.

res <- SPARQL(aopwikisparql, query)
res <- res$results[, c("Chemical_name", "CAS_ID", "CompTox_ID")]

# List of compounds.
res

# CAS-IDs of the compounds
res$CAS_ID


### ChemIdConvert and CDK Depict
compoundstable <- data.frame(CAS_ID=res$CAS_ID, Smiles=NA, InChiKey=NA)

for(i in 1:nrow(compoundstable)) {
  compoundstable$Smiles[i]    <- content(GET(paste0(chemidconvert, "cas/to/smiles?cas=", compoundstable$CAS_ID[i])))$smiles
  compoundstable$InChiKey[i]  <- content(GET(paste0(chemidconvert, "cas/to/inchikey?cas=", compoundstable$CAS_ID[i])))$inchikey
}
compoundstable

for(i in 1:nrow(compoundstable)) {
  tmp <- GET(paste0(cdkdepict, "depict/bot/png?smi=", compoundstable$Smiles[i], "%20", compoundstable$CAS_ID[i], "&showtitle=true&abbr=on&zoom=1.5"))
  writePNG(content(tmp), target=paste0(compoundstable$CAS_ID[i], "_test.png"))
}

par(mfrow=c(4, 2))
for(i in 1:nrow(compoundstable)){
  img <- image_read(paste0(compoundstable$CAS_ID[i], "_test.png"))
  plot(img)
}


### AOP-DB RDF

# Extracting all genes related to AOP of interest 
key_events

# Creating a list to store the results.
genes_entrez <- list()

# Making SPARQL queries for all key events. 
for(i in 1:length(key_events)) {
  key_event <- key_events[i]
  # Getting only the key event's id.
  key_event <- strsplit(key_event, "/")[[1]][5]
  
  query <- paste0('PREFIX aop.events: <http://identifiers.org/aop.events/>
    SELECT DISTINCT ?KE_URI ?Entrez_ID
    WHERE{
      ?KE_URI edam:data_1027 ?Entrez_URI.
      ?Entrez_URI edam:data_1027 ?Entrez_ID.
      FILTER (?KE_URI = aop.events:', key_event,')}
  ')
  
  res                     <- SPARQL(aopdbsparql, query)
  genes_entrez[[i]]       <- res$results
  names(genes_entrez)[i]  <- key_event
}

# Converting the results into a data frame. 
for(i in 1:length(genes_entrez)) {
  if(nrow(genes_entrez[[i]]) > 0) {
    genes_entrez[[i]][, 1] <- names(genes_entrez)[i]
  }
}
genes_entrez            <- matrix(unlist(genes_entrez), ncol=2, byrow=FALSE)
colnames(genes_entrez)  <- c("KE", "Entrez")  
genes_entrez            <- as.data.frame(genes_entrez)
genes_entrez

genes <- genes_entrez$Entrez
genes


## BridgeDb to Map Identifiers

input_data_source   <- "L"
output_data_source  <- c("H", "En")
species             <- c("Human", "Dog", "Mouse", "Rat")

mappings  <- data.frame()

for(i in 1:length(output_data_source)) {
  source <- output_data_source[i]
  for(entrez in genes) {
    for(spec in species) {
      query_url <- paste0(bridgedb, spec, "/xrefs/", input_data_source, "/", 
                          entrez, "?dataSource=", source)
      res <- GET(query_url)
      dat <- content(res, as="text")
      
      if(dat != "{}") {
        dat <- as.data.frame(strsplit(dat, ",")[[1]])
        dat <- unlist(apply(dat, 1, strsplit, '":"'))
        dat <- matrix(dat, ncol=2, byrow=TRUE)
        dat <- gsub("\\{", "", dat)
        dat <- gsub("}", "", dat)
        dat <- gsub('\\"', "", dat)
        
        dat           <- as.data.frame(dat)
        dat           <- cbind(entrez, dat)
        colnames(dat) <- c("entrez", "identifier", "database")
        
        mappings <- rbind(mappings, dat)
      }
    }
  }
}
mappings$identifier <- unlist(lapply(strsplit(mappings$identifier, ":"), 
                                     function(x) {x[2]}))
mappings


### Importing Data

# Since the EdelweissData Explorer is not available anymore, we read the data 
# set from a local file. 
csp_dat <- read.csv("data/CSP_48hr_50uM.csv")
head(csp_dat)

# Adding a column to the data set to indicate their regulation in gene 
# expression based on log2fc.
csp_dat$diffexpressed <- "NO"
# Finding the up-regulated genes
csp_dat$diffexpressed[csp_dat$log2FoldChange > 0.6 & csp_dat$pvalue < 0.05]   <- "UP"
# Finding the down-regulated genes
csp_dat$diffexpressed[csp_dat$log2FoldChange < -0.6 & csp_dat$pvalue < 0.05]  <- "DOWN"

# Some exploration: Ordering the down-regulated genes in terms of their significance
csp_dat_down <- subset(csp_dat, diffexpressed=="DOWN")
head(csp_dat_down[order(csp_dat_down$padj), ])

# Creating the "delabel" column to contain the name of the top 30 differentially 
# expressed genes (NA in case they are not). 
csp_dat$delabel <- ifelse(csp_dat$GeneSymbol_new %in% head(csp_dat[order(csp_dat$padj), 
                          "GeneSymbol_new"], 30), csp_dat$GeneSymbol_new, NA)

# Getting the list of differentially expressed genes. 
deg <- csp_dat$Entrez_ID_new[csp_dat$diffexpressed %in% c("UP", "DOWN")]

# The number of differentially expressed genes.
length(deg)

# Entrez IDs of the (first five) differentially expressed genes.
deg[1:5]

# Creating the volcano plot of the differentially expressed genes.
ggplot(data = csp_dat, aes(x = log2FoldChange, y = -log10(pvalue), 
                           col = diffexpressed, label = delabel)) +
  geom_vline(xintercept = c(-0.6, 0.6), col = "gray", linetype = 'dashed') +
  geom_hline(yintercept = -log10(0.05), col = "gray", linetype = 'dashed') + 
  geom_point(size = 2) + 
  scale_color_manual(values = c("#00AFBB", "grey", "#bb0c00"), 
                     labels = c("Downregulated", "Not significant", "Upregulated")) + 
  coord_cartesian(ylim = c(0, 200), xlim = c(-10, 10)) + 
  labs(color = 'Severe', 
       x = expression("log"[2]*"FC"), y = expression("-log"[10]*"p-value")) + 
  scale_x_continuous(breaks = seq(-10, 10, 2)) + 
  ggtitle('Volcano Plot') +  
  geom_text_repel(max.overlaps = Inf)  


### WikiPathways RDF

# Entrez IDs of the genes received from AOP-DB.
genes

# Creating an empty data frame to store the results.
WPwithGenes <- data.frame(Pathway_ID = character(), Pathway_title = character(),
                          organism = character(), Gene_ID = character(),
                          stringsAsFactors = FALSE)

# Looping through the list of genes from AOPDB and querying data.
for (i in 1:length(genes)) {
  query <- paste0('SELECT DISTINCT (str(?wpid) as ?Pathway_ID) (str(?PW_Title) as ?Pathway_title) ?organism
    WHERE {
      ?gene a wp:GeneProduct; dcterms:identifier ?id; dcterms:isPartOf ?pathwayRes; wp:bdbEntrezGene <https://identifiers.org/ncbigene/', genes[i], '>.
      ?pathwayRes a wp:Pathway; dcterms:identifier ?wpid; dc:title ?PW_Title; wp:organismName ?organism.}'
  )
  
  res <- SPARQL(wikipathwayssparql, query)
  res <- res$results
  
  # Adding the Gene_ID column to results. 
  res$Gene_ID <- genes[i]
  
  # Adding the results to the data frame.
  WPwithGenes <- rbind(WPwithGenes, res)
}

# Printing the results.
flextable
# flextable(WPwithGenes, cwidth=c(1, 6, 2, 1))