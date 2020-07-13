#!/bin/bash
#2020/07/01 ctc
begla=21.8
endla=25.8
beglo=118
endlo=122.3

gmt coast -R${beglo}/${endlo}/${begla}/${endla} -JM6i -W0.1p,black -Gdarkseagreen2 \
	  -Scornflowerblue -Ba2f0.5g1 -BWSNE+t"Taiwan" -LjBR+c20+o1c/1c+f+w50k+u -U -V \
	  -ps Taiwan
