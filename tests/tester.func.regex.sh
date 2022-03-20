#!/bin/basg
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
source func.kbytes
source func.regex

TESTNAME="Test of function regex (func.regex) from\n\thttps://github.com/sailnfool/func"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the regular expression for integers, numbers,\r\n
\t\thexadecimal numbers and nicenumbers work correctly.\r\n
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

echo "Nicenumber string is ${re_nicenumber}"
integertest="12345"
signednumber1test="+123"
signednumber2test="-123"
decimalnumber1test="-123.45"
hex1test="face1"
hex2test="DEADBeef9"
nicenum1test="1M"
nicenum2test="1MIB"
nicenum3test="1BYT"
nicenum4test="99ZIB"

if [[ ! "${integertest}" =~ ${re_integer} ]]
then
  failure="TRUE"
fi

if [[ ! "${signednumber1test}" =~ ${re_signedinteger} ]]
then
  failure="TRUE"
fi

if [[ ! "${signednumber2test}" =~ ${re_signedinteger} ]]
then
  failure="TRUE"
fi

if [[ ! "${decimalnumber1test}" =~ ${re_decimal} ]]
then
  failure="TRUE"
fi

if [[ ! "${hex1test}" =~ ${re_hexnumber} ]]
then
  failure="TRUE"
fi

if [[ ! "${hex2test}" =~ ${re_hexnumber} ]]
then
  failure="TRUE"
fi

if [[ ! "${nicenum1test}" =~ ${re_nicenumber} ]]
then
  failure="TRUE"
fi

if [[ ! "${nicenum2test}" =~ ${re_nicenumber} ]]
then
  failure="TRUE"
fi

if [[ ! "${nicenum3test}" =~ ${re_nicenumber} ]]
then
  failure="TRUE"
fi

if [[ ! "${nicenum4test}" =~ ${re_nicenumber} ]]
then
  failure="TRUE"
fi

if [[ "${failure}" = "TRUE" ]]
then
  exit 1
else
  exit 0
fi
