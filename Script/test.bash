#!/bin/bash

function testres() {
	echo $0
	echo $#
	echo $@
	echo $1, $2, $3, $4, $5, $6, $7
	CNT=1;
	for i in $@
	do
		echo -n "$CNT:$i "
		CNT=`expr $CNT + 1`
	done
	echo
}

testres aa bb cc dd ee ff
