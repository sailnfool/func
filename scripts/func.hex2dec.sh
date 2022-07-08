#!/bin/bash
########################################################################
# Copyright (C) 2022 Sea2cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# func_hex2dec Convert the argument from Hex to decimal
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
# 1.0 |REN|05/27/2022| Initial Release
#_____________________________________________________________________
#
########################################################################
if [[ -z "${__funchex2dec}" ]]
then
  export __funchex2dec=1

  source func.insufficieant

  function func_hex2dec() {
    if [[ "$#" -ne 1 ]]
    then
      insufficient 1 $@
    else
      hexnum=$1
    fi
    echo $((16#$hexnum))
  }
  export func_hex2dec
fi # if [[ -z "${__funchex2dec}" ]]
