#!/bin/bash
########################################################################
# Copyright (C) 2022 Sea2cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# askcreatehashcanonical - If the canonical files don't exist, ask
#                          the user if they want them created.
# Author - Robert E. Novak aka REN
# sailnfool@gmail.com
# skype:sailnfool.ren
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
########################################################################
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|07/06/2022| Initial Release
#_____________________________________________________________________
#
########################################################################
source func.hashcanonical
source func.insufficient
source func.errecho
if [[ -z "${__funcaskcreatehashcanonical}" ]]
then
  export __funccreatehashcanonical=1
  function askcreatehashcanonical() {
    # <file> "answeryes" "verbosemode"
    if [[ "$#" -ne 3 ]]
      then
        insufficient 3 $@
        exit 1
      else
        filecanonical="$1"
        answeryes="$2"
        verbosemode="$3"
    fi # if [[ "$#" -ne 3 ]]

    if [[ -r "${filecanonical}" ]]
    then
      if [[ "${verbosemode}" == "TRUE" ]]
      then
        cat "${filecanonical}"
      fi # if [[ "${verbosemode}" == "TRUE" ]]
    else
      if [[ "${answeryes}" == "FALSE" ]]
      then
        errecho "Missing ${filecanonical}, " \
          "run 'createhashcanonical'"
        errecho "to generate."
        echo -n "Run Now (Y/n): "
        read installanswer
        if [[ -z "${installanswer}" ]]
        then
          installanswer="Y"
        else
          installanswer=$(echo ${installanswer} | tr a-z A-Z)
        fi
        case ${installanswer} in
          Y|YES)
            createhashcanonical
            ;;
          N|NO)
            errecho "Missing ${YesFSdiretc}/${Fcanonicalhash}, exiting"
            exit 1
           ;;
          \?)
           errecho "Invalid answer"
           exit 1
           ;;
        esac
      else
        createhashcanonical
      fi # if [[ "${answeryes}" == "FALSE" ]]
    fi # if [[ -r "${filecanonical}" ]]
  }
  export askcreatehashcanonical
fi #if [[ -z "${__funcaskcreatehashcanonical}" ]]
