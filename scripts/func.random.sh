#!/bin/bash
if [ -z "$__funcintrandom" ]
then
	export __funcintrandom=1

	function func_intrandom()
	{
		num=$(od -N4 -i -An /dev/urandom)
		((num=num<0?-num:num))
		echo $num
	}
	export -f func_intrandom
	
	function func_intrandomrange()
	{
		num=$(func_intrandom)
		echo $(expr $num % $1)
	}
	export -f func_intrandomrange
fi # if [ -z "$__funcintrandom" ]
