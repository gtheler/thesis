for i in $(seq $1 $2); do  feenox point.fee $i | tee -a point.dat; done
