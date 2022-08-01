#!/bin/bash
####################
# Author - Robert E. Novak aka REN
# sailnfool@gmail.com
# skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|12/03/2019| Initial Release
#_____________________________________________________________________
####################
# Standard Prolog for stc utilities found in stc_prolog.sh
# Copy from here to the end into stc script files.
####################
##################
# The following are the environment variables created/modified
# in $stcPATH
##################
# stcBIN=/usr/local/stc/bin
# PATH=$PATH:${stcBIN}:
# stc_CONF_PATH=/etc/stc/conf
# stcCONF=stc_paths.conf
# stcTMP=/tmp/stc
# stcFIX="fix.sh"
# stcDEBUGTXT="debug.txt"
##################
STC_fullname=$0
STC_command=${0##*/}
source func.getprojdir
source func.errecho
####################
# make sure that the project has been setup
####################
which proj_setup > /dev/null
if [[ $? -ne 0 ]] ; then
  stderrecho "proj_setup not found in PATH"
  exit -1
fi
projdir=$(getprojdir -i .archive stc $HOME/Dropbox/AAA_My_Jobs)
if [[ ! -d ${projdir} ]] ; then
  proj_setup -e stc 2>&1 > /dev/null
fi
##################
# This is the directory where stc commands will put 
# temporary or diagnostic information.
##################
export STCMP=${STCTMP:-"/tmp/stc"}

##################
# The general usage of these next two variables is to use
# them as suffixes for the files produced by an executing
# command.  The files are usually placed in STCTMP and
# the command name is a prefix to the suffix.  There may
# be other reasons to use the process ID (AKA \$\$) as part
# of the name to avoid conflicts between multiple instances
# of the utilities running on a single machine.
##################
# This is the suffix for scripts generated by STC utilities
# Generally these utilities will unwind the actions of the 
# parent script that ran the command - hence the "fix" in
# the name
##################
export STCFIX=${STCFIX:-"fix.sh"}

##################
# This is the suffix for any debug or diagnostic information
# generated by an STC utility
##################
export STCDEBUGTXT=${STCDEBUGTXT:-"debug.txt"}
