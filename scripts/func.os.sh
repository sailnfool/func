#!/bin/bash
########################################################################
# Copyright (C) 2022 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# func_os - Debian dependent, report OS release info
#
# func_idlike - Debian dependent, report a  debia like OS
#
# func_os_version_id - Debian dependent report a version ID
# 
# func_arch - Debian dependent report the underlying CPU architecture
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.0 |REN|01/24/2022| Initial Release
#_____________________________________________________________________

########################################################################
# func_os
# Find the name of the installled operating system
########################################################################
if [ -z "${__funcos}" ]
then
  export __funcos=1

  function func_os() {
    echo $(sed -ne '/^ID=/s/^ID=\(.*\)$/\1/p' < /etc/os-release)
  }
  #################### 
  # end of function func_os
  #################### 
  export -f func_os
fi # if [ -z "${__funcos}" ]

########################################################################
# func_idlike
# Find the release famile
########################################################################
if [ -z "${__funcidlike}" ]
then
  export __funcidlike=1

  function func_idlike() {
    echo $(sed -ne '/^ID_LIKE=/s/^ID_LIKE=\(.*\)$/\1/p' < /etc/os-release)
  }
  #################### 
  # end of function func_idlike
  #################### 
  export -f func_idlike
fi # if [ -z "${__funcidlike}" ]

########################################################################
# func_os_version_id
# Find the name of the installled operating system
########################################################################
if [ -z "${__funcos_version_id}" ]
then
  export __funcos_version_id=1

  function func_os_version_id() {
    echo $(sed -ne '/^VERSION_ID=/s/^VERSION_ID=\(.*\)$/\1/p' < /etc/os-release)
  }
  #################### 
  # end of function func_os
  #################### 
  export -f func_os_version_id
fi # if [ -z "${__funcos_version_id}" ]

########################################################################
# func_arch
# Find the name of the installled operating system
########################################################################
if [ -z "${__funcarch}" ]
then
  export __funcarch=1

  function func_arch() {
    echo $(uname -m)
  }
  #################### 
  # end of function func_arch
  #################### 
  export -f func_arch
fi # if [ -z "${__funcarch}" ]
