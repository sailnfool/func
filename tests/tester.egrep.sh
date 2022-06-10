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

########################################################################
# tv short for testvalue
# tr short for testresults
# fv short for failvalue
# fr short for failrsults
########################################################################
declare -a tv
declare -a tr
declare -a fv
declare -a fr

tv[0]="^[0-9]\$"
tr[0]="1"
tv[1]='^[0-9]{1,}$'
tr[1]="1"
tr[1]+=" 12"
tr[1]+=" 123"
tr[1]+=" 1234"
maxtest=1

for i in $(seq 0 ${maxtest})
do
  rm -f /tmp/good_$i.txt /tmp/test_$i.txt
  for j in ${tr[${i}]}
  do
    echo  "${j}" >> /tmp/good_$i.txt
  done
  result=$(egrep ${tv[$i]} ${TESTINPUT})
  count=0
  for j in ${result}
  do
    echo "$j" >> /tmp/test_$i.txt
  done
  if [[ "${verbose_mode}" == "TRUE" ]]
  then
    more /tmp/good_${i}.txt /tmp/test_${i}.txt
    diff /tmp/good_${i}.txt /tmp/test_${i}.txt
    echo "verbose diff result $?"
    cmp /tmp/good_${i}.txt /tmp/test_${i}.txt
    echo "verbose cmp result $?"
  fi
  diff /tmp/good_${i}.txt /tmp/test_${i}.txt
  diffresult=$?
  if [[ "${diffresult}" -ne 0 ]]
  then
    if [[ "${verbose_mode}" == "TRUE" ]]
    then
      diff /tmp/good_${i}.txt /tmp/test_${i}.txt
      echo "diff result $?"
      cmp /tmp/good_${i}.txt /tmp/test_${i}.txt
      echo "cmp result $?"
    fi
    ((fail++))
  fi
done
if [[ "${verbose_mode}" == "FALSE" ]]
then
  rm -f ${TESTINPUT} /tmp/good_*.txt /tmp/test_*.txt
fi
if [[ "${fail}" -gt 0 ]]
then
  echo "About to fail with ${fail}"
fi
exit ${fail}