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
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.1 | REN |06/05/2022| Rewritten to use key/value arrays
# 1.0 | REN |05/26/2022| original version
#_____________________________________________________________________


source func.hashcanonical
source func.errecho
source func.regex
source func.debug

tmpcanonical=/tmp/canonical_source_$$.csv
  cat > ${tmpcanonical} << EOF
Index	short	Bits	indexCol
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
021 b2psum 256
EOF

canonical_source=/${YesFSdir}/canonical_source.csv

if [[ -r "${canonical_source}" ]]
then
  pushd ${HOME}/github/func
  git pull 2>&1 > /dev/null
  touchtimes func 2>&1 > /dev/null
  if [[ "${HOME}/github/ren/scripts/createhashcanonical.sh" -nt "${canonical_source}" ]]
  then
    mv ${tmpcanonical} ${canonical_source}
  fi
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

VERBOSE_USAGE="\t\t\tDEBUGOFF 0\r\n
\t\t\tDEBUGWAVE 2 - print indented entry/exit to functions\r\n
\t\t\tDEBUGWAVAR 3 - print variable data from functions if enabled\r\n
\t\t\tDEBUGSTRACE 5 = prefix the executable with strace\r\n
\t\t\t                (if implement)\r\n
\t\t\tDEBUGNOEXECUTE or\t\n
\t\t\tDEBUGNOEX 6 - generate and display the command lines but don't\r\n
\t\t\t              execute the script\r\n
\t\t\tDEBUGSETX 9 - turn on set -x to debug\r\n
"
######################################################################
# environmental and script dependent variables.
######################################################################
optionargs="hdf:v"
NUMARGS=0
debug=${DEBUGOFF}
verbose="FALSE"
re_canonicalhashnumber="[0-9a-fA-F]{3}"

######################################################################
# default defined in yfunc.global (should be the same)
######################################################################
YesFS=${YesFS:-/home/rnovak/dropbox/YesFS}

while getopts ${optionargs} name
do
	case ${name} in
	h)
		echo -e ${USAGE}
  if [[ "${verbose}" = "TRUE" ]]
  then
    echo -e ${VERBOSE_USAGE}
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
done
shift "$(($OPTIND - 1))"

if [[ "$#" -gt "${NUMARGS}" ]]
then
  errecho -e "Excess parameters ignored"
# 	  filename="$1"
# 		if [ ! -f "${filename}" ]
# 		then
# 			echo "filename=${filename} is not a file"
#       echo "parameters $@"
# 			exit 1
# 		fi
# 	  canonical_source=${filename}
# 	  canonical_dir=${canonical_source%/*}
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
done

######################################################################
# Canonical tables will always have the first three column as:
# Index hashshortname #read_hashbits
# The Index is always a 3 digit HEX number
# The hashbits is always an integer
######################################################################
if [[ ! -r ${canonical_source} ]]
then
  errecho "Could not find ${canonical_source}"
  exit 1
fi
count=0
cut --fields=1-3 ${canonical_source} | \
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
  #if [[ ! "${read_hashnum}" =~ [0-9a-fA-F]{3} ]]
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
  Cnum2hash+=([${read_hashnum}]=${read_hashshort})
  Chash2num+=([${read_hashshort}]=${read_hashnum})
  Cnum2bits+=([${read_hashnum}]=${read_hashbits})
  Cnum2hexdigits+=([${read_hashnum}]=$((read_hashbits / CHEXBITS)))
  if [[ "${verbose}" == "TRUE" ]]
  then
    echo -n Cnum2hash[${read_hashnum}]="${read_hashshort}"
    echo =\'${Cnum2hash[${read_hashnum}]}\'
    echo "Cnum2hash has ${#Cnum2hash[@]} keys"
    echo -n Chash2num[${read_hashshort}]="${read_hashnum}"
    echo =\'${Chash2num[${read_hashshort}]}\'
    echo "Chash2num has ${#Chash2num[@]} keys"
    echo -n Cnum2bits[${read_hashnum}]="${read_hashbits}"
    echo =\'${Cnum2bits[${read_hashnum}]}\'
    echo "Cnum2bits has ${#Cnum2bits[@]} keys"
    echo -n Cnum2hexdigits[${read_hashnum}]="$((read_hashbits / CHEXBITS))"
    echo =\'${Cnum2hexdigits[${read_hashnum}]}\'
    echo "Cnum2hexdigits has ${#Cnum2hexdigits[@]} keys"
  fi

#  which ${read_hashshort} 2>&1 > /dev/null
#  foundhash=$?
#  set -x
#  if [[ "${foundhash}" -ne 0 ]]
#  then
    Cnum2bin+=([${read_hashnum}]=$(which ${read_hashshort}))
#  else
#    Cnum2bin+=([${read_hashnum}]="")
#  fi
#  set +x
  if [[ "${verbose}" == "TRUE" ]]
  then
    echo -n "Cnum2bin[${read_hashnum}]=${read_hashshort}"
    echo =\'${Cnum2bin[${read_hashnum}]}\'
    echo "Cnum2bin has ${#Cnum2bin[@]} keys"
    echo "Dumping Cnum2bin keys:${!Cnum2bin[@]}"
  fi
done # read hash canonical

