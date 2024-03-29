#!/bin/bash
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# globalcanonical - define the associative arrays used to hold the
#                   mappings of:
#        hash2num - Map a short hash name to a canonical ID number
#        num2bin - Map a canonical id number to the local path for
#                  the executable script/program
#        num2bits - Map a canonical ID number to the number of bits
#                   that the cryptographic hash program generates
#        num2hexdigits - Map a canonical ID number to the number of
#                        hexadecimal digits generated by the
#                        cryptographic hash program.
#        num2hash - Map a canonical ID number ot the short hash name
#                   that identifies the cryptographic hash program
# More info on Canonical Hash Encoding
# https://www.linkedin.com/posts/sailnfool_activity-6937946456754466817-Cy--?utm_source=linkedin_share&utm_medium=member_desktop_web
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
# License CC by Sea2Cloud Storage, Inc.
# see https://creativecommons.org/licenses/by/4.0/legalcode
# for a complete copy of the Creative Commons Attribution license
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|07/29/2022| Initial Release
#_____________________________________________________________________

if [[ -z "${__hashglobalcanonical}" ]] ; then
  export __hashglobalcanonical=1

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
  if [[ ! -d "${YesFSdir}" ]] ; then
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
