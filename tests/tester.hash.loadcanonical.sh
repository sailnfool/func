#!/bin/bash
scriptname=${0##/*}
########################################################################
# Author: Robert E. Novak
# email: sailnfool@gmail.com
# Copyright (C) 2022 Sea2Cloud Storage, Inc. All Rights Reserved
# Modesto, CA 95356
#
# Create_canonical - Create the canonical hash lists
#                    Given an initial list of canonical numbers
#                    and short hash names, generate the following
#                    lists:
#                          number to short hash name
#                          short hash name to number
#                          number to executable (local)
#                          number to number of bits generated
#
#                    Given these lists, generate a function that
#                    will load these lists into Bash Associative
#                    arrays for use in a bash script.
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

TESTNAME="Test of hash function (hash.loadcanonical.sh) from \nhttps://github.com/sailnfool/func"
failcode=0
USAGE="\n${0##*/} [-[hv]]\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the function will load Associative arrays with the\n
\t\tcorrect cryptographic values\n
\t\tseconds only\n
\t\tNormally emits only PASS|FAIL message\r\n
"

optionargs="hv"
verbosemode="FALSE"
fail=0

while getopts ${optionargs} name
do
	case ${name} in
	h)
		echo -e ${USAGE}
		exit 0
		;;
	v)
		verbosemode="TRUE"
		;;
	\?)
		errecho "-e" "invalid option: -$OPTARG"
		errecho "-e" ${USAGE}
		exit 1
		;;
	esac
done

shift $(( ${OPTIND} - 1 ))

hash_loadcanonical -v

echo "No exclaim keys for Cnum2bin '${Cnum2bin[@]}'"
echo "Exclaim keys    for Cnum2bin '${!Cnum2bin[@]}'"

for filetype in num2bin num2bits num2hexdigits num2hash hash2num
do
  set -x
  filename=$(eval echo \$F${filetype})
  tmpunsortedtarget=/tmp/$$_unsort_${filename}
  tmptarget=/tmp/$$_${filename}
  associative=$(eval echo C${filetype})
  echo "Checking ${filename} vs. ${associative}"
  # for key in "$(eval \${!${associative}[\@]})"
  echo "No exclaim keys for Cnum2bin '${Cnum2bin[@]}'"
  echo "Exclaim keys    for Cnum2bin '${!Cnum2bin[@]}'"
  for key in "$!{Cnum2bin[@]}"
  do
    echo "key='${key}'"
    echo -e "${key}\t$(eval \${${associative}[\${key}]})" > ${tmpunsortedtarget}
  done
  sort ${tmpunsortedtarget} > ${tmptarget}
  diff ${YesFSetcdir}/${filename} ${tmptarget} 2>&1 > /dev/null
  diffresult=$?
  if [[ "${diffresult}" -ne 0 ]]
  then
    stderrecho "*** WARNING *** " "File ${filename} is different"
    ((failcode += diffresult))
  fi
done
exit ${failcode}
