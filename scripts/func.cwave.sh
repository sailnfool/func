#!/bin/bash
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# cwave - Define function entry/exit tracking routines that print
#         indented traces of the entry and exit to functions.
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution licens
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 2.1 |REN|07/24/2022| Normalized header file and end the funcenter
#                    | and funcexit functions
# 2.0 |REN|11/13/2019| added vim directive and header file
# 1.0 |REN|09/06/2018| original version
#_____________________________________________________________________
#
# The following functions (see list) are used by the "cwave"
# macro/functions to trace the entry and exit from nested scripts
# to show the indentation.  The same mechanisms are used in 
# my C Language programs.
# wavfuncentry
# wavfuncexit
# waverrindentdir
# wavindentdir
########################################################################
if [[ -z "${__funccwave}" ]]
then
	export __funccwave=1

  source func.errecho
  source func.debug
  ######################################################################
	# The following functions (see list) are used by the "cwave"
	# macro/functions to trace the entry and exit from nested scripts
	# to show the indentation.  The same mechanisms are used in 
	# my C Language programs.
  # wavfuncentry
  # wavfuncexit
	# waverrindentdir
	# wavindentdir
  ######################################################################

  ######################################################################
  # Mark the entry to a function
  ######################################################################
  function wavfuncentry () {>&2
    local level
    local xx

    if [[ "${FUNC_DEBUG}" -ge "${DEBUGWAVE}" ]]
    then
      local FN=${FUNCNAME[1]}
      local LN=${BASH_LINENO[1]}
      local SF=${BASH_SOURCE[1]}
      local CM=${0##*/}
      ##################################################################
      # Find out how many level deep we are in the function stack
      ##################################################################
      level=${#FUNCNAME[@]}
      xx=""

      ##################################################################
      # skip over this function (which is FUNCNAME[0])
      ##################################################################
      for ((i=2;i<level;i++));do xx="${xx}>";done
      echo "${xx}${FN}:${LN}:::${SF}-->${CM}" >&2
    fi
  }
  export -f wavfuncentry

  function wavfuncexit () {>&2

    if [[ "${FUNC_DEBUG}" -ge "${DEBUGWAVE}" ]]
    then
      local FN=${FUNCNAME[1]}
      local LN=${BASH_LINENO[1]}
      local SF=${BASH_SOURCE[1]}
      local CM=${0##*/}
      local level
      local xx
      ##################################################################
      # Find out how many level deep we are in the function stack
      ##################################################################
      level=${#FUNCNAME[@]}

      ##################################################################
      # skip over this function (which is FUNCNAME[0])
      ##################################################################
      for ((i=2;i<level;i++));do xx="${xx}<";done
      echo "${xx}${FN}:${LN}:::${SF}-->${CM}" >&2
    fi
  }
  export -f wavfuncexit

  ######################################################################
  # Send N indented space(s)  equal to the function call depth
  # then print an argument string to stderr
  ######################################################################
	function waverrindentvar () {>&2

    if [[ "${FUNC_DEBUG}" -ge "${DEBUGWAVAR}" ]]
    then
      local FN=${FUNCNAME[1]}
      local LN=${BASH_LINENO[1]}
      local SF=${BASH_SOURCE[1]}
      local CM=${0##*/}
      local level
      local xx

      xx=$(printf "%${level}c%s" " " "${1}")
      echo "${xx} ${FN}:${LN}:::${SF}-->${DM}"
    fi
	}
  export -f waverrindentvar
	
	##########
  # Send N indented space(s) equal to the function call depth
	##########
	function wavindentvar () {

    local level
    local xx

    level=${#FUNCNAME[@]}
		xx=$(printf "%${level}c%s" " " "${1}")
		echo $xx
	}
	##########
	# End of cwave functions
	##########
	export -f wavindentvar
fi # if [[ -z "${__funccwave}" ]]
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78
