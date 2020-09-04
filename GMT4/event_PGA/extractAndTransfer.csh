#!/bin/csh
# UPDATE: 2020/09/02, ctc
#
# Goals:
# 1. extracting sac & PZ files from fullseed
# 2. writing the event info in to sac header
# 3. trans to disp, vel, acc
# 
# Given:
# 1. catalog.dat (sholud only contain data and no header text above)
# 2. seed directory (name of .seed files should be named after the event datetime)
#
# Constraints:
# none
# 
# Developed:
# 1. extracting sac & PZ files from fullseed
# 2. writing the event info in to sac header
# 3. trans to none, vel, acc
#
# Under developement: 
# 
# Notes:
# 1. only take [net],[sta],[loc],[channel] into consider during match each sac file to PZ file. [startTime],[endTime] are not considered.
# 
# Debug:
# 1. 20181125235723 trans to none. (At least 2 files entcouter error)
# SEISMIC ANALYSIS CODE [11/11/2013 (Version 101.6a)]
# Copyright 1995 Regents of the University of California
# Time of data not found in file
# Date Time: 2018/11/25 (329) 23:57:23.000
# ERROR 2114: No response information for this channel in response file. 
# Station: TW.A032.HLE.10
# 2018.329.23.55.23.0025.TW.A032.10.HLE.D.SAC.none
# ------------------------------------------------
# SAC_PZs_TW_A032_HLE_10_2018.330.00.00.00.0000_2599.365.23.59.59.99999
# SAC_PZs_TW_A032_HLN_10_2018.330.00.00.00.0000_2599.365.23.59.59.99999
# SAC_PZs_TW_A032_HLZ_10_2018.330.00.00.00.0000_2599.365.23.59.59.99999
# ------------------------------------------------
# [SOLUTION]
# use rdseed4 to extract PZfiles to get PZfiles without header.
# This is because rdseed5 will extract PZfiles with header.


# =====Paramerters settings===== #
if ( -s 'catalog.dat' ) then
  set catalog = 'catalog.dat'
else
  echo '\n catalog.dat does not exist.\n'
  exit 1
endif
set dateColumn = `awk '{print $1}' $catalog`
set time = `awk '{print $2}' $catalog`
set lat = `awk '{print $3}' $catalog`
set lon = `awk '{print $4}' $catalog`
set depth = `awk '{print $5}' $catalog`
set ML = `awk '{print $6}' $catalog`
set fileDir = '/middle/CWBGDMS/GDMS_check/local_event'
set seedDir = $fileDir/seed
set f1None = 0.02 
set f2None = 0.05
set f3None = 1
set f4None = 5
set f1Acc = 0.01
set f2Acc = 0.02
set f3Acc = 30
set f4Acc = 50
set i = 1

# =====Deal with each earthqauke event listed in the catalog.dat===== #
foreach event ( $time )
  echo '#' $i
  set yr = `echo $dateColumn[$i] | awk -F'-' '{print $1}'`
  set mm = `echo $dateColumn[$i] | awk -F'-' '{print $2}'`
  set day = `echo $dateColumn[$i] | awk -F'-' '{print $3}'`
  set jday = `date +%j --date="$yr-$mm-$day"`
  set hr = `echo $time[$i] | awk -F':' '{print $1}'`
  set min = `echo $time[$i] | awk -F':' '{print $2}'`
  set sec = `echo $time[$i] | awk -F':' '{print $3}' | awk -F'.' '{print $1}'`
  set evla = $lat[$i]
  set evlo = $lon[$i]
  set evdp = $depth[$i]
  set mag = $ML[$i]
  echo $yr $mm $day $jday $hr $min $sec $evla $evlo $evdp $mag


# =====Checking fullseed raw data existence===== #
  if ( ! -s $seedDir/$yr$mm$day$hr$min$sec.seed ) then
    echo $yr$mm$day$hr$min$sec.seed 'do not exist. Abort!'
    exit 1
  endif


# =====Extracting sac & PZ files===== #
# has no dir
  if ( ! -d $yr$mm$day$hr$min$sec ) then
    echo 'mkdir' $yr$mm$day$hr$min$sec
    mkdir $yr$mm$day$hr$min$sec
