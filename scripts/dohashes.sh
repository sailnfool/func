#!/bin/bash
########################################################################
# Author: Robert E. Novak
# email: sailnfool@gmail.com
########################################################################
#
# Histogram
#
# From the root directory passed as a parameter,
# generate a histogram of the files and subdirectories of that tree.
#
# Bin the files in the drectories into bins based on power of 2 file
# sizes
#
# Based on the script below, BUT!!!!
# https://superuser.com/questions/565443/generate-distribution-of-file-sizes-from-the-command-prompt
#
# the awk command had integer overflow in computing 2^30, 2^31, 2^32, etc.
# Had to use bc command to get proper computations done
########################################################################
# There is still a potential bug of having 'awk' overflow if the number
# of files in a single bin exceeds 2^30.  To make this more efficient,
# The bins should be BASH associative arrays that the bin index is
# simply an arbitrary string of digits as is the value of the bin
# count.  This will involve using bc to increment the bin count. Need
# to verify the size of the BASH number that can handle ((num++)).  If
# it is 2^64, then we can speedup using BASH alone.
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.1 | REN |05/11/2022| Improved initial checking parameters
#                      | Added commentary outline for efficiently
#                      | Improving the count calculation and bypassing
#                      | using awk and bc to avoid overflow and for
#                      | improving efficiency.
# 1.0 | REN |03/26/2020| Initial Release
#_____________________________________________________________________
#
source func.debug
source func.errecho
source func.insufficient

USAGE="\r\n${0##*/} [-[hv]] [-d #] <dir> [<dir> ...]\r\n
\t\tSummarize the count of the number of files in this tree sorted by\r\n
\t\tthe size of the files.  This application is single threaded and\r\n
\t\tused the 'find' command.  The output is saved in the /tmp\r\n
\t\tdirectory.\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tProvide verbose help\r\n
\t-d\t#\tEnable diagnostics\r\n
\t-s\t#\tspecify the length of the short hash used.
"
VERBOSE="Outputs the file bin sizes in human readable form:\r\n
B = Bytes\r\n
K = Kilobytes\t(kiB = 1024)\r\n
M = Megabytes\t(MiB)\r\n
G = Gigabytes\t(GiB)\r\n
T = Terabytes\t(TiB)\r\n
E = Exabytes\t(EiB)\r\n
P = Petabytes\t(PiB)\r\n
Y = Yettabytes\t(YiB)\r\n
Z = Zettabytes\t(ZiB)\r\n
"
NUMARGS=1
TMPFILE=/tmp/bins.$$
shortlen=4
optionargs="hvd:s:"
if [ $# -lt "${NUMARGS}" ]
then
	errecho "No directory specified"
  exit -1
fi

while getopts ${optionargs} name
do
  case ${name} in
  h)
    errecho -e ${USAGE}
    exit 0
    ;;
  v)
    errecho -e ${USAGE}
    errecho -e ${VERBOSE}
    exit 0
    ;;
  d)
    FUNC_DEBUG=${OPTARG}
    export FUNC_DEBUG
    ;;
  s)
    shortlen="${OPTARG}"
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

########################################################################
# Run through the remaining parameters and make sure they are all
# directories.  Quit if they are not.
########################################################################
for rootdir in $*
do
  if [[ ! -d ${rootdir} ]]
  then
    errecho "Not a directory: ${rootdir}"
    errecho -e ${USAGE}
    exit -1
  fi
done
suffixes="BKMGTEPYZ"
declare -A countshort
for rootdir in $*
do
  if [ ! -d ${rootdir} ]
  then
    errecho "Not a directory: ${rootdir}"
    exit -1
  fi
  basedirname=${rootdir##*/}
  countprefix=/tmp/file.hashes.$$
  countprefix2=/tmp/file.hashes2.$$
  countname=${countprefix}.${basedirname}.txt
  echo "*** Start ***" > ${countname}
  echo "*** Path = $(realpath ${rootdir})" >> ${countname}
  echo "**** Dir = ${basedirname}" >> ${countname}
  echo "***** Size $(du -s -h ${rootdir} 2> /dev/null )" >> ${countname}
  cd ${rootdir}
  OLDIFS=$IFS
  IFS=" "

  rm -f ${countprefix} ${countprefix2}
  ####################
  # Potential bug here.  Awk on many machines only supports 32-bit
  # integers.  If the size[n] for any bucket overflows that count
  # then this will silently provide erroneous results.  It should
  # probably be redone with bc
  ####################
  find . -type f -print 2> /dev/null                                    \
 | parallel b2sum -a blake2bp {} 2> /dev/null >> ${countprefix}.txt
  while read -r full
  do
     short=${full:0:${shortlen}}
#     long=${full:0:128}
#     filname=${full:128}
    if [[ ${countshort[$short}]+_} ]]
    then
      ((countshort[${short}]++))
    else
      countshort+=([${short}]=1)
    fi
  done < ${countprefix}.txt
#     if [[ ${countshort[${short}]+_} ]]
#     then
#       ((countshort[${short}]++))
#     else
#       countshort+=([${short}]=1)
#     fi
#   done < ${countprefix}
  for i in ${!countshort[@]}
  do
    if [[ "${countshort[${i}]}" -gt 1 ]]
    then
      echo "found ${i}"
      grep ${i} ${countprefix}.txt
    fi
  done
done
