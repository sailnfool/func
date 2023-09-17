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

source func.debug
source func.errecho
source func.kbytes
source func.regex

TESTNAME="Test of function kbytes (func.kbytes) from \n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t\tVerifies that the __kbytesvalue and __kbibytesvalue arrays have\r\n
\t\tcorrectly initialized.  Normally emits only PASS|FAIL message\r\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see the diagnostic levels.\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
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

if [[ -z "${__kbytessuffix}" ]] ; then
  errecho -i "__kbytessuffix not initialized"
  exit 1
fi
if [[ -z "${__kbibytessuffix}" ]] ; then
  errecho -i "__kbibytessuffix not initialized"
  exit 1
fi
if [[ -z "${__kbytesvalue[@]}" ]] ; then
  errecho -i "__kbytesvalue not initialized"
  exit 1
fi
if [[ -z "${__kbibytesvalue[@]}" ]] ; then
  errecho -i "__kbibytesvalue not initialized"
  exit 1
fi
#for i in { 0 $((${#__kbytessuffix}-1)) }
for ((i=0;i<${#__kbytessuffix};i++))
do
  k_bytesuffix=${__kbytessuffix:${i}:1}
  k_bibytesuffix=${__kbibytessuffix[${i}]}

  ############################################################ 
  # Note that this is a string comparison rather then a 
  # numeric comparison since the higher end numbers will
  # exceed the capacity of native integers on a machine
  ############################################################ 
  if [[ "${__kbytesvalue[${k_bytesuffix}]}" != \
    $(echo "1000 ^ ${i}" | bc) ]] ; then
    if [[ "${verbosemode}" == "TRUE" ]] ; then
      echo "Byte Suffix $i = \"${k_bytesuffix}\", " \
        "value=\"${__kbytesvalue[${k_bytesuffix}]}\""
      echo -n "Computed value= "
      echo "1000 ^ ${i}" |bc
      echo ""
    fi
    ((fail++))
  fi
  if [[ "${__kbibytesvalue[${k_bibytesuffix}]}" != \
    $(echo "1024 ^ ${i}" | bc) ]] ; then
    if [[ "${verbosemode}" == "TRUE" ]] ; then
      echo "BiByte Suffix $i = \"${k_bibytesuffix}\", " \
        "value=\"${__kbibytesvalue[${k_bibytesuffix}]}\""
      echo -n "Computed value= "
      echo "1024 ^ ${i}" |bc
      echo ""
    fi
    ((fail++))
  fi
   if [[ "${verbosemode}" == "TRUE" ]] ; then
     waverrindentvar "Byte Suffix $i = \"${k_bytesuffix}\", " \
       "value=\"${__kbytesvalue[${k_bytesuffix}]}\""
     waverrindentvar "BiByte Suffix $i = \"${k_bibytesuffix}\", " \
       "value=\"${__kbibytesvalue[${k_bibytesuffix}]}\""
   fi
done
exit ${fail}
