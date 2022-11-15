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
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.1 | REN |03/17/2021| Changed default printer name
# 1.0 | REN |06/18/2019| Initial Release
#_____________________________________________________________________
#
##########
source func.errecho


USAGE="\r\n${0##*/} [-[hd]] <file> ...\r\n
\t\tprint file(s) with proper options set\r\n
\t-h\tPrint this message\r\n
\t-c\tturn on color syntax highlighting\r\n
\t-d\tturn on diagnostics for this script\r\n
\t-e\tuse enscript\r\n
\t-p\t<printer>\tName of the printer (default Canon_MX920_series)\r\n
\t-l\t<command>\tCommand for printer (lp|lpr) (lpr is default)\r\n
"

optionargs="hcdel:p:"
NUMARGS=1
debug=0
colorize=0
PRINTER="Canon_MX920_series"
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
	e)
		use_enscript=1
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
		errecho ${FUNCNAME} ${LINENO} "-e" "invalid option: -$OPTARG"
		errecho ${FUNCNAME} ${LINENO} "-e" ${USAGE}
		exit 0
		;;
	esac

	errecho ${FUNCNAME} ${LINENO} "OPTIND=${OPTIND}"
	errecho ${FUNCNAME} ${LINENO} "OPTIND=${@:$OPTIND:1}"
	errecho ${FUNCNAME} ${LINENO} "shift=$((${OPTIND} - 1 ))"
done

errecho ${FUNCNAME} ${LINENO} "\$#=$#"
errecho ${FUNCNAME} ${LINENO} "OPTIND=${@:$OPTIND:1}"
errecho ${FUNCNAME} ${LINENO} "OPTIND=${OPTIND}"
# shift "$((${OPTIND} - 1 ))"
LPROPTIONS="-o outputorder=reverse -o sides=two-sided-long-edge"
LPROPTIONS="${LPROPTIONS} -o media=letter -P ${PRINTER}"

if [ $# -lt ${NUMARGS} ]
then
	errecho ${FUNCNAME} ${LINENO} "Insufficient Parameters: ${NUMARGS} required, $# supplied"
	errecho ${FUNCNAME} ${LINENO} "\$@=$@"
	errecho ${FUNCNAME} ${LINENO} "\$#=$#"
	errecho ${FUNCNAME} ${LINENO} "OPTIND=${OPTIND}"
	errecho ${FUNCNAME} ${LINENO} "-e" ${USAGE}
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
	errecho ${FUNCNAME} ${LINENO} "filename=${filename}, pwd=$(pwd)"

	if [ -z "${filename}" ]
	then
		shift
		continue
	fi
	if [ "${colorize}" = "1" ]
	then
		set -x
		TERM=xterm-256color vim -me -c ":syntax=on" \
			-c "set t_Co=256" \
			-c "set printoptions=number:y,left:5pc,paper:letter" \
			-c "set printfont=:h9" \
			-c "set pdef=${PRINTER}" \
			-c ":hardcopy" -c ":q" ${filename}
		set +x
	else
		errecho ${FUNCNAME} ${LINENO} "/usr/bin/pr ${formfeed} ${numberlines} ${twotabs} \
		    ${filename} | ${COMMAND}"
		/usr/bin/pr ${formfeed} ${numberlines} ${twotabs} \
		    ${filename} | ${COMMAND}
	fi
	shift
done
exit 0
