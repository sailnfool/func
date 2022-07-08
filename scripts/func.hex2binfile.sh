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

  source func.insufficieant

  function func_hex2binfile() {
#   hexstring filename
    NUMARGS=2
    if [[ ! "$#" == "${NUMARGS}" ]]
    then
      insufficient ${NUMARGS} $@
    else
      hexstring="${1}"
      filename="${2}"
    fi
    index=0
    while [[ "${index}" -lt "${#hexstring}" ]]
    do
      if [[ "$((${#hexstring} - index ))" -gt 2 ]]
      then
        printf "\x${hexstring:${index}:2} >> ${filename}
      else
        printf "\x${hexstring:${index}:1} >> ${filename}
      fi
      ((index+=2))
    done
  }
  export func_hex2binfile
fi # if [[ -z "${__funchex2binfile}" ]]
