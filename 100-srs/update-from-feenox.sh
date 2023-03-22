#!/bin/bash
dir=${HOME}/codigos/feenox

cp ${dir}/doc/[1234]*.md .
sed -i 's/sec:/sec-srs-/g' [1234]*.md

