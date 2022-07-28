#!/bin/bash
scriptname=${0##/*}
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# tester.hash.loadcanonical - Load the canonical lists that were
#                    stored in the canonical files and test that
#                    we have recovered these key/vallue data files.
#
#                          number to short hash name
#                          short hash name to number
#                          number to executable (local)
#                          number to number of bits generated
#
#                    Load these lists into Bash Associative
#                    arrays for use in a bash script.
# Author: Robert E. Novak
# email: sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#
########################################################################
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.1 |REN|06/05/2022| Rewritten to use key/value arrays
# 1.0 |REN|05/26/2022| original version
#_____________________________________________________________________


source hash.globalcanonical
source hash.loadcanonical
source func.errecho
source func.debug
source func.regex

TESTNAME="Test of hash function (hash.loadcanonical.sh) from \nhttps://github.com/sailnfool/func"
failcode=0
successfiles=0
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t-d\t<#>\tset the debug level to <#>, use -hv to see levels\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the function will load Associative arrays with the\n
\t\tcorrect cryptographic values\n
\t\tNormally emits only PASS|FAIL message\r\n
"

optionargs="d:hv"
verbosemode="FALSE"
verboseflag=""
fail=0
FUNC_DEBUG=${DEBUGOFF}

while getopts ${optionargs} name
do
	case ${name} in
	h)
		echo -e ${USAGE}
    if [[ "${verbosemode}" == "TRUE" ]]
    then
      echo -e ${DEBUG_USAGE}
    fi
		exit 0
		;;
  d)
    if [[ ! "${OPTARG}" =~ $re_digit ]]
    then
      errecho "-d requires a decimal digit"
    fi
    FUNC_DEBUG="${OPTARG}"
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

shift $(( ${OPTIND} - 1 ))

hash_loadcanonical ${verboseflag}

waverrindentvar "Exclaim keys    for Cnum2bin ${!Cnum2bin[@]}"

########################################################################
# Loop through all of the suffix values
# dump the associative arrays to files and sort them and then 
# compare them against the stored files.
########################################################################
for filesuffix in num2bin num2bits num2hexdigits num2hash hash2num
do
  declare -n newarr=C${filesuffix}
  
  arrname=$(echo C${filesuffix})
  filename=$(eval echo \$F${filesuffix})
  fullfile=${YesFSdiretc}/${filename}
  waverrindentvar "fullfile=${fullfile}"
  tmpunsortedtarget=/tmp/$$_unsort_${filename}.txt
  tmptarget=/tmp/$$_${filename}
  rm -f ${tmptarget} ${tmpunsortedtarget}
  [[ "${verbosemode}" == "TRUE" ]] && \
    echo "Checking ${filename} vs. ${arrname}"
  for key in "${!newarr[@]}"
  do
    waverrindentvar "key="${key}", value=${newarr["${key}"]}"
    echo -e "${key}\t${newarr["${key}"]}" >> ${tmpunsortedtarget}
  done
  sort ${tmpunsortedtarget} > ${tmptarget}
  [[ "${verbosemode}" == "TRUE" ]] && \
    echo "diff ${fullfile} ${tmptarget} 2>&1 > /dev/null"
  diff ${fullfile} ${tmptarget} 2>&1 > /dev/null
  diffresult=$?
  if [[ "${diffresult}" -ne 0 ]]
  then
    stderrecho "*** WARNING *** " "File ${fullfile} is different"
    diff ${fullfile} ${tmptarget}

    ((failcode += diffresult))
  else
    ((successfiles++))
  fi
done
waverrindentvar "${successfiles} compared"
exit ${failcode}
