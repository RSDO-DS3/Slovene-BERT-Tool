#!/bin/bash

kaspath="path/to/kas_folder/"
for f in ${kaspath}/*.vert
do
cat $f | egrep -v '</name>|<name|<page|</page>' | awk '{print $1}' | sed 's/<text/<doc>/g;s|</text>|</doc>|g;s|<p|<p>|g;s|<s|<s>|g' > ${f}.clean
done

cat ${kaspath}/*.vert.clean > kas-complete.clean.vert
