#!/bin/bash
########################################################################
# Author: Robert E. Novak
# email: sailnfool@gmail.com
########################################################################
#
# countfiles - Count the number of files underneath the directory
# passed as a parameter.
#
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |05/16/2022| Initial Release
#_____________________________________________________________________
#
source func.debug
source func.errecho
source func.insufficient

NUMARGS=1

USAGE="\r\n${0##*/} [-h] <dir>\r\n
\t\tSummarize the count of the number of files in this tree\r\n
\t-h\t\tPrint this message\r\n
"
optionargs="h"
while getopts ${optionargs} name
do
  case ${name} in
  h)
    errecho -e ${USAGE}
    exit 0
    ;;
  \?)
    errecho "-e" "invalid option: -${OPTARG}"
    errecho "-e" ${USAGE}
    exit 1
    ;;
  esac
done
shift $((OPTIND-1))

if [ $# -lt ${NUMARGS} ]
then
	errecho "-e" ${USAGE}
	insufficient ${NUMARGS} $@
  errecho -e ${USAGE}
	exit -2
fi
dirname="$1"
filecount=$(find ${dirname} -type f -print | wc -l)
echo ${filecount}
