#!/bin/bash

for i in gnu; do
 for j in dif-src dif s2-src s2 s4-src s4; do
  echo $i $j
  feenox phwr-${j}.fee --log_view --eps_view --ksp_view | tee ${i}-phwr-${j}.out
 done
done
