#!/bin/bash

while read ac af; do
#  echo $ac $af
 feenox point-nucengdes.fee ${ac} ${af} | tee -a point.dat
done < rhalton

