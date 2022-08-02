#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.1 |REN|06/04/2022| Tweaked to exit with the number of fails
# 1.0 |REN|02/08/2022| testing nice2num
#_____________________________________________________________________

source func.debug
source func.nice2num
source func.errecho
source func.regex

TESTNAME="Test of function nice2num (func.nice2num) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t\tVerifies that the __kbytesvalue and __kbibytesvalue arrays have\r\n
\t\tcorrectly initialized.  Normally emits only PASS|FAIL message\r\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see the diagnostic levels.\n
\t-h\t\tPrint this message\n
\t-v\t\tVerbose mode to show testing steps\n
\t\t\Normally emits only ${passstring}|${failstring} message\n
"

optionargs="hv"
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
      verboseflag=""
  		;;
  	\?)
  		errecho "-e" "invalid option: -$OPTARG"
  		errecho "-e" ${USAGE}
  		exit 1
  		;;
	esac
done

shift $(( ${OPTIND} -1 ))

kbtable="/tmp/kbyte_table_$$.txt"
cat > ${kbtable} <<EOF
B	1
K	1000
M	1000000
G	1000000000
T	1000000000000
P	1000000000000000
E	1000000000000000000
Z	1000000000000000000000
EOF

kbibtable="/tmp/kbibyte_table_$$.txt"
cat > ${kbibtable} <<EOF2
BYT	1
KIB	1024
MIB	1048576
GIB	1073741824
TIB	1099511627776
PIB	1125899906842624
EIB	1152921504606846976
ZIB	1180591620717411303424
EOF2
while read -r suffix value
do
  if [[ "${verbosemode}" == "TRUE" ]] ; then
    echo -e "${suffix}\t$(nice2num 1${suffix})"
  fi
  if [[ "$(nice2num 1${suffix})" != "${value}" ]] ; then
    ((fail++))
  fi
done < ${kbtable}
while read -r suffix value
do
  if [[ "${verbosemode}" == "TRUE" ]] ; then
    echo -e "${suffix}\t$(nice2num 1${suffix})"
  fi
  if [[ "$(nice2num 1${suffix})" != "${value}" ]] ; then
    ((fail++))
  fi
done < ${kbibtable}

########################################################################
# Previously forgot to cleanup
########################################################################
rm -f ${kbtable} ${kbibtable}

exit ${fail}
