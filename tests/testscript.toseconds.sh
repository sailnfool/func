#!/bin/sh
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |02/02/2022| testing reconstructed kbytes
#_____________________________________________________________________
#
########################################################################
source func.toseconds

declare -a testvalue
declare -a testresult
TESTNAME="Test of function toseconds (func.toseconds) from\n\thttps://github.com/sailnfool/func"
testvalue[0]="40.25"
testresult[0]="40.25"
testvalue[1]="10:40.25"
testresult[1]="640.25"
testvalue[2]="5:15:20.4"
testresult[2]="18920.4"
testvalue[3]="20:10:40.25"
testresult[3]="72640.25"
testvalue[4]=".08"
testresult[4]="0.08"
resultvar=0
for i in $(seq 0 4)
do
  answer=$(toseconds "${testvalue[${i}]}")
  echo "answer=${answer}; test=${testvalue[${i}]}"
  if [[ ! "${answer}" == "${testresult[${i}]}" ]]
  then
    ((resultvar+=1))
  fi
done
exit ${resultvar}
