#!/bin/csh
#2020/07/01 ctc
set begla = 21.8
set endla = 25.8
set beglo = 118
set endlo = 122.3

gmt begin TaiwanGrd png,ps
	gmt grdimage @earth_relief_01m -R${beglo}/${endlo}/${begla}/${endla} -JM6i -Cmby.cpt -V
	gmt coast -Ir/0.7p,cornflowerblue -Ccornflowerblue -Ba2f0.5 -BWSNE+t"Taiwan" -LjBR+c20+o1c/1c+f+w50k+u -U -V
        gmt colorbar -Cmby.cpt -DjLM+w3c -Bx2000 -By+lm -F+gwhite@50 -V
gmt end show
