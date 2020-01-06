#!/bin/bash
scriptname=${0##*/}
####################
# Copyright (c) 2019 Sea2Cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# getb2sum - returns the b2sum of a string or a file.
#   -s <string> signals that the argument is a string rather than a file.
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#
# This is a human-readable summary of (and not a substitute for) the license.
# Disclaimer.
# You are free to:
# Share — copy and redistribute the material in any medium or format
# Adapt — remix, transform, and build upon the material
# for any purpose, even commercially.
# 
# The licensor cannot revoke these freedoms as long as you follow
# the license terms.
# 
# Under the following terms:
# Attribution — You must give appropriate credit, provide a link to
# the license, and indicate if changes were made. You may do so in
# any reasonable manner, but not in any way that suggests the licensor
# endorses you or your use.
# 
# No additional restrictions — You may not apply legal terms or
# technological measures that legally restrict others from doing
# anything the license permits.
# 
# Notices:
# You do not have to comply with the license for elements of the
# material in the public domain or where your use is permitted by
# an applicable exception or limitation.
# 
# No warranties are given. The license may not give you all of
# the permissions necessary for your intended use. For
# example, other rights such as publicity, privacy, or moral
# rights may limit how you use the material.
#
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |11/21/2019| Initial Release
#_____________________________________________________________________
#
##########
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

source func.errecho

USAGE="\r\n${scriptname} [-h] [ -d # ] [ -s <string> ] <filename>\r\n
\t\treturn the b2sum hash of a string or a filename\r\n
\t-h\tPrint this message\r\n
\t-s <string>\treturn the b2sum hash of <string>\r\n
\t-d #\tturn on diagnostics to level #\r\n"

optionargs="hd:s:"
NUMARGS=1
FUNC_DEBUG="0"
export FUNC_DEBUG

while getopts ${optionargs} name
do
	case ${name} in
	h) 
#		errecho "-e" ${LINENO} ${USAGE}
		echo -e ${USAGE}
		exit 0
		;;
	s)
		string=${OPTARG}
		NUMARGS=0
		;;
	d) 
		FUNC_DEBUG=${OPTARG}
		export FUNC_DEBUG
		;;
	\?)
		errecho "-e" ${LINENO} "invalid option: -$OPTARG"
		errecho "-e" ${LINENO} ${USAGE}
		exit 0
		;;
	esac
done

if [ $# -lt ${NUMARGS} ]
then
	errecho ${LINENO} "Insufficient Parameters: ${NUMARGS} required, $# supplied"
	errecho "-e" ${LINENO} ${USAGE}
	exit -2
fi
shift "$(($OPTIND -1))"
# echo "Number of unparsed Parameters is $#"
if [ "${FUNC_DEBUG}" -gt 0 ]
then
	if [ $# -gt 0 ]
	then
		errecho ${LINENO} "${filename}"
	else
		errecho ${LINENO} "${string}"
	fi
fi
if [ $# -gt 0 ]
then
	filename=$1
#	b2sum ${filename} | awk '{print $1}'
  hashstring=$(b2sum ${filename})
else
#	echo ${string} | b2sum | awk '{print $1}'
  hashstring=$(echo ${string} | b2sum)
fi
echo ${hashstring:0:128}
# vim: set syntax=bash
