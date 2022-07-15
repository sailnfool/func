#!/bin/bash
if [[ -z "${__hashglobalcanonical}" ]]
then
  export __hashglobalcanonical=1

  ####################################################################
  # More info on Canonical Hash Encoding
  # https://www.linkedin.com/posts/sailnfool_activity-6937946456754466817-Cy--?utm_source=linkedin_share&utm_medium=member_desktop_web
  ####################################################################
  ####################################################################
  # A constant to convert number of hash bits to the number of hex
  # digits to represent those bits
  ####################################################################
  export CHEXBITS=4

  declare -A Cnum2hash
  declare -A Cnum2bin
  declare -A Cnum2bits
  declare -A Cnum2hexdigits
  declare -A Chash2num
  export Cnum2hash
  export Cnum2bin
  export Cnum2bits
  export Cnum2hexdigits
  export Chash2num
  
  export YesFSdir=${HOME}/Dropbox/YesFS
  export YesFSdiretc=${HOME}/Dropbox/YesFS/etc
  if [[ ! -d "${YesFSdir}" ]]
  then
    export YesFSdir=/tmp/YesFS
    export YesFSdiretc=${YesFSdir}/etc
    mkdir -p ${YesFSdiretc}
  fi

  export Fnum2hash="num2hash.csv"
  export Fnum2bin="num2bin.csv"
  export Fnum2bits="num2bits.csv"
  export Fnum2hexdigits="num2hexdigits.csv"
  export Fhash2num="hash2num.csv"
  export Fcanonicalhash="canonical_source.csv"

  export re_canonicalhashnumber="[0-9a-fA-F]{3}"

fi # if [[ -z "${__hashglobalcanonical}" ]]
