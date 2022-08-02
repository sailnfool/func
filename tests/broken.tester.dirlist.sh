#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|03/20/2022| testing regex
#_____________________________________________________________________

source func.cwave
source func.debug
source func.errecho
source func.regex

TESTNAME="Test of function descending large directories"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the regular expression for integers, numbers,\r\n
\t\thexadecimal numbers and nicenumbers work correctly.\r\n
\t\tNormally emits only PASS|FAIL message\r\n
"

optionargs="d:hv"
verbosemode="FALSE"
fail=0

while getopts ${optionargs} name
do
	case ${name} in
	d)
    if [[ ! "${OPTARG}" =~ ${re_digit} ]] ; then
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
fail=0
topdir=/home/rnovak
filecount=$(countfiles ${topdir})
if [[ "${filecount}" -ge 2000 ]] ; then
  echo "Large directory ${topdir} has ${filecount} files"
  cd ${topdir}
  dirlist="$(find . -maxdepth 1 -type d -print 2>/dev/null | sed 's/^\.$//')"
  for dir in ${dirlist}
  do
    if [[ -d ${dir} ]] ; then
      if [[ ! -r ${dir} ]] ; then
        echo cannot read "./${dir}"
        ((fail++))
      fi
    fi
  done
fi
exit ${fail}
