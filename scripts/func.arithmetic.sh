#!/bin/bash
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# arithmetic - define some useful arithmetic functions
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|07/24/2022| Initial Release
#_____________________________________________________________________
#

if [ -z "$__funcarithmetic" ]
then
  export __funcarithmetic=1

  source func.regex

  ######################################################################
  # Return the minimum of two integers
  ######################################################################
	function func_intmin()
	{
    if [[ ! "${1}" =~ $re_integer ]] || \
      [[ ! "${2}" =~ $re_integer ]]
    then
      errecho "Both arguments must be integers $@"
      exit 1
    fi
	  echo $(( $1 < $2 ? $1 : $2 ))
	}
	export -f func_intmin

  ######################################################################
  # Return the maximum of two integers
  ######################################################################
	function func_intmax()
	{
    if [[ ! "${1}" =~ $re_integer ]] || \
      [[ ! "${2}" =~ $re_integer ]]
    then
      errecho "Both arguments must be integers $@"
      exit 1
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
    local number
    local nearest

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
		(( number+=nearest ))
		(( number-= ((number%nearest))))
		echo $number
	}
	export -f func_introundup

  ######################################################################
  # Return the factorial of a number. Requires an integer argument
  # allows arbitrary precision by using 'bc'
  # This function provides a great example of wavfuncentry and
  # wavfuncexit (see func.debug and func.cwave
  ######################################################################
  function func_factorial {

    wavfuncentry
    local sub
    if [[ $# -ne 1 ]]
    then
      insufficient 1 $@
      exit 1
    fi
    if [[ "${1}" =~ $re_integer ]]
    then
      errecho "argument is not an integer"
      exit 1
    fi
    if [[ "${1}" -le 1 ]]
    then
      wavfuncexit
      echo 1
    else
      sub=$(factorial $(( $1 - 1 )) )
      wavfuncexit
      echo "$1 * $sub" | bc
    fi
  }
  export -f func_factorial
fi # if [ -z "$__funcarithmetic" ]
# vim: filetype=sh
