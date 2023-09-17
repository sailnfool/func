#!/bin/bash
scriptname=${0##*/}
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# tester.func.toseconds - test the function toseconds emit a pass/fail
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.1 |REN|06/04/2022| Added command line option processing to add
#                    | -v verbose options.  Switched to using arrays
#                    | for the test values and result.
# 1.0 |REN|02/02/2022| testing reconstructed kbytes
#_____________________________________________________________________

source func.cwave
source func.debug
source func.errecho
source func.regex
source func.toseconds

TESTNAME="Test of function toseconds (func.toseconds) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t\tVerifies that the function will convert oddly format times into 
\t\tseconds only\n
\t\tNormally emits only PASS|FAIL message\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see the diagnostic levels.\n
\t-h\t\tPrint this message\n
\t-v\t\tVerbose mode to show values\n
"

optionargs="d:hv"
verbosemode="FALSE"
verboseflag=""
fail=0

while getopts ${optionargs} name
do
	case ${name} in
  	d)
      if [[ ! "${OPTARG}" =~ $re_digit ]] ; then
        errecho "${0##/*}" "${LINENO}" "-d requires a decimal digit"
        errecho -e "${USAGE}"
        errecho -e "${DEBUG_USAGE}"
        exit 1
      fi
  		FUNC_DEBUG="${OPTARG}"
  		export FUNC_DEBUG
  		if [[ $FUNC_DEBUG -ge ${DEBUGSETX} ]] ; then
  			set -x
  		fi
  		;;
  	h)
  		echo -e ${USAGE}
      if [[ "${verbosemode}" == "TRUE" ]] ; then
        echo -e ${DEBUG_USAGE}
      fi
  		exit 0
  		;;
  	v)
  		verbosemode="TRUE"
      verboseflag="-v"
  		;;
  	\?)
  		errecho "-e" "invalid option: -$OPTARG"
  		errecho "-e" ${USAGE}
  		exit 1
  		;;
	esac
done

shift $(( ${OPTIND} - 1 ))

########################################################################
# tv is short for testvalue
# tr is short for testresult
########################################################################
declare -a tv
declare -a tr

tv[0]="40.25"
tr[0]="40.25"

tv[1]="10:40.25"
tr[1]="640.25"

tv[2]="5:15:20.4"
tr[2]="18920.4"

tv[3]="20:10:40.25"
tr[3]="72640.25"

tv[4]=".08"
tr[4]="0.08"

fail=0

########################################################################
# ti is short for testincrement
########################################################################
for ((ti=0;ti<${#tv[@]};ti++))
do
  if [[ ! "$(toseconds ${tv[${ti}]})" == "${tr[${ti}]}" ]] ; then
    ((fail++))
    if [[ "${verbosemode}" == "TRUE" ]] ; then
      waverrindentvar "Failed test of toseconds ${tv[${ti}]}"
      waverrindentvar "    expected ${tr[${ti}]}"
      waverrindentvar "    received $(toseconds ${verboseflag} ${tv[${ti}]})"
    fi
  fi
done
exit ${fail}
