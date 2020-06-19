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
# 1.0 | REN |06/17/2020| Set the directory for storing benchmark results
####################
if [ -z "${__zfuncresults}" ]
then
	export __zfuncresults=1
	function benchresults {
		if [ $# -gt 0 ]
		then
			luser=$1
		else
			echo "Missing username"
			echo "${0##*/} <user>"
			exit -1
		fi

		case $(hostname) in
		slagi|jet*)
			benchresults="/tftpboot/global/${luser}/bench_results"
			;;
		*)
			benchresults="~${luser}/bench_results"
			;;
		esac
		echo "${benchresults}"
	}
	export -f benchresults
fi # if [ -z "${__zfuncresults}" ]
