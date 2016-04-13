#!/bin/sh

#change directory to wherever Cytoscape is installed
/deps/cytoscape-unix-3.3.0/cytoscape.sh &

#change directory to wherever testBMA.R is installed
Rscript /deps/testDocker/testBMA.R
