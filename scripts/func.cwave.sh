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
# 2.2 |REN|07/26/2022| added "-v" option to functions.
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
if [[ -z "${__wavfuncs}" ]]
then
	export __wavfuncs=1

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
      local LN=${BASH_LINENO[0]}
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
      if [[ $# -eq 1 ]] && [[ $1 == "-v" ]]
      then
        echo "${xx} ${FN}:${LN}:::${SF}-->${CM}" >&2
      else
        echo "${xx} ${FN}:${LN}" >&2
      fi
    fi
  }
  export -f wavfuncentry

  function wavfuncexit () {>&2

    if [[ "${FUNC_DEBUG}" -ge "${DEBUGWAVE}" ]]
    then
      local FN=${FUNCNAME[1]}
      local LN=${BASH_LINENO[0]}
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
      if [[ $# -eq 1 ]] && [[ $1 == "-v" ]]
      then
        echo "${xx} ${FN}:${LN}:::${SF}-->${CM}" >&2
      else
        echo "${xx} ${FN}:${LN}" >&2
      fi
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
      local LN=${BASH_LINENO[0]}
      local SF=${BASH_SOURCE[0]}
      local CM=${0##*/}
      local level
      local xx
      local verbosemode="FALSE"

      if [[ $# -gt 1 ]] && [[ "${1}" == -v ]]
      then
        verbosemode="TRUE"
        shift
      fi
      level=${#FUNCNAME[@]}
      xx=$(printf "%${level}c%s" " " "$@")
      if [[ "${verbosemode}" == "TRUE" ]]
      then
#         echo "${xx} ${FN}:${LN}:::${SF}-->${CM}" >&2
        echo -n "${xx} ${FN}:${LN}" >&2
#        echo -n "${xx} " >&2
        for ((i=1;i<level;i++))
        do
          echo -n "${BASH_SOURCE[${i}]}:${BASH_LINENO[$((i-1))]}-> " >&2
        done
        echo "" >&2
      else
        echo "${xx} ${FN}:${LN}" >&2
      fi
    fi
	}
  export -f waverrindentvar
	
	##########
  # Send N indented space(s) equal to the function call depth
	##########
	function wavindentvar () {

    local FN=${FUNCNAME[1]}
    local LN=${BASH_LINENO[0]}
    local level
    local xx
    local verbosemode="FALSE"

    if [[ $# -gt 1 ]] && [[ "${1}" == -v ]]
    then
      verbosemode="TRUE"
      shift
    fi

    level=${#FUNCNAME[@]}
		xx=$(printf "%${level}c%s" " " "$@")
		echo $xx
    if [[ "${verbosemode}" == "TRUE" ]]
    then
      local SF=${BASH_SOURCE[1]}
      local CM=${0##*/}
      echo "${xx} ${FN}:${LN}:::${SF}-->${CM}" >&2
    else
      echo "${xx} ${FN}:${LN}" >&2
    fi
    
	}
	##########
	# End of cwave functions
	##########
	export -f wavindentvar
fi # if [[ -z "${__wavfuncs}" ]]
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78
