#!/bin/csh
#2020/07/01 ctc
set begla = 20
set endla = 50
set beglo = 110
set endlo = 150
#Taiwan, Japan, Republic of Korea
set color1 = '240/230/140'
set colorgroup1 = 'TW,JP,KR'
#China
set color2 = '#CD5C5C'
set colorgroup2 = 'CN'
#Russian Federation, Democratic People's Republic of Korea
set color3 = 'pink'
set colorgroup3 = 'RU'
#Democratic People's Republic of Korea
set color4 = 'orange'
set colorgroup4 = 'KP'
#others
set color0 = '169'

gmt begin EastAsia png,ps
	gmt grdimage @earth_relief_01m -R${beglo}/${endlo}/${begla}/${endla} -JM6i -Cmby.cpt -V
        gmt coast -G${color0} \
        -E${colorgroup1}+g${color1} \
        -E${colorgroup2}+g${color2} \
        -E${colorgroup3}+g${color3} \
        -E${colorgroup4}+g${color4} \
	-LjBR+c20+o1c/1c+f+w1000k+u  -V
        gmt coast -W1/thinner -N1/thinner -Di -Bafg -B+t"EastAsia" -V
        gmt colorbar -Cmby.cpt -DjLM+w3c -G-8000/0 -Bx2000 -By+lm -F+gwhite@50 -V
gmt end show
