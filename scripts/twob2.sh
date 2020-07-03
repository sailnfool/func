#!/bin/bash
HASHES=/hashes
HASHCNT=0
TMPDIR=/tmp/hashes.$$.dir
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
find "$1" -type d -name hashes -prune \
	-o -type d -print  > ${DIRLIST}
# ls -l ${DIRLIST}
# wc -l ${DIRLIST}
# split -C 2048 ${DIRLIST} ${TMPDIR}/dirfile
# ls -l ${TMPDIR}/dirfile*
# wc -l ${TMPDIR}/dirfile*

while read dirname
do
	find "$dirname" -maxdepth 1 -type f  > ${TMPDIR}/thislist
	# ls -l ${TMPDIR}/thislist
	# echo "Number of Files in ${dirname} is $(wc -l ${TMPDIR}/thislist)"
	while read filename
	do
		if [ ! -f "${filename}" ]
		then
			echo "filename=${filename} is not a file"
			exit 0
		fi
		((HASHCNT++))
		b2hash=$(b2sum "${filename}" 2>/dev/null)
		# echo "b2hash of ${filename}=${b2hash}"
		hashonly=$(echo ${b2hash} | cut -d ' ' -f 1)
		directoryname=$(echo ${hashonly}|sed 's/^\(..\).*/\1/')
		if [[ ! ${directoryname} =~ ${re_hexnumber} ]]
		then
			echo $LINENO working on "${filename}"
			echo b2hash=${b2hash}
			echo directoryname is not a hex number
			echo hashonly=${hashonly}
			echo directoryname=${directoryname}
			echo "HASHCNT=${HASHCNT}"
			exit 0
		fi
		hashdir=${HASHES}/${directoryname}
		if [ ! -d ${hashdir} ]
		then
			echo $LINENO "Creating ${hashdir}"
			# echo hashonly=${hashonly}
			# echo directoryname=${directoryname}
			echo "HASHCNT=${HASHCNT}"
			mkdir -p ${hashdir}
			chmod 777 ${hashdir}
		fi
		echo ${filename} >> ${hashdir}/${hashonly}
		if [ $(expr ${HASHCNT} % 100) -eq 0 ]
		then
			echo -n '.'
		fi
		if [ $(expr ${HASHCNT} % 7000) -eq 0 ]
		then
			echo ""
			echo "$(date '+%T') ${HASHCNT}"
		fi
	done < ${TMPDIR}/thislist
done  < ${DIRLIST}
