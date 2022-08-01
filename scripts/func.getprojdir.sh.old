if [[ -z "${__stcfuncgetprojdir}" ]] ; then
	export __stcfuncgetprojdir=1
	##########
	# getprojdir
	#
	# This function returns the parent directory of a project within the 
	# "projectbase" tree
	##########
	function getprojdir() {
		numparms=2
		project="$1"
		projectbase="$2"
		if [[ $# -lt ${numparms} ]] ; then
			insufficient ${LINENO} ${FUNCNAME} ${numparms} $@
			exit -1
		fi
		if [[ -z ${project} ]] ; then
			nullparm ${LINENO} ${FUNCNAME} "1"
		fi
		if [[ -z ${projectbase} ]] ; then
			nullparm ${LINENO} ${FUNCNAME} "2"
			exit -1
		fi
		if [[ ! -d ${projectbase} ]] ; then
			nullparm ${LINENO} ${FUNCNAME} "3"
			exit -1
		fi
		projdir=$(find ${projectbase} -name ${project} -a -type d -a -print | sed -e "/\.archive/d")
		echo $projdir
	##########
	# End of function getprojdir
	##########
	}
	export -f getprojdir
fi
