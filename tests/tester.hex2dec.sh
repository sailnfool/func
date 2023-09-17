#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |03/20/2022| testing hex2dec
#_____________________________________________________________________
#
########################################################################
source func.errecho
source func.hex2dec

TESTNAME="Test of function global (func.hex2dec) from\n\thttps://github.com/sailnfool/func"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the function will convert hexadeximal numbers to
\t\tdecimal numbers
\t\tNormally emits only PASS|FAIL message\r\n
"

optionargs="hv"
verbose_mode="FALSE"
failure="FALSE"

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

# echo $(func_hex2dec 00c)
if [[ ! "$(func_hex2dec 00c)" = "12" ]]
then
  failure="TRUE"
fi

# echo $(func_hex2dec 00f)
if [[ ! "$(func_hex2dec 00f)" = "15" ]]
then
  failure="TRUE"
fi

# echo $(func_hex2dec 0FF)
if [[ ! "$(func_hex2dec 0FF)" = "255" ]]
then
  failure="TRUE"
fi

if [[ "${failure}" = "TRUE" ]]
then
  exit 1
else
  exit 0
fi
