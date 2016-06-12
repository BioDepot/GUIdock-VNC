#!/bin/bash

run_and_clean (){
   echo "Running $1 of $2"
   /deps/testDocker/runCytoscapeTest.sh
}

clean_up (){
   pkill -9 java
   pkill -9 R
}


echo "Starting 4 warmups for consistent results"

run_and_clean 1 4
clean_up
run_and_clean 2 4
clean_up
run_and_clean 3 4
clean_up
run_and_clean 4 4
clean_up

date_nanoseconds /tmp/start
run_and_clean final final
date_nanoseconds /tmp/end

cat /tmp/start
cat /tmp/end
