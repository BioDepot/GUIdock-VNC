## script to test

# adjust this to where cyRestBase directory lives
cyRestBase <- "/deps/testDocker/cy-rest-R/";

## Commenting out original install methods as already installed as part of lib/r_serve.json
#source("https://bioconductor.org/biocLite.R")
#source(paste(cyRestBase,"cy-rest-R/utility/cytoscape_util.R",sep="/"))
#biocLite("networkBMA")
wd<-getwd();
source(paste("/deps/testDocker/cy-rest-R/utility/cytoscape_util.R",sep="/"))

library(networkBMA)
library(RJSONIO)
library(httr)
library(igraph)
data(vignette)
edges.iBMA <- networkBMA(data = timeSeries[,-(1:2)],nTimePoints = length(unique(timeSeries$time)),prior.prob = reg.prob, known = reg.known,nvar = 50, control = iBMAcontrolLM(),ordering = "bic1+prior", diff100 = FALSE, diff0 = FALSE)
goodEdges <- edges.iBMA[edges.iBMA$PostProb > .5,]
g <- graph.data.frame(goodEdges, directed = TRUE)
cyjs <- toCytoscape(g)
base.url="http://localhost:1234/v1";
network.url = paste(base.url, "networks", sep="/")
res <- POST(url=network.url, body=cyjs, encode="json")
network.suid = unname(fromJSON(rawToChar(res$content)))
apply.layout.url = paste(base.url, "apply/layouts/force-directed", toString(network.suid), sep="/")
GET(apply.layout.url)
