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
# 1.2 | REN |02/20/2022| Modernized to [[]]
# 1.1 | REN |02/01/2022| Tweaked documentation
# 1.0 | REN |03/25/2021| original version
#_____________________________________________________________________
#
if [[ -z "${__func_regex}" ]]
then
	export __func_regex=1

	####################
	# Define a set of regular expressions for various tests of inputs
	# When you want to test a variable, do NOT place the expansion of
	# the re_xxxx value in quotes.  It will not work.
	#
	# if [[ "$input_value" =~ $re_hexnumber ]]
	# then
	#     echo "$input_value is a valid hex number
	# fi
	####################
	re_hexnumber='^[0-9a-fA-F][0-9a-fA-F]*$'
	re_integer='^[0-9][0-9]*$'
	re_signedinteger='^[+\-][0-9][0-9]*$'
	re_decimal='^[+\-][0-9]*\.[0-9]*$'
  export re_hexnumber
  export re_integer
  export re_signedinteger
  export re_decimal

  ###
  # We only do this if we find the global variable __kbytessuffix which
  # is defined in func.kbytes is non-zero.  If it wasn't defined we
  # don't need this.
  # Create a regular expression for nicenumbers
  # First we sort through all of the letters in the kbibytessuffix
  # and kbytessuffix to put them in a single string.
  ###
  if [[ ! -z "${__kbytessuffix}" ]]
  then
    let1=/tmp/letters1$$
    let2=/tmp/letters2$$
    sorted=/tmp/sorted$$
    rm -f ${let1} ${let2} ${sorted}
	  allcat="${__kbibytessuffix[*]} ${__kbytessuffix}"
	  for i in $(seq 0 ${#allcat})
	  do
	    echo -e "${allcat:${i}:1}\n" >> ${let1}
	  done
    tr "A-Z" "a-z" < ${let1} > ${let2}
	  cat ${let1} ${let2} | sort -u | \
      tr -d " " | sed -e '/^$/d' > ${sorted}
	  while read inletter
	  do
	    matcher="${matcher}${inletter}"
	  done < /tmp/sorted
	  re_nicenumber="[0-9][0-9]*[${matcher}][${matcher}]*"
    export re_nicenumber
  fi
  echo "${re_nicenumber}"
fi # if [[ -z "${__func_regex}" ]]
