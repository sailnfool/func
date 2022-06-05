#!/bin/bash
########################################################################
# Author Robert E. Novak
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.2 | REN |05/19/2022| moved re_nicenumber to here instead of
#                      | func.regex
# 1.1 | REN |02/08/2022| redo using arrays instead of named variables
#                      | see the accompanying test function
# 1.0 | REN |02/01/2022| Reconstructed from func.nice2num
#_____________________________________________________________________
#
########################################################################
if [[ -z "${__kbytessuffix}" ]]
then
    declare -a __kbibytessuffix
    declare -A __kbytesvalue
    declare -A __kbibytesvalue

    export __kbibytessuffix=("BYT" "KIB" "MIB" "GIB" "TIB" "PIB" \
      "EIB" "ZIB")
    export __kbytessuffix="BKMGTPEZ"
    for i in $(seq 0 $((${#__kbytessuffix}-1)) )
    do
      bytesuffix=${__kbytessuffix:${i}:1}
      bibytesuffix=${__kbibytessuffix[${i}]}
      __kbytesvalue[${bytesuffix}]=$(echo "1000 ^ ${i}" | bc)
      __kbibytesvalue[${bibytesuffix}]=$(echo "1024 ^ ${i}" | bc)
#       echo "Byte Suffix $i = \"${bytesuffix}\", " \
#         "value=\"${__kbytesvalue[${bytesuffix}]}\""
#       echo "BiByte Suffix $i = \"${bibytesuffix}\", " \
#         "value=\"${__kbibytesvalue[${bibytesuffix}]}\""
    done
#    echo "__kbytesvalue = ${__kbytesvalue[@]}"
#    echo "__kbibytesvalue = ${__kbibytesvalue[@]}"
    export __kbytesvalue
    export __kbibytesvalue
	  ####################################################################
	  # Create a regular expression for nicenumbers
	  ####################################################################
    let1=/tmp/letters1$$
    let2=/tmp/letters2$$
    sorted=/tmp/sorted$$
    rm -f ${let1} ${let2} ${sorted}
  
	  ####################################################################
	  # First we sort through all of the letters in the kbibytessuffix
	  # and kbytessuffix to put them in a single string.
	  ####################################################################
	  allcat="${__kbibytessuffix[*]} ${__kbytessuffix}"
   
	  for i in $(seq 0 ${#allcat})
	  do
	    echo -e "${allcat:${i}:1}\n" >> ${let1}
	  done

	  ####################################################################
    # Make a second lower case only copy of the strings
	  ####################################################################
    tr "A-Z" "a-z" < ${let1} > ${let2}

	  ####################################################################
    # Make a sorted, unique set of the strings and delete empty lines
	  ####################################################################
	  cat ${let1} ${let2} | sort -u | \
      tr -d " " | sed -e '/^$/d' > ${sorted}

	  ####################################################################
    # Make a single string of all of the letters in the nicenumber
    # names so we will only recognize a suffix containing those letters
    # (this is not perfect and could be improved upon)
	  ####################################################################
	  while read inletter
	  do
	    matcher="${matcher}${inletter}"
	  done < ${sorted}

	  ####################################################################
    # Create the regular expression that will recognize strings like:
    # 1M, 1MiB, 10T, 10TiB, etc.
	  ####################################################################
	  re_nicenumber="^[0-9][0-9]*[${matcher}][${matcher}]*$"

	  ####################################################################
    # Delete the temporary files.
	  ####################################################################
    rm -f ${let1} ${let2} ${sorted}
    export re_nicenumber

fi # if [[ -z "${__kbytessuffix}" ]]
