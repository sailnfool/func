#!/bin/bash
########################################################################
# Copyright (C) 2022 Sea2cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# hashaskcreatecanonical - If the canonical files don't exist, ask
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
source hash.globalcanonical
source func.insufficient
source func.errecho
source func.debug
if [[ -z "${__hashaskcreatecanonical}" ]]
then
  export __hashaskcreatecanonical=1

  function hash_askcreatecanonical() {
    # [-v] <file> "answeryes"

    local filecanonical
    local answeryes="FALSE"
    local verbosemode="FALSE"
    local verboseflag=""
    local installanswer
    declare -l installanswer #Always lower case
    local name
    local NUMARGS=1
    local USAGE="${FUNCNAME} [-[vy]] <file>\n
\t\t<file> is the canonical cryptographic hash file\n
\t-v\t\tverbose mode for diagnostics\n
\t\y\t\tanswer yes to questions\n
"

    local optionargs="hvy"
    local OPTIND
    local OPTARG

    wavfuncentry
    echo "${FUNCNAME} ${LINENO} args = $#"
    
    while getopts ${optionargs} name
    do
      case ${name} in
        h)
          errecho "-e" ${USAGE}
          wavfuncexit
          exit 0
          ;;
        v)
          verbosemode="TRUE"
          verboseflag="-v"
          ;;
        y)
          answeryes="TRUE"
          ;;
        \?)
          errecho "-e" "Invalid option -${OPTARG} $@"
          errecho "-e" ${USAGE}
          wavfuncexit
          exit 1
          ;;
      esac
    done

    waverrindentvar "args = $#"
    shift $(( ${OPTIND} - 1 ))
    waverrindentvar "args = $#"

    if [[ "$#" -lt "${NUMARGS}" ]]
    then
      insufficient "${NUMARGS} $@"
      wavfuncexit
      exit 1
    else
      filecanonical="$1"
      shift 1
    fi # if [[ "$#" -ne "${NUMARGS}" ]]

    if [[ -r "${filecanonical}" ]]
    then
      if [[ "${verbosemode}" == "TRUE" ]] && \
        [[ "${FUNC_DEBUG}" -ge "${DEBUGWAVAR}" ]]
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
        fi
        case ${installanswer} in
          y|yes)
            createhashcanonical ${verboseflag}
            ;;
          n|no)
            errecho "Missing ${YesFSdiretc}/${Fcanonicalhash}, exiting"
            wavfuncexit
            exit 1
           ;;
          \?)
           errecho "Invalid answer"
           wavfuncexit
           exit 1
           ;;
        esac
      else
        createhashcanonical ${verboseflag}
      fi # if [[ "${answeryes}" == "FALSE" ]]
    fi # if [[ -r "${filecanonical}" ]]
    wavfuncexit
  }
  export hash_askcreatecanonical
fi #if [[ -z "${__hashaskcreatecanonical}" ]]
