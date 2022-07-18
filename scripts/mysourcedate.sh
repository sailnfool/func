#!/bin/bash
scriptname=${0##*/}
# Copyright (c) 2022 Sea2Cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# sourcedate - find date/time/name of newest file in tree
#              ignore directories and contents of ".ignore"
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 2.6 |REN|07/04/2022| Modernize to [[, fixed func.debug usage
# 2.4 |REN|05/01/2022| streamlined header comments, added help for
#                      | Debug flags.
# 2.3 |REN|02/21/2021| added test for file vs. directory to allow
#                      | the formats output for a file, not the tree
# 2.2 |REN|02/21/2021| added -s for touch time stamp.
# 2.1 |REN|03/21/2019| fixed the ignoredir to handle a list
#                      | of directories to ignore.
# 2.0 |REN|10/14/2018| Combined sourcedatetime into one script
# 1.2 |REN|09/06/2018| Updated prolog
# 1.1 |REN|11/18/2017| Changed SEACS to s2c
# 1.0 |REN|08/28/2011| Initial Release
#_____________________________________________________________________
#
########################################################################
# This script checks the last modified date (and time) of each file
# in a directory tree and extracts the date (and time) of the newest
# file in the hierarchy.
#
# Default behavior is to return the date only
# as a numeric string in the format: "+%Y%m%d" (see the date
# command documentation for an explanation.
#
# the optional parameter -t adds a period followed by the Time in
# "+%H%M%S" format.
# the optional parameter -o outputs only the time without the date.
# the optional parameter -n Don't suppress directories in the date
#       calculations. Directories are normally suppressed because
#       a clone of a source tree will not have accurate directory
#      	timestamps
# the optional parameter -d turns on diagnostics.
# all of the times are emitted in Universal Time (UCT) format.
# see 'man stat'
#

source func.debug
source func.errecho
source func.insufficient
source func.regex

USAGE="\n${scriptname} [-[hostnv]] [-d <#>] [ [-i <ignoredir> ] ... ] <dirname>\n
\t\treturn the date of the newest file in the tree\n
\t\tin the format \"+%Y%m%d\"\n
\t\tsee 'man date' for syntax\n
\t\tIf <dirname> is a file it returns the timestamp for a file not\n
\t\tnot a tree under <dirname>\n
\t-d\t<#>\tSet the diagnostic levels\n
\t\t\tUse -vh to see debug modes\n
\t-f\treport the name of the newest file\n
\t-h\tPrint this message\n
\t-n\tinclude the time stamps of directories\n
\t\tdirectory timestamps are ignored because you may be\n
\t\tlooking at a clone tree\n
\t-o\treturn only the time stamp of the newest file\n
\t-s\treturn the time stamp in STAMP format (see man touch)\n
\t-t\tadd a period followd by the time in \"+%H%M%S\" format\n
\t-i\t<ignoredir>\tignore everything under <ignoredir>\n
\t\tE.G.:\n
\t\t${scriptname} -i .ignore .\n
\t\t\twill ignore any directories named '.ignore'\n
\t\t\tand the files in the directory '.ignore'\n
\t\t${scriptname} -i .ignore -i .archive .\n
\t\t\twill ignore any directories named '.ignore' or '.archive'\n
\t\t\tand the files in the directories '.ignore' or '.archive'\n
\t-v\tturn on verbose mode for this script\n
"

optionargs="hfnostvd:i:"
NUMARGS=1
FUNC_DEBUG="0"
export FUNC_DEBUG
verbosemode="FALSE"
nodirs="-not -type d -a"
onlytell="0"
addtell="0"
stamptell="0"
filetell="0"
datetell="1"
ignoredir=""
ignorelist=".archive"

while getopts ${optionargs} name
do
	case ${name} in
	d)
    if [[ ! "${OPTARG}" =~ $re_digit ]]
    then
      errecho "${0##/*}" "${LINENO}" "-d requires a decimal digit"
      errecho -e "${USAGE}"
      errecho -e "${DEBUG_USAGE}"
      exit 1
    fi
		FUNC_DEBUG="${OPTARG}"
		export FUNC_DEBUG
		if [[ $FUNC_DEBUG -ge 9 ]]
		then
			set -x
		fi
		;;
	f)
		filetell="1"
		;;
	h)
		errecho -e ${USAGE}
    if [[ "${verbosemode}" == "TRUE" ]]
    then
      errecho -e "${DEBUG_USAGE}"
    fi
		exit 0
		;;
	i)
		ignorelist="${ignorelist} ${OPTARG}"
		;;
	n)
		nodirs=""
		;;
	o)
		onlytell=1
		addtell="0"
		stamptell="0"
		filetell="0"
		datetell="0"
		;;
	t)
		addtell=1
		onlytell="0"
		stamptell="0"
		filetell="0"
		datetell="0"
		;;
	s)
		stamptell=1
		onlytell="0"
		addtell="0"
		filetell="0"
		datetell="0"
		;;
	v)
    verbosemode="TRUE"
		;;
	\?)
		errecho "-e" "invalid option: -${OPTARG}"
		errecho "-e" ${USAGE}
		exit 1
		;;
	esac
