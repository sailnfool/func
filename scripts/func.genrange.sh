#!/bin/sh
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
if [ -z "${__funcgenrange}" ]
then
	export __funcgenrange=1
	##########
	# gen_range - generate a range of integers
	#
	# Since it is impossible to simply evaluate variables within a
	# range expression expansion, I wrote this function to generate
	# the integer numbers in a range.  If either the lower bound or
	# the upper bound are not numbers, a value of zero is substituted
	# for the # positional parameter
	# instead of: "for i in {${low}..${high}}"
	# use:        "for i in $(gen_range ${low} ${high})"
	#
	# See:
	# https://unix.stackexchange.com/questions/340440/bash-test-what-does-do
	##########
	gen_range () {
	re="^[0-9]+$"
	# errecho "re=${re}"
	if [ $# -ge 2 ]
		then
			lower=$1
			upper=$2
			# errecho ${lower} ${upper}
			if [[ ! "${lower}" =~ ^[0-9]+$ ]]
			then
				lower=0
			fi
			if [[ ! "${upper}" =~ ^[0-9]+$ ]]
			then
				upper=0
			fi
			i=${lower}
			while [ $i -lt ${upper} ]
			do
				echo "$i"
				((++i))
			done
		fi
	##########
	# End function gen_range
	##########
	}
	export -f gen_range
fi # if [ -z "${__funcgenrange}" ]
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78
