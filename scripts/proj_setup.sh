#!/bin/bash
####################
# Author(s) - Robert E. Novak aka REN
# sailnfool@gmail.com
# skype: sailnfool.ren
#
# proj_setup
#
# Set up the necessary system files for managing a project.
# Projects will have a parent directory for the project with various
# files underneath the project.  This setup program will only
# concern itself with the following resources:
#
# BIN - The system wide bin directory where the executables for the
#   support of the project (scripts or binaries) are placed for access
#   via the PATH variable for users.  Previously we had placed each
#   projects BIN in a separate directory.  With improvements in the
#   makefile used by the projects, all of the projects will share a
#   common BIN location.  Each project is responsible to have both
#   an install target and an uninstall target in the makefile to
#   insure that the executables can be removed and/or replaced by
#   the project.  The downside here is that two projects may have
#   conflicting executables.  Testing and guarding against that
#   is left as a later function.
# <group> is the group name of the files in the project.  The project
#   parent directory must have group ownership of <group> as must all
#   children.  Executables belonging to this project must have a
#   groupid of <group> when they are "installed" in BIN.  A
#   pre-installation check for name conflicts of executables with a
#   different group ID is the check that we need as described above.
#
#_____________________________________________________________________
# Rev |Aut| Date		 | Notes
#_____________________________________________________________________
# 2.2 |REN|12/03/2019| Fixed func_pathmunge.  Moved initialization
#                      | of project path after setting project.
#                      | Fixed projectvindir to projectbindir
# 2.1 |REN|11/10/2019| Fixed problems with non-existent directories
# 2.0 |REN|02/27/2019| Changes to make the script more robust
#                      | and less dependent on outside resources
#_____________________________________________________________________
####################
# normally we source from scripts that are in the $PATH environment.
# If we are running from the source directory where this is found it
# means that the project binary directories are not yet installed
# therefore we will use the file name ending in ".sh" which are
# the original source.
####################
if [ $(which func.errecho | wc-l) -eq 1 ]
then
  source func.errecho
