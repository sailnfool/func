#!/bin/bash
####################
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
source func.kbytes

TESTNAME="Test of function kbytes (func.kbytes) from \n\thttps://github.com/sailnfool/func"
USAGE="\r\n${0##*/} [-[hv]]\r\n
\t\tVerifies that the __kbytesvalue and __kbibytesvalue arrays have\r\n
\t\tcorrectly initialized.  Normally emits only PASS|FAIL message\r\n
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

if [[ -z "${__kbytessuffix}" ]]
then
  errecho -i "__kbytessuffix not initialized"
  exit 1
fi
if [[ -z "${__kbibytessuffix}" ]]
then
  errecho -i "__kbibytessuffix not initialized"
  exit 1
fi
if [[ -z "${__kbytesvalue[@]}" ]]
then
  errecho -i "__kbytesvalue not initialized"
  exit 1
fi
if [[ -z "${__kbibytesvalue[@]}" ]]
then
  errecho -i "__kbibytesvalue not initialized"
  exit 1
fi
for i in $(seq 0 $((${#__kbytessuffix}-1)) )
do
  bytesuffix=${__kbytessuffix:${i}:1}
  bibytesuffix=${__kbibytessuffix[${i}]}

  ############################################################ 
  # Note that this is a string comparison rather then a 
  # numeric comparison since the higher end numbers will
  # exceed the capacity of native integers on a machine
  ############################################################ 
  if [[ "${__kbytesvalue[${bytesuffix}]}" != \
    "$(echo \"1000 ^ ${i}\" | bc)" ]]
  then
    failure="TRUE"
  fi
  if [[ "${__kbibytesvalue[${bibytesuffix}]}" != \
    "$(echo \"1024 ^ ${i}\" | bc)" ]]
  then
    failure="TRUE"
  fi
  if [[ "${verbose_mode}" == "TRUE" ]]
  then
    echo "Byte Suffix $i = \"${bytesuffix}\", " \
      "value=\"${__kbytesvalue[${bytesuffix}]}\""
    echo "BiByte Suffix $i = \"${bibytesuffix}\", " \
      "value=\"${__kbibytesvalue[${bibytesuffix}]}\""
  fi
done
if [[ "${failure}" == "FALSE" ]]
then
  exit 0
else
  exit 1
fi
