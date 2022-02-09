#!/bin/bash
#######################################################################
# Author: Robert E. Novak
# email: sailnfool@gmail.com
# Copyright (C)2022 Sea2Cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# convert a time to number of seconds
# Has to be flexible for HH:MM:SS or MM:SS or just SS.xx
#
#######################################################################
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |02/01/2022| Initial Release
#_____________________________________________________________________
#######################################################################

if [[ -z "${__functoseconds}" ]]
then
	export __functoseconds=1

	source func.insufficient

  function toseconds() {
    declare -a secondresult
    if [[ $# -lt 1 ]]
    then
      insufficient 1 "at least one argument in time format required"
      exit -1
    fi
    secondresult[0]=$(echo "$1" | awk -F: '{ if (NF == 1) {print $NF} }' | bc)
    secondresult[1]=$(echo "$1" | awk -F: '{ if (NF == 2) {print $1 "* 60 + " $2} }' | bc)
    secondresult[2]=$(echo "$1" | awk -F: '{ if (NF == 3) {print $1 " * 3600 + " $2 " * 60 + " $3} }' | bc)
    for i in $(seq 0 2)
    do
      tresult="${secondresult[${i}]}"
      if [[ ! -z "${tresult}" ]]
      then
        if [[ "${tresult:0:1}" == "." ]]
        then
          result="0${tresult}"
        else
          result="${tresult}"
        fi
      fi
    done
    if [[ "${result}" == "0" ]]
    then
      result="0.0"
    fi
    echo ${result}
   }
	export -f toseconds
fi # if [ -z "${__functoseconds}" ]

