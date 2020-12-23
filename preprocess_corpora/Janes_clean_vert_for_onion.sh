#!/bin/bash
# Cleans/minimizes .vert files from Janes corpus so that they're ready for onion deduplicator

infile=$1
outfile=$2

cat $infile | egrep -v '</name>|<name|<text|</text>' | awk '{print $1}' | sed 's/<group/<doc>/g;s|</group>|</doc>|g' > $outfile
