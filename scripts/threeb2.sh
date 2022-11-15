#!/bin/bash
HASHES=/hashes
HASHCNT=0
TMPDIR=/tmp/${HASHES}.$$.dir
re_hexnumber='^[0-9a-f][0-9a-f]*$'
mkdir -p ${TMPDIR}
if [ ! -d ${HASHES} ]
then
	sudo mkdir -p ${HASHES}
	sudo chmod 777 ${HASHES}
fi
if [ $# -lt 1 ]
then
	echo $LINENO working on "$1"
	exit 0
fi
DIRLIST=${TMPDIR}/directories
if [ ! -d "$1" ]
then
	echo "Not a directory $1"
	exit 0
fi
find "$1" -type d -a \( -name hashes -o -name tmp \) -prune \
	-o -type d -print  > ${DIRLIST}
cat ${DIRLIST}
ls -l ${DIRLIST}
wc -l ${DIRLIST}
# split -C 2048 ${DIRLIST} ${TMPDIR}/dirfile
# ls -l ${TMPDIR}/dirfile*
# wc -l ${TMPDIR}/dirfile*
declare -A allhashes
echo $(date '+%T')
while read -r dirname
do
	#find "$dirname" -maxdepth 1 -type f  > ${TMPDIR}/thislist
	# ls -l ${TMPDIR}/thislist
	# echo "Number of Files in ${dirname} is $(wc -l ${TMPDIR}/thislist)"
	if [ ! -d "$dirname" ]
	then
		echo "${0##*/} $LINENO dirname=${dirname} is not a directory"
		exit -1
	fi
	b2sum "$dirname"/* 2> /dev/null >/${TMPDIR}/thislist
	# cat ${TMPDIR}/thislist
	while read -r hashline
	do
		if [ "${hashline:0:5}" == "Failed" ]
		then
			continue
		fi
		hashonly=${hashline:0:127}
		filename=${hashline:130}
		allhashes[$hashonly]="$filename"
		if [ ! -f "${filename}" ]
		then
			echo "filename=${filename} is not a file"
			exit 0
		fi
		((HASHCNT++))
		# b2hash=$(b2sum "${filename}" 2>/dev/null)
		# echo "b2hash of ${filename}=${b2hash}"
		# hashonly=$(echo ${b2hash} | cut -d ' ' -f 1)
		directoryname=${hashonly:0:2}
		subdirectoryname=${hashonly:2:2}
		hashdir=${HASHES}/${directoryname}/${subdirectoryname}
		mkdir -p ${hashdir}
		echo "${filename}" >> ${hashdir}/${hashonly}
		[ $(expr ${HASHCNT} % 100) -eq 0 ] && echo -n "."
		[ $(expr ${HASHCNT} % 7000) -eq 0 ] && { \
			echo ""; echo "$(date '+%T') ${HASHCNT}"
		}
	done < ${TMPDIR}/thislist
	wait
done  < ${DIRLIST}
for hashindex in "${!allhashes[@]}"
do
	directory=${hashindex:0:2}
	subdirectory=${hashindex:2:2}
	hashdir=/hashes/${directory}/${subdirectory}
	tmphashdir=/tmp/hashes/${directory}/${subdirectory}
	if [ ! -d ${hashdir} ]
	then
		echo Creating ${hashdir}
		sudo mkdir -p ${hashdir}
	fi
	echo ${allhashes[$hashindex]} >> ${tmphashdir}/$hashindex
	if [ ! cmp ${hashdir}/${hashindex} ${tmphashdir}/${hashindex} ]
	then
		echo "*!*!*!*!* FAILURE *!*!*!*!*"
		diff ${hashdir}/${hashindex} ${tmphashdir}/${hashindex}
		echo ${hashindex}
		exit -1
	fi
done
