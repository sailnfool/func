#!/bin/sh
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.1 | REN |06/04/2022| Added command line option processing to add
#                      | -v verbose options.  Switched to using arrays
#                      | for the test values and result.
# 1.0 | REN |02/02/2022| testing reconstructed kbytes
#_____________________________________________________________________
#
########################################################################
source func.toseconds

TESTNAME="Test of function toseconds (func.toseconds) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]]\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the function will convert oddly format times into 
\t\tseconds only\n
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

shift $(( ${OPTIND} - 1 ))

########################################################################
# tv is short for testvalue
# tr is short for testresult
########################################################################
declare -a tv
declare -a tr

tv[0]="40.25"
tr[0]="40.25"

tv[1]="10:40.25"
tr[1]="640.25"

tv[2]="5:15:20.4"
tr[2]="18920.4"

tv[3]="20:10:40.25"
tr[3]="72640.25"

tv[4]=".08"
tr[4]="0.08"
maxtests=4

fail=0

########################################################################
# ti is short for testincrement
########################################################################
for ti in $(seq 0 ${maxtests})
do
  if [[ ! "$(toseconds ${tv[${ti}]})" == "${tr[${ti}]}" ]]
  then
    ((fail++))
  fi
done
exit ${fail}
