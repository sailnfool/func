#!/bin/bash
b2hash=$(b2sum $1)
hashonly=$(echo ${b2hash} | cut -d ' ' -f 1)
dirname=$(echo ${b2hash}|sed 's/^\(..\).*/\1/')
hashdir=/hashes/$dirname
if [ ! -d /hashes ]
then
	sudo mkdir -p /hashes
	chmod 777 /hashes
fi
if [ ! -d ${hashdir} ]
then
	mkdir -p ${hashdir}
	chmod 777 ${hashdir}
fi
echo $1 >> ${hashdir}/${hashonly}
