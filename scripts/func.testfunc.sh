#!/bin/bash
source func.errecho
source func.arithmetic
source func.random
source func.genrange
# for i in $(gen_range 1 $1)
# do
# 	num=$(func_intrandom 1000)
# 	for k in 10 15 100 150 175 250
# 	do
# 		echo "${num} $(func_introundup ${num} $k)"
# 	done
# done
for i in $(gen_range 1 $1)
do
	randrange=1000
#	num=$(od -N4 -i -An /dev/urandom)
#	((num=num<0?-num:num))
#	((num=num%randrange))
	num=$(func_intrandomrange $randrange)
	for k in 10 15 100 150 175 250
	do
		echo "${num} $(func_introundup ${num} $k)"
	done
done
