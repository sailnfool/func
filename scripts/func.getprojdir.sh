#!/bin/bash
####################
# getprojdir [ -i <dir> ... ] <projectname> <base_directory>
#
# This function returns the parent directory of a project within the 
# "projectbase" tree.  It ignores directories specified with:
# -i <dirname>
# E.G.
# $(getprojdir -i .archive -i book.ignore uos ~/Dropbox/AAA_My_Jobs)
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 2.0 |REN|11/14/2019| added vim directive and header file
# 1.0 |REN|09/06/2018| original version
#_____________________________________________________________________
####################
if [ -z "${__funcgetprojdir}" ]
then
  GETPROJDIR_USAGE="$__FUNC__ [ -i <dir> ... ] <projectname> <base_directory>"
	export __funcgetprojdir=1
	source func.errecho
	source func.insufficient
	function getprojdir() {

    local ignorelist
    local numparms
    local project
    local projectbase
    local projdir

		ignorelist=""

#		stderrecho "$__FUNC__ ignorelist=${ignorelist}, 1=${1}"
		while [ "${1}" = "-i" ]
		do
#				stderrecho "$__FUNC__ ignorelist=${ignorelist}, 1=${1}"
				ignorelist="-e /${2}/d ${ignorelist}"
				shift
				shift
#				stderrecho "$__FUNC__ ignorelist=${ignorelist}, 1=${1}"
		done
#		stderrecho "$__FUNC__ ignorelist=${ignorelist}, 1=${1}"
		numparms=2
		project="$1"
		projectbase="$2"
		if [ $# -lt ${numparms} ]
		then
			insufficient ${numparms} $@
		fi
		if [ -z ${project} ]
		then
			$(nullparm "1")
		fi
		if [ -z ${projectbase} ]
		then
			$(nullparm "2")
		fi
		if [ ! -d ${projectbase} ]
		then
			$(nullparm "3")
		fi
#		stderrecho "ignorelist = ${ignorelist}"
    ####################
    # The ignore list needs to be changed to pruning the find tree
    # this version will fail in mysterious ways due to partial matches
    # of the ignorelist names.  C.F. proj_dir.sh
    ####################
		if [ -z "${ignorelist}" ]
		then
			projdir=$(find ${projectbase} -name ${project} -a -type d \
        -a -print )
  	else
#		  echo "projdir=\$(find ${projectbase} -name ${project} -a \
#       -type d -a -print | sed \"${ignorelist}\" )"
      projdir=""
      for ignoredir in ${ignorelist}
      do
		    projdir=$(find ${projectbase} -name ${project} -a -type d \
          -a -print | grep -v "${ignorelist}" )
      done
		fi
#		stderrecho "projdir = ${projdir}"
		echo $projdir
	##########
	# End of function getprojdir
	##########
	}
	export -f getprojdir
fi # if [ -z "${__funcgetprojdir}" ]
# vim: set syntax=bash, lines=55, columns=78,colorcolumn=72
