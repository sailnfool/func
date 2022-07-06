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


source func.hashcanonical
source func.errecho
source func.regex
source func.debug

########################################################################
# The "HERE" file must always be up to date.  In addition, the
# system canonical file will not be updated until this source file
# is also stored in the git repository.
########################################################################
tmpcanonical=/tmp/canonical_source_$$.csv
  cat > ${tmpcanonical} << EOF
Index	short	Bits
001	md2sum	128
002	md4sum	128
003	Havalsum	0
004	md5sum	128
005	ripemdsum	0
006	sha0sum	0
007	Gostrsum	0
008	sha1sum	160
009	tigersum	0
00A	Ripemd-128sum	128
00B	Ripemd-160sum	160
00C	Ripemd-256sum	256
00D	Ripemd-320sum	320
00E	sha256sum	256
00F	sha2sum	256
010	sha384sum	384
011	sha512sum	512
012	sha224sum	224
013	whirlpool	512
014	bsum	0
015	md6sum	0
016	sha3-224sum	224
017	sha3-256sum	256
018	sha3-384sum	384
019	sha3sum	224
01A	Shake128sum	256
01B	Shake256sum	256
01C	b2sum	512
01D	Streebogsum	0
01E	KangarooTwelvesum	0
01F	b3sum	256
020	Blake3sum	256
021 b2ppsum 512
EOF

canonical_source=/${YesFSdir}/etc/canonical_source.csv

########################################################################
# The theory is that since we have embedded a "HERE" file in this
# script, then an updated version of this script will contain the
# latest version of the canonical list of functions for performing
# cryptographic hashes.  If there is an existing canonical source
# we compare the time of its last update to the last update time
# of this script.  If the script is newer, then we replace the
# canonical form with the one generated by the HERE script.  If you
# modify this script, you MUST insure that the embedded HERE file is
# current and up to date.  Note that touchtimes is a mildly
# interesting script that updates the timestamp on the retrieved files
# to the timestamp of when they were last update in git.
########################################################################
if [[ -r "${canonical_source}" ]]
then
  pushd ${HOME}/github/func 2>&1 > /dev/null
  git pull 2>&1 > /dev/null
  touchtimes func 2>&1 > /dev/null
  if [[ "${HOME}/github/ren/scripts/createhashcanonical.sh" -nt "${canonical_source}" ]]
  then
    mv ${tmpcanonical} ${canonical_source}
  fi
  popd 2>&1 > /dev/null
else
  mv ${tmpcanonical} ${canonical_source}
fi
canonical_dir=${canonical_source%/*}


USAGE="${0##*/} [-[hv]] [-d <#>] [-f <file>]\n
\t\tThis command will create the canonical files for cryptographic\n
\t\tprograms.  The default file is:\n
\t\t${canonical_source}\n
\n
\t\tThe default files are:\n
\t\t\tnumber to short hash name\t\tnum2hash.csv\n
\t\t\tshort hash name to number\t\thash2num.csv\n
\t\t\tnumber to executable\t\tnum2bin\n
\t\t\tnumber to hash length in bits\t\tnum2bits\n
\t\t\tin the same directory as the source file,\n
\n
\t\t\tThen these files are loaded into the same directory as the file\n
\t-h\t\tPrint this help information.\n
\t-d\t<#>\tPrint diagnostic information. Use -v for Debug levels\n
\t\t\t(dump manifests as created).\n
\t-f\t<file>\tUse <file> as an alternate input for the canonical list\n
\t\t\tinstead of the default file hard-coded in the script\n
\t-v\t\tUse '-vh' to display the debug levels\n
"

######################################################################
# environmental and script dependent variables.
######################################################################
optionargs="hdf:v"
NUMARGS=0
debug=${DEBUGOFF}
verbose="FALSE"

######################################################################
# default defined in yfunc.global (should be the same)
######################################################################
YesFSdir=${YesFSdir:-/home/rnovak/dropbox/YesFS}

while getopts ${optionargs} name
do
	case ${name} in
	h)
		echo -e ${USAGE}
    if [[ "${verbose}" = "TRUE" ]]
    then
      echo -e ${DEBUG_USAGE}
    fi
		exit 0
		;;
	d)
    if [[ "${OPTARG}" =~ $re_digit ]]
    then
      debug="${OPTARG}"
    else
      errecho -e "-d requires a single digit"
      echo -e ${USAGE}
      exit 1
    fi
		;;
  f)
    if [[ -r "${OPTARG}" ]]
    then
      cp "${OPTARG}" "${canonical_source}"
    else
      errecho -e "-f ${OPTARG} cannot be read"
      echo -e ${USAGE}
      exit 1
    fi
    ;;
	v)
    if [[ "${verbose}" = "FALSE" ]]
		then
      verbose="TRUE"
    else
  	  if [[ "${verbose}" = "TRUE" ]]
      then
			  verbose="FALSE"
      fi
    fi
		;;
	\?)
		echo "${0##*/}: invalid option: -${OPTARG}"
		echo -e "${USAGE}"
		exit 0
		;;
	esac
