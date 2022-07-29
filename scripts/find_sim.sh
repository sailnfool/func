#!/bin/bash
scriptname=${0##*/}
########################################################################
# Copyright (c) 2019 Sea2Cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# find_sim - find files which are similar to a given file within
#            the specified directory tier
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|05/05/2022| Initial Release
#_____________________________________________________________________
########################################################################
source func.debug
source func.errecho
source func.insufficient

USAGE="\r\n${scriptname} [-[hv] [ -d <#> ] [ [-i <ignoredir> ] ... ]
<filename> <dirname>\r\n
\t\treturn a list of files in <dirname> which have the same hash as\r\n
\t\t<filename> (A better similarity test is needed)\r\n
\r\n
\t-d\t<#>\tSet the diagnostic levels\r\n
\t\t\tUse -v to see diagnostic level help\r\n
\t-h\tPrint this message\r\n
\t-i\t<ignoredir>\tignore everything under <ignoredir>\r\n
\t\tE.G.:\r\n
\t\t${scriptname} -i .ignore .\r\n
\t\t\twill ignore any directories named '.ignore'\r\n
\t\t\tand the files in the directory '.ignore'\r\n
\t\t${scriptname} -i .ignore -i .archive .\r\n
\t\t\twill ignore any directories named '.ignore' or '.archive'\r\n
\t\t\tand the files in the directories '.ignore' or '.archive'\r\n
\t\t\tBy default any directories named .archive .Archive or \r\n
\t\t\tArchive are ignored\r\n
\t-v\tShow diagnostic levels, must precede -h\r\n
"

optionargs="hd:i:v"
NUMARGS=2
FUNC_DEBUG="0"
export FUNC_DEBUG
nodirs="-not -type d -a"
ignoredir=""
declare -a ignorelist
ignorelist=(".archive")
verbose="FALSE"

while getopts ${optionargs} name
do
	case ${name} in
	d)
		FUNC_DEBUG=${OPTARG}
		export FUNC_DEBUG
		if [ $FUNC_DEBUG -ge 9 ]
		then
			set -x
		fi
		;;
	h)
		echo -e ${USAGE}
    if [[ "${verbose}" = "TRUE" ]]
    then
      echo -e ${DEBUG_USAGE}
    fi
		exit 0
		;;
	i)
    ignorelist+=("${OPTARG}")
		;;
  v)
    verbose="TRUE"
    ;;
	\?)
		errecho "-e" "invalid option: -${name}"
		errecho "-e" ${USAGE}
		exit 1
		;;
	esac
done

shift "$((${OPTIND}-1))"

if [[ $# -lt ${NUMARGS} ]]
then
	errecho "-e" ${USAGE}
	insufficient "Expected ${NUMARGS}, got $#, $@"
	exit -2
fi
dirname="${@:$OPTIND:1}"

if [[ $# -ge 1 ]]
then
  filename="$1"
  shift
fi

if [[ $# -ge 1 ]]
then
  dirname="$1"
  shift
  if [[ ! -d ${dirname} ]]
  then
    errecho "${dirname} is not a directory"
    errecho "-e" ${USAGE}
    exit -2
  fi
fi

fileprefix=/tmp/${USER}.$$
rawlist=${fileprefix}.list
timesort=${fileprefix}.time
hashlist=${fileprefix}.hashlist
shortlist=${fileprefix}.shortlist
shorthash=${fileprefix}.shorthash
find ${dirname} -type f -a -name ${filename} -print \
  2> /dev/null > ${rawlist}
ls -t $(cat "${rawlist}") > ${timesort}
for filename in $(cat ${timesort})
do
	filehash=$(getb2sum $filename)
#	echo "${filehash} ${filename}" >> ${hashlist}
	echo "${filehash:0:4} ${filename}"
#	echo "${filehash:0:4}" >> ${shorthash}
done
#sort ${hashlist}
#sort ${shortlist}
# sort -u ${shorthash}
# for hashes in $(cat ${shorthash})
# do
# 	grep ${hashes} ${shortlist}
# done
#more ${fileprefix}*
rm -f ${fileprefix}.*
