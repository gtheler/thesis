#!/bin/bash -e

for i in git date; do
 if [ -z "$(which ${i})" ]; then
  echo "error: ${i} not installed"
  exit 1
 fi
done

currentdateedtf=$(date +%Y-%m-%d)

headepoch=$(git log -1 --format="%ct")
headdateedtf=$(date -d@${headepoch} +%Y-%m-%d)
# TODO: read locale from _quarto.yml's lang
monthyear=$(LANG="es_AR.utf8" date -d@${headepoch} +"%B %Y")

hash=$(git rev-parse --short HEAD)

# if the current working tree is not clean, we add a "+"
# (should be $\epsilon$, but it would screw the file name),
# set the date to today and change the author to the current user,
# as it is the most probable scenario
if [ -z "$(git status --porcelain)" ]; then
  dateedtf=${headdateedtf}
else
  dateedtf=${currentdateedtf}
  hash="${hash}+dirty"
fi

cat << EOF > _date.yml.local
git_hash: ${dateedtf}--${hash}
format:
  pdf:
    include-in-header: 
      - text: \\cfoot{\\tiny{${dateedtf}--${hash}}}
book:
  date: ${dateedtf}
EOF

