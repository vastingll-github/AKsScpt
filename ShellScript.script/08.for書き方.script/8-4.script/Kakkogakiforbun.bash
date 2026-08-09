#! /usr/bin/env bash
for ((i=1; i<=10; i++))
do
  echo "$i"
done

for ((i=1, j=1; i <= 10; i++, j+=2)) #（1）〜（3）
do
  ((sum=i+j))               #（4）
  echo $i + $j = $sum           #（5）
done

