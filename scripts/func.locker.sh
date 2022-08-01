#!bin/bash
########################################################################
# Copyright (C) 2021 Robert E. Novak  All Rights Reserved
# Modesto, CA 95356
########################################################################
#
# locker - Creates directories for storing test results.  Each
#          test is give a unique test number.  Implements the
#          following functions:
#        func_getlock - acquire a lock
#        func_release - release a lock
#        getcounter - get the current count
#        putcounter - modify the counter
#        getnextcounter - bump the counter before the next use.
# Set up Global variables for testing scripts
# Define func_getlock and func_release to avoid conflicts
#
# Author: Robert E. Novak
# email: sailnfool@gmail.com
#_____________________________________________________________________
# Rev.|Aut| Date     | Notes
#_____________________________________________________________________
# 1.1 |REN|03/25/2021| added getcounter putcounter getnextcounter
# 1.0 |REN|03/15/2021| original version
#_____________________________________________________________________

if [[ -z "${__func_locker}" ]] ; then
	export __func_locker=1
	
	source func.errecho
  source func.regex

  ####################
  # Directories that must be created by func_setuplocks
  ####################
	export HOME_RESULTS=${HOME_RESULTS:-${HOME}/.results}
	export TESTDIR=${TESTDIR:-${HOME_RESULTS}/testdir}
	export ETCDIR=${ETCDIR:-${TESTDIR}/etc}

  ####################
  # Files that must be created by func_setuplocks
  ####################
	export LOCKERRS=${ETCDIR}/lockerrs
	export TESTLOG=${HOME_RESULTS}/testlog.txt
	export LOCKFILE_TESTNUMBERFILE=${HOME_RESULTS}/TESTNUMBER.lock
	export LOCKFILE_BATCHNUMBERFILE=${HOME_RESULTS}/BATCHNUMBER.lock

  ####################
  # The maximum number of spins allowed waiting for a lock
  ####################
	export MAXSPINS=10
  export SPINWAIT=20

	####################
	# updating the following requires locking
	####################
	export TESTNUMBERFILE=${HOME_RESULTS}/TESTNUMBER
	export BATCHNUMBERFILE=${HOME_RESULTS}/BATCHNUMBER
	####################
	# End of files that need locking
	####################

  ############################################################
	# func_getlock lockfile sleeptime maxspins
  ############################################################
	func_getlock()
	{
    local func_getlock_USAGE
    local lockfile
    local lockcount
    local sleeptime
    local maxspins
    local OLD_FUNC_VERBOSE

    func_getlock_USAGE="func_getlock [ <lockfile> [<sleeptime> [<spincount>]]]\n
\t\twhere <lockfile> is the lockfile to acquire\n
\t\tand <sleeptime> is the maximum seconds to wait for acquisition\n
\t\tand <spincoun> is the number of times to wait for <sleeptime>\n
"
		lockcount=0
		sleeptime=1
		maxspins="${MAXSPINS}"
		OLD_FUNC_VERBOSE=${FUNC_VERBOSE}
		FUNC_VERBOSE=1

		maxspins=${MAXSPINS}
    case $# in
      0)
  			errecho "${FUNCNAME}" "${LINENO}" \
  			    "No lockfile specified"
        errecho "${func_getlock_USAGE}"
  			exit 1
        ;;
      1)
			  lockfile="$1"
        ;;
      2)
			  lockfile="$1"
				if [[ ! "$2" =~ $re_integer ]] ; then
					errecho "${FUNCNAME}" "${LINENO}" \
						"Not a number - $2"
          errecho "${func_getlock_USAGE}"
					exit 1
				fi
				sleeptime="$2"
        ;;
      3)
			  lockfile="$1"
				if [[ ! "$2" =~ $re_integer ]]; then
					errecho "${FUNCNAME}" "${LINENO}" \
						"Not a number - $2"
          errecho "${func_getlock_USAGE}"
					exit 1
				fi
				sleeptime="$2"
				if [[ ! "$3" =~ $re_integer ]]; then
					errecho "${FUNCNAME}" "${LINENO}" \
						"Not a number - $3"
          errecho "${func_getlock_USAGE}"
					exit 1
				fi
				maxspins="$3"
        ;;
      \?)
        errecho "${FUNCNAME}" "${LINENO}" \
          "Invalied arguments $@"
        errecho "${func_getlock_USAGE}"
        exit 1
        ;;
    esac

		while [[ -f "${lockfile}" ]]
		do
			errecho "${FUNCNAME}" "${LINENO}" \
				"Sleeping on lock acquisition for lock owned by"
			errecho "${FUNCNAME}" "${LINENO}" \
				$(ls -l "${lockfile}" | cut -d " " -f 3)
			((++lockcount))
			if [[ "${lockcount}" -gt "${maxspins}" ]] ; then
				errecho "${FUNCNAME}" "${LINENO}" \
					"Exceeded ${maxspins} spins waiting for lock, quitting"
				exit 1
			fi
			sleep ${sleeptime}
		done
		FUNC_VERBOSE="${OLD_FUNC_VERBOSE}"
		touch "${lockfile}"

	}
	export -f func_getlock

	################################################################
	# func_releaselock lockfile
	################################################################
	func_releaselock()
	{

    local lockfile

		if [[ $# -eq 0 ]] ; then
			errecho "${FUNCNAME}" "${LINENO}" \
			    "No lockfile specified"
			exit 1
		fi
    lockfile="$1"
    if [[ -f "${lockfile}" ]] ; then
		  rm -f "${lockfile}"
    else
      errecho ${FUNCNAME} ${LINENO} \
        "Nothing to release, ${lockfile} not found"
    fi
	}
	export -f func_releaselock

  ############################################################
  # func_setuplocks
  ############################################################
  func_setuplocks()
  {
    mkdir -p ${HOME_RESULTS} ${TESTDIR} ${ETCDIR} 
    touch ${LOCKERRS} ${TESTLOG}

    if [[ ! -r ${BATCHNUMBERFILE} ]] ; then
      func_getlock ${LOCKFILE_BATCHNUMBERFILE}
      echo 0 > ${BATCHNUMBERFILE}
      func_releaselock ${LOCKFILE_BATCHNUMBERFILE}
    fi
    if [[ ! -r ${TESTNUMBERFILE} ]] ; then
      func_getlock ${LOCKFILE_TESTNUMBERFILE}
      echo 0 > ${TESTNUMBERFILE}
      func_releaselock ${LOCKFILE_TESTNUMBERFILE}
    fi
  }
  export -f func_setuplocks

	################################################################
	# Get a batch number for batch of tests
	################################################################
	func_getbatchnumber()
	{
    local value
    value=$(func_getnextcounter "${LOCKFILE_BATCHNUMBERFIL}" \
      "${BATCHNUMBERFILE}")
		echo "${value}"
	}
	export -f func_getbatchnumber

	################################################################
	# Get a test number for a test
	################################################################
	func_gettestnumber()
	{
    local value

    value=$(func_getnextcounter "${LOCKFILE_TESTNUMBERFILE}" \
      "${TESTNUMBERFILE}")
		echo "${value}"
	}
	export -f func_gettestnumber

  ############################################################
  # get a counter value
  ############################################################
  func_getcounter()
  {
    local value

    if [[ $# -ne 2 ]] ; then
      insufficient 2
    fi
    func_getlock "$1"
    if [[ ! -r "$2" ]] ; then
      echo 0 > "$2"
    fi
    value=$(cat "$2")
    func_releaselock "$1"
    echo "${value}"
  }
  export -f func_getcounter

  ############################################################
  # put a counter value
  ############################################################
  func_putcounter()
  {
    if [[ $# -ne 3 ]] ; then
      insufficient 3
    fi
    func_getlock "$1"
    echo "$3" > "$2"
    func_release "$1"
  }
  export -f func_putcounter

  ############################################################
  # get the next counter value
  ############################################################
  func_getnextcounter()
  {

    local value

    if [[ $# -ne 2 ]] ; then
      insufficient 2
    fi
    value=$(func_getcounter "$1" "$2")
    ((value++))
    func_putcounter "$1" "$2" "${value}"
  }
  export -f func_getnextcounter
fi # if [[ -z "${__func_locker}" ]]
