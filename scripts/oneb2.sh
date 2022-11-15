#!/bin/bash
if [ $# -lt 1 ]
then
	echo $LINENO working on $1
	exit 0
fi
if [ -f /hashes/count ]
then
	HASHCNT=$(cat /hashes/count)
fi
re_hexnumber='^[0-9a-f][0-9a-f]$'
if [ -z "$1" ]
then
	echo $LINENO working on $1
	exit 0
fi
if [ $(file $1|grep "empty">/dev/null) ]
then
	echo $LINENO working on $1
	echo "File is empty?"
	echo "file $1 = $(file $1)"
	exit 0
fi
# echo $LINENO working on $1
b2hash=$(b2sum "$1" 2>/dev/null)
# echo "$LINENO b2hash=${b2hash}"
hashonly=$(echo ${b2hash} | cut -d ' ' -f 1)
# echo "$LINENO hashonly=${hashonly}"
directoryname=$(echo ${hashonly}|sed 's/^\(..\).*/\1/')
# echo "$LINENO directoryname=${directoryname}"
if [ -z "${directoryname}" ]
then
	echo $LINENO working on $1
	echo "$LINENO Empty directoryname=${directoryname}"
	echo "$LINENO b2hash=${b2hash}"
	echo "$LINENO hashonly=${hashonly}"
	echo "HASHCNT=${HASHCNT}"
	exit 0
fi
if [[ ! ${directoryname} =~ ${re_hexnumber} ]]
then
	echo $LINENO working on $1
	echo directoryname is not a hex number
	echo hashonly=${hashonly}
	echo directoryname=${directoryname}
	echo "HASHCNT=${HASHCNT}"
	exit 0
fi
hashdir=/hashes/$directoryname
if [ ! -d /hashes ]
then
	echo $LINENO "Creating /hashes"
	echo "HASHCNT=${HASHCNT}"
	sudo mkdir -p /hashes
	chmod 777 /hashes
fi
if [ ! -d ${hashdir} ]
then
	echo $LINENO "Creating ${hashdir}"
	echo hashonly=${hashonly}
	echo directoryname=${directoryname}
	echo "HASHCNT=${HASHCNT}"
	mkdir -p ${hashdir}
	chmod 777 ${hashdir}
fi
echo $1 >> ${hashdir}/${hashonly}
if [ ! -f /hashes/count ]
then
	echo 1 > /hashes/count
else
	HASHCNT=$(cat /hashes/count)
	((HASHCNT++))
	echo ${HASHCNT} > /hashes/count
fi
if [ $(expr ${HASHCNT} % 1000) -eq 0 ]
then
	echo -n '.'
fi
if [ $(expr ${HASHCNT} % 70000) -eq 0 ]
then
	echo ""
	echo ${HASHCNT}
fi
