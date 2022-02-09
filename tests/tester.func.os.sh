#!/bin/bash
####################
# Copyright (C) 2022 Sea2cloud
# Modesto, CA 95356
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.1 | REN |02/08/2022| Restructured to use arrays
# 1.0 | REN |02/01/2022| testing reconstructed kbytes
#_____________________________________________________________________
#
########################################################################
source func.errecho
source func.os

TESTNAME="Test of functions func_os and func_arch (func.os) from \n\thttps://github.com/sailnfool/func"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t\tVerifies that functions funcos and funcarch work.\r\n
\t\tNormally emits only PASS|FAIL message\r\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
"

optionargs="hv"
verbose_mode="FALSE"
failure="FALSE"

while getopts ${optionargs} name
do
	case ${name} in
	h)
		echo -e ${USAGE}
		exit 0
		;;
	v)
		verbose_mode="TRUE"
		;;
	\?)
		errecho "-e" "invalid option: -$OPTARG"
		errecho "-e" ${USAGE}
		exit 1
		;;
	esac
done

if [[ -z "${__funcos}" ]]
then
  errecho -i "funcos not found"
  exit 1
fi
if [[ ! -f /etc/os-release ]]
then
  errecho -i "/etc/os-release not found are you on a Debian OS?"
  exit 1
fi
check_os=$(sed -ne '/^ID=/s/^ID=\(.*\)$/\1/p' < /etc/os-release)
if [[ "${verbose_mode}" == "TRUE" ]]
then
  echo -e "Operating system check \"${check_os}\" vs. \"$(func_os)\""
  echo -e "Architecture check \"$(uname -m)\" vs. \"$(func_arch)\""
fi
if [[ "${check_os}" != "$(func_os)" ]] 
then
  errecho -i "Operating system mismatch \"${check_os}\" vs. \"$(func_os)\""
  failure="TRUE"
fi
if [[ "$(uname -m)" != "$(func_arch)" ]]
then
  errecho -i "Architecture mismatch \"$(uname -m)\" vs. \"$(func_arch)\""
  failure="TRUE"
fi
if [[ "${failure}" == "FALSE" ]]
then
  exit 0
else
  exit 1
fi
