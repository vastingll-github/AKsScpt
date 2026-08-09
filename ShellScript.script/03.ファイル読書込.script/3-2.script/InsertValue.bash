#!/usr/bin/env bash

txtfile=$(cat $1)		
echo $txtfile
txtfile=($(cat $1))
echo ${txtfile[1]} ${txtfile[2]} ${txtfile[4]} ${textfile[7]} ${textfile[9]}
set OFS="\n"
echo ${txtfile[@]}
