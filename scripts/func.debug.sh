#!/bin/bash
####################
# Copyright (c) 2021 Sea2Cloud
# 3901 Moorea Dr.
# Modesto, CA 95356
########################################################################
#
# func.debug - Set up global definitions of debugging levels and 
#              define the DEBUG_USAGE string that defines the verbose
#              help string on using func.debug definitions
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.2 |REN|07/19/2022| Cleaned up DEBUG_USAGE and removed redundant
#                    | comments
# 1.1 |REN|03/01/2021| Added DEBUGOFF
# 1.0 |REN|07/22/2010| Initial Release
#_____________________________________________________________________
#
########################################################################
# Scripts that include this should also have the following three
# command line options: -h -v -d, where -h is the normal help file
# and -v when used before -h, e.g., -vh will cause the script to
# not only print out USAGE string but also the DEBUG_USAGE string.
# Finally -d will accepte an integer parameter as defined in
# DEBUG_USAGE.  This parameter should be verfied using $re_digit
# found in func.regex
########################################################################
if [[ -z "${__funcdebug}" ]]
then
  export __funcdebug=1
  export DEBUGOFF=0
  export DEBUGWAVE=2
  export DEBUGWAVAR=3
  export DEBUGSTRACE=5
  export DEBUGNOEXECUTE=6
  export DEBUGNOEX=6
  export DEBUGSETX=9
  export DEBUG_USAGE="\tThe '-d'\t<#>\twhere <#> evaluates to a\n
\t\t\tdecimal integer\n
\tDEBUGOFF 0 -\tTurn off debugging\n
\tDEBUGWAVE 2 -\tprint indented entry/exit to functions\n
\tDEBUGWAVAR 3 -\tprint variable data from functions if enabled\n
\tDEBUGSTRACE 5 -\tprefix the executable with strace\n
\t\t\t(if implemented)\n
\tDEBUGNOEXECUTE\tor\n
\tDEBUGNOEX 6 -\tgenerate and display the command lines but don't\n
\t\t\texecute the script\n
\tDEBUGSETX 9 -\tturn on set -x to debug\n
"
fi # if [[ -z "${__funcdebug}" ]]
