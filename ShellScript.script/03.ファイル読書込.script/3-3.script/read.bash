#!/usr/bin/env bash
#
while read onln
do
	if [[ $onln =~ "VVVVVVVVV" ]];then
		echo $onln
##	else
##		echo "NOT $onln"
	fi
done  < "$1"

