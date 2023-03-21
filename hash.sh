#!/bin/bash -e

for i in git grep locale sed date m4; do
 if [ -z "$(which ${i})" ]; then
  echo "error: ${i} not installed"
  exit 1
 fi
done

currentdateedtf=$(date +%Y-%m-%d)

headepoch=$(git log -1 --format="%ct")
headdateedtf=$(date -d@${headepoch} +%Y-%m-%d)

hash=$(git rev-parse --short HEAD)

# if the current working tree is not clean, we add a "+"
# (should be $\epsilon$, but it would screw the file name),
# set the date to today and change the author to the current user,
# as it is the most probable scenario
if [ -z "$(git status --porcelain)" ]; then
  dateedtf=${headdateedtf}
else
  dateedtf=${currentdateedtf}
fi



m4 "-Dgit_hash=${dateedtf}--${hash}" "-Dgit_date=${dateedtf}" quarto.yml > _quarto.yml
