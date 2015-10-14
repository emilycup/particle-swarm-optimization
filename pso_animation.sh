#call octave to create all snapshots
octave pso2.m

#create animated GIF
convert -delay 10 -loop 0 Chandelier*.png Chandelier.gif

#delete images afterwards
rm *.png