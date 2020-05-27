#!/bin/bash
####################
# onefilehash - compute the hash for one file and store it in
#     the HASHDIR of the current directory.  First check to
#     see if we already computed the hash and that the file
#     has not been updated since the hash was computed.  If
#     the file has not changed use the saved hash and
#     echo ":" else compute the hash and echo "." to show
#     progress.
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 2.0 | REN |11/14/2019| added vim directive and header file
# 1.0 | REN |09/06/2018| original version
#_____________________________________________________________________
#
####################
if [ -z "${__funconefilehash}" ]
then
	export __funconefilehash=1
  source func.errecho
	function onefilehash () {
		digestfile="$1"
		hashdir="$2"
		if [ $# -lt 2 ]
		then
			errecho "Insufficient parameters $#, need 2"
		fi
		if [ -z ${digestfile} ]
		then
			errecho "First parameter is null"
		fi
		if [ -z ${hashdir} ]
		then
			errecho "Second parameter is null"
		fi
	#	stderrecho "How did we get here"
	#	####################
	#	For each file, we check to see if there is already a HASH
	#	directory that stores the hashes for each of the files.
	#	If there is not we will create it.
	#	This test should be moved so that it is done once
	#	for each directory.
	#	####################
		SAVEIFS=$IFS
		IFS=$(echo -en "\n\b")

		if [ ! -d ${hashdir} ]
		then
			mkdir ${hashdir}
			cat > ${hashdir}/README${hashdir}.txt <<EOF_EOF
# This directory contains the hashcodes of the files
# contained in the parent directory.  The directory
# name, ".hash_xxxxx" represents this and xxxxx is
# the name of the hash algorithm used to create this
# hash, e.g. blake2b, SHA1, SHA512, etc.
#
# These hash codes are used to deduplicate files on
# the same volume by linking together directory
# entries that point to the same underlying content
# The scripts that create these codes and generate
# the code for linking are found in /usr/var/s2c/bin
# They are part of the Sea2Cloud package
EOF_EOF
		fi

		#	####################
		#	Now we see if there is a directory entry for this digest
		#	file in the hash directory.  If there is and it is newer
		#	than the file, we use the pre-computed value of the hash
		#	for this file.  If there is not, we compute the hash and
		#	we store the hash in the hash directory under the same
		#	filename.  As a result, we can never process the hash
		#	directories in this way.
		#	####################
		#	stderrecho "How did we get here"

		if [ -r "${hashdir}/${digestfile}" ]
		then
			if [ "${digestfile}" -ot "${hashdir}/${digestfile}" ]
			then
				stderrnecho ":"
				hexhash=$(cat "${hashdir}/${digestfile}")
			else
				stderrnecho "."
				hexhash=$(b2sum "${digestfile}" | sed -e "s/ .*//")
				echo "${hexhash}" > "${hashdir}/${digestfile}"
			fi
		else
			stderrnecho "."
			hexhash=$(b2sum "${digestfile}" | sed -e "s/ .*//")
			echo "${hexhash}" > "${hashdir}/${digestfile}"
		fi
		IFS=${SAVEIFS}
	##########
	# End of function onefilehash
	##########
	}
	export -f onefilehash
fi # if [ -z "${__funconefilehash}" ]
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78
