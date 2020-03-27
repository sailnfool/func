#!/bin/bash
#
# Histogram
# 
# From the root directory passed as a parameter,
# generate a histogram of the files and subdirectories of that tree.
#
# Bin the files in the drectories into two types of bins:
#
# DONE: File size by powers of 2
# Based on the script below, BUT!!!!
# https://superuser.com/questions/565443/generate-distribution-of-file-sizes-from-the-command-prompt
# 
# the awk command had integer overflow in computing 2^30, 2^31, 2^32
#
# File types as reported by file command.
#
# File ownership
#
# Group ownership

if [ $# -eq 0 ]
then
  echo ${0##*/} ${LINENO} "No directory specified"
  exit -1
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
  countname=/tmp/file.histogram.${basedirname}.$$.txt
  echo "*** Start ***" > ${countname}
  echo "*** Path = $(realpath ${rootdir})" >> ${countname}
  echo "**** Dir = ${basedirname}" >> ${countname}
  echo "***** Size $(du -s -h ${rootdir})" >> ${countname}
  cd ${rootdir}
  OLDIFS=$IFS;                                                           \
  IFS=" ";                                    
  /usr/bin/time find . -type f -print0                                   \
 | xargs -0 ls -l                                                        \
 | awk '{ n=int(log($5)/log(2));                                         \
          size[n]++ }                                                    \
      END { for (i in size) printf("%d %d\n", i, size[i]) }'             \
 | sort -n                                                               \
  while read -r power count
  do
    index=$(echo "a=(l(2^${power})/l(1024));scale=0;a/1"|bc -l)
    suffix=${suffixes:${index}:1}
    prefix=$(echo "a=2^${power}/1024^${index};scale=0;a/1"|bc -l)
    filesize=$(echo "scale=0;2^${power}"|bc -l)
    human=$(printf "%d%s" ${prefix} ${suffix})
    echo $(printf "%*s: %s %d" 6 ${human} 15 ${filesize} ${count})
  done
done
