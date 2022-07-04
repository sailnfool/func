#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.2 |REN|06/04/2022| Tweaked to exit with number of fails
# 1.1 |REN|02/08/2022| Restructured to use arrays
# 1.0 |REN|02/01/2022| testing reconstructed kbytes
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
fail=0

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
  k_bytesuffix=${__kbytessuffix:${i}:1}
  k_bibytesuffix=${__kbibytessuffix[${i}]}

  ############################################################ 
  # Note that this is a string comparison rather then a 
  # numeric comparison since the higher end numbers will
  # exceed the capacity of native integers on a machine
  ############################################################ 
  if [[ "${__kbytesvalue[${k_bytesuffix}]}" != \
    $(echo "1000 ^ ${i}" | bc) ]]
  then
    if [[ "${verbose_mode}" == "TRUE" ]]
    then
      echo "Byte Suffix $i = \"${k_bytesuffix}\", " \
        "value=\"${__kbytesvalue[${k_bytesuffix}]}\""
      echo -n "Computed value= "
      echo "1000 ^ ${i}" |bc
      echo ""
    fi
    ((fail++))
  fi
  if [[ "${__kbibytesvalue[${k_bibytesuffix}]}" != \
    $(echo "1024 ^ ${i}" | bc) ]]
  then
    if [[ "${verbose_mode}" == "TRUE" ]]
    then
      echo "BiByte Suffix $i = \"${k_bibytesuffix}\", " \
        "value=\"${__kbibytesvalue[${k_bibytesuffix}]}\""
      echo -n "Computed value= "
      echo "1024 ^ ${i}" |bc
      echo ""
    fi
    ((fail++))
  fi
#   if [[ "${verbose_mode}" == "TRUE" ]]
#   then
#     echo "Byte Suffix $i = \"${k_bytesuffix}\", " \
#       "value=\"${__kbytesvalue[${k_bytesuffix}]}\""
#     echo "BiByte Suffix $i = \"${k_bibytesuffix}\", " \
#       "value=\"${__kbibytesvalue[${k_bibytesuffix}]}\""
#   fi
done
exit ${fail}
