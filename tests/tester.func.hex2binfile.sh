#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|07/07/2022| testing hex2binfile
#_____________________________________________________________________
#
########################################################################
source func.errecho
source func.hex2binfile

TESTNAME="Test of function global (func.hex2binfile) from\n\thttps://github.com/sailnfool/func"
USAGE="\r\n${0##*/} [-[bhv]] [-f <file>]\r\n
\t-b\t\tEnable byte swapping\n
\t-f\t<file>\tspecify the output file\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the function will convert hexadeximal numbers to
\t\tdecimal numbers\n
\t\tNormally emits only PASS|FAIL message\r\n
"

optionargs="bf:hv"
verbose_mode="FALSE"
testoutput=/tmp/t1$$
byteswap=""

while getopts ${optionargs} name
do
	case ${name} in
    b)
      byteswap="-b"
      ;;
    f)
      testoutput="${OPTARG}"
      ;;
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

shift $(( ${OPTIND} - 1 ))

fail=0
testinput=~/github/func/etc/OTP_Hex_sample.txt
testverify=~/github/func/etc/OTP_Hex_sample.bin

while read line
do
  echo -n "${FUNCNAME} ${LINENO} "
  echo "func_hex2binfile ${byteswap} ${line} ${testoutput}"
  
  func_hex2binfile ${byteswap} ${line} ${testoutput}
done < ${testinput}
cmp ${testverify} ${testoutput} 2>&1 > /dev/null
fail=$?
if [[ ! "${fail}" == 0 ]]
then
  od -cx ${testoutput} | less
fi
exit ${fail}
