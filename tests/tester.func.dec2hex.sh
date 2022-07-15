#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|03/20/2022| testing dec2hex
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

########################################################################
# tv short for testvalue
# td short for testdigits
# tr short for testresult
########################################################################
declare -a tv
declare -a td
declare -a tr

tv[0]=12
td[0]=3
tr[0]="00c"

tv[1]=15
td[1]=3
tr[1]="00f"

tv[2]=255
td[2]=3
tr[2]="0ff"
maxtests=2

fail=0

########################################################################
# ti short for testindex
########################################################################
for ti in $(seq 0 ${maxtests})
do
  if [[ "${verbose_mode}" == "TRUE" ]]
  then
    echo "$(func_dec2hex ${tv[${ti}]} ${td[${ti}]}) should ${tr[${ti}]}"
  fi

  if [[ ! "$(func_dec2hex ${tv[${ti}]} ${td[${ti}]})" == "${tr[${ti}]}" ]]
  then
    ((fail++))
  fi
done

exit ${fail}
