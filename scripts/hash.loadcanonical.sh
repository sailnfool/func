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

  function hash_hashcanonical () {

    local filesuffix
    local filename
    local key
    local value
    ######################################################################
    # Now read the canonical files to load up the canonical hash info
    # Note that this is subtle the way we generate the list of
    # filenames and the list of Associative Arrays
    # A similar clever trick could eliminate the case statement, 
    # but my # brain is aching from the number of levels of
    # indirection.
    ######################################################################
    for filesuffix in num2hash num2bin num2bits num2hexdigits hash2num
    do
      filename=${YesFSdiretc}/$(eval echo \$F${filesuffix})
      while read key value
      do
        case ${filesuffix} in
          num2hash)
            Cnum2hash+=([${key}]=${value})
            ;;
          num2bin)
            Cnum2bin+=([${key}]=${value})
            ;;
          num2bits)
            Cnum2bits+=([${key}]=${value})
            ;;
          num2hexdigits)
            Cnum2hexdigits+=([${key}]=${value})
            ;;
          hash2num)
            Chash2num+=([${key}]=${value})
            ;;
          \?)
            errecho "${0##*/}:${FUNCNAME}:${LINENO}: " \
              "this should never happen"
            exit 1
            ;;
        esac
      done < ${filename}
    done # for filesuffix in num2hash num2bin num2bits num2hexdigits hash2num
  }
  export hash_loadcanonical
fi # if [[ -z "${__hashloadcanonical}" ]]
