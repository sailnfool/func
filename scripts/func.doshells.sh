#!/bin/bash
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
####################
# doshells
# copies shell scripts from their source directory to the bin
# directory
#
# invoked as:
#
# doshells .sh; doshells .bash
#
# copies files with .sh or .bash suffix (or other) into
# $HOME/bin without the suffix.
#
# This script is obsoleted by proper use of make and install
####################
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 2.0 |REN|11/13/2019| added vim directive and header file
# 1.0 |REN|09/06/2018| original version
#_____________________________________________________________________
#
####################
if [ -z "${__funcdoshells}" ]
then
	export __funcdoshells=1
	source func.errecho
	source func.env
  source func.insufficient
	function doshells() {
    local numparms
    local scriptsuffix
    local bin_path
    local tmpfile
    local splitprefix
    local filecount
    local list
    local i
    local j

		numparms=2
		scriptsuffix="${1}"
		bin_path="${2}"

		if [ $# -lt ${numparms} ]
		then
			insufficient ${numparms} $@
		fi

	  ##########
		# What is the suffix of the script type we are copying?
		# Typically it is ".bash" or ".sh"
	  ##########
		if [ -z "${scriptsuffix}" ]
		then
			nullparm "1"
		fi

	  ##########
		# What is the path where the executable will be copied?
	  ##########
		if [ -z "${bin_path}" ]
		then
			nullparm "2"
		fi

		##########
		# find out how many files there are in the source directory
		# We use this step to avoid an error in the "for" loop below
		#
		# In order to "future proof" this against large numbers of
		# files I split the list of files and then process each
		# group of up to 500 files separately
		##########

		tmpfile="/tmp/stc$$.filelist.txt"
		splitprefix="/tmp/filelist.$$."
		ls *${scriptsuffix} 2> /dev/null > ${tmpfile}
		filecount=$(cat ${tmpfile} | wc -l )
		# filecount=$(ls *${scriptsuffix} 2>/dev/null | wc -l)
		if [ ${filecount} -gt 0 ]
		then
			split --lines=500 ${tmpfile} ${splitprefix}
			for list in ${splitprefix}*
			do
				for i in $(cat $list)
				do
					j=$(basename ${i} ${scriptsuffix})
					if [ ${i} -nt ${bin_path}/${j} ]
					then
#						stderrecho "${i} is newer"
						stderrecho "${i} is newer"
						if [[ -r ${bin_path}/${j} ]]
						then
							diff -q ${bin_path}/${j} ${i} >&2
						fi
					fi
					install --backup=numbered --preserve-timestamps ${i} ${bin_path}/${j} >&2
				done # for i in $(cat $list)
			done # for list in ${splitprefix}*
			rm -rf ${tmpfile} ${splitprefix}*
		fi
	##########
	# End of function doshells
	##########
	}
	export -f doshells
	##########
	# dorshells
	# copies shell scripts from their archive path to the bin
	# directory and to the local source directory where the
	# scripts are normally edited.  Basically insuring that
	# the working directory is not the same one as the cloud
	# archive.
	##########
	function dorshells() {

    local scriptsuffix
    local filecount
    local i
    local j

		scriptsuffix="$1"
		filecount=$(ls *${scriptsuffix} 2>/dev/null | wc -l)
		if [ ${filecount} -gt 0 ]
		then
			for i in *$scriptsuffix
			do
				j=$(basename $i $scriptsuffix)
				chmod +x $i
				if [ $i -nt ${bin_path}/$j ]
				then
					cp $i ${bin_path}/$j
					echo "${0##*/}: Updated $j"
				fi
			done
		fi
	##########
	# End of function dorshells
	##########
	}
	export -f dorshells
fi # if [ -z "${__funcdoshells}" ]
# vim: set syntax=bash, lines=55, columns=78,colorcolumn=72
