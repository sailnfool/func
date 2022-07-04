#!/bin/sh
####################
# Copyright (c) 2021 Sea2Cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# getgitroot - Find the parent directory of the current git repository
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|08/13/2021| Initial Release
#_____________________________________________________________________
#
# Look for the parent directory which contains the .git file with 
# the repository information.
# Quit if you reach $HOME or / and not .git directory is found
#[ $(pwd) = ${HOME} ] || [ $(pwd) = "/" ] && exit -1
if [ $(pwd) = ${HOME} ]
then
  exit -1
fi
if [ $(pwd) = "/" ]
then
  exit -1
fi

while [ ! -d .git ]
do
  cd ..
	if [ $(pwd) = ${HOME} ]
	then
	  exit -1
	fi
	if [ $(pwd) = "/" ]
	then
	  exit -1
	fi
done
pwd
