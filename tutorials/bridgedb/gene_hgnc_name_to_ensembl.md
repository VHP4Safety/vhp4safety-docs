
# BridgeDb: Mapping Gene Identifiers

<a target="_blank" href="https://colab.research.google.com/github/VHP4Safety/vhp4safety-docs/blob/main/tutorials/bridgedb/gene_hgnc_name_to_ensembl.ipynb">
  <img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open In Colab (Python Script)"/>
</a>

## Using BridgeDb with `Python`

This tutorial explains how to use the BridgeDb identifier mapping service to translate HGNC names to Ensembl identifiers with Python (using a Jupyter Notebook). This step has been created as a part of the OpenRiskNet use case to link Adverse Outcome Pathways to [WikiPathways](https://wikipathways.org/). The original tutorial can be found [here](https://github.com/OpenRiskNet/notebooks/blob/master/BridgeDb/genes.ipynb). Additionally, this tutorial can be interactively run through the Google Colab found [here](https://colab.research.google.com/github/VHP4Safety/vhp4safety-docs/blob/main/tutorials/bridgedb/gene_hgnc_name_to_ensembl.ipynb) (you can also click the Google Colab badge at the top of this page). 

First we need to load the Python library to allow calls to the [BridgeDb REST webservice](https://bridgedb.cloud.vhp4safety.nl/):


```python
import requests
```

Let's assume we're interested in the gene with HGNC MECP2 (FIXME: look up a gene in AOPWiki), the API call to make mappings is given below as `callUrl`. Here, the `H` indicates that the query (`MECP2`) is an HGNC symbol:


```python
callUrl = 'https://bridgedb.cloud.vhp4safety.nl/Human/xrefs/H/MECP2'
```

The default call returns all identifiers, not just for Ensembl:


```python
response = requests.get(callUrl)
response.text
```


## Using BridgeDb with `R`

Genes can have different identifiers in different databases. BridgeDb is a tool to map the identifiers from different databases. This tutorial presents how an exemplary [HGNC symbol](https://en.wikipedia.org/wiki/HUGO_Gene_Nomenclature_Committee) can be translated to its [Ensembl identifier](https://www.ensembl.org/info/genome/stable_ids/index.html) with BridgeDb. This work is based on the tutorial to show the use case of linking Adverse Outcome Pathways to [WikiPathways](https://www.wikipathways.org/) which was a part of the [OpenRiskNet](https://openrisknet.org/). The original tutorial using the Python language can be found [here](https://github.com/OpenRiskNet/notebooks/blob/master/BridgeDb/genes.ipynb). This tutorial follows the original one by replicating it in the R language. To do so, the [`httr`](https://cran.r-project.org/package=httr) R package is required. 


```r
# Please install the httr package if it is not installed yet with the next command.
# install.packages("httr")

# Loading the httr package.
library(httr)
```

The translation of interest will be made by connecting to the BridgeDb's REST webservice at [https://bridgedb.cloud.vhp4safety.nl/](https://bridgedb.cloud.vhp4safety.nl/) through R. 


### Setting Up a Query

In this tutorial, the goal is to find the Ensembl identifier(s) for the gene with the HGNC symbol of [*MECP2*](https://en.wikipedia.org/wiki/MECP2). In order to reach the required information, we need to make a query by setting up an URL in R as below.


```r
# Setting up the query url.
query_url <- "https://bridgedb.cloud.vhp4safety.nl/Human/xrefs/H/MECP2"
```

In the above command, `H` indicates a query, whereas `MECP2` is the HGNC symbol. The HGNC symbol can be replaced with another symbol of interest depending on the user's needs (please see BridgeDb's [system codes page](https://www.bridgedb.org/pages/system-codes.html) to see how other databases are coded). 


### Making the Query

Next, we will make the query to the webservice through R using the `GET` function in the `httr` package.


```r
# Making the query.
res <- GET(query_url)
```


#### The Raw Content of the Query

The query above, unfortunately, does not return immediately an output that is easy for human reading. This section presents how to see the raw content of the output; please skip to the next section to see how to convert the output into an R `data.frame` object that is easier to explore and use.

The content of the response is not displayed in the output object immediately. 


```r
# The content of the output.
res
```

```
## Response [https://bridgedb.cloud.vhp4safety.nl/Human/xrefs/H/MECP2]
##   Date: 2023-05-16 09:55
##   Status: 200
##   Content-Type: text/plain; charset=UTF-8
##   Size: 8.5 kB
```

BridgeDb returns a content in the plain text format. Therefore, this raw content can be displayed with the `content` function. 


```r
content(res, as="text")
```

```
## [1] "{\"affy.probeset:202618_PM_s_at\":\"Affy\",\"affy.probeset:8175977\":\"Affy\",\"go:GO:0008283\":\"GeneOntology\",\"go:GO:0008284\":\"GeneOntology\",\"go:GO:1905643\":\"GeneOntology\",\"go:GO:0003700\":\"GeneOntology\",\"ucsc:uc065cbc.1\":\"UCSC Genome Browser\",\"go:GO:0006541\":\"GeneOntology\",\"go:GO:0000792\":\"GeneOntology\",\"illumina.probe:ILMN_1682091\":\"Illumina\",\"go:GO:0031507\":\"GeneOntology\",\"ucsc:uc288qen.1\":\"UCSC Genome Browser\",\"pdb:6C1Y\":\"PDB\",\"go:GO:0060291\":\"GeneOntology\",\"wikigenes:4204\":\"WikiGenes\",\"go:GO:0016573\":\"GeneOntology\",\"go:GO:0016571\":\"GeneOntology\",\"go:GO:0003714\":\"GeneOntology\",\"agilent.probe:HMNXSV003039744\":\"Agilent\",\"pdb:5BT2\":\"PDB\",\"go:GO:0098794\":\"GeneOntology\",\"ucsc:uc065cay.1\":\"UCSC Genome Browser\",\"affy.probeset:11722684_a_at\":\"Affy\",\"go:GO:0032048\":\"GeneOntology\",\"affy.probeset:4027100\":\"Affy\",\"agilent.probe:A_24_P237486\":\"Agilent\",\"affy.probeset:202616_s_at\":\"Affy\",\"go:GO:0007052\":\"GeneOntology\",\"go:GO:0099191\":\"GeneOntology\",\"refseq:NM_001386137\":\"RefSeq\",\"refseq:NM_001386138\":\"RefSeq\",\"ucsc:uc065cbd.1\":\"UCSC Genome Browser\",\"refseq:NM_001386139\":\"RefSeq\",\"uniprot:H7BY72\":\"Uniprot-TrEMBL\",\"go:GO:0007613\":\"GeneOntology\",\"go:GO:0007612\":\"GeneOntology\",\"affy.probeset:X89430_at\":\"Affy\",\"go:GO:0021591\":\"GeneOntology\",\"go:GO:0007616\":\"GeneOntology\",\"uniprot:C9JH89\":\"Uniprot-TrEMBL\",\"go:GO:0010467\":\"GeneOntology\",\"go:GO:0010468\":\"GeneOntology\",\"affy.probeset:8175998\":\"Affy\",\"affy.probeset:17115428\":\"Affy\",\"hgnc:HGNC:6990\":\"HGNC Accession number\",\"go:GO:0060079\":\"GeneOntology\",\"illumina.probe:0006510725\":\"Illumina\",\"pdb:1QK9\":\"PDB\",\"pdb:6OGJ\":\"PDB\",\"pdb:6OGK\":\"PDB\",\"ucsc:uc065caz.1\":\"UCSC Genome Browser\",\"uniprot:A0A6Q8PF93\":\"Uniprot-TrEMBL\",\"refseq:NM_001369392\":\"RefSeq\",\"refseq:NM_001369391\":\"RefSeq\",\"uniprot:P51608\":\"Uniprot-TrEMBL\",\"refseq:NM_001369394\":\"RefSeq\",\"refseq:NM_001369393\":\"RefSeq\",\"ucsc:uc065car.1\":\"UCSC Genome Browser\",\"go:GO:0043524\":\"GeneOntology\",\"go:GO:0045944\":\"GeneOntology\",\"go:GO:0042551\":\"GeneOntology\",\"ucsc:uc065cbi.1\":\"UCSC Genome Browser\",\"go:GO:0051707\":\"GeneOntology\",\"go:GO:0001964\":\"GeneOntology\",\"ucsc:uc286dlx.1\":\"UCSC Genome Browser\",\"ucsc:uc065cba.1\":\"UCSC Genome Browser\",\"ncbigene:4204\":\"Entrez Gene\",\"ucsc:uc286dma.1\":\"UCSC Genome Browser\",\"go:GO:0005654\":\"GeneOntology\",\"go:GO:0046470\":\"GeneOntology\",\"go:GO:2000820\":\"GeneOntology\",\"go:GO:0051151\":\"GeneOntology\",\"illumina.probe:ILMN_1702715\":\"Illumina\",\"go:GO:0014009\":\"GeneOntology\",\"go:GO:0043537\":\"GeneOntology\",\"refseq:NP_001373068\":\"RefSeq\",\"refseq:NP_001373067\":\"RefSeq\",\"refseq:NP_001373066\":\"RefSeq\",\"go:GO:0001976\":\"GeneOntology\",\"go:GO:0007268\":\"GeneOntology\",\"go:GO:0040029\":\"GeneOntology\",\"ucsc:uc065caw.1\":\"UCSC Genome Browser\",\"illumina.probe:ILMN_3310740\":\"Illumina\",\"affy.probeset:4027023\":\"Affy\",\"affy.probeset:4027024\":\"Affy\",\"affy.probeset:4027025\":\"Affy\",\"affy.probeset:4027026\":\"Affy\",\"affy.probeset:4027027\":\"Affy\",\"affy.probeset:4027028\":\"Affy\",\"go:GO:0009791\":\"GeneOntology\",\"affy.probeset:4027029\":\"Affy\",\"refseq:XM_024452383\":\"RefSeq\",\"agilent.probe:A_33_P3339036\":\"Agilent\",\"affy.probeset:34355_at\":\"Affy\",\"go:GO:0008344\":\"GeneOntology\",\"go:GO:0008104\":\"GeneOntology\",\"ucsc:uc065cbb.1\":\"UCSC Genome Browser\",\"go:GO:0005634\":\"GeneOntology\",\"go:GO:0003682\":\"GeneOntology\",\"affy.probeset:TC0X002288.hg\":\"Affy\",\"go:GO:0005515\":\"GeneOntology\",\"go:GO:0019230\":\"GeneOntology\",\"affy.probeset:4027030\":\"Affy\",\"go:GO:0019233\":\"GeneOntology\",\"affy.probeset:4027031\":\"Affy\",\"affy.probeset:4027032\":\"Affy\",\"go:GO:0016525\":\"GeneOntology\",\"affy.probeset:4027033\":\"Affy\",\"go:GO:0050884\":\"GeneOntology\",\"affy.probeset:4027034\":\"Affy\",\"affy.probeset:4027035\":\"Affy\",\"affy.probeset:4027036\":\"Affy\",\"go:GO:0021549\":\"GeneOntology\",\"affy.probeset:4027037\":\"Affy\",\"uniprot:A0A6Q8PHQ3\":\"Uniprot-TrEMBL\",\"affy.probeset:4027038\":\"Affy\",\"affy.probeset:4027039\":\"Affy\",\"go:GO:0019904\":\"GeneOntology\",\"refseq:XM_011531166\":\"RefSeq\",\"uniprot:A0A1B0GTV0\":\"Uniprot-TrEMBL\",\"go:GO:0090063\":\"GeneOntology\",\"uniprot:D3YJ43\":\"Uniprot-TrEMBL\",\"ensembl:ENSG00000169057\":\"Ensembl\",\"go:GO:0008211\":\"GeneOntology\",\"affy.probeset:TC0X001524.hg\":\"Affy\",\"ucsc:uc065cax.1\":\"UCSC Genome Browser\",\"affy.probeset:4027040\":\"Affy\",\"affy.probeset:4027041\":\"Affy\",\"affy.probeset:4027042\":\"Affy\",\"affy.probeset:4027043\":\"Affy\",\"affy.probeset:4027044\":\"Affy\",\"affy.probeset:4027045\":\"Affy\",\"affy.probeset:4027046\":\"Affy\",\"affy.probeset:4027047\":\"Affy\",\"affy.probeset:4027048\":\"Affy\",\"affy.probeset:4027049\":\"Affy\",\"uniprot:A0A0D9SEX1\":\"Uniprot-TrEMBL\",\"go:GO:0006020\":\"GeneOntology\",\"ucsc:uc065cbg.2\":\"UCSC Genome Browser\",\"ucsc:uc286dlz.1\":\"UCSC Genome Browser\",\"go:GO:1900114\":\"GeneOntology\",\"refseq:XP_011529468\":\"RefSeq\",\"go:GO:0008327\":\"GeneOntology\",\"affy.probeset:g7710148_3p_a_at\":\"Affy\",\"agilent.probe:HMNXSV003006762\":\"Agilent\",\"go:GO:0005615\":\"GeneOntology\",\"go:GO:0005737\":\"GeneOntology\",\"go:GO:0047485\":\"GeneOntology\",\"affy.probeset:4027050\":\"Affy\",\"affy.probeset:4027051\":\"Affy\",\"affy.probeset:4027052\":\"Affy\",\"affy.probeset:4027053\":\"Affy\",\"refseq:NM_001316337\":\"RefSeq\",\"affy.probeset:4027055\":\"Affy\",\"affy.probeset:4027057\":\"Affy\",\"affy.probeset:4027058\":\"Affy\",\"affy.probeset:4027059\":\"Affy\",\"pdb:3C2I\":\"PDB\",\"go:GO:0007585\":\"GeneOntology\",\"go:GO:0003677\":\"GeneOntology\",\"affy.probeset:g972764_3p_a_at\":\"Affy\",\"agilent.probe:A_33_P3317211\":\"Agilent\",\"affy.probeset:4027060\":\"Affy\",\"affy.probeset:4027061\":\"Affy\",\"affy.probeset:4027062\":\"Affy\",\"affy.probeset:4027063\":\"Affy\",\"ucsc:uc065cau.1\":\"UCSC Genome Browser\",\"affy.probeset:4027065\":\"Affy\",\"affy.probeset:4027068\":\"Affy\",\"affy.probeset:4027069\":\"Affy\",\"refseq:NP_001104262\":\"RefSeq\",\"refseq:NM_001110792\":\"RefSeq\",\"affy.probeset:11722682_at\":\"Affy\",\"affy.probeset:202617_PM_s_at\":\"Affy\",\"go:GO:0008542\":\"GeneOntology\",\"ucsc:uc065cbh.1\":\"UCSC Genome Browser\",\"ucsc:uc286dly.1\":\"UCSC Genome Browser\",\"go:GO:0008306\":\"GeneOntology\",\"go:GO:0007219\":\"GeneOntology\",\"go:GO:0010629\":\"GeneOntology\",\"ucsc:uc286dmb.1\":\"UCSC Genome Browser\",\"affy.probeset:4027078\":\"Affy\",\"affy.probeset:4027079\":\"Affy\",\"affy.probeset:202617_s_at\":\"Affy\",\"go:GO:0035176\":\"GeneOntology\",\"go:GO:0045893\":\"GeneOntology\",\"go:GO:0045892\":\"GeneOntology\",\"affy.probeset:X99687_at\":\"Affy\",\"ucsc:uc288oef.1\":\"UCSC Genome Browser\",\"go:GO:0006357\":\"GeneOntology\",\"affy.probeset:4027080\":\"Affy\",\"affy.probeset:4027081\":\"Affy\",\"affy.probeset:4027082\":\"Affy\",\"affy.probeset:4027083\":\"Affy\",\"go:GO:0010971\":\"GeneOntology\",\"affy.probeset:4027084\":\"Affy\",\"ucsc:uc065cav.2\":\"UCSC Genome Browser\",\"affy.probeset:4027085\":\"Affy\",\"go:GO:0005829\":\"GeneOntology\",\"affy.probeset:4027086\":\"Affy\",\"affy.probeset:4027087\":\"Affy\",\"go:GO:0050432\":\"GeneOntology\",\"affy.probeset:4027088\":\"Affy\",\"affy.probeset:4027089\":\"Affy\",\"go:GO:0033555\":\"GeneOntology\",\"refseq:XP_024308151\":\"RefSeq\",\"ucsc:uc065cbe.1\":\"UCSC Genome Browser\",\"ucsc:uc004fjv.4\":\"UCSC Genome Browser\",\"affy.probeset:202616_PM_s_at\":\"Affy\",\"omim:300005\":\"OMIM\",\"go:GO:0006349\":\"GeneOntology\",\"affy.probeset:4027090\":\"Affy\",\"affy.probeset:4027091\":\"Affy\",\"go:GO:0005813\":\"GeneOntology\",\"affy.probeset:4027092\":\"Affy\",\"ucsc:uc288oyf.1\":\"UCSC Genome Browser\",\"agilent.probe:HMNXSV003048644\":\"Agilent\",\"affy.probeset:4027099\":\"Affy\",\"go:GO:0030182\":\"GeneOntology\",\"go:GO:0060252\":\"GeneOntology\",\"go:GO:0035197\":\"GeneOntology\",\"go:GO:0007420\":\"GeneOntology\",\"agilent.probe:A_23_P114361\":\"Agilent\",\"uniprot:B5MCB4\":\"Uniprot-TrEMBL\",\"go:GO:0006576\":\"GeneOntology\",\"go:GO:0000122\":\"GeneOntology\",\"refseq:NP_001303266\":\"RefSeq\",\"ucsc:uc065cas.1\":\"UCSC Genome Browser\",\"go:GO:0003729\":\"GeneOntology\",\"uniprot:A0A140VKC4\":\"Uniprot-TrEMBL\",\"refseq:NM_004992\":\"RefSeq\",\"go:GO:1990841\":\"GeneOntology\",\"go:GO:0003723\":\"GeneOntology\",\"go:GO:0001666\":\"GeneOntology\",\"ucsc:uc065cbf.1\":\"UCSC Genome Browser\",\"go:GO:0045202\":\"GeneOntology\",\"uniprot:A0A0D9SFX7\":\"Uniprot-TrEMBL\",\"ucsc:uc004fjw.4\":\"UCSC Genome Browser\",\"go:GO:0001662\":\"GeneOntology\",\"refseq:NP_001356320\":\"RefSeq\",\"go:GO:0007416\":\"GeneOntology\",\"go:GO:0051570\":\"GeneOntology\",\"affy.probeset:X94628_rna1_s_at\":\"Affy\",\"go:GO:0010385\":\"GeneOntology\",\"affy.probeset:11722683_a_at\":\"Affy\",\"hgnc.symbol:MECP2\":\"HGNC\",\"illumina.probe:ILMN_1824898\":\"Illumina\",\"go:GO:0050905\":\"GeneOntology\",\"refseq:NP_001356321\":\"RefSeq\",\"refseq:NP_001356322\":\"RefSeq\",\"refseq:NP_001356323\":\"RefSeq\",\"ucsc:uc288pkg.1\":\"UCSC Genome Browser\",\"go:GO:0002087\":\"GeneOntology\",\"affy.probeset:202618_s_at\":\"Affy\",\"go:GO:0048167\":\"GeneOntology\",\"refseq:NP_004983\":\"RefSeq\",\"affy.probeset:Hs.3239.0.S2_3p_a_at\":\"Affy\",\"affy.probeset:17115453\":\"Affy\",\"go:GO:0031175\":\"GeneOntology\",\"go:GO:0016358\":\"GeneOntology\"}"
```


### Processing the Raw Content to Get a Data Frame

The raw content of the response can be converted into a data frame by managing the text in the response. The commands below show these steps to process the raw content.


```r
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
```

```
##                             identifier              database
## 1         affy.probeset:202618_PM_s_at                  Affy
## 2                affy.probeset:8175977                  Affy
## 3                        go:GO:0008283          GeneOntology
## 4                        go:GO:0008284          GeneOntology
## 5                        go:GO:1905643          GeneOntology
## 6                        go:GO:0003700          GeneOntology
## 7                      ucsc:uc065cbc.1   UCSC Genome Browser
## 8                        go:GO:0006541          GeneOntology
## 9                        go:GO:0000792          GeneOntology
## 10         illumina.probe:ILMN_1682091              Illumina
## 11                       go:GO:0031507          GeneOntology
## 12                     ucsc:uc288qen.1   UCSC Genome Browser
## 13                            pdb:6C1Y                   PDB
## 14                       go:GO:0060291          GeneOntology
## 15                      wikigenes:4204             WikiGenes
## 16                       go:GO:0016573          GeneOntology
## 17                       go:GO:0016571          GeneOntology
## 18                       go:GO:0003714          GeneOntology
## 19       agilent.probe:HMNXSV003039744               Agilent
## 20                            pdb:5BT2                   PDB
## 21                       go:GO:0098794          GeneOntology
## 22                     ucsc:uc065cay.1   UCSC Genome Browser
## 23         affy.probeset:11722684_a_at                  Affy
## 24                       go:GO:0032048          GeneOntology
## 25               affy.probeset:4027100                  Affy
## 26          agilent.probe:A_24_P237486               Agilent
## 27           affy.probeset:202616_s_at                  Affy
## 28                       go:GO:0007052          GeneOntology
## 29                       go:GO:0099191          GeneOntology
## 30                 refseq:NM_001386137                RefSeq
## 31                 refseq:NM_001386138                RefSeq
## 32                     ucsc:uc065cbd.1   UCSC Genome Browser
## 33                 refseq:NM_001386139                RefSeq
## 34                      uniprot:H7BY72        Uniprot-TrEMBL
## 35                       go:GO:0007613          GeneOntology
## 36                       go:GO:0007612          GeneOntology
## 37             affy.probeset:X89430_at                  Affy
## 38                       go:GO:0021591          GeneOntology
## 39                       go:GO:0007616          GeneOntology
## 40                      uniprot:C9JH89        Uniprot-TrEMBL
## 41                       go:GO:0010467          GeneOntology
## 42                       go:GO:0010468          GeneOntology
## 43               affy.probeset:8175998                  Affy
## 44              affy.probeset:17115428                  Affy
## 45                      hgnc:HGNC:6990 HGNC Accession number
## 46                       go:GO:0060079          GeneOntology
## 47           illumina.probe:0006510725              Illumina
## 48                            pdb:1QK9                   PDB
## 49                            pdb:6OGJ                   PDB
## 50                            pdb:6OGK                   PDB
## 51                     ucsc:uc065caz.1   UCSC Genome Browser
## 52                  uniprot:A0A6Q8PF93        Uniprot-TrEMBL
## 53                 refseq:NM_001369392                RefSeq
## 54                 refseq:NM_001369391                RefSeq
## 55                      uniprot:P51608        Uniprot-TrEMBL
## 56                 refseq:NM_001369394                RefSeq
## 57                 refseq:NM_001369393                RefSeq
## 58                     ucsc:uc065car.1   UCSC Genome Browser
## 59                       go:GO:0043524          GeneOntology
## 60                       go:GO:0045944          GeneOntology
## 61                       go:GO:0042551          GeneOntology
## 62                     ucsc:uc065cbi.1   UCSC Genome Browser
## 63                       go:GO:0051707          GeneOntology
## 64                       go:GO:0001964          GeneOntology
## 65                     ucsc:uc286dlx.1   UCSC Genome Browser
## 66                     ucsc:uc065cba.1   UCSC Genome Browser
## 67                       ncbigene:4204           Entrez Gene
## 68                     ucsc:uc286dma.1   UCSC Genome Browser
## 69                       go:GO:0005654          GeneOntology
## 70                       go:GO:0046470          GeneOntology
## 71                       go:GO:2000820          GeneOntology
## 72                       go:GO:0051151          GeneOntology
## 73         illumina.probe:ILMN_1702715              Illumina
## 74                       go:GO:0014009          GeneOntology
## 75                       go:GO:0043537          GeneOntology
## 76                 refseq:NP_001373068                RefSeq
## 77                 refseq:NP_001373067                RefSeq
## 78                 refseq:NP_001373066                RefSeq
## 79                       go:GO:0001976          GeneOntology
## 80                       go:GO:0007268          GeneOntology
## 81                       go:GO:0040029          GeneOntology
## 82                     ucsc:uc065caw.1   UCSC Genome Browser
## 83         illumina.probe:ILMN_3310740              Illumina
## 84               affy.probeset:4027023                  Affy
## 85               affy.probeset:4027024                  Affy
## 86               affy.probeset:4027025                  Affy
## 87               affy.probeset:4027026                  Affy
## 88               affy.probeset:4027027                  Affy
## 89               affy.probeset:4027028                  Affy
## 90                       go:GO:0009791          GeneOntology
## 91               affy.probeset:4027029                  Affy
## 92                 refseq:XM_024452383                RefSeq
## 93         agilent.probe:A_33_P3339036               Agilent
## 94              affy.probeset:34355_at                  Affy
## 95                       go:GO:0008344          GeneOntology
## 96                       go:GO:0008104          GeneOntology
## 97                     ucsc:uc065cbb.1   UCSC Genome Browser
## 98                       go:GO:0005634          GeneOntology
## 99                       go:GO:0003682          GeneOntology
## 100        affy.probeset:TC0X002288.hg                  Affy
## 101                      go:GO:0005515          GeneOntology
## 102                      go:GO:0019230          GeneOntology
## 103              affy.probeset:4027030                  Affy
## 104                      go:GO:0019233          GeneOntology
## 105              affy.probeset:4027031                  Affy
## 106              affy.probeset:4027032                  Affy
## 107                      go:GO:0016525          GeneOntology
## 108              affy.probeset:4027033                  Affy
## 109                      go:GO:0050884          GeneOntology
## 110              affy.probeset:4027034                  Affy
## 111              affy.probeset:4027035                  Affy
## 112              affy.probeset:4027036                  Affy
## 113                      go:GO:0021549          GeneOntology
## 114              affy.probeset:4027037                  Affy
## 115                 uniprot:A0A6Q8PHQ3        Uniprot-TrEMBL
## 116              affy.probeset:4027038                  Affy
## 117              affy.probeset:4027039                  Affy
## 118                      go:GO:0019904          GeneOntology
## 119                refseq:XM_011531166                RefSeq
## 120                 uniprot:A0A1B0GTV0        Uniprot-TrEMBL
## 121                      go:GO:0090063          GeneOntology
## 122                     uniprot:D3YJ43        Uniprot-TrEMBL
## 123            ensembl:ENSG00000169057               Ensembl
## 124                      go:GO:0008211          GeneOntology
## 125        affy.probeset:TC0X001524.hg                  Affy
## 126                    ucsc:uc065cax.1   UCSC Genome Browser
## 127              affy.probeset:4027040                  Affy
## 128              affy.probeset:4027041                  Affy
## 129              affy.probeset:4027042                  Affy
## 130              affy.probeset:4027043                  Affy
## 131              affy.probeset:4027044                  Affy
## 132              affy.probeset:4027045                  Affy
## 133              affy.probeset:4027046                  Affy
## 134              affy.probeset:4027047                  Affy
## 135              affy.probeset:4027048                  Affy
## 136              affy.probeset:4027049                  Affy
## 137                 uniprot:A0A0D9SEX1        Uniprot-TrEMBL
## 138                      go:GO:0006020          GeneOntology
## 139                    ucsc:uc065cbg.2   UCSC Genome Browser
## 140                    ucsc:uc286dlz.1   UCSC Genome Browser
## 141                      go:GO:1900114          GeneOntology
## 142                refseq:XP_011529468                RefSeq
## 143                      go:GO:0008327          GeneOntology
## 144     affy.probeset:g7710148_3p_a_at                  Affy
## 145      agilent.probe:HMNXSV003006762               Agilent
## 146                      go:GO:0005615          GeneOntology
## 147                      go:GO:0005737          GeneOntology
## 148                      go:GO:0047485          GeneOntology
## 149              affy.probeset:4027050                  Affy
## 150              affy.probeset:4027051                  Affy
## 151              affy.probeset:4027052                  Affy
## 152              affy.probeset:4027053                  Affy
## 153                refseq:NM_001316337                RefSeq
## 154              affy.probeset:4027055                  Affy
## 155              affy.probeset:4027057                  Affy
## 156              affy.probeset:4027058                  Affy
## 157              affy.probeset:4027059                  Affy
## 158                           pdb:3C2I                   PDB
## 159                      go:GO:0007585          GeneOntology
## 160                      go:GO:0003677          GeneOntology
## 161      affy.probeset:g972764_3p_a_at                  Affy
## 162        agilent.probe:A_33_P3317211               Agilent
## 163              affy.probeset:4027060                  Affy
## 164              affy.probeset:4027061                  Affy
## 165              affy.probeset:4027062                  Affy
## 166              affy.probeset:4027063                  Affy
## 167                    ucsc:uc065cau.1   UCSC Genome Browser
## 168              affy.probeset:4027065                  Affy
## 169              affy.probeset:4027068                  Affy
## 170              affy.probeset:4027069                  Affy
## 171                refseq:NP_001104262                RefSeq
## 172                refseq:NM_001110792                RefSeq
## 173          affy.probeset:11722682_at                  Affy
## 174       affy.probeset:202617_PM_s_at                  Affy
## 175                      go:GO:0008542          GeneOntology
## 176                    ucsc:uc065cbh.1   UCSC Genome Browser
## 177                    ucsc:uc286dly.1   UCSC Genome Browser
## 178                      go:GO:0008306          GeneOntology
## 179                      go:GO:0007219          GeneOntology
## 180                      go:GO:0010629          GeneOntology
## 181                    ucsc:uc286dmb.1   UCSC Genome Browser
## 182              affy.probeset:4027078                  Affy
## 183              affy.probeset:4027079                  Affy
## 184          affy.probeset:202617_s_at                  Affy
## 185                      go:GO:0035176          GeneOntology
## 186                      go:GO:0045893          GeneOntology
## 187                      go:GO:0045892          GeneOntology
## 188            affy.probeset:X99687_at                  Affy
## 189                    ucsc:uc288oef.1   UCSC Genome Browser
## 190                      go:GO:0006357          GeneOntology
## 191              affy.probeset:4027080                  Affy
## 192              affy.probeset:4027081                  Affy
## 193              affy.probeset:4027082                  Affy
## 194              affy.probeset:4027083                  Affy
## 195                      go:GO:0010971          GeneOntology
## 196              affy.probeset:4027084                  Affy
## 197                    ucsc:uc065cav.2   UCSC Genome Browser
## 198              affy.probeset:4027085                  Affy
## 199                      go:GO:0005829          GeneOntology
## 200              affy.probeset:4027086                  Affy
## 201              affy.probeset:4027087                  Affy
## 202                      go:GO:0050432          GeneOntology
## 203              affy.probeset:4027088                  Affy
## 204              affy.probeset:4027089                  Affy
## 205                      go:GO:0033555          GeneOntology
## 206                refseq:XP_024308151                RefSeq
## 207                    ucsc:uc065cbe.1   UCSC Genome Browser
## 208                    ucsc:uc004fjv.4   UCSC Genome Browser
## 209       affy.probeset:202616_PM_s_at                  Affy
## 210                        omim:300005                  OMIM
## 211                      go:GO:0006349          GeneOntology
## 212              affy.probeset:4027090                  Affy
## 213              affy.probeset:4027091                  Affy
## 214                      go:GO:0005813          GeneOntology
## 215              affy.probeset:4027092                  Affy
## 216                    ucsc:uc288oyf.1   UCSC Genome Browser
## 217      agilent.probe:HMNXSV003048644               Agilent
## 218              affy.probeset:4027099                  Affy
## 219                      go:GO:0030182          GeneOntology
## 220                      go:GO:0060252          GeneOntology
## 221                      go:GO:0035197          GeneOntology
## 222                      go:GO:0007420          GeneOntology
## 223         agilent.probe:A_23_P114361               Agilent
## 224                     uniprot:B5MCB4        Uniprot-TrEMBL
## 225                      go:GO:0006576          GeneOntology
## 226                      go:GO:0000122          GeneOntology
## 227                refseq:NP_001303266                RefSeq
## 228                    ucsc:uc065cas.1   UCSC Genome Browser
## 229                      go:GO:0003729          GeneOntology
## 230                 uniprot:A0A140VKC4        Uniprot-TrEMBL
## 231                   refseq:NM_004992                RefSeq
## 232                      go:GO:1990841          GeneOntology
## 233                      go:GO:0003723          GeneOntology
## 234                      go:GO:0001666          GeneOntology
## 235                    ucsc:uc065cbf.1   UCSC Genome Browser
## 236                      go:GO:0045202          GeneOntology
## 237                 uniprot:A0A0D9SFX7        Uniprot-TrEMBL
## 238                    ucsc:uc004fjw.4   UCSC Genome Browser
## 239                      go:GO:0001662          GeneOntology
## 240                refseq:NP_001356320                RefSeq
## 241                      go:GO:0007416          GeneOntology
## 242                      go:GO:0051570          GeneOntology
## 243     affy.probeset:X94628_rna1_s_at                  Affy
## 244                      go:GO:0010385          GeneOntology
## 245        affy.probeset:11722683_a_at                  Affy
## 246                  hgnc.symbol:MECP2                  HGNC
## 247        illumina.probe:ILMN_1824898              Illumina
## 248                      go:GO:0050905          GeneOntology
## 249                refseq:NP_001356321                RefSeq
## 250                refseq:NP_001356322                RefSeq
## 251                refseq:NP_001356323                RefSeq
## 252                    ucsc:uc288pkg.1   UCSC Genome Browser
## 253                      go:GO:0002087          GeneOntology
## 254          affy.probeset:202618_s_at                  Affy
## 255                      go:GO:0048167          GeneOntology
## 256                   refseq:NP_004983                RefSeq
## 257 affy.probeset:Hs.3239.0.S2_3p_a_at                  Affy
## 258             affy.probeset:17115453                  Affy
## 259                      go:GO:0031175          GeneOntology
## 260                      go:GO:0016358          GeneOntology
```

Finally, the respective Ensemble identifier for the HGNC symbol asked in the beginning of the tutorial can be found by checking the Ensembl database in the output.


```r
dat[which(dat$database == "Ensembl"), ]
```

```
##                  identifier database
## 123 ensembl:ENSG00000169057  Ensembl
```



    '4027037\tAffy\n4027036\tAffy\n4027039\tAffy\nNP_001356323\tRefSeq\n4027038\tAffy\nNP_001356322\tRefSeq\nGO:0042551\tGeneOntology\nNP_001356321\tRefSeq\nuc065car.1\tUCSC Genome Browser\nNP_001356320\tRefSeq\n4204\tWikiGenes\nGO:0051707\tGeneOntology\nGO:0043524\tGeneOntology\nHMNXSV003039744\tAgilent\nILMN_1702715\tIllumina\nGO:0045944\tGeneOntology\nuc065caz.1\tUCSC Genome Browser\nA_33_P3339036\tAgilent\nGO:0006576\tGeneOntology\nuc065cbc.1\tUCSC Genome Browser\n4027031\tAffy\n4027030\tAffy\n4027033\tAffy\n4027032\tAffy\n4027035\tAffy\n4027034\tAffy\nGO:0060090\tGeneOntology\n4027048\tAffy\n4027047\tAffy\n4027049\tAffy\nGO:0090063\tGeneOntology\nGO:0002087\tGeneOntology\nGO:0007416\tGeneOntology\nXP_047298078\tRefSeq\nXP_047298073\tRefSeq\nXP_047298071\tRefSeq\nXP_047298072\tRefSeq\nGO:0007420\tGeneOntology\n4027040\tAffy\n4027042\tAffy\nGO:0046470\tGeneOntology\n4027041\tAffy\n4027044\tAffy\n4027043\tAffy\nGO:0010385\tGeneOntology\nILMN_3310740\tIllumina\n4027046\tAffy\n4027045\tAffy\n11722682_at\tAffy\n4027059\tAffy\n4027058\tAffy\nGO:1990841\tGeneOntology\nGO:0003723\tGeneOntology\nGO:0001666\tGeneOntology\nGO:0003729\tGeneOntology\nuc065cas.1\tUCSC Genome Browser\nGO:0001662\tGeneOntology\nNM_001369391\tRefSeq\nNM_001369392\tRefSeq\nNM_001369393\tRefSeq\nNM_001369394\tRefSeq\nuc065cbd.1\tUCSC Genome Browser\n4027051\tAffy\n4027050\tAffy\n4027053\tAffy\n4027052\tAffy\n4027055\tAffy\n4027057\tAffy\nGO:0016358\tGeneOntology\nNM_004992\tRefSeq\nGO:0003714\tGeneOntology\n4027069\tAffy\nuc004fjv.4\tUCSC Genome Browser\nHGNC:6990\tHGNC Accession number\nD3YJ43\tUniprot-TrEMBL\nGO:0043537\tGeneOntology\nGO:0006541\tGeneOntology\nGO:0040029\tGeneOntology\nA_33_P3317211\tAgilent\nNP_001303266\tRefSeq\n11722683_a_at\tAffy\nGO:0051151\tGeneOntology\n4027060\tAffy\nNM_001110792\tRefSeq\n4027062\tAffy\n4027061\tAffy\n4027063\tAffy\n4027065\tAffy\n4027068\tAffy\nA0A0D9SEX1\tUniprot-TrEMBL\nGO:0098794\tGeneOntology\n5BT2\tPDB\nGO:0006020\tGeneOntology\nGO:0140693\tGeneOntology\nGO:0031175\tGeneOntology\nGO:1905643\tGeneOntology\nuc065cbe.1\tUCSC Genome Browser\n6C1Y\tPDB\nGO:0060291\tGeneOntology\n202618_s_at\tAffy\n17115453\tAffy\n4027079\tAffy\n4027078\tAffy\nGO:0048167\tGeneOntology\nuc004fjw.4\tUCSC Genome Browser\nGO:0031507\tGeneOntology\nGO:0008306\tGeneOntology\nGO:0007219\tGeneOntology\nGO:0010629\tGeneOntology\nuc288oyf.1\tUCSC Genome Browser\nGO:0007585\tGeneOntology\n4027080\tAffy\ng972764_3p_a_at\tAffy\n4027082\tAffy\n4027081\tAffy\nGO:0051570\tGeneOntology\n4027084\tAffy\ng7710148_3p_a_at\tAffy\nuc288pkg.1\tUCSC Genome Browser\n4027083\tAffy\n4027086\tAffy\n4027085\tAffy\n4027088\tAffy\nHs.3239.0.S2_3p_a_at\tAffy\n4027087\tAffy\n4027089\tAffy\n6OGJ\tPDB\n6OGK\tPDB\nXM_047442122\tRefSeq\nGO:0005829\tGeneOntology\nuc065cau.1\tUCSC Genome Browser\n202616_PM_s_at\tAffy\nGO:0006357\tGeneOntology\nGO:0010971\tGeneOntology\nGO:0099191\tGeneOntology\nGO:0008542\tGeneOntology\nGO:0060079\tGeneOntology\nuc065cbf.1\tUCSC Genome Browser\n4027091\tAffy\n4027090\tAffy\n4027092\tAffy\nC9JH89\tUniprot-TrEMBL\n4027099\tAffy\nGO:0032048\tGeneOntology\nuc288qen.1\tUCSC Genome Browser\nGO:0005813\tGeneOntology\nXM_047442117\tRefSeq\nP51608\tUniprot-TrEMBL\n1QK9\tPDB\nGO:0006349\tGeneOntology\nGO:0000122\tGeneOntology\nNP_001373068\tRefSeq\nGO:0001964\tGeneOntology\nuc065cav.2\tUCSC Genome Browser\nNP_001373066\tRefSeq\nNP_001373067\tRefSeq\n34355_at\tAffy\nGO:0007268\tGeneOntology\nMECP2\tHGNC\nuc065cbg.2\tUCSC Genome Browser\nA0A6Q8PF93\tUniprot-TrEMBL\nGO:0035176\tGeneOntology\nGO:0060252\tGeneOntology\nTC0X002288.hg\tAffy\nGO:0033555\tGeneOntology\nGO:0045892\tGeneOntology\nA_23_P114361\tAgilent\nGO:0045893\tGeneOntology\nENSG00000169057\tEnsembl\nGO:0005515\tGeneOntology\nGO:0005634\tGeneOntology\nGO:0008104\tGeneOntology\nHMNXSV003006762\tAgilent\n300005\tOMIM\nNP_001104262\tRefSeq\nNP_004983\tRefSeq\nGO:0016525\tGeneOntology\nNM_001316337\tRefSeq\nuc065caw.1\tUCSC Genome Browser\nA0A0D9SFX7\tUniprot-TrEMBL\nA0A140VKC4\tUniprot-TrEMBL\nGO:0019233\tGeneOntology\nGO:0045202\tGeneOntology\nGO:0021591\tGeneOntology\nuc288oef.1\tUCSC Genome Browser\n202618_PM_s_at\tAffy\nGO:0019230\tGeneOntology\nGO:0003682\tGeneOntology\n6YWW\tPDB\nuc065cbh.1\tUCSC Genome Browser\nX99687_at\tAffy\nGO:0008344\tGeneOntology\nGO:0009791\tGeneOntology\nGO:0019904\tGeneOntology\nGO:0030182\tGeneOntology\nGO:0035197\tGeneOntology\n8175998\tAffy\nTC0X001524.hg\tAffy\nuc286dlz.1\tUCSC Genome Browser\n8175977\tAffy\nGO:0005615\tGeneOntology\nGO:0005737\tGeneOntology\n202617_s_at\tAffy\nGO:0050905\tGeneOntology\nGO:0008327\tGeneOntology\nGO:0003677\tGeneOntology\nGO:0003676\tGeneOntology\nGO:0008211\tGeneOntology\n17115428\tAffy\nX89430_at\tAffy\nGO:2000820\tGeneOntology\n4027100\tAffy\nA0A6Q8PHQ3\tUniprot-TrEMBL\nGO:0003700\tGeneOntology\nGO:0047485\tGeneOntology\n4204\tEntrez Gene\n202617_PM_s_at\tAffy\n3C2I\tPDB\nGO:0000792\tGeneOntology\nuc065cax.1\tUCSC Genome Browser\nGO:0008283\tGeneOntology\nGO:0008284\tGeneOntology\nuc065cba.1\tUCSC Genome Browser\nGO:0016573\tGeneOntology\nNM_001386139\tRefSeq\nuc286dmb.1\tUCSC Genome Browser\nA0A1B0GTV0\tUniprot-TrEMBL\nuc065cbi.1\tUCSC Genome Browser\nuc286dly.1\tUCSC Genome Browser\nGO:0007616\tGeneOntology\nGO:0016571\tGeneOntology\nGO:0007613\tGeneOntology\nGO:0007612\tGeneOntology\nGO:0021549\tGeneOntology\n11722684_a_at\tAffy\nX94628_rna1_s_at\tAffy\nGO:0010467\tGeneOntology\nGO:0010468\tGeneOntology\nA_24_P237486\tAgilent\nHMNXSV003048644\tAgilent\nGO:0050884\tGeneOntology\nH7BY72\tUniprot-TrEMBL\n202616_s_at\tAffy\nuc065cay.1\tUCSC Genome Browser\nuc065cbb.1\tUCSC Genome Browser\nGO:0007052\tGeneOntology\nuc286dma.1\tUCSC Genome Browser\nB5MCB4\tUniprot-TrEMBL\nGO:0050432\tGeneOntology\n4027026\tAffy\nuc286dlx.1\tUCSC Genome Browser\n4027025\tAffy\nGO:0001976\tGeneOntology\n4027028\tAffy\n4027027\tAffy\nNM_001386138\tRefSeq\n4027029\tAffy\nNM_001386137\tRefSeq\nILMN_1682091\tIllumina\nGO:0005654\tGeneOntology\nGO:1900114\tGeneOntology\nGO:0014009\tGeneOntology\nILMN_1824898\tIllumina\n4027024\tAffy\n0006510725\tIllumina\n4027023\tAffy\n'



You can also see the results are returned as a TSV file, consisting of two columns, the identifier and the matching database.

We will want to convert this reply into a Python dictionary (with the identifier as key, as one database may have multiple identifiers):


```python
lines = response.text.split("\n")
mappings = {}
for line in lines:
    if ('\t' in line):
        tuple = line.split('\t')
        identifier = tuple[0]
        database = tuple[1]
        if (database == "Ensembl"):
            mappings[identifier] = database

print(mappings)
```

    {'ENSG00000169057': 'Ensembl'}


Alternatively, we can restrivct the return values from the BridgeDb webservice to just return Ensembl identifiers (system code `En`). For this, we add the `?dataSource=En` call parameter:


```python
callUrl = 'https://webservice.bridgedb.org/Human/xrefs/H/MECP2?dataSource=En'
response = requests.get(callUrl)
response.text
```




    'ENSG00000169057\tEnsembl\n'


