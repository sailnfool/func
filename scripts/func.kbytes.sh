#!/bin/bash
########################################################################
# Author Robert E. Novak
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.1 | REN |02/08/2022| redo using arrays instead of named variables
#                      | see the accompanying test function
# 1.0 | REN |02/01/2022| Reconstructed from func.nice2num
#_____________________________________________________________________
#
########################################################################
if [[ -z "${__kbytessuffix}" ]]
then
    declare -a __kbibytessuffix
    declare -A __kbytesvalue
    declare -A __kbibytesvalue

    export __kbibytessuffix=("BYT" "KIB" "MIB" "GIB" "TIB" "PIB" \
      "EIB" "ZIB")
    export __kbytessuffix="BKMGTPEZ"
    for i in $(seq 0 $((${#__kbytessuffix}-1)) )
    do
      bytesuffix=${__kbytessuffix:${i}:1}
      bibytesuffix=${__kbibytessuffix[${i}]}
      __kbytesvalue[${bytesuffix}]=$(echo "1000 ^ ${i}" | bc)
      __kbibytesvalue[${bibytesuffix}]=$(echo "1024 ^ ${i}" | bc)
#       echo "Byte Suffix $i = \"${bytesuffix}\", " \
#         "value=\"${__kbytesvalue[${bytesuffix}]}\""
#       echo "BiByte Suffix $i = \"${bibytesuffix}\", " \
#         "value=\"${__kbibytesvalue[${bibytesuffix}]}\""
    done
#    echo "__kbytesvalue = ${__kbytesvalue[@]}"
#    echo "__kbibytesvalue = ${__kbibytesvalue[@]}"
    export __kbytesvalue
    export __kbibytesvalue
fi # if [[ -z "${__kbytessuffix}" ]]
