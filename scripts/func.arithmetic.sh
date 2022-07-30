#!/bin/bash
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# arithmetic - define some useful arithmetic functions
#        since the arguments to the int functions are passed as
#        strings, error checking for integers fitting into two's
#        complement 64 bit numbers should be added and abort the
#        functions if invalid arguments are presented since they
#        would produce invalid results.
#
#        intmin - The minimum of two integers
#        intmax - The Maximum of two integers
#        introundup - Round an integer to the specified power of value
#                     Note that this can produce results larger than
#                     the maximum signed integer.  A warning is
#                     issued to stderr
#        func_factorial - compute an arbitrary precision factorial
#                         of a given argument
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.1 |REN|07/29/2022| Added func_factorial, added additional error
#                    | checks for exceeding the maximum signed integer
# 1.0 |REN|07/24/2022| Initial Release
#_____________________________________________________________________

if [ -z "$__funcarithmetic" ]
then
  export __funcarithmetic=1

  source func.regex

  ######################################################################
  # Return the minimum of two integers
  ######################################################################
	function func_intmin()
	{
    local maxsignedint=$(echo "2^63-1" | bc)
    local checksign

    if [[ ! "${1}" =~ $re_integer ]] || \
      [[ ! "${2}" =~ $re_integer ]]
    then
      errecho "Both arguments must be integers $@"
      exit 1
    fi
    checksign=$(echo "${maxsignedint} - ${1}" | bc)
    if [[ "${checksign:0:1}" == "-" ]]
    then
      errecho "Argument ${1} is larger than the " \
        "maximum signed integer on a 64-bit machine"
      errecho "Max signed integer = ${maxsignedint}"
      errecho "calculation aborted, result would be invalid, use bc"
      exit 2
    fi
    checksign=$(echo "${maxsignedint} - ${2}" | bc)
    if [[ "${checksign:0:1}" == "-" ]]
    then
      errecho "Argument ${2} is larger than the " \
        "maximum signed integer on a 64-bit machine"
      errecho "Max signed integer = ${maxsignedint}"
      errecho "calculation aborted, result would be invalid, use bc"
      exit 2
    fi
	  echo $(( $1 < $2 ? $1 : $2 ))
	}
	export -f func_intmin

  ######################################################################
  # Return the maximum of two integers
  ######################################################################
	function func_intmax()
	{
    local maxsignedint=$(echo "2^63-1" | bc)
    local checksign

    if [[ ! "${1}" =~ $re_integer ]] || \
      [[ ! "${2}" =~ $re_integer ]]
    then
      errecho "Both arguments must be integers $@"
      exit 1
    fi
    checksign=$(echo "${maxsignedint} - ${1}" | bc)
    if [[ "${checksign:0:1}" == "-" ]]
    then
      errecho "Argument ${1} is larger than the " \
        "maximum signed integer on a 64-bit machine"
      errecho "Max signed integer = ${maxsignedint}"
      errecho "calculation aborted, result would be invalid, use bc"
      exit 2
    fi
    checksign=$(echo "${maxsignedint} - ${2}" | bc)
    if [[ "${checksign:0:1}" == "-" ]]
    then
      errecho "Argument ${2} is larger than the " \
        "maximum signed integer on a 64-bit machine"
      errecho "Max signed integer = ${maxsignedint}"
      errecho "calculation aborted, result would be invalid, use bc"
      exit 2
    fi
	  echo $(( $1 > $2 ? $1 : $2 ))
	}
	export -f func_intmax

  ######################################################################
  # round up a number to the nearest value.  This is only integer
  # arithmetic so, call will look like:
  # func_introundup(number, 100) to round a number up to the next
  # multiple of 100.  Similar for 10 or 1000.  
  ######################################################################
	function func_introundup()
	{
    local maxsignedint=$(echo "2^63-1" | bc)
    local checksign

    local number
    local nearest
    local result

    if [[ ! "${1}" =~ $re_integer ]] || \
      [[ ! "${2}" =~ $re_integer ]]
    then
      errecho "Both arguments must be integers $@"
      exit 1
    fi

		number=$1
		nearest=$2

		if [[ $nearest -eq 0 ]]
		then
      errecho "second argument must be integer > 0 $@"
			exit 1
		fi
    checksign=$(echo "${maxsignedint} - ${1}" | bc)
    if [[ "${checksign:0:1}" == "-" ]]
    then
      errecho "Argument ${1} is larger than the " \
        "maximum signed integer on a 64-bit machine"
      errecho "Max signed integer = ${maxsignedint}"
      errecho "calculation aborted, result would be invalid, use bc"
      exit 2
    fi
    checksign=$(echo "${maxsignedint} - ${2}" | bc)
    if [[ "${checksign:0:1}" == "-" ]]
    then
      errecho "Argument ${2} is larger than the " \
        "maximum signed integer on a 64-bit machine"
      errecho "Max signed integer = ${maxsignedint}"
      errecho "calculation aborted, result would be invalid, use bc"
      exit 2
    fi
    result=$(echo "( ${number} + ${nearest} ) - ( ${number} % ${nearest} )" | bc )
    checksign=$(echo "${maxsigned} - ${result}" | bc)
    if [[ "${checksign:0:1}" == "-" ]]
    then
      errecho "*** WARNING *** Result is larger than max signed integer"
      errecho "Max signed integer = ${maxsignedint}"
    fi
#		(( number+=nearest ))
#		(( number-= ((number%nearest))))
		echo $result
	}
	export -f func_introundup

  ######################################################################
  # Return the factorial of a number. Requires an integer argument
  # allows arbitrary precision by using 'bc'
  # This function provides a great example of wavfuncentry and
  # wavfuncexit (see func.debug and func.cwave
  ######################################################################
  function func_factorial {

    wavfuncentry -v
    local sub
    if [[ $# -ne 1 ]]
    then
      insufficient 1 $@
      exit 1
    fi
    if [[ ! "${1}" =~ $re_integer ]]
    then
      errecho "argument is not an integer"
      exit 1
    fi
    if [[ "${1}" -le 1 ]]
    then
      wavfuncexit -v
      echo 1
    else
      sub=$(func_factorial $(( $1 - 1 )) )
      wavfuncexit -v
      echo "$1 * $sub" | bc
    fi
  }
  export -f func_factorial
fi # if [ -z "$__funcarithmetic" ]
