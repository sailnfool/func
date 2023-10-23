#!/bin/bash
scriptname=${0##*/}
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#Script Name    : valid_ipv4
#Description    : returns 0 (TRUE) if the address is valid
#args           : xxx.xxx.xxx.xxx
#Author         : Robert E. Novak aka REN
#Email          : sailnfool@gmail.com
#License        : CC by Sea2Cloud Storage, Inc.
#License source : https://creativecommons.org/licenses/by/4.0/legalcode
#License name   : Creative Commons Attribution license
#Citationur : https://www.linuxjournal.com/content/validating-ip-address-bash-script 
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|08/03/2022| Initial Release
#_____________________________________________________________________

USAGE="\n${0##*/} xxx.xxx.xxx.xxx
\t\tverifies if the IP address is valid\n
"
if [[ -z "${__funcvalidipv4}" ]] ; then

	__funcvalidipv4=1

	valid_ipv4()
	{
		source func.errecho
		source func.insufficient
		source func.regex

		local	ip=$1
		local	stat=1
		local	numargs=1
		if [[ $# -le "${numargs}" ]] ; then
			insufficient "${numargs}" $@
			return 1
		fi

#    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
#    then
		if [[ ! "${ip}" =~ ${re_ipv4} ]] ; then
			exit 1
		fi
		OIFS=$IFS
		IFS='.'
        	ip=($ip)
		IFS=$OIFS
		[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
			&& ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
		stat=$?
    		return $stat
	}
fi # if [[ -z "${__funcvalidipv4}" ]] ; then
