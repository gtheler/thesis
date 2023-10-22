#!/bin/bash

for p in la-p01-PUa-1-0-IN  \
         la-p47-U-2-0-IN    \
         la-p70-URRa-2-1-IN \
         la-p05-PUb-1-0-IN  \
         la-p50-UAl-2-0-IN  \
         la-p74-URR-3-0-IN  \
         la-p75-URR6-6-0-IN; do
  feenox ${p}.fee
done
