#!/bin/csh
set figure = ex04.ps
set beglon = 121.3
set beglat = 23.5
set endlon = 121.5
set endlat = 23.9

psbasemap -JM5i -R120.7/121.7/23/24 -Ba1f1WsNe:."Seismicity(1991-2015)": -P -K -Y10 > $figure
makecpt -Cseis -T0/40/5 -Z -I > depth.cpt
awk '{print $8,$7}' alleq.dat | psxy -J -R -Sc0.1 -G200 -K -O -P >> $figure
awk '{print $8,$7,$9,$10/20}' output_mag3.dat | psxy -J -R -Sc -W0.1 -Cdepth.cpt -K -O -P >> $figure
pscoast -J -R -W3 -Dh -K -O >> $figure

#plot the box -> study area
psxy -J -R -W6/0/0/0 -K -O << ! >> $figure
$beglon $endlat
$endlon $endlat
$endlon $beglat
$beglon $beglat
$beglon $endlat
!

pstext -J -R -G255/0/0 -K -O << ! >> $figure
121.4 23.95 22 0 5 6 study area
!

psscale -Cdepth.cpt -D9/-0.8/12/0.5h -S -Ba10f5:,km:/:Depth: -I -X-2.5 -O >> $figure

gs $figure 
