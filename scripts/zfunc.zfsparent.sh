#!/bin/bash
####################
# The assumption here is that we are cloning into a github subdirectory
# of the user's HOME directory, since that will hopefully be 
# intuitively obvious.
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |06/17/2020| Set the parent directory of zfs in-tree

####################
if [ -z "${__zfunczfsparent}" ]
then
	export __zfunczfsparent=1
	function zfsparent()
	{
		case $(hostname) in
		slagi|jet*)
			zfsparent="/tftpboot/global/novak5/github"
			;;
		*)
			zfsparent="$HOME/github"
			;;
		esac
		echo "${zfsparent}"
	}
fi # if [ -z "${__zfunczfsparent}" ]
