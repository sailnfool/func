#!/bin/sh
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |03/26/2022| original version
#_____________________________________________________________________
#
# This function is the reverse of nice2num.  However note that
# it will generate fixed length strings.  For Kbytes, the format is
# always four characters [0-9][0-9]*X where the digits are only three
# in number and X represents a Kbyte suffix defined in __kbytessuffix
#
# For bibyte numbers (e.g. mebibyte = 1024*1024) the number is always
# only 3 digits but that includes counting the decimal point as one of
# the positions.
#
# The format of the numbers as KB vs, KiB is defined at:
# https://physics.nist.gov/cuu/Units/binary.html
########################################################################
source func.errecho
source func.kbytes
if [[ -z "${__funcnum2nice}" ]]
then
	export __funcnum2nice=1

	num2nice () {
    local convert
    local bignumber
    local kdivisor
    local kbibquotient
    local kquotient
    local kprefix
    local kbibprefix
    local foundk
    local foundkbib


    ####################################################################
    # There must be at least one argument, the number to be converted
    # Optionally, there is a "-b" parameter to convert to bibyte vs.
    # kbyte
    ####################################################################
	  if [[ $# -lt 1 ]]
	  then
      insufficient 1 $@
      exit 1
	  else
      if [[ "$1" = "-b" ]]
      then
        convert="bibyte"
        if [[ $# -lt 2 ]]
        then
          errecho "${FUNCNAME[0]} Found \"-b\" but number parameter missing"
          insufficient 2 $@
          exit 1
        else
          bignumber=$1
        fi #         if [[ $# -lt 2 ]]
      else
        convert="kbyte"
        bignumber=$1
    fi #      if [[ "$1" = "-b" ]]
    fi #	  if [[ $# -lt 1 ]]

    ####################################################################
    # The idea here is that we take the big number and divide it by the
    # valus of the various named powers (BYT KiB, ..) and if the result
    # is less than 1000 (or 1024) we have the prefix for the named
    # power.
    ####################################################################
    for (( i=0; i < ${#__kbytessuffix}; i++))
    do
#      echo "__kbytessuffix:$i:1 = ${__kbytessuffix:$i:1}"
#      echo "__kbytesvalue[${__kbytessuffix:$i:1}] = "\
#        ${__kbytesvalue[${__kbytessuffix:$i:1}]}

#      echo "__kbibytessufix[$i] = ${__kbibytessuffix[$i]}"
#      echo "__kbibytesvalue[${__kbibytessuffix[$i]}] = "\
#          ${__kbibytesvalue[${__kbibytessuffix[$i]}]}

      kdivisor=${__kbytesvalue[${__kbytessuffix:$i:1}]}
      kbibdivisor=${__kbibytesvalue[${__kbibytessuffix[$i]}]}

#      echo "kdivisor = ${kdivisor}"
#      echo kbibdivisor = "${kbibdivisor}"

      kquotient=$(echo "${bignumber} / ${kdivisor}" | bc)
      kbibquotient=$(echo "${bignumber} / ${kbibdivisor}" | bc)

#      echo "kquotient = ${kquotient}"
#      echo "kbibquotient = ${kbibquotient}"

      if [[ "${kquotient}" -lt "1000" ]]
      then
        kprefix=${kquotient}
        foundk="TRUE"
        if [[ "${convert}" = "kbyte" ]]
        then
          kindex=$i
          break
        fi
      fi
      if [[ "${kbibquotient}" -lt "1024" ]]
      then
        kbibprefix=${kbibquotient}
        foundkbib="TRUE"
        if [[ "${convert}" = "kbibyte" ]]
        then
          kindex=$i
          break
        fi
      fi
    done
    if [[ ( "${convert}" = "kbyte" ) && ( "${foundk}" = "TRUE" ) ]]
    then
      result=$(echo "${kprefix}${__kbytessuffix:${kindex}:1}")
      if [[ "${#result}" -le 4 ]]
      then
        echo ${result}
        exit 0
      else
        echo "Invalid result, kindex=${kindex}, result=${result}, "\
          "kprefix=${kprefix}"
        exit 1
      fi
    fi
    if [[ ( "${convert}" = "kbibyte" ) && ( "${foundkbib} = ""TRUE" ) ]]
    then
      echo "${kbibprefix}${__kbibytessuffix[${kindex}]}"
      exit 0
    fi
    exit 1
  }
fi # if [[ -z "${__funcnum2nice}" ]]
