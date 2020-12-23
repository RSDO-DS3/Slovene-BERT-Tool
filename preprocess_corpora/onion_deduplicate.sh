#!/bin/bash

# Deduplicate with onion, using low mem processing variant
# Usage: bash onion_deduplicate.sh input.vert output.vert

inputfile=$1
outputfile=$2
ngram=9
threshold=0.9

filename=$(echo $inputfile | awk -F '/' '{print $NF}')
mkdir -p tmp
hashgen -n $ngram -o tmp/${filename}.n${ngram}.hashes. ${inputfile}
hashdup -o tmp/${filename}.n${ngram}.dup_hashes tmp/${filename}.n${ngram}.hashes.*
onion -sm -n ${ngram} -t ${threshold} -f tmp/${filename}.n${ngram}.dup_hashes ${inputfile} > ${outputfile}
