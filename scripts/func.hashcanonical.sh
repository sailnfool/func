#!/bin/bash
if [[ -z "${__canonicalarrays}" ]]
then
  __canonicalarrays=1

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
  
  export YesFSdir=/home/rnovak/Dropbox/YesFs

  export Fnum2hash="num2hash.csv"
  export Fnum2bin="num2bin.csv"
  export Fnum2bits="num2bits.csv"
  export Fnum2hexdigits="num2hexdigits.csv"
  export Fhash2num="hash2num.csv"

fi # if [[ -z "${__canonicalarrays}" ]]