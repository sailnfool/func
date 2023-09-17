#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.1 |REN|06/04/2022| testing hex2dec
# 1.0 |REN|03/20/2022| testing hex2dec
#_____________________________________________________________________

source func.debug
source func.errecho
source func.hex2dec
source func.regex

TESTNAME="Test of function global (func.hex2dec) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t\tVerifies that the function will convert hexadeximal numbers to
\t\tdecimal numbers\n
\t\tNormally emits only PASS|FAIL message\r\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see the diagnostic levels.\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
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

shift $(( ${OPTIND} - 1 ))
########################################################################
# tv short for testvalue
# tr short for testresult
########################################################################
declare -a tv
declare -a tr

tv[0]="00c"
tr[0]=12

tv[1]="00f"
tr[1]=15

tv[2]="0ff"
tr[2]=255

fail=0

########################################################################
# ti short for testindex
########################################################################
for ((ti=0;ti<${#tv[@]};ti++))
do
  if [[ "${verbosemode}" == "TRUE" ]] ; then
    echo "$(func_hex2dec ${tv[${ti}]} ) should ${tr[${ti}]}"
  fi

  if [[ ! "$(func_hex2dec ${tv[${ti}]} )" == "${tr[${ti}]}" ]] ; then
    ((fail++))
  fi
done

exit ${fail}
