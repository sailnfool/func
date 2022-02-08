#!/bin/sh
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |02/01/2022| testing reconstructed kbytes
#_____________________________________________________________________
#
########################################################################
source func.errecho
source func.kbytes
TESTNAME="Test of function kbytes (func.kbytes) from \n\thttps://github.com/sailnfool/func"
for i in $(seq 0 $((${#__kbytessuffix}-1)))
do
  suffix=${suffix}${__kbytessuffix:${i}:1}
done
if [[ ${suffix} == ${__kbytessuffix} ]]
then
  exit 0
else
  exit 1
fi

