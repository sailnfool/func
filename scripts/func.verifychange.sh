#! /bin/bash
####################################################################
# Copyright (C) 2019 Sea2Cloud Storage, Inc.  All Rights Reserved
# Modesto, CA 95356
# Author: Robert E. Novak aka REN
# sailnfool@gmail.com
# skype: sailnfool.ren
####################################################################
#
# verifychange - verifies that a system text/parameter file has
#                been modified.  The script performs a diff of 
#                two versions of the file.  The first parameter is
#                "name" of the file being changed.  The second
#                parameter is the older version of the file.  The
#                third parameter ist the newer version of the file.
#                The fourth paramter is a sequence number which is 
#                used to identify the diagnostic file placed in
#                /tmp which holds the output from this verification
####################################################################
#___________________________________________________________________
# Rev.|Auth.| Date       | Notes
#___________________________________________________________________
# 1.0 | REN | 06/08/2019 | Initial Version
#___________________________________________________________________
if [ -z "${__verifychange}" ]
then
	export __verifychange=1
	##########
	# This function provides a verification of the requested change
	##########
	function verifychange {
		set -x
		echo "${0##*/}:${LINENO}:STAFF_VERBOSE=${STAFF_VERBOSE}"
		if [ ${STAFF_VERBOSE} -gt 0 ]
		then
			if [ ${STAFF_VERBOSE} -gt 1 ]
			then
				set -x
				echo "${0##*/}:${LINENO}"
			fi
			numparms=4
			if [ $# -lt ${numparms} ]
			then
				insufficient ${FUNCNAME} $LINENO ${FUNCNAME} ${numparms}
			fi
			changename=$1
			if [ "${changename}" = "" ]
			then
				nullparm ${FUNCNAME} ${LINENO} 1
			fi
			origfile=$2
			if [ "${origfile}" = "" ]
			then
				nullparm ${FUNCNAME} ${LINENO} 1
			fi
			destfile=$3
			if [ "${destfile}" = "" ]
			then
				nullparm ${FUNCNAME} ${LINENO} 1
			fi
			sequence=$4
			if [ "${sequence}" = "" ]
			then
				nullparm ${FUNCNAME} ${LINENO} 1
			fi
		
			echo "Verify ${changename}" | tee /tmp/${sequence}.${changename}.$$.debug.txt
			ls -l ${origfile} ${destfile} | tee -a /tmp/${sequence}.${changename}.$$.debug.txt
			diff -s ${origfile} ${destfile} | tee -a /tmp/${sequence}.${changename}.$$.debug.txt
			if [ ${STAFF_VERBOSE} -gt 1 ]
			then
				echo "${0##*/}:${LINENO}"
				set +x
			fi
		fi
	}
	##########
	# end of function verifychange
	##########
fi # if [ -z "${__verifychange}" ]
# vim: set syntax=bash, ts=2, sw=2, lines=55, columns=120,colorcolumn=78
