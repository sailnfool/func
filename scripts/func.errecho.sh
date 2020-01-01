#!/bin/bash
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
# 2.0 | REN |11/14/2019| added vim directive and header file
# 1.0 | REN |09/06/2018| original version
#_____________________________________________________________________
#
####################
if [ -z "${__funcerrecho}" ]
then
	export __funcerrecho=1
	function errecho() {>&2
		processbackslash=""
		if [ "$1" = "-e" ]
		then
			processbackslash="-e"
			shift
		fi
		line=$1
		shift
		FUNC_VERBOSE=${FUNC_VERBOSE:-1}
		if [ ${FUNC_VERBOSE} -gt 0 ]
		then
			if [ "$1" = "-e" ]
			then
				/bin/echo "${processbackslash} ${0##*/}:${line}: \r\n"$@
			else
				/bin/echo "${processbackslash}" ${0##*/}:${line}: $@
			fi
		fi
	##########
	# End of function errecho
	##########
	}
	export -f errecho
	##########
	# Send diagnostic output to stderr with a newline
	##########
	function stderrecho() {>&2 echo ${0##*/}:${FUNCNAME}:$@;}
	export -f stderrecho
	##########
	# Send diagnostic output to stderr without a newline
	##########
	function stderrnecho() {>&2 echo -n ${0##*/}:${FUNCNAME}:$@;}
	export -f stderrnecho
fi # if [ -z "${__funcerrecho}" ]
# vim: set syntax=bash, ts=2, sw=2, lines=55, columns=120,colorcolumn=78
