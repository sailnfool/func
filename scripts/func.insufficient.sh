#!/bin/bash
####################
# insufficient
#
# tell the user that they have insufficient parameters to this function
####################
# nullparm
#
# tell the user that they have a null parameter
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
#
if [ -z "${__funcinsufficient}" ]
then
	export __funcinsufficient=1
	##########
	# insufficient
	#
	# tell the user that they have insufficient parameters to this function
	##########
	function insufficient() {
		lineno="$1"
		funcname="$2"
		numparms="$3"
		shift; shift; shift;
		errecho "${lineno} ${funcname}: Insufficient parameters $@, need ${numparms}"
		exit -1
		##########
		# end of function insufficient
		##########
	}
	export -f insufficient

	##########
	# nullparm
	#
	# tell the user that they have a null parameter
	##########
	function nullparm() {
		lineno="$1"
		funcname="$2"
		parmnum="$3"
		errecho "${lineno}: ${funcname}: Parameter #${parmnum} is null"
		exit -1
		##########
		# end of function insufficient
		##########
	}
	export -f nullparm
fi # if [ -z "${__funcinsufficient}" ]
# vim: set syntax=bash, ts=2, sw=2, lines=55, columns=120,colorcolumn=78
