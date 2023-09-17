#!/bin/bash
# Input is starting number of files to index
if [[ $# -eq 0 ]] ; then
	baseline=425000
else
	if [[ "${1}" =~ ${re_integer} ]] ; then
		baseline=${1}
	else
		echo "${0##*/} Invalid count ${1} not an integer" >2
		exit 1
	fi
fi
echo $latest
prefixstring="Syncing "
suffixstring=" "
while [[ 1 -gt 0 ]]
do
	indexing=$(dropbox status 2>/dev/null | grep "Syncing")
	noprefix=${indexing:${#prefixstring}}
	# echo "noprefix=${noprefix}"
	nosuffix=${noprefix%%${suffixstring}*}
	# echo "nosuffix=${nosuffix}"
	currentcount=$(echo ${nosuffix} | tr -d ",")
	# echo "currentcount=${currentcount}"
	count=$(echo "(80*((${currentcount}*100)/${baseline}))/100" | bc)
	echo -n "${count} ${currentcount} "
	for ((i=1; i<=count; i++)); do echo -n "*";done
	echo ""
	sleep 15
done
