#!/bin/bash
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# tester func.dec2hex - Testing conversion of decimal numbers to
#                       hexadecimal numbers.
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|03/20/2022| testing dec2hex
#_____________________________________________________________________

source func.errecho
source func.dec2hex

TESTNAME="Test of function global (func.dec2hex) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]]\n
\t-h\t\tPrint this message\n
\t-v\t\tVerbose mode to show values\n
\t\tVerifies that the function will convert decimal numbers to zero
\t\tprefixed hexadecimal values
\t\tNormally emits only PASS|FAIL message\n
"

optionargs="hv"
verbosemode="FALSE"
verboseflag=""

while getopts ${optionargs} name
do
	case ${name} in
	h)
		echo -e ${USAGE}
		exit 0
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
# td short for testdigits
# tr short for testresult
########################################################################
declare -a tv
declare -a td
declare -a tr

tv[0]=12
td[0]=3
tr[0]="00c"

tv[1]=15
td[1]=3
tr[1]="00f"

tv[2]=255
td[2]=3
tr[2]="0ff"

fail=0

########################################################################
# ti short for testindex
########################################################################
for ti in { 0 $(( ${#tv[@]} - 1 )) }
do
  if [[ "${verbosemode}" == "TRUE" ]]
  then
    echo "$(func_dec2hex ${tv[${ti}]} ${td[${ti}]}) should ${tr[${ti}]}"
  fi

  if [[ ! "$(func_dec2hex ${tv[${ti}]} ${td[${ti}]})" == "${tr[${ti}]}" ]]
  then
    ((fail++))
  fi
done

exit ${fail}
