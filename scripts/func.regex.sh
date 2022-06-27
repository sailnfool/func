#!/bin/bash
########################################################################
# Author: Robert E. Novak
# email: sailnfool@gmail.com
# Copyright (C) 2022 Sea2Cloud Storage, Inc. All Rights Reserved
# Modesto, CA 95356
#
# Define a set of regular expressions for various tests of inputs
# When you want to test a variable, do NOT place the expansion of
# the re_xxxx value in quotes.  It will not work.
#
########################################################################
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.4 | REN |05/27/2022| Added re_hexdigit, re_digit
# 1.3 | REN |05/19/2022| Added re_cryptohash, moved re_nicenumber to
#                      | func.kbytes
# 1.2 | REN |02/20/2022| Modernized to [[]]
# 1.1 | REN |02/01/2022| Tweaked documentation
# 1.0 | REN |03/25/2021| original version
#_____________________________________________________________________
#
if [[ -z "${__func_regex}" ]]
then
	export __func_regex=1

  ######################################################################
  # Define a set of regular expressions for various tests of inputs
  # When you want to test a variable, do NOT place the expansion of
  # the re_xxxx value in quotes.  It will not work.
  #
  # if [[ "$input_value" =~ $re_hexnumber ]]
  # then
  #     echo "$input_value is a valid hex number
  # fi
  #
  # Often used to test arguments passed when using getopts to process
  # Bash script parameters for example the value passed to debug (-d)
  # if [[ "${OPTARG}" =~ $re_digit ]]
  # then
  #   debug="${OPTARG}"
  # else
  #   echo -e ${USAGE}
  # fi
  #
  # Note that there is also a "re_nicenumber" found in func.kbytes
  ######################################################################
  export re_hexdigit='^[0-9a-fA-F]$'
  export re_hexnumber='^[0-9a-fA-F][0-9a-fA-F]*$'
  export re_digit='^[0-9]$'
  export re_integer='^[0-9][0-9]*$'
  export re_signedinteger='^[+\-][0-9][0-9]*$'
  export re_decimal='^[+\-][0-9]*\.[0-9]*$'
  export re_cryptohash='^[0-9a-fA-F]{3}:[0-9a-fA-F][0-9a-fA-F]*$'

fi # if [[ -z "${__func_regex}" ]]
