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

  function hash_loadcanonical () {
    # hash_loadcanonical [-v]

    local filesuffix
    local filename
    local key
    local value
    local verbosemode="FALSE"

    if [[ "$#" -eq 1 ]] && [[ "$1" == "-v" ]]
    then
      verbosemode="TRUE"
    fi
    if [[ "${FUNC_DEBUG}" -ge "${DEBUGWAVAR}" ]]
    then
    ######################################################################
    # Now read the canonical files to load up the canonical hash info
    # Note that this is subtle the way we generate the list of
    # filenames and the list of Associative Arrays
    # A similar clever trick could eliminate the case statement, 
    # but my # brain is aching from the number of levels of
    # indirection.
    ######################################################################
    unset Cnum2hash
    unset Cnum2bin
    unset Cnum2bits
    unset Cnum2hexdigits
    unset Chash2num
	  declare -A Cnum2hash
	  declare -A Cnum2bin
	  declare -A Cnum2bits
	  declare -A Cnum2hexdigits
	  declare -A Chash2num
	  export Cnum2hash
	  export Cnum2bin
	  export Cnum2bits
	  export Cnum2hexdigits
	  export Chash2num

    for filesuffix in num2hash num2bin num2bits num2hexdigits hash2num
    do
      filename=${YesFSdiretc}/$(eval echo \$F${filesuffix})
      while read key value
      do
        echo "key='${key}', value='${value}'"
        case ${filesuffix} in
          num2hash)
            Cnum2hash+=(["${key}"]="${value}")
            echo "${FUNCNAME} ${LINENO} ${Cnum2hash["${key}"]}"
            ;;
          num2bin)
            Cnum2bin+=(["${key}"]="${value}")
            if [[ ! "$(which ${Cnum2hash["${key}"]})" == "${value}" ]]
            then
              stderrecho "${FUNCNAME} ${LINENO} ***WARNING ***"
              stderrecho "Binary for '${Cnum2hash["${key}"]}' not found"
              stderrecho "at path '${value}'"
            fi
            echo "${FUNCNAME} ${LINENO} ${Cnum2bin["${key}"]}"
            ;;
          num2bits)
            Cnum2bits+=(["${key}"]="${value}")
            echo "${FUNCNAME} ${LINENO} ${Cnum2bits["${key}"]}"
            ;;
          num2hexdigits)
            Cnum2hexdigits+=(["${key}"]="${value}")
            echo "${FUNCNAME} ${LINENO} ${Cnum2hexdigits["${key}"]}"
            ;;
          hash2num)
            Chash2num+=(["${key}"]="${value}")
            echo "${FUNCNAME} ${LINENO} ${Chash2num["${key}"]}"
            ;;
          \?)
            errecho "${0##*/}:${FUNCNAME}:${LINENO}: " \
              "this should never happen"
            exit 1
            ;;
        esac
      done < ${filename}

    done # for filesuffix in num2hash num2bin num2bits num2hexdigits hash2num
    if [[ "${verbosemode}" == "TRUE" ]]
    then
      for key in "$!{Cnum2hash[@]}"
      do
        echo -n "${FUNCNAME} ${LINENO} " 
        echo "Cnum2hash["${key}"]='${Cnum2hash["${key}"]}'"
      done
      for key in "${Cnum2bin[@]}"
      do
        echo -n "${FUNCNAME} ${LINENO} " 
        echo "Cnum2bin["${key}"]='${Cnum2bin["${key}"]}'"
      done
      for key in "${Cnum2bits[@]}"
      do
        echo -n "${FUNCNAME} ${LINENO} " 
        echo "Cnum2bits["${key}"]='${Cnum2bits["${key}"]}'"
      done
      for key in "${Cnum2hexdigits[@]}"
      do
        echo -n "${FUNCNAME} ${LINENO} " 
        echo "Cnum2hexdigits["${key}"]='${Cnum2hexdigits["${key}"]}'"
      done
      for key in "${Chash2num[@]}"
      do
        echo -n "${FUNCNAME} ${LINENO} " 
        echo "hash2num["${key}"]='${hash2num["${key}"]}'"
      done
    fi
  }
  export hash_hashloadcanonical
fi # if [[ -z "${__loadcanonical}" ]]
