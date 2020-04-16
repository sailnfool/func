#!/bin/bash
###########################################################################
# Author: Robert E. Novak
# email: novak5@llnl.gov, sailnfool@gmail.com
###########################################################################
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
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |03/26/2020| Initial Release
#_____________________________________________________________________
#
source func.debug
source func.errecho
source func.insufficient

USAGE="\r\n${0##*/} [-[hv]] [-d #] <dir> ...\r\n
\t\tSummarize the count of the number of files in this tree sorted by\r\n
\t\tthe size of the files.  This application is single threaded and\r\n
\t\tused the 'find' command.  The output is saved in the /tmp\r\n
\t\tdirectory.\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tProvide verbose help\r\n
\t-d\t#\tEnable diagnostics\r\n
"
VERBOSE="Outputs the file bin sizes in human readable form:\r\n
b = bytes\r\n
k = kilobytes\t(kiB = 1024)\r\n
M = Megabytes\t(MiB)\r\n
G = Gigabytes\t(GiB)\r\n
T = Terabytes\t(TiB)\r\n
E = Exabytes\t(EiB)\r\n
P = Petabytes\t(PiB)\r\n
Y = Yettabytes\t(YiB)\r\n
Z = Zettabytes\t(ZiB)\r\n
"
optionargs="hvd:"
NUMARGS=1
if [ $# -lt "${NUMARGS}" ]
then
  echo ${0##*/} ${LINENO} "No directory specified"
  exit -1
fi

while getopts ${optionargs} name
do
  case ${name} in
  h)
    echo -e ${USAGE}
    exit 0
    ;;
  v)
    echo -e ${USAGE}
    echo -e ${VERBOSE}
    exit 0
    ;;
  d)
    FUNC_DEBUG=${OPTARG}
    export FUNC_DEBUG
    ;;
  \?)
    errecho "-e" ${0##*/} ${LINENO} "invalid option: -${OPTARG}"
    errecho "-e" ${0##*/} ${LINENO} ${USAGE}
    exit 1
    ;;
esac
done
if [ $# -lt ${NUMARGS} ]
then
	errecho "-e" ${0##*/} ${LINENO} ${USAGE}
  insufficient ${0##*/} ${LINENO} ${FUNCNAME} ${NUMARGS} $@
	exit -2
fi


suffixes="bkMGTEPYZ"
for rootdir in $*
do
  if [ ! -d ${rootdir} ]
  then
    echo ${0##*/} ${LINENO} "Not a directory: ${rootdir}"
    exit -1
  fi
  basedirname=${rootdir##*/}
  countprefix=/tmp/file.histogram
  countname=${countprefix}.${basedirname}.$$.txt
  echo "*** Start ***" > ${countname}
  echo "*** Path = $(realpath ${rootdir})" >> ${countname}
  echo "**** Dir = ${basedirname}" >> ${countname}
  echo "***** Size $(du -s -h ${rootdir} 2> /dev/null )" >> ${countname}
  cd ${rootdir}
  OLDIFS=$IFS
  IFS=" "

  ####################
  # Potential bug here.  Awk on many machines only supports 32-bit
  # integers.  If the size[n] for any bucket overflows that count
  # then this will silently provide erroneous results.  It should
  # probably be redone with bc
  ####################
  find . -type f -print0 2> /dev/null                                    \
 | xargs -0 ls -l 2> /dev/null                                           \
 | awk '{ n=int(log($5)/log(2));                                         \
          if (n<0) n=0;                                                  \
          size[n]++ }                                                    \
      END { for (i in size) printf("%d %d\n", i, size[i]) }'             \
 | sort -n                                                               \
 | {
   while read -r power count
   do
    # echo "power=${power}, count=${count}"
     index=$(echo "a=(l(2^${power})/l(1024));scale=0;a/1"|bc -l)
     suffix=${suffixes:${index}:1}
     prefix=$(echo "a=2^${power}/1024^${index};scale=0;a/1"|bc -l)
     filesize=$(echo "scale=0;2^${power}"|bc -l)
     human=$(printf "%d%s" ${prefix} ${suffix})
     $(echo printf "%*s:\t%*s\t%d\n" 6 ${human} 15 ${filesize} ${count}) >> ${countname}
   done 
}
done
more ${countprefix}.*.$$.txt
