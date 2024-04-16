
# Mapping Gene Identifiers with BridgeDb

## Install the httr package if it is not installed already.
# install.packages("httr")
# Loading the httr package.
library(httr)


## Setting Up a Query

# Setting up the query url.
query_url <- "https://bridgedb.cloud.vhp4safety.nl/Human/xrefs/H/MECP2"


### Making the Query

# Making the query.
res <- GET(query_url)


### The Raw Content of the Query

# The content of the output.
res
content(res, as="text")


## Processing the Raw Content to Get a Data Frame

# Assigning the raw content to an object.
dat <- content(res, as="text")

# Splitting the raw output into lines that are separated with a comma.
dat <- as.data.frame(strsplit(dat, ",")[[1]])

# Splitting the two columns in the data set and convert the output into a data.frame.
dat <- unlist(apply(dat, 1, strsplit, '":"'))

# Converting the data into a matrix.
dat <- matrix(dat, ncol=2, byrow=TRUE)

# Cleaning unnecessary characters in the raw output.
dat <- gsub("\\{", "", dat)
dat <- gsub("}", "", dat)
dat <- gsub('\\"', "", dat)

# Converting the output into a data frame and naming its columns.
dat           <- as.data.frame(dat)
colnames(dat) <- c("identifier", "database")

dat   # The processed data frame
dat[which(dat$database == "Ensembl"), ]

