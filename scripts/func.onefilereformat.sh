#!/bin/bash
####################
# onefilereformat
#
# This function reformats a single file to wrap lines and make
# sure that sentences start after a newline character
#
# onfilereformat <file> <sourcedir> <targetdir>
#
# A rewrite of this would use the syntax of:
#	onefilereformat <sourcedir>/<file> <targetdir>
####################
# Author - Robert E. Novak aka REN
#	sailnfool@gmail.com
#	skype:sailnfool.ren
#_____________________________________________________________________
# Rev.|Auth.| Date     | Notes
#_____________________________________________________________________
# 2.0 | REN |11/14/2019| added vim directive and header file
# 1.0 | REN |09/06/2018| original version
#_____________________________________________________________________
#
####################
if [ -z "${__funconefilereformat}" ]
then
	export __funconefilereformat=1
	function onefilereformat() {
		numparms=3
		sourcefile="$1"
		sourcedir="$2"
		destdir="$3"
		if [ $# -lt ${numparms} ]
		then
			insufficient ${numparms} $@
		fi
		if [ -z "${sourcefile}" ]
		then
			nullparm "1"
		fi
		if [ -z "${sourcedir}" ]
		then
			nullparm "2"
		fi
		if [ -z "${destdir}" ]
		then
			nullparm "3"
		fi

		if [ ! -d ${destdir} ]
		then
			mkdir -p ${destdir}
		fi
		if [ ! -d ${sourcedir} ]
		then
			errecho "Source ${sourcedir} directory not present"
			exit -1
		fi
		if [  ! -f ${sourcedir}/${sourcefile} ]
		then
			errecho "Source file ${sourecedir}/${souecefile} file not present"
			exit -1
		fi
		cp ${sourcedir}/${sourcefile} /tmp/${sourcefile}$$

		##########
		# in case the source file did not include a \n at the end of the
		# file we do this to avoid having "fmt" or asciidoctor-pdf throw
		# an error message.
		##########
		echo "" >> /tmp/${sourcefile}$$

		##########
		# We tell "fmt" to generate "standard output which includes
		# two spaces after a sentence.  When we find a "." or "?" followed
		# by two spaces, we replace that with a \r\n to insure that any
		# new sentences start on a new line.  Then we do a cleanup since
		# text copied from email messages sometimes have a \r but no \n
		# so we detect those instances and fix them.  We also delete
		# spaces that may occur at the end of a line.
		##########

		fmt -s -u /tmp/${sourcefile}$$ | \
			sed -e 's/\([\.\?]\)[ ]{2,2}/\1\r\n/g' \
				-e 's/\r[^\n]/\r\n/' \
				-e 's/\r\n/\n/g'  \
				-e 's/ \n/\n/g' \
				-e 's/ \r/\r/g' > ${destdir}/${sourcefile}
	#			tr -d '\r' > ${destdir}/${sourcefile}
		rm /tmp/${sourcefile}$$
	##########
	# End of function onefilereformat
	##########
	}
	export -f onefilereformat
fi # if [ -z "${__funconefilereformat}" ]
# vim: set syntax=bash, lines=55, columns=120,colorcolumn=78
