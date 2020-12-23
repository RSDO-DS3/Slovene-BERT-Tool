#!/bin/bash
# Cleans/minimizes .vert files from WaC corpus so that they're ready for onion deduplicator

infile=$1
outfile=$2

cat $infile | egrep -v '</name>|<name|<gap' | awk '{print $1}' | sed 's/<text/<doc>/g;s|</text>|</doc>|g;s|<p|<p>|g' > $outfile
