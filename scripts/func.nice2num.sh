#!/bin/sh
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.1 | REN |02/01/2022| added robustness and modernization
#                      | triggered reconstruction of func.kbytes
# 1.0 | REN |05/26/2020| original version
#_____________________________________________________________________
#
########################################################################
source func.errecho
source func.kbytes
if [[ -z "${__funcnice2num}" ]]
then
	export __funcnice2num=1

	nice2num () {
	if [[ $# -ne 1 ]]
	then
		errecho "Missing Parameter"
		echo ""
	else
    ############################################################
		# Insure the multiplier is upper case
    ############################################################
		nicenum=$(echo $1 | tr '[a-z]' '[A-Z]')
    
    ############################################################
    # Strip the number off of the front
    ############################################################
		number=$(echo $nicenum | sed 's/^[^0-9]*\([0-9][0-9]*\).*$/\1/')

    ############################################################
    # Now strip the bibyte suffix off the end
    ############################################################
		multiplier=$(echo $nicenum | \
			sed "s/^.*[0-9]*\([${__kbibytessuffix}]\)/\1/")

		if [[ -z "${multiplier}" ]]
		then
			echo ${number}
		else
			case $multiplier in
			B)
        resultnumber=$(echo $number * $__byte) | bc)
				;;
			KIB)
        resultnumber=$(echo $number * $__kibibyte) | bc)
				;;
			K)
        resultnumber=$(echo $number * $__kbyte) | bc)
				;;
			MIB)
        resultnumber=$(echo $number * $__mibibyte) | bc)
				;;
			M)
        resultnumber=$(echo $number * $__mbyte) | bc)
				;;
			GIB)
        resultnumber=$(echo $number * $__gibibyte) | bc)
				;;
			G)
        resultnumber=$(echo $number * $__gbyte) | bc)
				;;
			TIB)
        resultnumber=$(echo $number * $__tibibyte) | bc)
				;;
			T)
        resultnumber=$(echo $number * $__tbyte) | bc)
				;;
			PIB)
        resultnumber=$(echo $number * $__pibibyte) | bc)
				;;
			P)
        resultnumber=$(echo $number * $__pbyte) | bc)
				;;
			EIB)
        resultnumber=$(echo $number * $__eibibyte) | bc)
				;;
			E)
        resultnumber=$(echo $number * $__ebyte) | bc)
				;;
			ZIB)
        resultnumber=$(echo $number * $__zibibyte) | bc)
				;;
			Z)
        resultnumber=$(echo $number * $__zbyte) | bc)
				;;
			\?)
				errecho "Bad Suffix $multiplier"
				;;
			esac
			echo $resultnumber
		fi
	fi
	##########
	# End function nice2num
	##########
	}
	export -f nice2num
fi # if [[ -z "${__funcnice2num}" ]]
