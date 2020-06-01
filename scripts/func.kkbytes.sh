#!/bin/ksh
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 1.0 | REN |05/26/2020| original version
#_____________________________________________________________________
#
####################
if [ -z "${__funckbibytes}" ]
then
	export __funckbibytes=1
	####################
	####################
	__kbibytesuffix="BKMGTPEZ"
	__byte=1
	__kilobyte=${__byte} * 1000
	__megabyte=${__kilobyte} * 1000
	__gigabyte=${__megabyte} * 1000
	__terabyte=${__gigabyte} * 1000
	__petabyte=${__terabyte} * 1000
	__etabyte=${__petabyte} * 1000
	__zetabyte=${__etabyte} * 1000
	__kibibyte=${__byte} * 1024
	__mibibyte=${__kibibyte} * 1024
	__gibibyte=${__mibibyte} * 1024
	__tibibyte=${__gibibyte} * 1024
	__pibibyte=${__tibibyte} * 1024
	__etibyte=${__pibibyte} * 1024
	__zibibyte=${__etibyte} * 1024
	export __kbibytesuffix
	export __byte
	export __kilobyte
	export __megabyte
	export __gigabyte
	export __terabyte
	export __petabyte
	export __etabyte
	export __zetabyte
	export __kibibyte
	export __mibibyte
	export __gibibyte
	export __tibibyte
	export __pibibyte
	export __etibyte
	export __zibibyte
	####################
	####################
fi # if [ -z "${__funckbibytes}" ]
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78

