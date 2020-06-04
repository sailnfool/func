#!/bin/sh
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |05/26/2020| original version
#_____________________________________________________________________
#
####################
source func.errecho
source func.kbytes
if [ -z "${__funcnice2num}" ]
then
	export __funcnice2num=1
	####################
	####################
	nice2num () {
	if [ $# -ne 1 ]
	then
		errecho "Missing Parameter"
		echo ""
	else
		###################
		# Insure the multiplier is upper case
		###################
		nicenum=$(echo $1 | tr '[a-z]' '[A-Z]')

		number=$(echo $nicenum | sed 's/^[^0-9]*\([0-9][0-9]*\).*$/\1/')
		multiplier=$(echo $nicenum | \
			sed "s/^.*[0-9]*\([$__kbibytesuffix]\)/\1/")
	    
		if [ -z ${multiplier} ]
		then
			echo ${number}
		else
			case $multiplier in
			B)
				((number *= __byte))
				;;
			K)
				((number *= __kibibyte))
				;;
			M)
				((number *= __mibibyte))
				;;
			G)
				((number *= __gibibyte))
				;;
			T)
				((number *= __tibibyte))
				;;
			P)
				((number *= __pibibyte))
				;;
			E)
				((number *= __etibyte))
				;;
			Z)
				((number *= __zibibyte))
				;;
			\?)
				errecho "Bad Suffix $multiplier"
				;;
			esac
			echo $number
		fi
	fi
	##########
	# End function nice2num
	##########
	}
	export -f nice2num
fi # if [ -z "${__funcnice2num}" ]
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78
