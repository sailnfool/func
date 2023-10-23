#!/bin/bash
########################################################################
# Copyright (C) 2020 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# insufficient - tell the user that they have insufficient
#                parameters to a function
#
# nullparm - tell the user that they have a null parameter
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 2.2 |REN|07/29/2022| Remove .vim directive
# 2.1 |REN|04/27/2020| swapped order of parameters to make func first
# 2.0 |REN|11/14/2019| added vim directive and header file
# 1.0 |REN|09/06/2018| original version
#_____________________________________________________________________

if [[ -z "${__funcinsufficient}" ]] ; then

	export __funcinsufficient=1

  ####################################################################
	# insufficient - tell the user that they have insufficient
  #                parameters to a function
  ####################################################################

	function insufficient() {

    local numparms
    
		numparms="$1"
		shift;
		errecho -i "Insufficient parameters '$@', need ${numparms}"
		exit -1

    ##################################################################
		# end of function insufficient
    ##################################################################
	}
	export -f insufficient

  ####################################################################
  # nullparm - tell the user that they have a null parameter
  ####################################################################
	function nullparm() {

    local parmnum

		parmnum="$1"
		errecho -i "Parameter #${parmnum} is null"
		exit -1

    ##################################################################
		# end of function nullparm
    ##################################################################
	}
	export -f nullparm
fi # if [ -z "${__funcinsufficient}" ]
