#!/bin/bash
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# tester wavfuncentry - Testing using func_factorial to illustrate
#                       the wave pattern of wavfuncentry and
#                       wavfuncexit
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|07/24/2022| Testing func_factorial and wavfuncentry
#_____________________________________________________________________

source func.errecho
source func.cwave
source func.insufficient
source func.arithmetic

TESTNAME="Test of function (func.cwave) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]]\n
\t-d\t<#>\tset the debug level to <#>, use -hv to see levels\n
\t-h\t\tPrint this message\n
\t-v\t\tVerbose mode to show values\n
\t\tVerifies that the factorial function works and that wavfuncentry
\t\twill illustrate the entry/exit pattern for the function.
\t\tNormally emits only PASS|FAIL message\n
"

optionargs="d:hv"
verbosemode="FALSE"
verboseflag=""
FUNC_DEBUG=0

while getopts ${optionargs} name
do
	case ${name} in
	h)
		echo -e ${USAGE}
		exit 0
    if [[ "${verbosemode}" == "TRUE" ]]
    then
      echo -e ${DEBUG_USAGE}
    fi
		;;
  d)
    if [[ ! "${OPTARG}" =~ $re_digit ]]
    then
      errecho "-d requires a decimal digit"
    fi
    FUNC_DEBUG="${OPTARG}"
    ;;
	v)
		verbosemode="TRUE"
    verboseflag="-v"
		;;
	\?)
		errecho "-e" "invalid option: -${OPTARG}"
		errecho "-e" ${USAGE}
		exit 1
		;;
	esac
done

########################################################################
# tv short for testvalue
# tr short for testresult
########################################################################

declare -a tv
declare -a tr

tv[0]=4
tr[0]=24

tv[1]=5
tr[1]=120

tv[2]=6
tr[2]=720

fail=0

#for ti in { 0 $((${#tv[@]}-1)) }
for ((ti=0;ti<${#tv[@]};i++))
do
  if [[ "${verbosemode}" == "TRUE" ]]
  then
    echo "$(func_factorial ${tv[${ti}]} ) should be ${tr[${ti}]}"
  fi
  if [[ ! "$(func_factorial ${tv[${ti}]} )" -eq "${tr[${ti}]}" ]]
  then
    ((fail++))
  fi
done

exit ${fail}
