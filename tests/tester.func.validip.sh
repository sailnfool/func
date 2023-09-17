#!/bin/bash
scriptname=${0##*/}
########################################################################
#copyright      :(C) 2022
#copyrightholder:Robert E. Novak  All Rights Reserved
#location       :Modesto, CA 95356 USA
########################################################################
#scriptname     :tester.func.validip
#description    :Test to see if an IP address is vaild for ipv4, need
#description02  :to add ipv6 testing as well
#args           :xxx.xxx.xxx.xxx
#author         :Robert E. Novak
#authorinitials :REN
#email          :sailnfool@gmail.com
#license        :CC by Sea2Cloud Storage, Inc.
#licensesource  :https://creativecommons.org/licenses/by/4.0/legalcode
#Licensename    :Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|08/03/2022| Initial Release
#_____________________________________________________________________

source func.errecho
source func.insufficient
source func.regex
source func.validip

func_NUMARGS=0
verbosemode="FALSE"
verboseflag=""
FUNC_DEBUG=${DEBUGOFF}

USAGE="\n${0##*/} [-hv] [-d <#>]\n
\t\ttest a set of valid and invalid IP addresses with valid_ipv4\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see debug modes/levels\n
\t-h\t\tPrint this message\n
\t-v\t\tTurn on verbose mode\n
"

optionargs="d:hv"
while getopts ${optionargs} name
do
	case ${name} in
		d)
			if [[ ! "${OPTARG}" =~ $re_digit ]]
			then
				errecho "-d requires a decimal digit"
				errecho -e "${USAGE}"
				errecho -e "${DEBUG_USAGE}"
				exit 1
			fi
			FUNC_DEBUG="${OPTARG}"
			export FUNC_DEBUG
			if [[ ${FUNC_DEBUG} -ge ${DEBUGNOEX} ]] ; then
				set -v
			fi
			;;
		h)
			echo -e "${USAGE}"
			if [[ "${verbosemode}" == "TRUE" ]] ; then
				errecho -e "${DEBUG_USAGE}"
			fi
			exit 0
			;;
		v)
			verbosemode="TRUE"
			verboseflag="-v"
			;;
		\?)
			errecho "-e" "invalid option: -${OPTARG}"
			errecho "-e" ${USAGE}
			exit 1
			;;
	esac
done

shift $((OPTIND-1))

if [[ $# -lt ${func_NUMARGS} ]] ; then
	insufficient ${func_NUMARGS} $@
	errecho "-e" ${USAGE}
	exit 2
fi

########################################################################
# tv is short for testvalue
# tr is short for testresult
########################################################################
tv[0]="4.2.2.2"
tr[0]=0

tv[1]="a.b.c.d"
tr[1]=1

tv[2]="192.168.1.1"
tr[2]=0

tv[3]="0.0.0.0"
tr[3]=0

tv[4]="255.255.255.255"
tr[4]=0

tv[5]="255.255.255.256"
tr[5]=1

tv[6]="192.168.0.1"
tr[6]=0

tv[7]="192.168.0"
tr[7]=1

tv[8]="1234.123.123.123"
tr[8]=1

fail=0
for ((ti=0; ti<${#tv[@]}; ti++))
do
  if [[ valid_ipv4 "${tv[${ti}]}"  ]] ; then
	  if [[ "${tr[${ti}]}" -eq 1 ]] ; then
		  ((fail))++
		  if [[ "${verbosemode}" == "TRUE" ]] ; then
			  errecho "Got valid for ${tv[${ti}]}, " \
				  "expected fail"
		  fi
	  fi
  elif [[ "${tr[${ti}]}" -eq 0 ]] ; then
	  ((fail))++
	  if [[ "${verbosemode}" == "TRUE" ]] ; then
		  errecho "Got fail for ${tv[${ti}]}, expected success"
	  fi
  fi
done
exit ${fail}


