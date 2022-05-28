#!/bin/bash
########################################################################
# Copyright (C) 2022 Sea2cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# func_dec2hex Convert the argument from decimal to N digits of zero
#              prefixe hexadecimal digits
# Author - Robert E. Novak aka REN
# sailnfool@gmail.com
# skype:sailnfool.ren
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
########################################################################
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |05/27/2022| Initial Release
#_____________________________________________________________________
#
########################################################################
if [[ -z "${__funcdec2hex}" ]]
then
  export __funcdec2hex=1
  function func_dec2hex() {
    case "$#" in
      0)
        insufficient 1 $@
        ;;
      1)
        number="$1"
        digits=""
        ;;
      2)
        number="$1"
        digits="$2"
        ;;
      \?)
        errecho "Bad arg to dec2hex"
        exit 1
        ;;
    esac
    if [[ ! "${number}" =~ ${re_integer} ]]
    then
      errecho "First arg to dec2hex is not an integer ${number}"
      exit 1
    fi
    if [[ ! "${digits}" =~ ${re_integer} ]]
    then
      errecho "Second arg to dec2hex is not an integer ${digits}"
      exit 1
    fi
    printf "%0${digits}x" ${number}
  }
  export func_dec2hex
fi #if [[ -z "${__funcdec2hex}" ]]
