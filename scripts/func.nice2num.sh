#!/bin/sh
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# nice2num - converts a "nice" number like 10K to a decimal numeric
#            string which is likely to overflow 64 bit signed integers
#            The format of the numbers as KB vs, KiB is defined at:
#            https://physics.nist.gov/cuu/Units/binary.html
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.2 |REN|03/17/2022| Added documentation reference to the 
#                      | difference between megabytes and mebibytes
# 1.1 |REN|02/01/2022| added robustness and modernization
#                      | triggered reconstruction of func.kbytes
# 1.0 |REN|05/26/2020| original version
#_____________________________________________________________________

if [[ -z "${__funcnice2num}" ]]
then
	export __funcnice2num=1

  source func.errecho
  source func.kbytes

	nice2num () {
    local resultnumber
    local nicenum
    local number
    local multiplier

	  if [[ $# -ne 1 ]]
	  then
		  errecho "${FUNCNAME[0]} Missing Parameter"
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

          ##############################################################
          # To understand the following existence test, see:
          # https://linuxhint.com/associative_arrays_bash_examples/
          # Also see:
          # https://wiki.bash-hackers.org/syntax/pe#use_an_alternate_value
          ##############################################################
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
          ##############################################################
          # Some purists may only use a two letter suffix, e.g. Ki vs.
          # KiB.  This if statement handles conversion to a three
          # letter suffix.
          ##############################################################
          if [[ "${#multiplier}" -eq 2 ]]
          then
            if [[ "${multiplier}" -eq "BY" ]]
            then
              multiplier="BYT"
            else
              multiplier="${multiplier}B"
            fi
          fi

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
