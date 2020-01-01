#!/bin/bash
# scriptname=${0##*/}
####################
# Copyright (c) 2019 Sea2Cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
#
# mypr - insure that printing options are set correctly
# Author - Robert E. Novak aka REN
# sailnfool@gmail.com
# skype:sailnfool.ren
#
#_____________________________________________________________________
# Rev.|Auth.| Date       | Notes
#_____________________________________________________________________
# 1.0 | REN | 06/18/2019 | Initial Release
#_____________________________________________________________________
#
##########
source func.errecho


USAGE="\r\n${0##*/} [-[hd]] <file> ...\r\n
\t\tprint file(s) with proper options set\r\n
\t-h\tPrint this message\r\n
\t-d\tturn on diagnostics for this script\r\n
\t-p\t<printer>\tName of the printer (default MX920LAN)\r\n
\t-c\t<command>\tCommand for printer (lp|lpr) (lpr is default)\r\n"

optionargs="hdp:c:"
NUMARGS=1
debug=0
PRINTER="MX920LAN"
COMMAND="lpr"

while getopts ${optionargs} name
do
	case ${name} in
	h) 
#		errecho "-e" ${LINENO} ${USAGE}
		echo -e ${USAGE}
		exit 0
		;;
	d) 
		debug=1
		;;
  p)
    PRINTER=${OPTARG}
    ;;
  c)
    COMMAND=${OPTARG}
    ;;
	\?)
		errecho "-e" ${LINENO} "invalid option: -$OPTARG"
		errecho "-e" ${LINENO} ${USAGE}
		exit 0
		;;
	esac
done
LPROPTIONS="-o outputorder=reverse -o sides=two-sided-long-edge -P ${PRINTER}"

if [ $# -lt ${NUMARGS} ]
then
	errecho ${LINENO} "Insufficient Parameters: ${NUMARGS} required, $# supplied"
	errecho "-e" ${LINENO} ${USAGE}
	exit -2
fi

##########
formfeed="-f"
numberlines="-n"
twotabs="-e2"
if [ "${COMMAND}" = "lpr" ]
then
  COMMAND="${COMMAND} ${LPROPTIONS}"
fi
while [ $# -gt 0 ]
	do
    filename=${@:$OPTIND:1}
		/usr/bin/pr ${formfeed} ${numberlines} ${twotabs} ${filename} | ${COMMAND}
		shift
	done
exit 0
