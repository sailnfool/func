#!/bin/bash
####################
# Copyright (c) 2019 Sea2Cloud
# 3901 Moorea Dr.
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
# 2.1 | REN |06/27/2020| brought up to date with getopts
# 2.0 | REN |12/03/2019| Modified to use more source'd functions
# 1.1 | REN |07/29/2010| Installed new prolog, cleaned up the
#                      | temporary files on exit and added a 
#                      | correct exit code
# 1.0 | REN |07/22/2010| Initial Release
#_____________________________________________________________________
#
# source func.config
####################
# set up local variables for debugging
####################
configure_debug=0
configure_verbose=0
pingertmp=/tmp/pinger.$$
mkdir -p $pingertmp
####################
# USAGE
#
# pinger 	-h # Show Usage
#		-v # Verbose Mode
#		-p <IP Prefix>
#		-n <netmask for IPrefix>
#		-g <gateway for addr>
#		-I <Low PING port>
#		-O <High Ping port>
####################
Subnet=$(hostname -I | sed -e 's/\.[^\.]*$//')
netdevice=$(ip route list default | cut -f 5 -d ' ')
netmask=$(ifconfig "$netdevice" | awk '/netmask/{ print $4;}')
Gateway=$(ip r | grep default | awk -F " " '{print $3}')
USAGE="${0##*/} [-hv] [-p <IP Prefix] [-n IP netmask] [-g <gateway>]\n
\t\t[-I <low ping>] [-O <high ping>]\n\n
\t-h\t\t\tDisplay this message\n
\t-v\t\t\tVerbose Mode\n
\t-p\t<IP Prefix>\tDefault on this machine is $Subnet\n
\t-n\t<netmask>\tDefault on network on this device is $netdevice\n
\t\t\t\tDefault netmask on this machine is $netmask\n
\t-g\t<gateway>\tDefault on this machine is $Gateway\n
\t-I\t<low ping port>\tDefault is ${Subnet}.1\n
\t-O\t<high ping port\tDefault is ${Subnet}.255\n
"

configure_verbose=0
configure_IPrefix=0
configure_IPnetmask=0
configure_gateway=0

####################
# Set the Subnet and Mask Parameters
#
# This is the subnet 
####################
configure_IPrefix=1
Subnet=$(hostname -I | sed -e 's/\.[^\.]*$//')
#Subnet="10.0.11"
configure_IPnetmask=1

####################
# Gateway Addresses
####################
Gateway=$(ip route list default | cut -d ' ' -f 3)

####################
# Set the subnet port numbers for devices
#
# Low Port Number on Mergepoint for PING diagnostic
# High Port Number on Mergepoint for PING diagnostic
####################
Low_PING_Port=1
High_PING_Port=255

####################
# USAGE
#
# pinger 	-h # Show Usage
#		-v # Verbose Mode
#		-p <IP Prefix>
#		-n <netmask for IPrefix>
#		-g <gateway for addr>
#		-I <Low PING Address>
#		-O <High Ping Address>
####################
optionargs="hdI:g:n:O:p:v"
NUMARGS=0
if [ ${configure_debug} = 1 ]
then
	echo "Parameters are $*"
fi
while getopts ${optionargs} name
do
	case ${name} in
	-h)	echo -ne ${USAGE}; exit 0;;
	-d)	configure_debug=1; ;;
	-v)	configure_verbose=1; set -x; ;;
	-p)	Subnet=${OPTARG}; configure_IPrefix=1; ;;
	-n)	netmask=${OPTARG}; configure_IPnetmaks=1; ;;
	-g)	Gateway=${OPTARG}; configure_gateway=1; ;;
	-I)	Low_PING_Port=${OPTARG}; configure_LowPING=1; ;;
	-O)	High_PING_Port=${OPTARG}; configure_HighPING=1; ;;
	\?)	errecho "invalid option -${OPTARG}"; \
		errecho "-e" ${USAGE}; exit 1; ;;
	esac
done
shift "$((${OPTIND} - 1 ))"
if [ $# != ${NUMARGS} ]
then
	echo -ne ${USAGE}
	exit 2
fi

if [ $(which arp | wc -l) -ne 1 ]
then
	sudo sudo apt-get update && sudo apt-get install net-tools
fi
if [ ${configure_debug} = 1 ]
then
	echo configure_verbose=${configure_verbose}
	echo Subnet=${Subnet}
	echo netmask=${netmask}
	echo Gateway=${Gateway}
	echo Low_PING_Port=${Low_PING_Port}
	echo High_PING_Port=${High_PING_Port}
fi

####################
# Set the names of various temporary files.
#
# Set the file name for the PING logging
####################
filepinglog="pingit"
grepall="grepall"
greplog="greplog"

####################
# Set the full pathnames for the various files.
#
# Set the ping logging path and file
####################
pinglog=${pingertmp}/${filepinglog}
grepallfile=${pingertmp}/${grepall}
greplogfile=${pingertmp}/${greplog}

####################
# Set various sleep timers
#
# Sleeptime after Ping
####################
pingsleep=1
####################
# provision BMCs
####################
rm -f ${pinglog}
for i in `seq ${Low_PING_Port}     ${High_PING_Port}`
do
	####################
        # 1 Ping to each node
	#  This can be sped up a great deal by making the ping process
	#  a background process that sends the output to a unique file
	#  in /tmp and then dumping all of the processes that worked.
	####################
        ping -w 1 -c 1 ${Subnet}.${i} >> ${pinglog}-${i} 2>&1 &
done

if [ ${configure_debug} = 1 ]
then
	set -x
fi

####################
# Wait for the background processes to finish.
####################
if [ $# -lt 1 ]
then
  sleeptime=10
else
  sleeptime=$1
fi
echo "${0##*/} ${LINENO} sleeping for $sleeptime seconds"
sleep $sleeptime
wait

####################
# get the list of files that had 100% loss
####################
grep -l "100% packet loss" ${pinglog}-* | sort -u > ${greplogfile}

####################
# Now get the list of all files
####################
ls ${pinglog}-* > ${grepallfile}

responders=0
####################
# take the difference between the two sets and generate a list of ports
# that answered, then echo the full IP address of those machines.
####################
for i in `diff ${grepallfile} ${greplogfile} | sed -n -e "s/^<.*-\(.*\)$/\1/p"`
do
  address_name=$(arp ${Subnet}.${i} | tail -1 | awk '{print $1}')
  if [ "${address_name}" = "${Subnet}.${i}" ]
  then
    address_name="HWtype=$(arp ${Subnet}.${i} | tail -1 | awk '{print $2}')"
  fi
  echo -e "${Subnet}.${i}\t${address_name}"
	responders=`expr ${responders} + 1`
done

####################
# Unless we are debugging, clean up all of the temporary files
####################
if [ $configure_debug = 0 ]
then
	rm -f ${grepallfile} ${greplogfile} ${pinglog}-*
fi

####################
# If we are verbose, then tell how many systems answered the pings
####################
if [ ${configure_verbose} = 1 ]
then
	echo "${0##*/}: ${responders} answered"
fi
rm -rf $pingertmp
####################
# if there were no responses then exit with an error
####################
if [ ${responders} -gt 0 ]
then
	exit 0
else
	exit 257	# Since it is impossible for 257 nodes on a subnet
fi
