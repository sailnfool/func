#!/bin/ksh
####################
# This defines 3 functions:
# errecho
# stderrecho
# stderrnecho
#
# errecho is invoked as in the example below:
# errecho ${LINENO} "some error message " "with more text"
# the LINENO has to be on the invoking line to get the correct
# line number from the point of invocation
# The output is only generated if the global variable $FUNC_VERBOSE
# is defined and greater than 0
# The errecho function takes an optional argument "-e" to tell the
# echo command to add a new line at the end of a line and to process
# any in-line control characters (see man echo)
# The implementation of stderrecho should have the comparable
#  command line arguments but that will wait for a later day.
# stderrnecho drops the output of a trailing newline character like
#  the "-n" optional parameter to echo (see man echo)
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 2.1 | REN |05/20/2020| removed vim directive.  Added additional
#                      | bash builtins to report the name of the
#                      | source file, the command that is executing
#                      | the name of the function that is throwing
#                      | the error number and the line number
# 2.0 | REN |11/14/2019| added vim directive and header file
# 1.0 | REN |09/06/2018| original version
#_____________________________________________________________________
#
####################
if [ -z "${__funcerrecho}" ]
then
	export __funcerrecho=1
	function errecho
	{>&2
		PL=1
		pbs=""
		if [ "$1" = "-e" ]
		then
			pbs="-e"
			shift
		fi
		if [ "$1" = "-i" ]
		then
			PL=2
		fi
		FUNC_VERBOSE=${FUNC_VERBOSE:-0}
		if [ ${FUNC_VERBOSE} -gt 0 ]
		then
			FN=${FUNCNAME[${PL}]}
			LN=${BASH_LINENO[${PL}]}
			SF=${BASH_SOURCE[${PL}]}
			CM=${0##*/}
			if [ "${pbs}" = "-e" ]
			then
				if [ -t 1 ]
				then
					/bin/echo "${pbs}" $@
				else
					/bin/echo "${pbs}" "${SF}->${CM}::${FN}:${LN}: \r\n"$@
				fi
			else
				if [ -t 1 ]
				then
					/bin/echo "${pbs}" $@
				else
					/bin/echo "${pbs}" "${SF}->${CM}::${FN}:${LN}: "$@
				fi
			fi
		fi
	##########
	# End of function errecho
	##########
	}
	export errecho
	##########
	# Send diagnostic output to stderr with a newline
	##########
	function stderrecho
	{>&2 
		FN=${FUNCNAME[1]}
		LN=${BASH_LINENO[1]}
		SF=${BASH_SOURCE[1]}
		CM=${0##*/}
		echo ${SF}->${CM}::${FN}:${LN}:$@
	}
	export stderrecho
	##########
	# Send diagnostic output to stderr without a newline
	##########
	function stderrnecho
	{>&2
		FN=${FUNCNAME[1]}
		LN=${BASH_LINENO[1]}
		SF=${BASH_SOURCE[1]}
		CM=${0##*/}
		echo -n ${SF}->${CM}::${FN}:${LN}:$@
	}
	export stderrnecho
fi # if [ -z "${__funcerrecho}" ]
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78
