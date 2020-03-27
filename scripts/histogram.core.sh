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

for rootdir in $*
do
  if [ ! -d ${rootdir} ]
  then
    echo ${0##*/} ${LINENO} "Not a directory: ${rootdir}"
    exit -1
  fi
  cd ${rootdir}
  find . -type f -print0                                                 \
 | xargs -0 ls -l                                                        \
 | awk '{ n=int(log($5)/log(2));                                         \
          if (n<10) n=10;                                                \
          size[n]++ }                                                    \
      END { for (i in size) printf("%d %d\n", 2^i, size[i]) }'           \
 | sort -n                                                               \
 | awk 'function human(x) { x[1]/=1024;                                  \
                            if (x[1]>=1024) { x[2]++;                    \
                                              human(x) } }               \
        { a[1]=$1;                                                       \
          a[2]=0;                                                        \
          human(a);                                                      \
          printf("%3d%s: %6d\n", a[1],substr("kMGTEPYZ",a[2]+1,1),$2) }' 
#  find . -type f -print0 | \
#  xargs -0 ls -l | \
#  awk '{size[int(log($5)/log(2))]++}END{for (i in size) printf("%10d %3d\n", 2^i, size[i])}' | \
#  sort -n
done
