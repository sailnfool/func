#!/bin/bash
####################
# Copyright (C) 2022 Sea2cloud
# Modesto, CA 95356
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.1 |REN|06/04/2022| Tweaked to exit with the number of fails
# 1.0 |REN|02/01/2022| testing reconstructed kbytes
#_____________________________________________________________________

source func.debug
source func.errecho
source func.os
source func.regex

TESTNAME="Test of functions func_os and func_arch (func.os) from \n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t\tVerifies that functions funcos and funcarch work.\n
\t\tNormally emits only PASS|FAIL message\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see the diagnostic levels.\n
\t-h\t\tPrint this message\n
\t-v\t\tVerbose mode to show values\n
"

optionargs="d:hv"
verbosemode="FALSE"
fail=0

while getopts ${optionargs} name
do
	case ${name} in
  	d)
      if [[ ! "${OPTARG}" =~ $re_digit ]] ; then
        errecho "${0##/*}" "${LINENO}" "-d requires a decimal digit"
        errecho -e "${USAGE}"
        errecho -e "${DEBUG_USAGE}"
        exit 1
      fi
  		FUNC_DEBUG="${OPTARG}"
  		export FUNC_DEBUG
  		if [[ $FUNC_DEBUG -ge ${DEBUGSETX} ]] ; then
  			set -x
  		fi
  		;;
  	h)
  		echo -e ${USAGE}
      if [[ "${verbosemode}" == "TRUE" ]] ; then
        echo -e ${DEBUG_USAGE}
      fi
  		exit 0
  		;;
  	v)
  		verbosemode="TRUE"
      verboseflag="-v"
  		;;
  	\?)
  		errecho "-e" "invalid option: -$OPTARG"
  		errecho "-e" ${USAGE}
  		exit 1
  		;;
	esac
done

shift $(( ${OPTIND} - 1 ))

fail=0
if [[ -z "${__funcos}" ]] ; then
  errecho -i "funcos not found"
  ((fail++))
fi
if [[ ! -f /etc/os-release ]] ; then
  errecho -i "/etc/os-release not found are you on a Debian OS?"
  ((fail++))
fi
check_os=$(sed -ne '/^ID=/s/^ID=\(.*\)$/\1/p' < /etc/os-release)
if [[ "${verbosemode}" == "TRUE" ]] ; then
  echo -e "Operating system check \"${check_os}\" vs. \"$(func_os)\""
  echo -e "Architecture check \"$(uname -m)\" vs. \"$(func_arch)\""
fi
if [[ "${check_os}" != "$(func_os)" ]]  ; then
  errecho -i "Operating system mismatch \"${check_os}\" vs. \"$(func_os)\""
  ((fail++))
fi
if [[ "$(uname -m)" != "$(func_arch)" ]] ; then
  errecho -i "Architecture mismatch \"$(uname -m)\" vs. \"$(func_arch)\""
  ((fail++))
fi

exit ${fail}
