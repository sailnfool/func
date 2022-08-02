#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|06/03/2022| testing egrep expressions
#_____________________________________________________________________

source func.cwave
source func.debug
source func.errecho
source func.regex

TESTNAME="Test of function global (egrep) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see the diagnostic levels.\n
\t-h\t\tPrint this message\n
\t-v\t\tVerbose mode to show values\n
\t\tvarious test of grep expressions
\t\tNormally emits only PASS|FAIL message\n
"

optionargs="d:hv"
verbosemode="FALSE"
fail=0

while getopts ${optionargs} name
do
	case ${name} in
	d)
    if [[ ! "${OPTARG}" =~ $re_digit ]] ; then
      errecho "${0##/*}" "${LINENO}" "-d requires a decimal digit"
      errecho -e "${USAGE}"
      errecho -e "${DEBUG_USAGE}"
      exit 1
    fi
		FUNC_DEBUG="${OPTARG}"
		export FUNC_DEBUG
		if [[ $FUNC_DEBUG -ge ${DEBUGSETX} ]] ; then
			set -x
		fi
		;;
	h)
		echo -e ${USAGE}
    if [[ "${verbosemode}" == "TRUE" ]] ; then
      echo -e ${DEBUG_USAGE}
    fi
		exit 0
		;;
	v)
		verbosemode="TRUE"
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

for ((i=0;i<${#tv[@]};i++))
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
  if [[ "${verbosemode}" == "TRUE" ]] ; then
    more /tmp/good_${i}.txt /tmp/test_${i}.txt
    diff /tmp/good_${i}.txt /tmp/test_${i}.txt
    echo "verbose diff result $?"
    cmp /tmp/good_${i}.txt /tmp/test_${i}.txt
    echo "verbose cmp result $?"
  fi
  diff /tmp/good_${i}.txt /tmp/test_${i}.txt
  diffresult=$?
  if [[ "${diffresult}" -ne 0 ]] ; then
    if [[ "${verbosemode}" == "TRUE" ]] ; then
      diff /tmp/good_${i}.txt /tmp/test_${i}.txt
      echo "diff result $?"
      cmp /tmp/good_${i}.txt /tmp/test_${i}.txt
      echo "cmp result $?"
    fi
    ((fail++))
  fi
done
if [[ "${verbosemode}" == "FALSE" ]] ; then
  rm -f ${TESTINPUT} /tmp/good_*.txt /tmp/test_*.txt
fi
if [[ "${fail}" -gt 0 ]] ; then
  echo "About to fail with ${fail}"
fi
exit ${fail}
