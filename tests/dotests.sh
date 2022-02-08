#!/bin/sh

# it would be nice to add color

fail=0
nametext="TESTNAME="
for test_script in "test.*.sh"
do
  testname=$(grep "${nametext}" ${test_script})
  if [[ -z "${testname}" ]]
  then
    echo "testing script \"${test_script}\" is missing TESTNAME"
    echo "[FAIL] ${test_script}"
    ((fail++))
  fi
  if [[ ! ${test_script} ]]
  then
    echo -e "[FAIL] ${test_script}\n\t${testname:${#nametext}}"
    ((fail++))
  else
    echo -e "[PASS] ${test_script}\n\t${testname:${#nametext}}"
  fi
done
exit ${fail}