else
####################
# This defines 3 functions:
# errecho
# stderrecho
# stderrnecho
#
# errecho is invoked as in the example below:
# errecho ${LINENO} "some error message " "with more text"
# the LINENO has to be on the invoking line to get the correct
# line number from the point of invocation
# The output is only generated if the global variable $FUNC_VERBOSE
# is defined and greater than 0
# The errecho function takes an optional argument "-e" to tell the
# echo command to add a new line at the end of a line and to process
# any in-line control characters (see man echo)
# The implementation of stderrecho should have the comparable
#  command line arguments but that will wait for a later day.
# stderrnecho drops the output of a trailing newline character like
#  the "-n" optional parameter to echo (see man echo)
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 2.1 |REN|05/20/2020| removed vim directive.  Added additional
#                      | bash builtins to report the name of the
#                      | source file, the command that is executing
#                      | the name of the function that is throwing
#                      | the error number and the line number
# 2.0 |REN|11/14/2019| added vim directive and header file
# 1.0 |REN|09/06/2018| original version
#_____________________________________________________________________
#
####################
	if [ -z "${__funcerrecho}" ]
	then
		export __funcerrecho=1
		function errecho() {>&2
			PL=1
			pbs=""
			if [ "$1" = "-e" ]
			then
				pbs="-e"
				shift
			fi
			if [ "$1" = "-i" ]
			then
				PL=2
			fi
			FUNC_VERBOSE=${FUNC_VERBOSE:-1}
			if [ ${FUNC_VERBOSE} -gt 0 ]
			then
				local FN=${FUNCNAME[${PL}]}
				local LN=${BASH_LINENO[${PL}]}
				local SF=${BASH_SOURCE[${PL}]}
				local CM=${0##*/}
				if [ "${pbs}" = "-e" ]
				then
					/bin/echo "${pbs}" "${SF}->${CM}::${FN}:${LN}: \r\n"$@
				else
					/bin/echo "${pbs}" "${SF}->${CM}::${FN}:${LN}: "$@
				fi
			fi
		##########
		# End of function errecho
		##########
		}
		export -f errecho
		##########
		# Send diagnostic output to stderr with a newline
		##########
		function stderrecho() {>&2
			local FN=${FUNCNAME[1]}
			local LN=${BASH_LINENO[1]}
			local SF=${BASH_SOURCE[1]}
			local CM=${0##*/}
			echo ${SF}->${CM}::${FN}:${LN}:$@
		}
		export -f stderrecho
		##########
		# Send diagnostic output to stderr without a newline
		##########
		function stderrnecho() {>&2
			local FN=${FUNCNAME[1]}
			local LN=${BASH_LINENO[1]}
			local SF=${BASH_SOURCE[1]}
			local CM=${0##*/}
			echo -n ${SF}->${CM}::${FN}:${LN}:$@
		}
		export -f stderrnecho
	fi # if [ -z "${__funcerrecho}" ]
fi # if [ $(which func.errecho | wc-l) -eq 1 ]
####################

if [ $(which func.pathmunge | wc -l) -eq 1 ]
then
  source func.pathmunge
else
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
	# Rev.|Aut| Date     | Notes
	#_____________________________________________________________________
	# 2.0 |REN|11/13/2019| added vim directive and header file
	# 1.0 |REN|09/06/2018| original version
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
fi # if [ $(which func.pathmunge | wc -l) -eq 1 ]
if [ $(which func.insufficient | wc -l) -eq 1 ]
then
  source func.insufficient.sh
else
####################
# insufficient
#
# tell the user that they have insufficient parameters to this function
####################
# nullparm
#
# tell the user that they have a null parameter
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 2.1 |REN|04/27/2020| swapped order of parameters to make func first
# 2.0 |REN|11/14/2019| added vim directive and header file
# 1.0 |REN|09/06/2018| original version
#_____________________________________________________________________
#
####################
#
	if [ -z "${__funcinsufficient}" ]
	then
		export __funcinsufficient=1
		##########
		# insufficient
		#
		# tell the user that they have insufficient parameters to this function
		##########
		function insufficient() {
			numparms="$1"
			shift;
			errecho -i "Insufficient parameters $@, need ${numparms}"
			exit -1
			##########
			# end of function insufficient
			##########
		}
		export -f insufficient

		##########
		# nullparm
		#
		# tell the user that they have a null parameter
		##########
		function nullparm() {
			parmnum="$1"
			errecho -i "Parameter #${parmnum} is null"
			exit -1
			##########
			# end of function insufficient
			##########
		}
		export -f nullparm
	fi # if [ -z "${__funcinsufficient}" ]
fi # if [ $(which func.insufficient | wc -l) -eq 1 ]

function projectdirectory(){
  ##################
  # projectdirectory - create the requested directory for the
  # project and make sure that the project group
  ##################
  if [ $# -lt 2 ]
  then
    $(insufficient(${LINENO} ${FUNCNAME} 2))
  fi
  projdir=$1
  project=$2

  ##################
  # Make sure that the proj bin directory exists and that the
  # current user has read/write permission for the directory
  ##################
  if [ ! -d  ${projdir} ]
  then
  	sudo mkdir -p ${projdir}
  fi
  cd ${projdir}

  ##################
  # Find out if the project is in a group, add it if it is not.
  ##################
  if [ ! $(getent group ${project}) ]
  then
    sudo addgroup ${project}
    sudo addgroup ${USER} ${project}
  fi
  sudo chown ${USER} ${projdir}
  sudo chgrp ${USER} ${projdir}
  sudo chmod g+rwx ${projdir}

  ##################
  # Check to see if there are already files in the directory.
  # If there are, then make sure they are owned and belong to
  # the $USER and $project.
  ##################
  if [ `ls -l ${projdir} | wc -l` -ne 1 ]
  then
  	sudo chown ${USER} ${projdir}/*
  	sudo chgrp ${project} ${projdir}/*
  	sudo chmod g+rwx ${projdir}/*
  fi
}

NUMARGS=1

USAGE="USAGE: ${0##*/}: [-[hdv]] [-l <projectbase>] [-b <binpath>] [-p <projectpath>] <project>\r\n
\t-h\tPrint this usage message\r\n
\t-b\t<bin>\tThe path to the bin directory which is used for\r\n
\t\tfor the project. Within the /etc/<project>/conf/conf.txt there\r\n
\t\tis a record of the project initializations from this program.\r\n
\t-l\t<projectbase>\tSpecify the parent directory (e.g. \$HOME))\r\n
\t\tthe -l prefix was chosen to use \"lead\" as a substitute for\r\n
\t\tprojectbase, i.e. PB == lead.\r\n
\t-d\tEnable Diagnostics. This will also preserve the old version.\r\n
\t-v\tEnable Verbose mode to display changes to \$HOME/.bashrc\r\n
\t-p\t<projectpath>\tE.G. /usr/var.  The <project> will be postpended.\r\n
\t<project>	The name of a project to setup\r\n
\tThe project name must be unique.  This command will create the\r\n
\tetc directory for the project in <projectpath> (default is\r\n
\t/usr/var).  It will add a group called <project>\r\n
\tto the system wide groups and add the current user to that group\r\n
\r\n
\tAll of this is predicated on having makefiles that will both\r\n
\t\tinstall and uninstall executables and ancillary files in bin\r\n
\t\tand etc directories.\r\n
\r\n
\tRUN THIS AS A MERE MORTAL.  The script will ask for su privileges\r\n
\tas needed.\r\n"

options=hdveb:l:p:
debug=""
abortonfirst=""
binpath="/usr/var/func/bin"
projectpath="/usr/var/"
etcprefix="/etc/"
etcpostfix="/conf/"
projectbase=$HOME
while getopts ${options} name
do
  case ${name} in
  d)
    debug=1
    FUNC_VERBOSE=1
    export FUNC_VERBOSE
    set -x
    ;;
  v)
    verbose=1
    export verbose
    FUNC_VERBOSE=1
    export FUNC_VERBOSE
    ;;
  h)
    errecho -e ${USAGE}
    exit 0
    ;;
  l)
  	projectbase=${OPTARG}
  	;;
  b)
    binpath=${OPTARG}
    ;;
  p)
    projectpath=${OPTARG}
    ;;
  \?)
	errecho "-e" ${LINENO} "Invalid option: ${OPTARG}"
	errecho "-e" ${LINENO} ${USAGE}
	exit -1
	;;
  esac
done
##########
# Get the arguments to the script, produce an error if inadequate parameters
##########
if [ $# -lt ${NUMARGS} ]
then
	errecho ${LINENO} "${NUMARGS} parameters required $# supplied"
	errecho ${LINENO} ${USAGE}
	exit -2
fi
if [ ${debug} ]
then
	errecho ${LINENO} "Number of Args" $#
	errecho ${LINENO} "$@"
fi
project=${@:$OPTIND:1}
##################
# Make sure that the bin directory exists for executables
##################
if [ ! -d ${binpath} ]
then
  /bin/echo $(projectdirectory ${binpath} ${project}) > /dev/null
  $(func_pathmunge ${binpath} after)
fi

projectetcdir=${projectetcdir:-"${etcprefix}${project}${etcpostfix}"}
/bin/echo $(projectdirectory ${projectetcdir} ${project}) > /dev/null
/bin/echo "$0 $*" >> ${projectetcdir}/conf.txt
exit 0
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78
