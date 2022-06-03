#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |06/03/2022| testing egrep expressions
#_____________________________________________________________________
#
########################################################################
source func.errecho

TESTNAME="Test of function global (egrep) from\n\thttps://github.com/sailnfool/func"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tvarious test of grep expressions
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
shift $((${OPTIND} - 1))

########################################################################
# Create the test file
########################################################################
TESTINPUT=/tmp/stringtests_$$.txt
cat > ${TESTINPUT}  << EOF
1
12
123
1234
a1
aa
ax
EOF

declare -a successtests
declare -a successresults
declare -a failtests

successtests[0]="^[0-9]\$"
successresults[0]="1"
successtests[1]='^[0-9]{1,}$'
successresults[1]="1"
successresults[1]+="12"
successresults[1]+="123"
successresutls[1]+="1234"
maxtest=1

for i in $(seq 0 ${maxtest})
do
  rm -f /tmp/good_$i.txt /tmp/test_$i.txt
  for j in ${successresults[${i}]}
  do
    echo $j >> /tmp/good_$i.txt
  done
  result=$(egrep ${successtests[$i]} ${TESTINPUT})
  count=0
  for j in ${result}
  do
    echo $j >> /tmp/test_$i.txt
    ((count++))
  done
  if [[ "${verbose_mode}" == "TRUE" ]]
  then
    echo "There were ${count} results"
    if [[ ! $(diff /tmp/good_$i.txt /tmp/test_$i.txt) ]]
    then
      failure="TRUE"
    fi
  fi
done
rm -f ${TESTINPUT} /tmp/good_*.txt /tmp/test_*.txt
if [[ "${failure}" == "FALSE" ]]
then
  exit 1
else
  exit 0
fi
