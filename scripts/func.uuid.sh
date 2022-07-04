#!/bin/bash
####################
# This generates a pseudo random uuid for the server
# This is based on the discussion in:
# https://serverfault.com/questions/103359/how-to-create-a-uuid-in-bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|07/22/2020| original version
#_____________________________________________________________________
#
####################
if [ -z "${__funcuuid}" ]
then
	export __funcuuid=1
	function uuid()
	{
		local N B T
	
		set -x
		for (( N=0; N < 16; ++N ))
		do
			B=$(( $RANDOM%255 ))
	
			if (( N == 6 ))
			then
				printf '4%x' $(( B%15 ))
			elif (( N == 8 ))
			then
				local C='89ab'
				printf '%c%x' ${C:$(( $RANDOM%${#C} )):1} $(( B%15 ))
			else
				printf '%02x' $B
			fi
			case $N in
				3|5|7|9)
					printf '-'
					;;
			esac
	    	done
	
	    echo
	}
	export -f uuid
fi # if [ -z "${__funcuuid}" ]
