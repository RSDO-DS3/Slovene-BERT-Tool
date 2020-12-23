#!/bin/bash

siparlpath="path/to/siparl/folder/"
for f in ${siparlpath}/*/*.vert
do
cat $f | egrep -v '</name>|<name|<speech|</speech>' | awk '{print $1}' | sed 's/<session/<doc>/g;s|</session>|</doc>|g;s|<p|<p>|g;s|<s|<s>|g' > ${f}.clean
done

for fold in SDT{2..7} SDZ{1..7} SSK11
do
cat ${siparlpath}/$fold/*.vert.clean > ${siparlpath}/siparl-${fold}.clean.vert
done
cat ${siparlpath}/siparl*.clean.vert > siparl-complete.clean.vert
