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
	re_decimal='^[+\-][0-9]*\.[0-9]*$'
fi # if [[ -z "${__func_regex}" ]]
