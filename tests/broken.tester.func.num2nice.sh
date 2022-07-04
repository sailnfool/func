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
#
########################################################################
source func.kbytes
source func.num2nice
source func.nice2num
source func.errecho

TESTNAME="Test of function num2nice (func.num2nice) from\n\thttps://github.com/sailnfool/func"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t\tVerfies that a large number can be successfully be converted to a\r\n
\t\tnice number respresentation\r\n
\r\n
\t\tNormally exits with 0 (PASS) or 1 (FAIL)
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
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
shift $(( ${OPTIND} -1 ))

for ((i=1298;i<1324;i++))
do
  for ((j=0;j<${#__kbytessuffix};j++))
  do
    if [[ "${verbose_mode}" == "TRUE" ]]
    then
      echo "Requesting $i${__kbytessuffix:$j:1}"
      echo $(num2nice $(nice2num "$i${__kbytessuffix:$j:1}") )
    fi
  done
done
exit 1
