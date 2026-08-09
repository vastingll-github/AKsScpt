#!/usr/bin/env bash

readarray -t example_array < "$1"		

echo "${example_array[2]}"
echo ${LINENO}
echo "${example_array[@]}"
echo ${LINENO}
echo "${example_array[*]}"
echo ${LINENO}
echo "${example_array[@]}"
#echo ${LINENO}
#printf "%s\n " "${example_array[@]}"
#echo ${LINENO}
#printf "%s\n " ${example_array[*]}
echo ${LINENO}
echo $example_array
