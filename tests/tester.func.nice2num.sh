#!/bin/basg
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |02/08/2022| testing nice2num
#_____________________________________________________________________
#
########################################################################
source func.nice2num
source func.errecho

TESTNAME="Test of function nice2num (func.nice2num) from\n\thttps://github.com/sailnfool/func"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t\tVerifies that the __kbytesvalue and __kbibytesvalue arrays have\r\n
\t\tcorrectly initialized.  Normally emits only PASS|FAIL message\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
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
  if [[ "$(nice2num 1${suffix})" != "${value}" ]]
  then
    failure="TRUE"
  fi
  if [[ "${verbose_mode}" == "TRUE" ]]
  then
    echo -e "${suffix}\t$(nice2num 1${suffix})"
  fi
done < ${kbtable}
while read -r suffix value
do
  if [[ "$(nice2num 1${suffix})" != "${value}" ]]
  then
    failure="TRUE"
  fi
  if [[ "${verbose_mode}" == "TRUE" ]]
  then
    echo -e "${suffix}\t$(nice2num 1${suffix})"
  fi
done < ${kbibtable}
if [[ "${failure}" == "TRUE" ]]
then
  exit 1
else
  exit 0
fi

testingsuffix=MiB
testingnumber=1048576
answer=$(nice2num 1${testingsuffix})
if [[ "${answer}" == "${testingnumber}" ]]
then
  exit 0
else
  exit 1
fi

