#!/bin/bash
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# func_intrandom - return a random positive integer from /dev/random
#
# func_intrandomrange - return a number in the inerval [0-#)
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|07/29/2022| Initial Release
#_____________________________________________________________________

########################################################################
# func_intrandom - return a random positive integer from /dev/random
########################################################################
if [[ -z "$__funcintrandom" ]] ; then
	export __funcintrandom=1

	function func_intrandom() {

    local num

		num=$(od -N4 -i -An /dev/urandom)
		((num=num<0?-num:num))
		echo $num
	}
	export -f func_intrandom
	
########################################################################
# func_intrandomrange - return a number in the inerval [0-#)
# The function func_intrandom returns a 4 byte positive integer
# which is guaranteed to work on 64-bit machines.
########################################################################

	function func_intrandomrange() {

    source func.regex

    local maxsignedint=$(echo "2^63-1" | bc)
    local checksign

    if [[ ! "${1}" =~ $re_decimal ]] ; then
      errecho "Argument is not a decimal number"
      exit 1
    else
      checksign=$(echo "${1} - ${maxsignedint}" | bc)
      if [[ "${checksign:0:1}" == "-" ]] ; then
        errecho "Argument out of range ${1}"
        errecho "Argument greater than maximum signed integer"
        errecho "${maxsignedint}"
        exit 1
      fi
    fi
    echo $(( $(func_intrandom) % $1 ))
	}
	export -f func_intrandomrange
fi # if [[ -z "$__funcintrandom" ]]
