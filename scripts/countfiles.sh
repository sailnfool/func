#!/bin/bash
scriptname=${0##*/}
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# countfiles - Count the number of files underneath the directory 
#              passed as a parameter.
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.1 |REN|07/18/2022| Added -d and -v command line options
# 1.0 |REN|05/16/2022| Initial Release
#_____________________________________________________________________
#
source func.debug
source func.errecho
source func.insufficient
source func.regex

NUMARGS=1
verbosemode="FALSE"
verboseflag=""
FUNC_DEBUG=${DEBUGOFF}

USAGE="\n${0##*/} [-hv] [-d <#>] <dir>\n
\t\tSummarize the count of the number of files in this tree\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see debug modes/levels\n
\t-h\t\tPrint this message\n
\t-v\t\tTurn on verbose mode\n
"
optionargs="d:hv"
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
		if [[ $FUNC_DEBUG -ge ${DEBUGSETX} ]]
		then
			set -x
		fi
		;;
  h)
    errecho -e ${USAGE}
    if [[ "${verbosemode}" == "TRUE" ]]
    then
      errecho -e ${DEBUG_USAGE}
    fi
    exit 0
    ;;
  v)
    verbosemode="TRUE"
    verboseflag="-v"
    ;;
  \?)
    errecho "-e" "invalid option: -${OPTARG}"
    errecho "-e" ${USAGE}
    exit 1
    ;;
  esac
done
shift $((OPTIND-1))

if [[ $# -lt ${NUMARGS} ]]
then
	insufficient ${NUMARGS} $@
	errecho "-e" ${USAGE}
	exit 2
fi
if [[ ! -d "$1" ]]
then
  errecho "First parameter must be a directory"
  exit 3
fi
dirname="$1"
filecount=$(find ${dirname} -type f -print 2>& /dev/null | wc -l)
echo ${filecount}
