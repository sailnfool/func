#!/bin/sh
########################################################################
# Author Robert E. Novak
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |02/01/2022| Reconstructed from func.nice2num
#_____________________________________________________________________
#
########################################################################
if [[ -z "${__kbytessuffix}" ]]
then
    declare -a __kbibytessuffix
    declare -A __kbibytesvalue
    declare -A __kbytesvalue

    export __kbibytessuffix=("BYT" "KIB" "MIB" "GIB" "TIB" "PIB" \
      "EIB" "ZIB")
    export __kbytessuffix="BKMGTPEZ"
    set -x
    for i in $(seq 0 $((${#__kbytessuffix}-1)) )
    do
      bytesuffix=${__kbytessuffix:${i}:1}
      bibytesuffix=${__kbibytessuffix[${i}]}
      __kbytesvalue[${bytesuffix}]=$(echo "1000 ^ ${i}" | bc)
      __kbibytesvalue[${bibytesuffix}]=$(echo "1024 ^ ${i}" | bc)
      echo "Byte Suffix $i = \"${bytesuffix}\", " \
        "value=\"${__kbytesvalue[${bytesuffix}]}\""
      echo "BiByte Suffix $i = \"${bibytesuffix}\", " \
        "value=\"${__kbibytesvalue[${bibytesuffix}]}\""
    done
fi # if [[ -z "${__kbytessuffix}" ]]