done # while getopts ${optionargs} name

shift "$(($OPTIND - 1))"

if [[ "$#" -gt "${NUMARGS}" ]]
then
  errecho -e "Excess parameters ignored"
fi

######################################################################
# b3sum is often missing.  This section should contain install/build
# script to install other well known cryptographic hashes on the
# local machine.
######################################################################
which b3sum 2>&1 > /dev/null
b3sumresult=$?
if [[ "${b3sumresult}" -ne 0 ]]
then
  echo "b3sum is not installed on your machine"
  echo -n "Install now (Y/n):"
  read installanswer
  if [[ -z "${installanswer}" ]]
  then
    installanswer="Y"
  fi
  installanswer=$(echo ${installanswer} | tr a-z A-Z)
  case ${installanswer} in
    Y|YES)

      ##############################################################
      # This should include tests to determine which OS and use
      # the correct package installer
      ##############################################################
      sudo apt-get install b3sum
      ;;
    N|NO)
      ;;
    \?)
      echo "Invalid answer"
      exit 1
  esac
fi

for i in num2bin num2hash num2bits hash2num
do

  ###################################################################
  # The num2bin mapping is highly dependent on the machine so it
  # should be placed in a hostname dir
  ###################################################################
  if [[ "${i}" = num2bin ]]
  then
    subdir=$(hostname)
    mkdir -p ${canonical_dir}/${subdir}
  else
    subdir=""
  fi
  if [[ -r ${canonical_dir}/${subdir}/${i}.csv ]]
  then
    rm -f ${canonical_dir}/${subdir}/${i}.csv
  fi
done # for i in num2bin num2hash num2bits hash2num

######################################################################
# Remove the external files before we write them
######################################################################
rm -f /tmp/$$_${Fhash2num}
rm -f /tmp/$$_${Fnum2hash}
rm -f /tmp/$$_${Fnum2bits}
rm -f /tmp/$$_${Fnum2hexdigits}
rm -f /tmp/$$_${Fnum2hash}

######################################################################
# Canonical tables will always have the first three columns as:
# Index hashshortname #read_hashbits
# The Index is always a 3 digit HEX number
# The hashbits is always an integer
######################################################################
if [[ ! -r ${canonical_source} ]]
then
  errecho "Could not find ${canonical_source}"
  exit 1
fi

#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?
# Removable diagnostics
#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?#?
if [[ "${verbose}" == "TRUE" ]]
then
  more ${canonical_source}
fi

