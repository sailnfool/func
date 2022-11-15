#!/bin/bash
fileprefix=/tmp/${USER}.$$
rawlist=${fileprefix}.list
timesort=${fileprefix}.time
hashlist=${fileprefix}.hashlist
shortlist=${fileprefix}.shortlist
shorthash=${fileprefix}.shorthash
find / -type f -a -name $1 -print 2> /dev/null > ${rawlist}
ls -t $(cat $rawlist) > ${timesort}
for filename in $(cat ${timesort})
do
	filehash=$(getb2sum $filename)
#	echo "${filehash} ${filename}" >> ${hashlist}
	echo "${filehash:(-4)} ${filename}"
#	echo "${filehash:(-4)}" >> ${shorthash}
done
#sort ${hashlist}
#sort ${shortlist}
# sort -u ${shorthash}
# for hashes in $(cat ${shorthash})
# do
# 	grep ${hashes} ${shortlist}
# done
#more ${fileprefix}*
rm ${fileprefix}*
