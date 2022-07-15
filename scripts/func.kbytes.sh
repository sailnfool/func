#!/bin/bash
########################################################################
# Author Robert E. Novak
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.3 |REN|07/15/2022| since this is not strictly a "function" I
#                    | changed the names of variable to unique names
#                    | to avoid conflicts with other source files
# 1.2 |REN|05/19/2022| moved re_nicenumber to here instead of
#                    | func.regex
# 1.1 |REN|02/08/2022| redo using arrays instead of named variables
#                    | see the accompanying test function
# 1.0 |REN|02/01/2022| Reconstructed from func.nice2num
#_____________________________________________________________________
#
########################################################################
if [[ -z "${__func_kbytes}" ]]
then
  __func_kbytes=1
  declare -a __kbibytessuffix
  declare -A __kbytesvalue
  declare -A __kbibytesvalue

  ####################################################################
  # Since we are not in a function and cannot declare local
  # variables, prefix each uses variable with a unique prefix
  ####################################################################
#     local kb_bytesuffix
#     local kb_bibytesuffix
#     local kb_let1
#     local kb_let2
#     local kb_sorted
#     local kb_i
#     local kb_allcat
#     local kb_matcher

  export __kbibytessuffix=("BYT" "KIB" "MIB" "GIB" "TIB" "PIB" \
    "EIB" "ZIB")
  export __kbytessuffix="BKMGTPEZ"
  for kb_i in $(seq 0 $((${#__kbytessuffix}-1)) )
  do
    kb_bytesuffix=${__kbytessuffix:${kb_i}:1}
    kb_bibytesuffix=${__kbibytessuffix[${kb_i}]}
    __kbytesvalue[${kb_bytesuffix}]=$(echo "1000 ^ ${kb_i}" | bc)
    __kbibytesvalue[${kb_bibytesuffix}]=$(echo "1024 ^ ${kb_i}" | bc)
  done
  export __kbytesvalue
  export __kbibytesvalue
  ####################################################################
  # Create a regular expression for nicenumbers
  ####################################################################
  kb_let1=/tmp/letters1$$
  kb_let2=/tmp/letters2$$
  kb_sorted=/tmp/kb_sorted$$
  rm -f ${kb_let1} ${kb_let2} ${kb_sorted}
  
  ####################################################################
  # First we sort through all of the letters in the kbibytessuffix
  # and kbytessuffix to put them in a single string.
  ####################################################################
  kb_allcat="${__kbibytessuffix[*]} ${__kbytessuffix}"
   
  for kb_i in $(seq 0 ${#kb_allcat})
  do
    echo -e "${kb_allcat:${kb_i}:1}\n" >> ${kb_let1}
  done

  ####################################################################
    # Make a second lower case only copy of the strings
  ####################################################################
  tr "A-Z" "a-z" < ${kb_let1} > ${kb_let2}

  ####################################################################
    # Make a sorted, unique set of the strings and delete empty lines
  ####################################################################
  cat ${kb_let1} ${kb_let2} | sort -u | \
      tr -d " " | sed -e '/^$/d' > ${kb_sorted}

  ####################################################################
    # Make a single string of all of the letters in the nicenumber
    # names so we will only recognize a suffix containing those letters
    # (this is not perfect and could be improved upon)
  ####################################################################
  while read inletter
  do
    kb_matcher="${kb_matcher}${inletter}"
  done < ${kb_sorted}

  ####################################################################
  # Create the regular expression that will recognize strings like:
  # 1M, 1MiB, 10T, 10TiB, etc.
  ####################################################################
  re_nicenumber="^[0-9][0-9]*[${kb_matcher}][${kb_matcher}]*$"

  ####################################################################
  # Delete the temporary files.
  ####################################################################
  rm -f ${kb_let1} ${kb_let2} ${kb_sorted}
  export re_nicenumber
  export __kbytesvalue
  export __kbibytesvalue

fi # if [[ -z "${__func_kbytes}" ]]
