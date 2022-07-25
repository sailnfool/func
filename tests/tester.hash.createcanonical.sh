#!/bin/bash
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|07/15/2022| testing hash.createcanonical
#_____________________________________________________________________
#
########################################################################
source hash.globalcanonical
source hash.askcreatecanonical
source hash.loadcanonical
source func.debug

TESTNAME="Test of hash script hashcreatecanonical (hashcreatecanonical.sh) from\n\thttps://github.com/sailnfool/func"
USAGE="\n${0##*/} [-[hv]] [-d <#>]\n
\t-d\t<#>\tSet the diagnostic levels.\n
\t\t\tUse -vh to see debug modes/levels\n
\t-h\t\tPrint this message\r\n
\t-v\t\tVerbose mode to show values\r\n
\t\tVerifies that the function will convert oddly format times into 
\t\tseconds only\n
\t\tNormally emits only PASS|FAIL message\r\n
"

optionargs="d:hv"
verbosemode="FALSE"
verboseflag=""
FUNC_DEBUG=${DEBUGOFF}
fail=0

while getopts ${optionargs} name
do
	case ${name} in
	d)
    if [[ ! "${OPTARG}" =~ $re_digit ]]
    then
      errecho "${0##/*}" "${LINENO}" "-d requires a decimal digit"
      errecho -e "${USAGE}"
      errecho -e "${DEBUG_USAGE}"
      exit 1
    fi
		FUNC_DEBUG="${OPTARG}"
		export FUNC_DEBUG
		if [[ $FUNC_DEBUG -ge ${DEBUGSETX} ]]
		then
			set -x
		fi
		;;
  h)
    errecho -e ${USAGE}
    if [[ "${verbosemode}" == "TRUE" ]]
    then
      errecho -e ${DEBUG_USAGE}
    fi
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

########################################################################
# Step 1: Check that this file is newer than the 
#         hashcreatecanonicalscript file.
########################################################################
canonical_source=/${YesFSdiretc}/${Fhashcanonical}
hashcreatecanonicalscript=${HOME}/github/ren/scripts/hashcreatecanonic.sh
hashtester=${HOME}/github/func/tests/tester.hash.createcanonical.sh
git pull 2>&1 >/dev/null
touchtimes func 2>&1 > /dev/null
if [[ ${hashcreatecanonicalscript} -nt ${hashtester} ]]
then
  errecho "Testing file is out of date"
  errecho "Rebuild 'HERE' files in ${hashtester}"
  errecho "edit ${hashtester}"
  exit 1
fi
########################################################################
# Step 2: Create the temporary copies of the data which will be
#         loaded into the canonical arrays.  Note that if the 
#         canonical hash array is newer than the last date of this
#         file, then these need to be rebuilt and created as HERE
#         files.
########################################################################
tmphash2num=/tmp/${Fhash2num}
tmpnum2bin=/tmp/${Fnum2bin}
tmpnum2bits=/tmp/${Fnum2bits}
tmpnum2hash=/tmp/${Fnum2hash}
tmpnum2hexdigits=/tmp/${Fnum2hexdigits}
cat > ${tmphash2num} << EOFhash2num
b2ppsum	021
b2psum	022
b2sum	01c
b3sum	01f
Blake3sum	020
bsum	014
Gostrsum	007
Havalsum	003
KangarooTwelvesum	01e
md2sum	001
md4sum	002
md5sum	004
md6sum	015
Ripemd-128sum	00a
Ripemd-160sum	00b
Ripemd-256sum	00c
Ripemd-320sum	00d
ripemdsum	005
sha0sum	006
sha1sum	008
sha224sum	012
sha256sum	00e
sha2sum	00f
sha3-224sum	016
sha3-256sum	017
sha3-384sum	018
sha384sum	010
sha3sum	019
sha512sum	011
Shake128sum	01a
Shake256sum	01b
Streebogsum	01d
tigersum	009
whirlpool	013
EOFhash2num
cat > ${tmpnum2bin} << EOFnum2bin
001	
002	
003	
004	/usr/bin/md5sum
005	
006	
007	
008	/usr/bin/sha1sum
009	
00a	
00b	
00c	
00d	
00e	/usr/bin/sha256sum
00f	
010	/usr/bin/sha384sum
011	/usr/bin/sha512sum
012	/usr/bin/sha224sum
013	
014	
015	
016	
017	
018	
019	/usr/bin/sha3sum
01a	
01b	
01c	/usr/bin/b2sum
01d	
01e	
01f	/usr/bin/b3sum
020	
021	/home/rnovak/bin/b2ppsum
022	/usr/local/bin/b2psum
EOFnum2bin
cat > ${tmpnum2bits} << EOFnum2bits
001	128
002	128
003	0
004	128
005	0
006	0
007	0
008	160
009	0
00a	128
00b	160
00c	256
00d	320
00e	256
00f	256
010	384
011	512
012	224
013	512
014	0
015	0
016	224
017	256
018	384
019	224
01a	256
01b	256
01c	512
01d	0
01e	0
01f	256
020	256
021	512
022	512
EOFnum2bits
cat > ${tmpnum2hash} << EOFnum2hash
001	md2sum
002	md4sum
003	Havalsum
004	md5sum
005	ripemdsum
006	sha0sum
007	Gostrsum
008	sha1sum
009	tigersum
00a	Ripemd-128sum
00b	Ripemd-160sum
00c	Ripemd-256sum
00d	Ripemd-320sum
00e	sha256sum
00f	sha2sum
010	sha384sum
011	sha512sum
012	sha224sum
013	whirlpool
014	bsum
015	md6sum
016	sha3-224sum
017	sha3-256sum
018	sha3-384sum
019	sha3sum
01a	Shake128sum
01b	Shake256sum
01c	b2sum
01d	Streebogsum
01e	KangarooTwelvesum
01f	b3sum
020	Blake3sum
021	b2ppsum
022	b2psum
EOFnum2hash
cat > ${tmpnum2hexdigits} << EOFnum2hexdigits
001	32
002	32
003	0
004	32
005	0
006	0
007	0
008	40
009	0
00a	32
00b	40
00c	64
00d	80
00e	64
00f	64
010	96
011	128
012	56
013	128
014	0
015	0
016	56
017	64
018	96
019	56
01a	64
01b	64
01c	128
01d	0
01e	0
01f	64
020	64
021	128
022	128
EOFnum2hexdigits

for filesuffix in num2hash num2bin num2bits num2hexdigits hash2num
do
  filename=$(eval echo \$F${filesuffix})
  tmpdir=/tmp
  diff /tmp/${filename} ${YesFSdiretc}/${filename}
  result=$?
  if [[ ! "${result}" -eq 0 ]]
  then
    stderrecho "${FUNCNAME} *** WARNING *** "\
      "Comparison failed for ${filename}"
  fi
  ((fail += $result ))
done
exit ${fail}
