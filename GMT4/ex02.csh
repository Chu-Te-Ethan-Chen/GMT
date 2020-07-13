#!/bin/csh
pscoast -JG124/15/6.2i -R30/210/-90/90 -N1/1p -I1/0/0/255 -G50/205/50 -S65/105/225 -W3 -Dh -Bg30 -A800 -P -V -K > ex02.ps
gs ex02.ps
