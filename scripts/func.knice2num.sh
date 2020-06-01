#!/bin/ksh
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#${__}___________________________________________________________________
# Rev.|Auth.| Date     | Notes
#${__}___________________________________________________________________
# 1.0 | REN |05/26/2020| original version
#${__}___________________________________________________________________
#
####################
source func.errecho
source func.kbytes
if [ -z "__kfuncnice2num" ]
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
		number=$(echo $1 | sed 's/^.*\([0-9][0-9]*\).*$/\1/')
		multiplier=$(echo $1 | \
			sed "s/^.*[0-9]*\([${__kbibytesuffix}]\)/\1/")
		if [ -z ${multiplier} ]
		then
			echo ${number}
		else
			case $multiplier in
			B)
				number = number * ${__byte}
				;;
			K)
				number = number * ${__kibibyte}
				;;
			M)
				number = number * ${__mibibyte}
				;;
			G)
				number = number * ${__gibibyte}
				;;
			T)
				number = number * ${__tibibyte}
				;;
			P)
				number = number * ${__pibibyte}
				;;
			E)
				number = number * ${__etibyte}
				;;
			Z)
				number = number * ${__zibibyte}
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
fi # if [ -z "__funcnice2num" ]
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78
