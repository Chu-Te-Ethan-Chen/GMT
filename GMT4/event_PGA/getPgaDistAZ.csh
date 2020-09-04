#!/bin/csh
# UPDATE: 2020/09/03, ctc
#
# Goals:
# 1. find station lat lon E N Z dist az Acc Max3, MaxH, MaxZ, MaxS
#
# Given:
# 1. eventDir
#
# Constraints:
# none
# 
# Developed:
# 1. find station lat lon E N Z dist az Acc Max3, MaxH, MaxZ, MaxS
# 2. Find event info from the dir or argvs instead of the catalog.dat
# 3. Transform the unit from m/s/s to gal (cm/s/s)
#
# Under developement: none
# 
# Notes:
# 1. shell can not compare float. We should use awk to do that.
#
# Debug:
# 1. saclst: No match. in 20181023043458 and 20190807212803
#
# Assumption: 
# 1. Every staion are in the same net, loc, and has the same channels.
#    That is to say, this script can not deal with same station in different nets.
#    Moreover, a station can only has one location. We do not process multiple locations.
# 2. Amount of staions is not too much. This is because `ls` & `saclst` have their upper limit.

# =====Input arguments===== #
if($#argv != 1) then
  echo
  echo "getPgaDistAZ.csh [eventDir]"
  echo "-EX: getPgaDistAZ.csh 20190807212803"
  echo "-It will extract lat, lon, depmaxE, depmaxN, depmaxZ, dist, azimuth, Max3, MaxH, MaxZ, MaxS"
  echo
  exit 1
endif


# =====Paramerters settings===== #
set filename = $1
set fileDir = '/middle/CWBGDMS/GDMS_check/local_event'
set maxArray = (0 0 0)
set yr = `echo $filename | cut -c 1-4`
set mm = `echo $filename | cut -c 5-6`
set day = `echo $filename | cut -c 7-8`
set jday = `date +%j --date="$yr-$mm-$day"`
set hr = `echo $filename | cut -c 9-10`
set min = `echo $filename | cut -c 11-12`
set sec = `echo $filename | cut -c 13-14`
set output = TSMIP_PGAs_$filename.txt


# =====Checking files===== #
# has no dir
  if ( ! -d $fileDir/$filename ) then
    echo $fileDir/$filename 'do not exist.' 'Abort!'
    exit 1
# has a dir already
  else
#    echo $yr$mm$day$hr$min$sec 'exist.'
#    echo 'cd' $fileDir/$filename
    cd $fileDir/$filename
  endif

# ====Checking txt===== #
if ( ! -s $fileDir/$filename/$output ) then
  echo $fileDir/$filename/$output 'do not exist.' 'Start calculation!'
# has a TSMIP_PGAs_event.txt already
else
  echo $fileDir/$filename/$output 'exist.' 'Pass!'
  exit 1
endif

# =====Making stations & channels lists===== #
set stas = `saclst kstnm f *SAC.acc | awk '{print $2}' | sort -u`
#echo $stas
set chans = `ls *SAC.acc | awk -F'.' '{print $10}' | sort -u`
#echo $chans
if ( $#chans == 3 ) then
  echo sta lat lon $chans[1] $chans[2] $chans[3] dist az Max3 MaxH MaxZ MaxS > $output
else if ( $#chans == 2 ) then
  echo sta lat lon $chans[1] $chans[2] dist az Max3 MaxH MaxZ MaxS > $output
else
  echo sta lat lon $chans[1] dist az Max3 MaxH MaxZ MaxS > $output
endif


# =====Processing===== #
echo $yr $mm $day $jday $hr $min $sec
foreach sta ( $stas )
# station info
  set staInfo = `saclst kstnm stla stlo dist az f *.$sta.*.$chans[$#chans].*.acc`
  set kstnm = `echo $staInfo | awk '{print $2}'`
  set stla = `echo $staInfo | awk '{print $3}'`
  set stlo = `echo $staInfo | awk '{print $4}'`
  set dist = `echo $staInfo | awk '{print $5}'`
  set az = `echo $staInfo | awk '{print $6}'`
  set j = 1
  echo $kstnm $stla $stlo $dist $az
  foreach cha ( $chans )
    set depminMax = `saclst depmin depmax f *$sta*$cha*SAC.acc | sort -k2 -g -r | awk 'END {print $2}' | awk '{printf $1*(-1)}'`
    set depmaxMax = `saclst depmin depmax f *$sta*$cha*SAC.acc | sort -k3 -g -r | awk 'NR==1 {print $3}'`
    set maxArray[$j] = `echo $depminMax $depmaxMax | awk '{if ( $1 > $2 ) {printf "%f", $1*100} else {printf "%f", $2*100}}'`
    @ j = $j + 1 # channel
  end # foreach cha ( $chans )
  set Max3 = `echo $maxArray[1] $maxArray[2] $maxArray[3] | awk '{if( $1 > $2 && $1 > $3 ){print $1} else if( $2 > $3 ){print $2} else{print $3}}'`
  set MaxH = `echo $maxArray[1] $maxArray[2] | awk '{if( $1 > $2 ){print $1} else{print $2}}'`
  set MaxZ = $maxArray[3]
  set MaxS = `echo $maxArray[1] $maxArray[2] $maxArray[3] | awk '{printf "%f", sqrt($1*$1+$2*$2+$3*$3)}'`
  if ( $j == 4) then
    echo $kstnm $stla $stlo $maxArray[1] $maxArray[2] $maxArray[3] $dist $az $Max3 $MaxH $MaxZ $MaxS >> $output
  else if ( $j == 3 ) then
    echo $kstnm $stla $stlo $maxArray[1] $maxArray[2] $dist $az $Max3 $MaxH $MaxZ $MaxS >> $output
  else 
    echo $kstnm $stla $stlo $maxArray[1] $dist $az $Max3 $MaxH $MaxZ $MaxS >> $output
  endif  
end # foreach sta ( $stas )
