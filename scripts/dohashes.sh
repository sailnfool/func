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
# 1.2 | REN |05/16/2022| Added parameter override for the cryptographic
#                      | program to be executed.  Also created a
#                      | directory tree for all of the hash names of
#                      | both the files and the directories.
#                      | TBD: Break the files into chunks and compute
#                      | the hashes for the chunks to add them to the
#                      | dirtree to get a feel for the size of the
#                      | hashspace.
#                      | added -t to make the dirtree somewhere other
#                      | then /tmp
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

########################################################################
# The following are hard coded for now.  Ideally they should be looked
# up in a global table.
########################################################################
cryptohashnum="1"
cryptohash="b2sum -a blake2bp"
cryptohashhexlen="128"
dirtree="/${HOME}/github/func/etc/dirtree"
NUMARGS=1
TMPFILE=/tmp/bins.$$
shortlen=4

USAGE="\r\n${0##*/} [-[hv]] [-d #] <dir> [<dir> ...]\r\n
\t\tSummarize the count of the number of files in this tree sorted by\r\n
\t\tthe size of the files.  This application is single threaded and\r\n
\t\tused the 'find' command.  The output is saved in the /tmp\r\n
\t\tdirectory.\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tProvide verbose help\r\n
\t-c\t<crypto>\tUse <crypto> instead of ${cryptohash} for computing\r\n
\t\t\tthe hash of the file and of the filename/path\r\n
\t-d\t#\tEnable diagnostics\r\n
\t-s\t#\tspecify the length of the short hash used.\r\n
\t-t\t<dir>\tSpecify the name of the hash directory tree \r\n
\t\t\tdefault: ${dirtree}\r\n
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
optionargs="hvc:d:s:t:"
if [[ $# -lt "${NUMARGS}" ]]
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
  c)
    cryptohash="${OPTARG}"
    ;;
  d)
    FUNC_DEBUG="${OPTARG}"
    export FUNC_DEBUG
    ;;
  s)
    if [[ "${OPTARG}" =~ $re_integer ]]
    then
      errecho -e "-s ${OPTARG}\tis not an integer"
      errecho -e ${USAGE}
      exit 2
    fi
    shortlen="${OPTARG}"
    ;;
  t)
    if [[ ! -d "${OPTARG}" ]]
    then
      errecho -e "-t ${OPTARG}\tis not a directory"
      errecho -e ${USAGE}
      exit 3
    fi
    dirtree="${OPTARG}"
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

########################################################################
# Now that we have a list of directories, run through the list.  Find
# all of the files and compute both the hash of the file and the name
# of the file.
########################################################################
for rootdir in $*
do

  ######################################################################
  # skip over any special root file system directories
  ######################################################################
  case $(realpath ${rootdir}) in
    /proc)
      continue
      ;;
    /lost+found)
      continue
      ;;
    /swap)
      continue
      ;;
    /dev)
      continue
      ;;
    esac

  ######################################################################
  # The following is dead code since the directory check above made
  # this redundant
  ######################################################################
#   if [ ! -d ${rootdir} ]
#   then
#     errecho "Not a directory: ${rootdir}"
#     exit -1
#   fi

  basedirname=${rootdir##*/}
  nodotbasedirname=$(echo ${basedirname} | tr "." "_")
  countprefix=/tmp/file.hashes.$$
  countprefix2=/tmp/file.hashes2.$$
  countname=${countprefix}.${nodotbasedirname}.txt

  ######################################################################
  # This code is not part of the main path.  May need to resurrect it
  # later.
  ######################################################################
#   echo "*** Start ***" > ${countname}
#   echo "*** Path = $(realpath ${rootdir})" >> ${countname}
#   echo "**** Dir = ${basedirname}" >> ${countname}
#   echo "***** Size $(du -s -h ${rootdir} 2> /dev/null )" >> ${countname}

  rm -f ${countprefix} ${countprefix2} ${countname}

  ######################################################################
  # search through the rootdir tree.  Compute the hash of each file
  # found by "find" and save those hashes & filenames in countname.txt
  ######################################################################
  cd ${rootdir}
  OLDIFS=$IFS
  IFS=" "
  find . -type f -print 2> /dev/null                                    \
 | parallel ${cryptohash} {} 2> /dev/null >> ${countname}

  ######################################################################
  # For each of the hashcodes that we created, take the short prefix
  # and create a directory of the short prefix and touch a zero length
  # placeholder for the filename manifest.  Then compute the hash
  # of the filename and create the entries for that as well.
  ######################################################################
  while read -r full
  do
     short=${full:0:${shortlen}}
     long=${full:0:${cryptohashhexlen}}
     filename=${full:${cryptohashhexlen}}
     filenamefull="$(echo "${filename}" | ${cryptohash} 2>/dev/null)"
     shortfilename=${filenamefull:0:${shortlen}}
     filenamelong=${filenamefull:0:${cryptohashhexlen}}
     filenamefullname=${filenamefull:${cryptohashhexlen}}
     mkdir -p ${dirtree}/${short} ${dirtree}/${shortfilename}
     touch ${dirtree}/${short}/${cryptohashnum}:${long}
#     echo "${dirtree}/${shortfilename}/${cryptohashnum}:${filenamelong}"
     echo "${filename}" > ${dirtree}/${shortfilename}/${cryptohashnum}:${filenamelong}
  done < ${countname}
done
