for i in $(seq 0 1024); do
 feenox point.fee $i | tee -a point.dat
 gnuplot map.gp
 mv map.png map-$(printf %04d ${i}).png
done
ffmpeg -y -framerate 60 -f image2 -i map-%04d.png anim.mp4
