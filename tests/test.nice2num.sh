#!/bin/sh
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |02/01/2022| testing reconstructed kbytes
#_____________________________________________________________________
#
########################################################################
source func.nice2num
testingsuffix=M
testingnumber=1048576
answer=$(nice2num 1M)
if [[ "${answer}" == "${testingnumber}" ]]
then
  exit 0
else
  exit 1
fi

