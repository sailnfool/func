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
    local resultnumber
    local nicenum
    local number

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
      multiplier=${nicenum:${#number}}
#		  multiplier=$(echo $nicenum | \
#			  sed "s/^.*[0-9]*\([${__kbibytessuffix}]\)/\1/")

		  if [[ -z "${multiplier}" ]]
		  then
			  echo ${number}
		  else
        if [[ "${#multiplier}" -eq 1 ]]
        then

          ##################################################
          # To understand the following existence test, see:
          # https://linuxhint.com/associative_arrays_bash_examples/
          # Also see:
          # https://wiki.bash-hackers.org/syntax/pe#use_an_alternate_value
          ##################################################
          if [[ ! ${__kbytesvalue[${multiplier}]+_} ]]
          then
            errecho -i "multiplier \"${multiplier}\" not found"
            errecho -i "Please use a nice number suffix in the"
            errecho -i "following set for decimal powers"
            errecho -i "${__kbytessuffix}"
            exit 1
          fi
          resultnumber=$(echo "${number} * ${__kbytesvalue[${multiplier}]}" | bc)
        else

          ##################################################
          # To understand the following existence test, see:
          # https://linuxhint.com/associative_arrays_bash_examples/
          # Also see:
          # https://wiki.bash-hackers.org/syntax/pe#use_an_alternate_value
          ##################################################
          if [[ ! ${__kbibytesvalue[${multiplier}]+_} ]]
          then
            errecho -i "multiplier \"${multiplier}\" not found"
            errecho -i "Please use a nice number suffix in the"
            errecho -i "following set for decimal powers"
            errecho -i "${!__kbibytessuffix[@]}"
            exit 1
          fi
          resultnumber=$(echo "${number} * ${__kbibytesvalue[${multiplier}]}" | bc)
        fi
      fi
			echo $resultnumber
		fi
	  ##########
	  # End function nice2num
	  ##########
	}
	export -f nice2num
fi # if [[ -z "${__funcnice2num}" ]]