if [[ "${verbose}" == "TRUE" ]]
then
  echo "Cnum2bin has ${#Cnum2bin[@]} keys"
  echo "Dumping Cnum2bin keys:${!Cnum2bin[@]}"
  echo "Cnum2bits has ${#Cnum2bits[@]} keys"
  echo "Dumping Cnum2bits keys:${!Cnum2bits[@]}"
  echo "Cnum2hexdigits has ${#Cnum2hexdigits[@]} keys"
  echo "Dumping Cnum2hexdigits keys:${!Cnum2hexdigits[@]}"
  echo "Cnum2hash has ${#Cnum2hash[@]} keys"
  echo "Dumping Cnum2hash keys:${!Cnum2hash[@]}"
  echo "Chash2num has ${#Chash2num[@]} keys"
  echo "Dumping Chash2num keys:${!Chash2num[@]}"
fi
###################################################################### 
# We have finished sorting the canonical data into a separate set
# of associative arrays, now save those arrays into key/value files
# with a tab separation between the key and value.
###################################################################### 
# num2bin
###################################################################### 
filename=${Fnum2bin}
target=${canonical_dir}/${subdir}/${filename}
tmptarget=/tmp/${filename}
rm -f ${tmptarget}
if [[ "${verbose}" == "TRUE" ]]
then
  echo "Cnum2bin has ${#Cnum2bin[@]} keys"
  echo "Dumping Cnum2bin keys:${!Cnum2bin[@]}"
fi
for num in "${!Cnum2bin[@]}"
do
  if [[ "${verbose}" == "TRUE" ]]
  then
    echo Cnum2bin[${num}]=${Cnum2bin[${num}]}
  fi
  echo -e "${num}\t${Cnum2bin[${num}]}" >> ${tmptarget}
done
if [[ ! -r "${tmptarget}" ]]
then
  errecho "Could not find '${tmptarget}'"
  exit 1
fi
sort ${tmptarget} > ${target}
rm -f ${tmptarget}

###################################################################### 
# num2bits
###################################################################### 
filename=${Fnum2bits}
target=${canonical_dir}/${subdir}/${filename}
tmptarget=/tmp/${filename}
rm -f ${tmptarget}
if [[ "${verbose}" == "TRUE" ]]
then
  echo "Cnum2bits has ${#Cnum2bits[@]} keys"
  echo "Dumping Cnum2bits keys:${!Cnum2bits[@]}"
fi
for num in "${!Cnum2bits[@]}"
do
  if [[ "${verbose}" == "TRUE" ]]
  then
    echo Cnum2bits[${num}]=${Cnum2bits[${num}]}
  fi
  echo -e "${num}\t${Cnum2bits[${num}]}" >> ${tmptarget}
done
if [[ ! -r "${tmptarget}" ]]
then
  errecho "Could not find '${tmptarget}'"
  exit 1
fi
sort ${tmptarget} > ${target}
rm -f ${tmptarget}

###################################################################### 
# num2hexdigits
###################################################################### 
filename=${Fnum2hexdigits}
target=${canonical_dir}/${subdir}/${filename}
tmptarget=/tmp/${filename}
rm -f ${tmptarget}
if [[ "${verbose}" == "TRUE" ]]
then
  echo "Cnum2hexdigits has ${#Cnum2hexdigits[@]} keys"
  echo "Dumping Cnum2hexdigits keys:${!Cnum2hexdigits[@]}"
fi
for num in "${!Cnum2hexdigits[@]}"
do
  if [[ "${verbose}" == "TRUE" ]]
  then
    echo Cnum2hexdigits[${num}]=${Cnum2hexdigits[${num}]}
  fi
  echo -e "${num}\t${Cnum2hexdigits[${num}]}" >> ${tmptarget}
done
if [[ ! -r "${tmptarget}" ]]
then
  errecho "Could not find '${tmptarget}'"
  exit 1
fi
sort ${tmptarget} > ${target}
rm -f ${tmptarget}

###################################################################### 
# num2hash
###################################################################### 
filename=${Fnum2hash}
target=${canonical_dir}/${subdir}/${filename}
tmptarget=/tmp/${filename}
rm -f ${tmptarget}
if [[ "${verbose}" == "TRUE" ]]
then
  echo "Cnum2hash has ${#Cnum2hash[@]} keys"
  echo "Dumping Cnum2hash keys:${!Cnum2hash[@]}"
fi
for num in "${!Cnum2hash[@]}"
do
  if [[ "${verbose}" == "TRUE" ]]
  then
    echo Cnum2hash[${num}]=${Cnum2hash[${num}]}
  fi
  echo -e "${num}\t${Cnum2hash[${num}]}" >> ${tmptarget}
done
if [[ ! -r "${tmptarget}" ]]
then
  errecho "Could not find '${tmptarget}'"
  exit 1
fi
sort ${tmptarget} > ${target}
rm -f ${tmptarget}

###################################################################### 
# hash2num
###################################################################### 
filename=${Fhash2num}
target=${canonical_dir}/${subdir}/${filename}
tmptarget=/tmp/${filename}
rm -f ${tmptarget}
if [[ "${verbose}" == "TRUE" ]]
then
  echo "Chash2num has ${#Chash2num[@]} keys"
  echo "Dumping Chash2num keys:${!Chash2num[@]}"
fi
for hash in "${!Chash2num[@]}"
do
  if [[ "${verbose}" == "TRUE" ]]
  then
    echo Chash2num[${num}]=${Chash2num[${num}]}
  fhash
  echo hashe "${hash}\t${Cnum2hash[${hash}]}" >> ${tmptarget}
  fi
done
if [[ ! -r "${tmptarget}" ]]
then
  errecho "Could not find '${tmptarget}'"
  exit 1
fi
sort ${tmptarget} > ${target}
rm -f ${tmptarget} ${tmpcanonical}
exit 0
