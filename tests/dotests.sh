#!/bin/bash
scriptname=${0##*/}
########################################################################
# Copyright (C) 2022 Sea2cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# dotests - run a series of scripts to test the bash functions in
#           the tests subdirectory which should have a 1-1
#           correspondence to the bash functions in the scripts
#           directory.  Note that each of the test scripts must contain
#           the "nametext" string to be able to announce the teste
#           which is being run.  The test functions exit with either
#           an exit value of 1 <FAIL> or 0 <PASS>
#
#           One of the tests has a -v option (verbose) option.  It 
#           would be good to add this as a parameter to this master 
#           script, but then all of the tests would have to be -v aware
#           which will take a bit of work to not only add it but to
#           verify that it is supported in a testing script and not
#           produce excess output if it does not.
# Author - Robert E. Novak aka REN
# sailnfool@gmail.com
# skype: sailnfool.ren
########################################################################

fail=0
########################################################################
# COlor sequences cribbed from:
# https://en.wikipedia.org/wiki/ANSI_escape_code
########################################################################
failstring="[\033[91mFAIL\033[m]"
passstring="[\033[92mPASS\033[m]"
nametext="TESTNAME="
for test_script in tester.*.sh
do
  testname=$(grep -h "${nametext}" ${test_script})
  if [[ -z "${testname}" ]]
  then
    echo "testing script \"${test_script}\" is missing TESTNAME"
    echo "${failstring} ${test_script}"
    ((fail++))
  fi
  if [[ ! ${test_script} ]]
  then
    echo -e "${failstring} ${test_script}\n\t${testname:${#nametext}}"
    ((fail++))
  else
    echo -e "${passstring} ${test_script}\n\t${testname:${#nametext}}"
  fi
done
exit ${fail}
