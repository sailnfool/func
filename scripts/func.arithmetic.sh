#!/bin/bash
if [ -z "$__funcarithmetic" ]
then
  export __funcarithmetic=1

	function func_intmin()
	{
	  echo $(( $1 < $2 ? $1 : $2 ))
	}
	export -f func_intmin
	function func_intmax()
	{
	  echo $(( $1 > $2 ? $1 : $2 ))
	}
	export -f func_intmax
#
# round up a number to the nearest value.  This is only integer
# arithmetic so, call will look like:
# func_introundup(number, 100) to round a number up to the next
# multiple of 100.  Similar for 10 or 1000.  
	function func_introundup()
	{
    local number
    local nearest

		number=$1
		nearest=$2
		if [ -z "$nearest" ]
		then
			exit 1
		elif [ $nearest -eq 0 ]
		then
			exit 1
		fi
		(( number+=nearest ))
		(( number-= ((number%nearest))))
		echo $number
	}
	export -f func_introundup
fi
# vim: filetype=sh
