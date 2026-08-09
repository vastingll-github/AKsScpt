#!/usr/bin/env bash
#
readarray -t onelines < "$1"
for i in "${!onelines[@]}"
do
  if [[ $onln =~ "$2" ]];then
    printf "%6s: %s" $i $onelines[$i]
  fi
done