# has a dir already
  else
    echo $yr$mm$day$hr$min$sec 'exist.' 'Pass!'
    @ i = $i + 1
    continue
  endif

  echo 'cd' $yr$mm$day$hr$min$sec 
  cd $yr$mm$day$hr$min$sec
  echo 'extracting sac from' $yr$mm$day$hr$min$sec.seed
  /home/dmc/bin/rdseed5 -d -f $seedDir/$yr$mm$day$hr$min$sec.seed  >& /dev/null
  echo 'extracting PZfiles'
# rdseed5 will extract PZfiles "with" header. Time dismatch will occur during transfering sac to none.
#  /home/dmc/bin/rdseed5 -p -f $seedDir/$yr$mm$day$hr$min$sec.seed  >& /dev/null
# rdseed(4) will extract PZfiles "without" header.
  /home/dmc/bin/rdseed -p -f $seedDir/$yr$mm$day$hr$min$sec.seed  >& /dev/null


# =====Writing event info into sac header===== #
# station info has already in the sac file due to rdseed5 tool
  echo "r *SAC ; synch; ch O GMT $yr $jday $hr $min $sec 00; ch allt ( 0 - &1,O );wh;\
    ch evla $evla evlo $evlo evdp $evdp mag $mag; wh;q" | sac >& /dev/null


# =====Find stations info [net, stn, loc, cha, startTime, endTime]===== #
# 2018.037.15.48.41.0025.TW.A034.10.HLE.D.SAC 
  set SACfiles = `ls *SAC`

  echo 'transfering...'
foreach sac ( $SACfiles )
  set yySAC = `echo $sac | awk -F'.' '{print $1}'`
  set jdaySAC = `echo $sac | awk -F'.' '{print $2}'`
  set net = `echo $sac | awk -F'.' '{print $7}'`
  set sta = `echo $sac | awk -F'.' '{print $8}'`
  set loc = `echo $sac | awk -F'.' '{print $9}'`
  set cha = `echo $sac | awk -F'.' '{print $10}'`
#  echo $yySAC $jdaySAC $net $sta $loc $cha


# =====Matching sac to PZ file===== #
# SAC_PZs_TW_A034_HLE_10_2017.328.00.00.00.0000_2599.365.23.59.59.99999
  set PZfile = `ls $fileDir/$yr$mm$day$hr$min$sec/SAC_PZs_$net'_'$sta'_'$cha'_'$loc'_'*'_'*`
  echo $sac match to $PZfile


# =====Transfer to displacement, velocity, acceleration===== #
# trans to disp
#  echo "r $sac ; qdp off; rmean; rtr; taper; trans from polezero s $PZfile to none freq $f1None $f2None $f3None $f4None; w append .disp; q"
  echo "r $sac ; qdp off; rmean; rtr; taper;\
    trans from polezero s $PZfile to none freq $f1None $f2None $f3None $f4None; w append .disp; q" | sac >& /dev/null

# trans to vel
#  echo "r $sac ; qdp off; rmean; rtr; taper; trans from polezero s $PZfile to vel freq $f1Acc $f2Acc $f3Acc $f4Acc; w append .vel; q"
  echo "r $sac ; qdp off; rmean; rtr; taper;\
    trans from polezero s $PZfile to vel freq $f1Acc $f2Acc $f3Acc $f4Acc; w append .vel; q" | sac >& /dev/null

# trans to acc
#  echo "r $sac ; qdp off; rmean; rtr; taper; trans from polezero s $PZfile to acc freq $f1Acc $f2Acc $f3Acc $f4Acc; w append .acc; q"
  echo "r $sac ; qdp off; rmean; rtr; taper;\
    trans from polezero s $PZfile to acc freq $f1Acc $f2Acc $f3Acc $f4Acc; w append .acc; q" | sac >& /dev/null

end # foreach sac ( $SACfiles )

  @ i = $i + 1
  cd ..
end # foreach event ( $time )

echo 'done'
