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


USAGE="\n${0##*/} [-[hd]] <file> ...\n
\t\tprint file(s) with proper options set\n
\t-h\tPrint this message\n
\t-c\tturn on color syntax highlighting\n
\t-d\tturn on diagnostics for this script\n
\t-p\t<printer>\tName of the printer (default MX920LAN)\n
\t-l\t<command>\tCommand for printer (lp|lpr) (lpr is default)\n
"

optionargs="hc:dlp:"
NUMARGS=1
debug=0
colorize=0
PRINTER="MX920LAN"
COMMAND="lpr"

while getopts ${optionargs} name
do
	case ${name} in
	h)
#		errecho "-e" ${USAGE}
		echo -e ${USAGE}
		exit 0
		;;
	d)
		debug=1
		;;
	p)
		PRINTER=${OPTARG}
		;;
	l)
		COMMAND=${OPTARG}
		;;
	c)
		colorize=1
		;;
	\?)
		errecho "-e" "invalid option: -$OPTARG"
		errecho "-e" ${USAGE}
		exit 0
		;;
	esac
done
LPROPTIONS="-o outputorder=reverse -o sides=two-sided-long-edge -P ${PRINTER}"

if [ $# -lt ${NUMARGS} ]
then
	errecho "Insufficient Parameters: ${NUMARGS} required, $# supplied"
	errecho "-e" ${USAGE}
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
	if [ "${colorize}" = "1" ]
	then
		set -x
		TERM=xterm-256color vim -me -c ":syntax=on" \
			-c "set t_Co=256" \
			-c "set printoptions=numer:y,left:5pc" \
			-c "set printfont=:h9" \
			-c ":hardcopy" -c ":q" ${filename}
		set +x
	else
		/usr/bin/pr ${formfeed} ${numberlines} ${twotabs} ${filename} | ${COMMAND}
	fi
	shift
done
exit 0
