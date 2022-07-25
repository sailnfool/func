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
    fi
    wavfuncentry
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
# 	  declare -A Cnum2hash
# 	  declare -A Cnum2bin
# 	  declare -A Cnum2bits
# 	  declare -A Cnum2hexdigits
# 	  declare -A Chash2num
# 	  export Cnum2hash
# 	  export Cnum2bin
# 	  export Cnum2bits
# 	  export Cnum2hexdigits
# 	  export Chash2num

    for filesuffix in num2hash num2bin num2bits num2hexdigits hash2num
    do
      filename=${YesFSdiretc}/$(eval echo \$F${filesuffix})
      waverrindentvar "filename=${filename}"
      while read key value
      do
        waverrindentvar "key='${key}', value='${value}'"
        eval \$C${filesuffix}+=("[${key}"]="${value}")
        waverrindentvar $(eval "\$C${filesuffix}["${key}"]")
#         case ${filesuffix} in
#           num2hash)
#             Cnum2hash+=(["${key}"]="${value}")
#             waverrindentvar "${Cnum2hash["${key}"]}"
#             ;;
#           num2bin)
#             Cnum2bin+=(["${key}"]="${value}")
#             if [[ ! "$(which ${Cnum2hash["${key}"]})" == "${value}" ]]
#             then
#               stderrecho "Binary for '${Cnum2hash["${key}"]}' " \
#                 "not found at path '${value}'"
#             fi
#             waverrindentvar "${Cnum2bin["${key}"]}"
#             ;;
#           num2bits)
#             Cnum2bits+=(["${key}"]="${value}")
#             waverrindentvar "${Cnum2bits["${key}"]}"
#             ;;
#           num2hexdigits)
#             Cnum2hexdigits+=(["${key}"]="${value}")
#             waverrindentvar "${Cnum2hexdigits["${key}"]}"
#             ;;
#           hash2num)
#             Chash2num+=(["${key}"]="${value}")
#             waverrindentvar "${Chash2num["${key}"]}"
#             ;;
#           \?)
#             stderrecho "${0##*/}:${FUNCNAME}:${LINENO}: " \
#               "this should never happen"
#             exit 1
#             ;;
#         esac
      done < ${filename}

      for key in "$(eval \$!{C${filesuffix}[@]})"
      do
        waverrindentvar "C${filesuffix}["${key}"]='$(eval \${C${filesuffix}["${key}"]})'"
      done

    done # for filesuffix in num2hash num2bin num2bits num2hexdigits hash2num

    ####################################################################
    # Verify that the associative arrays are initialized if
    # FUNC_DEBUG >= ${DEBUGWAVAR}
    ####################################################################
#     for key in "$!{Cnum2hash[@]}"
#     do
#       waverrindentvar "Cnum2hash["${key}"]='${Cnum2hash["${key}"]}'"
#     done
#     for key in "${Cnum2bin[@]}"
#     do
#       waverrindentvar "Cnum2bin["${key}"]='${Cnum2bin["${key}"]}'"
#     done
#     for key in "${Cnum2bits[@]}"
#     do
#       waverrindentvar "Cnum2bits["${key}"]='${Cnum2bits["${key}"]}'"
#     done
#     for key in "${Cnum2hexdigits[@]}"
#     do
#       waverrindentvar "Cnum2hexdigits["${key}"]='${Cnum2hexdigits["${key}"]}'"
#     done
#     for key in "${Chash2num[@]}"
#     do
#       waverrindentvar "hash2num["${key}"]='${hash2num["${key}"]}'"
#     done
    wavfuncexit
  }
  export hash_hashloadcanonical
fi # if [[ -z "${__loadcanonical}" ]]
