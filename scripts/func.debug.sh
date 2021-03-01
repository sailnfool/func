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
# DEBUGSTRACE	5 - prefix the executable with strace (if implemented)
# DEBUGNOEXECUTE	or
# DEBUGNOEX	6 - generate and display the command lines but don't
#                  execute the benchmark
# DEBUGSETX	9 - turn on set -x to debug
####################
if [ -z "${__funcdebug}" ]
then
  export DEBUGOFF=0
  export DEBUGSTRACE=5
  export DEBUGNOEXECUTE=6
  export DEBUGNOEX=6
  export DEBUGSETX=9
fi # if [ -z "${__funcdebug}" ]