done

shift $(( ${OPTIND} - 1 ))

if [[ $# -lt "${NUMARGS}" ]]
then
	insufficient ${0##*/} ${NUMARGS} $@
	errecho "-e" ${USAGE}
	exit 2
fi

# dirname="${@:$OPTIND:1}"
dirname="$1"

if [[ ! -d "${dirname}" ]]
then
  errecho "-e" ${0##*/} "${dirname} is not a directory"
  exit 3
fi

##########
# This is where we prune any specified directories from the list
# of directories that should be searched for a project
##########
ignoreprefix="-name "
ignoresuffix="-prune -o"
ignoredir=""
# ignoredir="-name '.ignore' -prune -o"
for i in ${ignorelist}
do
		ignoredir="${ignoredir} ${ignoreprefix} ${i} ${ignoresuffix}"
done
if [[ "$FUNC_DEBUG" -gt 0 ]]
then
	errecho ${FUNCNAME} ${LINENO} "Ignore list is:" "${ignoredir}"
fi

# 2018-10-14 10:33:55.990652503 -0700 --./sourcedate.bash
rm -f /tmp/sourcedate.newest.$$*
if [[ -d "${dirname}" ]]
then
	if [[ "${FUNC_DEBUG}" -ge 6 ]]
	then
		find "${dirname}" ${ignoredir} ${nodirs} \
		    -printf '%T+ %p\n' | \
#		    -exec stat \{\} --printf="%y --%n\n" \; | \
		    tee /dev/tty  | \
		    sort -n -r | head -1 > /tmp/sourcedate.newest.$$.txt
	else
		find "${dirname}" ${ignoredir} ${nodirs} \
		    -printf '%T+ %p\n' | \
#		    -exec stat \{\} --printf="%y --%n\n" \; | \
		    sort -n -r | head -1 > /tmp/sourcedate.newest.$$.txt
	fi
else
	ls -l "${dirname}" > /tmp/sourcedate.newest.$$.txt
fi
newestfile=$(sed -e s/.*--// < /tmp/sourcedate.newest.$$.txt)
dateonly=$(sed -e 's/ .*//' -e 's/-//g' < /tmp/sourcedate.newest.$$.txt)
datetime=$(sed -e 's/\..*//' -e 's/ /./' -e 's/-//g' -e 's/://g' < /tmp/sourcedate.newest.$$.txt)
stamptime=$(sed -e 's/\..*//' -e 's/ //' -e 's/-//g' -e 's/://' -e 's/:/./' < /tmp/sourcedate.newest.$$.txt)
# datetime2=$(sed -e 's/\..*--.*//' -e 's/ /./' -e 's/-//g' -e 's/://g' </tmp/sourcedate.newest.$$.txt)
timeonly=$(sed -e 's/\..*//' -e 's/.* //' -e 's/://g' < /tmp/sourcedate.newest.$$.txt)
if [[ "$FUNC_DEBUG" -gt 0 ]]
then
	ls -l /tmp/sourcedate*$$.txt
	more /tmp/sourcedate*$$.txt
	errecho "${FUNCNAME}" "${LINENO}" "Newest file is ${newestfile}"
	errecho "${FUNCNAME}" "${LINENO}" "Date only is ${dateonly}"
	errecho "${FUNCNAME}" "${LINENO}" "Date time is ${datetime}"
	errecho "${FUNCNAME}" "${LINENO}" "Date2 time is ${datetime2}"
	errecho "${FUNCNAME}" "${LINENO}" "Time only is ${timeonly}"
	errecho "${FUNCNAME}" "${LINENO}" "STAMP time is ${stamptime}"
fi
if [[ "${onlytell}" == "1" ]]
then
	echo -n ${timeonly} " "
fi
if [[ "${addtell}" == "1" ]]
then
	echo -n ${datetime}
fi
if [[ "${datetell}" == "1" ]]
then
	echo -n ${dateonly} " "
fi
if [[ "${stamptell}" == "1" ]]
then
	echo -n ${stamptime} " "
fi
if [[ "${filetell}" == "1" ]]
then
	echo ${newestfile}
else
	echo ""
fi
rm -f /tmp/sourcedate.newest.$$*
# vim: set syntax=bash
