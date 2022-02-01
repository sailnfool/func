#!/bin/sh

# it would be nice to add color

fail=0
for test_script in test.*.sh
do
  if [[ ${test_script} ]]
  then
    echo "[PASS] ${test_script}"
  else
    echo "[FAIL] ${test_script}"
    fail=1
  fi
done
exit ${fail}
