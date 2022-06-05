#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |03/20/2022| testing regex
#_____________________________________________________________________
#
########################################################################

TESTNAME="Test of function descending large directories"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the regular expression for integers, numbers,\r\n
\t\thexadecimal numbers and nicenumbers work correctly.\r\n
\t\tNormally emits only PASS|FAIL message\r\n
"

optionargs="hv"
verbose_mode="FALSE"
fail=0

while getopts ${optionargs} name
do
	case ${name} in
	h)
		echo -e ${USAGE}
		exit 0
		;;
	v)
		verbose_mode="TRUE"
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
if [[ "${filecount}" -ge 2000 ]]
then
  echo "Large directory ${topdir} has ${filecount} files"
  cd ${topdir}
  dirlist="$(find . -maxdepth 1 -type d -print 2>/dev/null | sed 's/^\.$//')"
  for dir in ${dirlist}
  do
    if [[ -d ${dir} ]]
    then
      if [[ ! -r ${dir} ]]
      then
        echo cannot read "./${dir}"
        ((fail++))
      fi
    fi
  done
fi
exit ${fail}
