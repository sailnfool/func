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

    export __kbibytessuffix=("BYT" "KIB" "MIB" "GIB" "TIB" "PIB" "EIB" "ZIB")
    export __kbytessuffix="BKMGTPEZ"
    for i in $(seq 0 ${#__kbytessuffix})
    do
      bytesuffix=${__kbytesuffix:${i}:1}
      bibytesuffix=$__kbibytesuffix[${1}]
      __kbytesvalue[${bytesuffix}]=$(echo "1000 ^ ${i}" | bc)
      __kbibytesvalue[${bibytesuffix}]=$(echo "1024 ^ ${i}" | bc)
      echo "Byte Suffix $i = \"${bytesuffix}\", " \
        "value=\"__kbytesvalue[${bytesuffix}]\""
      echo "BiByte Suffix $i = \"${bibytesuffix}\", " \
        "value=\"__kbibytesvalue[${bibytesuffix}]\""
    done
#    export __byte=1
#    export __kibibyte=$((__byte * 1024))
#    export __kbyte=$((__byte * 1000))
#    export __mibibyte=$((__kibibyte * 1024))
#    export __mbyte=$((__kbyte * 1000))
#    export __gibibyte=$((__mibibyte * 1024))
#    export __gbyte=$((__mbyte * 1000))
#    export __tibibyte=$((__gibibyte * 1024))
#    export __tbyte=$((__gbyte * 1000))
#    export __pibibyte=$((__tibibyte * 1024))
#    export __pbyte=$((__tbyte * 1000))
#    export __eibibyte=$((__pibibyte * 1024))
#    export __ebyte=$((__pbyte * 1000))
#    export __zibibyte=$((__eibibyte * 1024))
#    export __zbyte=$((__ebyte * 1000))
fi # if [[ -z "${__kbytessuffix}" ]]
