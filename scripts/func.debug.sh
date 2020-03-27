#!/bin/bash
########################################################################
# Author: Robert E. Novak
# email: novak5llnl.gov, sailnfool@gmail.com
#
# Set up global definitions of debugging levels
########################################################################
####################
# set the debug level to zero
# Define the debug levels:
#
# DEBUGSTRACE - prefix the executable with strace (if implemented)
# DEBUGSETX - turn on set -x to debug
# DEBUGNOEXECUTE - generate and display the command lines but don't
#                  execute the benchmark
####################
if [ -z "${__funcdebug}" ]
then
  export DEBUGOFF=0
	export DEBUGSTRACE=5
  export DEBUGNOEXECUTE=6
  export DEBUGSETX=9
fi # if [ -z "${__funcdebug}" ]
