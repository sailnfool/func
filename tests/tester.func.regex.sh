#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.1 |REN|06/04/2022| Tweaked to exit with number of fails and to
#                      | use arrays for test values and results
# 1.0 |REN|03/20/2022| testing regex
#_____________________________________________________________________

source func.debug
source func.errecho
source func.kbytes
source func.regex

TESTNAME="Test of function regex (func.regex) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t\tVerifies that the regular expression for integers, numbers,\n
\t\thexadecimal numbers and nicenumbers work correctly.\n
\t\tNormally emits only PASS|FAIL message\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see the diagnostic levels.\n
\t-h\t\tPrint this message\n
\t-v\t\tVerbose mode to show values\n
"

func_NUMARGS=0
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

if [[ $# -lt ${func_NUMARGS} ]] ; then
	insufficient ${func_NUMARGS} $@
	errecho "-e" ${USAGE}
	exit 2
fi

########################################################################
# tv is short for testvalue
# tt is short for testtype
########################################################################
tv[0]="12345"
tt[0]=${re_integer}

tv[1]="+123"
tt[1]=${re_signedinteger}

tv[2]="-123"
tt[2]=${re_signedinteger}

tv[3]="-123.45"
tt[3]=${re_decimal}

tv[4]="face1"
tt[4]=${re_hexnumber}

tv[5]="DEADBeef9"
tt[5]=${re_hexnumber}

tv[6]="1M"
tt[6]=${re_nicenumber}

tv[7]="1MIB"
tt[7]=${re_nicenumber}

tv[8]="1BYT"
tt[8]=${re_nicenumber}

tv[9]="99ZIB"
tt[9]=${re_nicenumber}

hash1result=$(b2sum < /dev/null)
tv[10]="01c:${hash1result:0:128}"
tt[10]=${re_cryptohash}

#for ti in { 0 "${maxtests}" }
for ((ti=0;ti<${#tv[@]};ti++))
do
  if [[ ! "${tv[${ti}]}" =~ ${tt[${ti}]} ]] ; then
    ((fail++))
  fi
done


hash1result=$(b2sum < /dev/null)
fv[0]="01:${hash1result:0:128}"
ft[0]=${re_cryptohash}

########################################################################
# In this case if the pattern match succeeds then it
# is broken
########################################################################
for ((ti=0;ti<${#fv[@]};ti++))
do
  if [[ "${fv[${ti}]}" =~ ${ft[${ti}]} ]] ; then
    ((fail++))
  fi
done

exit ${fail}
