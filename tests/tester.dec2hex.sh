#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |03/20/2022| testing dec2hex
#_____________________________________________________________________
#
########################################################################
source func.errecho
source func.dec2hex

TESTNAME="Test of function global (func.dec2hex) from\n\thttps://github.com/sailnfool/func"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the function will convert decimal numbers to zero
\t\tprefixed hexadecimal values
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

# echo $(func_dec2hex 12 3)
if [[ ! "$(func_dec2hex 12 3)" = "00c" ]]
then
  failure="TRUE"
fi

# echo $(func_dec2hex 15 3)
if [[ ! "$(func_dec2hex 15 3)" = "004" ]]
then
  failure="TRUE"
fi

# echo $(func_dec2hex 255 3)
if [[ ! "$(func_dec2hex 255 3)" = "044" ]]
then
  failure="TRUE"
fi

if [[ "${failure}" = "TRUE" ]]
then
  exit 1
else
  exit 0
fi
