#!/bin/bash
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# toseconds - convert a time to number of seconds.  Has to be
#             flexible for HH:MM:SS or MM:SS or just SS.xx
#
# Author: Robert E. Novak
# email: sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
# 1.0 |REN|02/01/2022| Initial Release
#_____________________________________________________________________

if [[ -z "${__functoseconds}" ]] ; then
	export __functoseconds=1

  source func.cwave
  source func.debug
  source func.errecho
	source func.insufficient

  toseconds()
  {

    local -a secondresult
    local tresult
    local result

    if [[ $# -lt 1 ]] ; then
      insufficient 1 "at least one argument in time format required"
      exit 1
    fi
    if [[ $# -eq 2 ]] ; then
      if [[ "$1" == "-v" ]] ; then
        local verbosemode="TRUE"
        shift
      else
        errecho "Invalid optional first argument, must be -v, got $@"
        exit 2
      fi
    fi
    secondresult[0]=$(echo "$1" | \
      awk -F: '{ if (NF == 1) {print $NF} }' | bc)
    secondresult[1]=$(echo "$1" | \
      awk -F: '{ if (NF == 2) {print $1 "* 60 + " $2} }' | bc)
    secondresult[2]=$(echo "$1" | \
      awk -F: '{ if (NF == 3) {print $1 "*3600+" $2 "*60+" $3} }' | bc)

    for ((i=0;i<${#secondresult[@]};i++))
    do
      tresult="${secondresult[${i}]}"
      if [[ ! -z "${tresult}" ]] ; then
        if [[ "${tresult:0:1}" == "." ]] ; then
          result="0${tresult}"
        else
          result="${tresult}"
        fi
      fi
    done
    if [[ "${result}" == "0" ]] ; then
      result="0.0"
    fi
    echo ${result}
   }
	export -f toseconds
fi # if [[ -z "${__functoseconds}" ]]
