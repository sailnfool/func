#!/bin/bash
####################
# Author - Robert E. Novak aka REN
# sailnfool@gmail.com
# skype: sailnfool.ren
#
# pathmunge - add a directory to $PATH
# This script came from stackoverflow
# https://stackoverflow.com/questions/5012958/what-is-the-advantage-of-pathmunge-over-grep
#
# pathmunge <dir> [ after ]
#
# The directory <dir> is added before the rest of the directories in
# PATH.  The optional argument "after" places the directory after all
# other directories in PATH.  This script guarantees that links or
# symbolic links are decoded via "realpath(1)" and that the specified
# directory is only placed in PATH one time.  The output of the pathmunge
# replaces the contents of $HOME/.bashrc.addpath which is sourced
# as the last line of $HOME/.bashrc
####################
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 2.0 | REN |11/13/2019| added vim directive and header file
# 1.0 | REN |09/06/2018| original version
#_____________________________________________________________________
if [ -z "${__funcpathmunge}" ]
then
	export __funcpathmunge=1
  source errecho
	##########
	function func_pathmunge() {
		USAGE="${FUNCNAME} <dir> [ after ]"
		BASHRC_ADDPATH=$HOME/.bashrc.addpath
		if [ -d "$1" ]
		then
		  realpath / 2>&1 >/dev/null && path=$(realpath "$1") || path="$1"
		  # GNU bash, version 2.02.0(1)-release (sparc-sun-solaris2.6) ==> TOTAL incompatibility with [[ test ]]
		  [ -z "$PATH" ] && export PATH="$path:/bin:/usr/bin"
		  # SunOS 5.6 ==> (e)grep option "-q" not implemented !
		  /bin/echo "$PATH" | /bin/egrep -s "(^|:)$path($|:)" >/dev/null || {
		    [ "$2" == "after" ] && export PATH="$PATH:$path" || export PATH="$path:$PATH"
		  }
		else
			errecho "$1 is not a directory" "${USAGE}"
		fi
		echo "export PATH=$PATH" > $BASHRC_ADDPATH
	}
	##########
	# End of function pathmunge
	##########
	export -f func_pathmunge
fi # if [ -z "${__funcpathmunge}" ]
# vim: set syntax=bash, ts=2, sw=2, lines=55, columns=120,colorcolumn=78
