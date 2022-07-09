#!/bin/bash
########################################################################
# Copyright (C) 2022 Sea2cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# func_hex2binfile Convert the argument from Hex to binary and output
#                  to a file.
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
# 1.0 |REN|07/08/2022| Initial Release
#_____________________________________________________________________
#
########################################################################
if [[ -z "${__funchex2binfile}" ]]
then
  export __funchex2binfile=1

  source func.insufficient
  source func.errecho
  source func.regex

  function func_hex2binfile() {
#    [-b] hexstring filename

    local NUMARGS
    local byteswap
    local OPTARGS
    local hexstring
    local i
    local saved
    local index

    NUMARGS=2

    ####################################################################
    # Added simplistic code for he optional argument of "-b" to handle
    # performing byteswaps on output.
    ####################################################################
    byteswap="FALSE"
    OPTARGS=3

    ####################################################################
    # The following declaration insures that the values in the
    # hexstring variable will all be lower case
    ####################################################################
    declare -l hexstring

    if [[ "$#" -eq "${OPTARGS}" ]]
    then
      if [[ "${1}" == "-b" ]]
      then
        byteswap="TRUE"
        shift 1
      fi
    fi
    ####################################################################
    # At this point the optional -b has been shifted out, make sure we
    # still have 2 parameters
    ####################################################################
    if [[ "$#" -lt "${NUMARGS}" ]]
    then
      insufficient ${FUNCNAME} ${NUMARGS} $@
      exit 1
    else
      hexstring="${1}"
      filename="${2}"
    fi
    echo "${FUNCNAME} ${LINENO} byteswap='${byteswap}'"
    echo "${FUNCNAME} ${LINENO} hexstring='${hexstring}'"
    echo "${FUNCNAME} ${LINENO} Length of hexstring='${#hexstring}'"
    echo "${FUNCNAME} ${LINENO} filename='${filename}'"

    ####################################################################
    # verify that all of the digits in hexstring are hex
    # Also transform into all lower case
    ####################################################################

    for i in $(seq 0 ${#hexstring})
    do
      if [[ ! "${hexstring:${i}:1}" =~ $rehexdigit ]]
      then
        errecho ${FUNCNAME} ${LINENO} "Digit ${i} is not "\
          "hex ${hexstring}"
        exit 1
      fi
    done

    ####################################################################
    # Obsoleted by the "declare -l hexstring
    ####################################################################
#    hexstring=$(echo ${hexstring} | tr a-f A-F)

    ####################################################################
    # The practice for managing byte swaps is to save the first byte
    # encountered in the string 'saved' and then on the next character
    # found emit them as swapped bytes.  If there is no swapping, then
    # we just emit the characters one at a time.
    ####################################################################

    saved=""
    index=0
    while [[ "${index}" -lt "${#hexstring}" ]]
    do
      ##################################################################
      # We have to handle the special case that there are an odd number
      # of hex digits.
      ##################################################################
      echo "${FUNCNAME} ${LINENO} index='${index}'"
      echo "${FUNCNAME} ${LINENO} saved='${saved}'"
      echo "${FUNCNAME} ${LINENO} Length of saved='${#saved}'"
      if [[ "$((${#hexstring} - index ))" -ge 2 ]]
      then
        if [[ "${byteswap}" == "TRUE" ]] && \
          [[ "${#saved}" == 0 ]]
        then
          set -xv
          echo "${FUNCNAME} ${LINENO}: index=${index} "\
            "${hexstring:${index}:2}"
          saved="${hexstring:${index}:2}"
          set +xv
        else
          set -xv
          echo "${FUNCNAME} ${LINENO}: index=${index} "\
            "${hexstring:${index}:2}"
          ##############################################################
          # The following code sometimes fails when the contents of
          # the hexstring picks up "FALSE" as a string?????
          ##############################################################
          printf "\x${hexstring:${index}:2}${saved}" >> ${filename}
          saved=""
          set +xv
        fi
      else # if [[ "$((${#hexstring} - index ))" -ge 2 ]]

        ################################################################
        # At this point we have a trailing single digit.
        # Zero pad a single digit and handle byteswapping corrctly
        ################################################################
        if [[ "${byteswap}" == "TRUE" ]]
        then
          set -xv
          echo "${FUNCNAME} ${LINENO}: index=${index} "\
            "${hexstring:${index}:1}"
          ##############################################################
          # The following code sometimes fails when the contents of
          # the hexstring picks up "FALSE" as a string?????
          ##############################################################
          printf "\x0${hexstring:${index}:1}" >> ${filename}
          set +xv
        else
          set -xv
          echo "${FUNCNAME} ${LINENO}: index=${index} "\
            "${hexstring:${index}:1}"
          printf "\x${hexstring:${index}:1}0" >> ${filename}
          set +xv
        fi
      fi # if [[ "$((${#hexstring} - index ))" -gt 2 ]]
      ((index+=2))
    done
  }
  export func_hex2binfile
fi # if [[ -z "${__funchex2binfile}" ]]
