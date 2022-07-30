#!/bin/bash
########################################################################
# Copyright (C) 2022 Sea2cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# hash.loadcanonical - Load the canonical hash files into Associative
#                      arrays
#                      A known flaw in this script is that it does not
#                      load the machine local version of num2bin so
#                      that it may attempt to invoke executables that
#                      may exist on other machines but do not exist on
#                      this machine.
#
# Author - Robert E. Novak aka REN
# sailnfool@gmail.com
# skype:sailnfool.ren
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|07/07/2022| Initial Release
#_____________________________________________________________________

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

      ##################################################################
      # set arrname to the name of the Associative array we will be
      # loading from a file by using a nameref (declare -n above) to 
      # affiliate with an array.
      ##################################################################
      arrname=$(echo C${filesuffix})

      ##################################################################
      # The filename is formed from the filesuffix used to drive this.
      ##################################################################
      filename=${YesFSdiretc}/$(eval echo \$F${filesuffix})
      waverrindentvar ${verboseflag} "filename=${filename}"

      ##################################################################
      # read in the key/values from the file 
      ##################################################################
      while read key value
      do
         newarr+=(["${key}"]="${value}")
         waverrindentvar ${verboseflag} "${arrname}["${key}"]=" \
           "${newarr["${key}"]}"
      done < ${filename}

      ##################################################################
      # Only perform a diagnostic dump in verbose & debug modes
      ##################################################################
      if [[ "${verboseflag}" == "TRUE" ]] && \
        [[ "${FUNC_DEBUG}" -gt "${DEBUGWAVARR}" ]]
      then
        for nkey in "${!newarr[@]}"
        do
          waverrindentvar ${verboseflag} "${arrname}["${nkey}"]=" \
            "${newarr["${nkey}"]}"
  
        done # for nkey in "${!newarr[@]}"
      fi
    done # for filesuffix in num2hash num2bin num2bits ...

    wavfuncexit ${verboseflag}
  }
  export hash_hashloadcanonical
fi # if [[ -z "${__loadcanonical}" ]]
