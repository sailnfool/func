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
#
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.1 | REN |04/08/2022| Improved documentation
# 1.0 | REN |02/20/2022| Initial Release
#_____________________________________________________________________
#
########################################################################

fail=0
########################################################################
# Color sequences cribbed from:
# https://en.wikipedia.org/wiki/ANSI_escape_code
########################################################################
failstring="[\033[91mFAIL\033[m]"
passstring="[\033[92mPASS\033[m]"
nametext="TESTNAME="
testprefix="tester"
for test_script in ${testprefix}.*.sh
do
  ######################################################################
  # pull the TESTNAME from each testing file and issue an error if it
  # does not exist
  ######################################################################
  testname=$(grep -h "${nametext}" ${test_script})
  if [[ -z "${testname}" ]]
  then
    echo "testing script \"${test_script}\" is missing TESTNAME"
    echo "${failstring} ${test_script}"
    ((fail++))
  fi

  ######################################################################
  # Execute each testscript and issue the pass/fail message as
  # appropriate
  ######################################################################
  if [[ ! ${test_script} ]]
  then
    echo -e "${failstring} ${test_script}\n\t${testname:${#nametext}}"
    ((fail++))
  else
    echo -e "${passstring} ${test_script}\n\t${testname:${#nametext}}"
  fi
done

########################################################################
# Note that we have kept track if any tests failed.  If all worked,
# then we exit cleanly.
########################################################################
exit ${fail}
