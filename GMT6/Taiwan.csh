#!/bin/bash
#2020/07/01 ctc
set begla = 21.8
set endla = 25.8
set beglo = 118
set endlo = 122.3

gmt coast -R${beglo}/${endlo}/${begla}/${endla} -JM6i -W0.1p,black -Gdarkseagreen2 \
	  -Scornflowerblue -Ba2f0.5g1 -BWSNE+t"Taiwan" -LjBR+c20+o1c/1c+f+w50k+u -U -V \
	  -ps Taiwan
