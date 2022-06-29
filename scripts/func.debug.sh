#!/bin/bash
####################
# Copyright (c) 2021 Sea2Cloud
# 3901 Moorea Dr.
# Modesto, CA 95356
# 408-910-9134
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.1 | REN |03/01/2021| Added DEBUGOFF
# 1.0 | REN |07/22/2010| Initial Release
#_____________________________________________________________________
#

########################################################################
# Author: Robert E. Novak
# email: sailnfool@gmail.com
#
# Set up global definitions of debugging levels
########################################################################
####################
# set the debug level to zero
# Define the debug levels:
#
# DEBUGOFF	0
# DEBUGWAVE 2 - print indented entry/exit to functions
# DEBUGWAVAR 3 - print variable data from functions if enabled
# DEBUGSTRACE	5 - prefix the executable with strace (if implemented)
# DEBUGNOEXECUTE	or
# DEBUGNOEX	6 - generate and display the command lines but don't
#                  execute the benchmark
# DEBUGSETX	9 - turn on set -x to debug
#
# Scripts that include this should also have the following three
# command line options: -h -v -d, where -h is the normal help file
# and -v when used before -h, e.g., -vh will cause the script to
# not only print out USAGE string but also the DEBUG_USAGE string.
# Finally -d will accepte a numeric parameter as defined in
# DEBUG_USAGE
####################
if [ -z "${__funcdebug}" ]
then
  export __funcdebug=1
  export DEBUGOFF=0
  export DEBUGWAVE=2
  export DEBUGWAVAR=3
  export DEBUGSTRACE=5
  export DEBUGNOEXECUTE=6
  export DEBUGNOEX=6
  export DEBUGSETX=9
  export DEBUG_USAGE="\t\t\tDEBUGOFF 0\r\n
\t\t\tDEBUGWAVE 2 - print indented entry/exit to functions\r\n
\t\t\tDEBUGWAVAR 3 - print variable data from functions if enabled\r\n
\t\t\tDEBUGSTRACE 5 = prefix the executable with strace\r\n
\t\t\t                (if implement)\r\n
\t\t\tDEBUGNOEXECUTE or\t\n
\t\t\tDEBUGNOEX 6 - generate and display the command lines but don't\r\n
\t\t\t              execute the script\r\n
\t\t\tDEBUGSETX 9 - turn on set -x to debug\r\n
"
fi # if [ -z "${__funcdebug}" ]
