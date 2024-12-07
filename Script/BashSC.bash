#!/bin/bash

line="abcaBcabcaBc" from="[bB]" to="-"

# 最初の一個だけ置換
if [[ $line =~ $from ]]; then
  line=${line/"$BASH_REMATCH"/"$to"}
fi
echo "$line" # => a-caBcabcaBc

# 全置換
tmp=''
while [[ $line =~ ($from) ]]; do
   tmp="${tmp}${line%%"$BASH_REMATCH"*}${to}"
   line="${line#*"$BASH_REMATCH"}"
done
line="${tmp}${line}"
echo "$line" # => a-ca-ca-ca-c

