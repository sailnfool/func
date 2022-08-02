#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|02/08/2022| testing num2nice
#_____________________________________________________________________

source func.debug
source func.errecho
source func.kbytes
source func.num2nice
source func.nice2num
source func.regex

TESTNAME="Test of function num2nice (func.num2nice) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t\tVerfies that a large number can be successfully be converted to a\n
\t\tnice number respresentation\n
\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see the diagnostic levels.\n
\t\tNormally exits with 0 (PASS) or 1 (FAIL)
\t-h\t\tPrint this message\n
\t-v\t\tVerbose mode to show values\n
"

optionargs="d:hv"
verbosemode="FALSE"
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
  		;;
  	\?)
  		errecho "-e" "invalid option: -$OPTARG"
  		errecho "-e" ${USAGE}
  		exit 1
  		;;
	esac
done
shift $(( ${OPTIND} -1 ))

for ((i=1298;i<1324;i++))
do
  for ((j=0;j<${#__kbytessuffix};j++))
  do
    if [[ "${verbosemode}" == "TRUE" ]] ; then
      echo "Requesting $i${__kbytessuffix:$j:1}"
      echo $(num2nice $(nice2num "$i${__kbytessuffix:$j:1}") )
    fi
  done
done
exit 1
