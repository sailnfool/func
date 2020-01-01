#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#
# The following functions (see list) are used by the "cwave"
# macro/functions to trace the entry and exit from nested scripts
# to show the indentation.  The same mechanisms are used in 
# my C Language programs.
# errindentdir
# indentdir
####################
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 2.0 | REN |11/13/2019| added vim directive and header file
# 1.0 | REN |09/06/2018| original version
#_____________________________________________________________________
#
####################
source func.errecho
if [ -z "${__funccwave}" ]
then
	export __funccwave=1
	##########
	# The following functions (see list) are used by the "cwave"
	# macro/functions to trace the entry and exit from nested scripts
	# to show the indentation.  The same mechanisms are used in 
	# my C Language programs.
	# errindentdir
	# indentdir
	##########
	##########
	# Send N indented space ($1) then print a directory name ($2)
	# to stderr
	##########
	function errindentdir () {
		stderrecho ""
		xx=$(printf "%$1c%s" " " $2)
		stderrnecho $xx
	}
	
	##########
	# Send N indented space ($1) then print a directory name ($2)
	##########
	function indentdir () {
		echo ""
		xx=$(printf "%$1c%s" " " $2)
		echo -n $xx
	}
	##########
	# End of cwave functions
	##########
	export -f errindentdir
	export -f indentdir
fi # if [ -z "${__funccwave}" ]
# vim: set syntax=bash, ts=2, sw=2, lines=55, columns=120,colorcolumn=78