########################################################################
# An earlier implementation of this had the "cut" command piped into
# the while statement.  It took me a long time to realize that the
# reason that the global associative arrays were empty AFTER the 
# while loop was because piping the cut command into the while put the
# cut command and the while loop into a subshell and the global arrays
# belonged to the subshell, but expired when the subshell (containing
# the while loop) ended and they were unavailable outside the while
# loop.  I fixed this by sending the output of the cut command to
# a file and then redirecting the file as the input to the while loop
# which does not create a separate shell... Only 2 days to realize
# (at about 3 AM) what I had done to myself.
########################################################################
count=0
cut -d " " --fields=1-3 ${canonical_source} > ${tmpcanonical}
while read read_hashnum read_hashshort read_hashbits
do
  ((count++))

####################################################################
# skip the title line
# Compensate for mixed case
####################################################################
  if [[ $(echo "${read_hashnum}"| tr  a-z A-Z ) = "INDEX" ]]
  then
    continue
  fi
  if [[ ! "${read_hashnum}" =~ $re_canonicalhashnumber ]]
  then
    errecho "Invalid read_hashnum ${read_hashnum} on line ${count} of"
    errecho "canonical file. It must be 3 hexadecimal digits."
    exit 1
  fi
  if [[ ! "${read_hashbits}" =~ $re_integer ]]
  then
    errecho "Invalid  read_hashbits '${read_hashbits}' on line ${count} of"
    errecho "canonical file. It must be an integer."
  fi
  Chash2num+=([${read_hashshort}]=${read_hashnum})
  Cnum2hash+=([${read_hashnum}]=${read_hashshort})
  Cnum2bits+=([${read_hashnum}]=${read_hashbits})
  Cnum2hexdigits+=([${read_hashnum}]=$((read_hashbits / CHEXBITS)))
  Cnum2bin+=([${read_hashnum}]=$(which ${read_hashshort}))
  
done < ${tmpcanonical} # while read read_hashnum read_hashshort read_hashbits

###################################################################### 
# We have finished distributing the canonical data into a separate set
# of associative arrays, now save those arrays into key/value files
# with a tab separation between the key and value and sort them by
# the key.  Note that the value is always enclosed in ""
###################################################################### 
# num2bin
###################################################################### 
filename=${Fnum2bin}
tmptarget=/tmp/$$_${filename}
target=${canonical_dir}/${subdir}/${filename}
for i in "${!Cnum2bin[@]}";do \
  echo -e "$i\t${Cnum2bin[$i]}" >> ${tmptarget};done
sort ${tmptarget} > ${target}
rm -f ${tmptarget}

###################################################################### 
# num2bits
###################################################################### 
filename=${Fnum2bits}
tmptarget=/tmp/$$_${filename}
target=${canonical_dir}/${subdir}/${filename}
for i in "${!Cnum2bits[@]}";do \
  echo -e "$i\t${Cnum2bits[$i]}" >> ${tmptarget};done
sort ${tmptarget} > ${target}
rm -f ${tmptarget}

###################################################################### 
# num2hexdigits
###################################################################### 
filename=${Fnum2hexdigits}
tmptarget=/tmp/$$_${filename}
target=${canonical_dir}/${subdir}/${filename}
for i in "${!Cnum2hexdigits[@]}";do \
  echo -e "$i\t${Cnum2hexdigits[$i]}" >> ${tmptarget};done
sort ${tmptarget} > ${target}
rm -f ${tmptarget}

###################################################################### 
# num2hash
###################################################################### 
filename=${Fnum2hash}
tmptarget=/tmp/$$_${filename}
target=${canonical_dir}/${subdir}/${filename}
for i in "${!Cnum2hash[@]}";do \
  echo -e "$i\t${Cnum2hash[$i]}">> ${tmptarget} ;done
sort ${tmptarget} > ${target}
rm -f ${tmptarget}

###################################################################### 
# hash2num
###################################################################### 
filename=${Fhash2num}
tmptarget=/tmp/$$_${filename}
target=${canonical_dir}/${subdir}/${filename}
for i in "${!Chash2num[@]}";do \
  echo -e "$i\t${Chash2num[$i]}" >> ${tmptarget} ;done
sort ${tmptarget} > ${target}
rm -f ${tmptarget} 
rm -f ${tmpcanonical}
exit 0
