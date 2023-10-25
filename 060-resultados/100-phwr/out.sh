for i in phwr*.fee; do
 feenox $i --progress --log_view | tee $i.out
done
