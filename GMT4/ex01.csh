#!/bin/csh
psbasemap -Rg -JA110/23.5/7i -B30g30/15g15 -P -V -K > ex01.ps
gs ex01.ps
