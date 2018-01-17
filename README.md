# gene2bcp

## gene2bcp software allow to annotate a human gene symbol list with implication in metabolism pathways

### metabolism pathway database was built with BioCycPathway annotations for human gene symbols
>https://biocyc.org/
### dependencies: need to install "moreutils" library because this program use "sponge" command line 
### under debian: >sudo apt-get install moreutils

#### this shell script allow to found metabolic genes from a human gene list 
**********************
#### usage: sh gene2bcp.sh humangene.txt
***********
author: christophe.desterke@gmail.com
licence : MIT
