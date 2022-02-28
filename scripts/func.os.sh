#!/bin/bash
####################
# Copyright (c) 2022 Sea2Cloud
# Modesto, CA 95356
# 408-910-9134
#
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |01/24/2022| Initial Release
#_____________________________________________________________________
#

########################################################################
# Author: Robert E. Novak
# email: sailnfool@gmail.com
#
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
