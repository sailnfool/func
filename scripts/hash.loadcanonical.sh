#!/bin/bash
########################################################################
# Copyright (C) 2022 Sea2cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# hash.loadcanonical - Load the canonical hash files into Associative
#                      arrays
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
# 1.0 |REN|07/07/2022| Initial Release
#_____________________________________________________________________
#
########################################################################

if [[ -z "${__hashloadcanonical}" ]]
then
  export __hashloadcanonical=1

  source hash.globalcanonical
  source func.cwave

  function hash_loadcanonical () {
    # hash_loadcanonical [-v]

    local filesuffix
    local filename
    local key
    local value
    local verbosemode="FALSE"
    local verboseflag=""

    if [[ "$#" -eq 1 ]] && [[ "$1" == "-v" ]]
    then
      verbosemode="TRUE"
      verboseflag=""
    fi
    wavfuncentry ${verboseflag}
    ####################################################################
    # Now read the canonical files to load up the canonical hash info
    # Note that this is subtle the way we generate the list of
    # filenames and the list of Associative Arrays
    # A similar clever trick could eliminate the case statement, 
    # but my # brain is aching from the number of levels of
    # indirection.
    ####################################################################
    for filesuffix in num2hash num2bin num2bits num2hexdigits hash2num
    do
      local -n newarr=C${filesuffix}
      local arrname
      arrname=$(echo C${filesuffix})
      filename=${YesFSdiretc}/$(eval echo \$F${filesuffix})
      waverrindentvar ${verboseflag} "filename=${filename}"
      while read key value
      do
         newarr+=(["${key}"]="${value}")
         waverrindentvar ${verboseflag} "${arrname}["${key}"]=" \
           "${newarr["${key}"]}"
      done < ${filename}

      for nkey in "${!newarr[@]}"
      do
        waverrindentvar ${verboseflag} "${arrname}["${nkey}"]=" \
          "${newarr["${nkey}"]}"
      done

    done # for filesuffix in num2hash num2bin num2bits ...

    wavfuncexit ${verboseflag}
  }
  export hash_hashloadcanonical
fi # if [[ -z "${__loadcanonical}" ]]
