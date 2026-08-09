#!/usr/bin/env bash
set -x

time sh cat.sh ./test.txt > shcat1.result 2>&1
time sh read.sh ./test.txt > shread1.result 2>&1
time bash cat.sh ./test.txt > bashcat1.result 2>&1
time bash read.sh ./test.txt > bashread1.result 2>&1
time ksh cat.sh ./test.txt > kshcat1.result 2>&1
time ksh read.sh ./test.txt > kshread1.result 2>&1

time sh cat.sh ./test.txt > shcat2.result 2>&1
time sh read.sh ./test.txt > shread2.result 2>&1
time bash cat.sh ./test.txt > bashcat2.result 2>&1
time bash read.sh ./test.txt > bashread2.result 2>&1
time ksh cat.sh ./test.txt > kshcat2.result 2>&1
time ksh read.sh ./test.txt > kshread2.result 2>&1

time sh cat.sh ./test.txt > shcat3.result 2>&1
time sh read.sh ./test.txt > shread3.result 2>&1
time bash cat.sh ./test.txt > bashcat3.result 2>&1
time bash read.sh ./test.txt > bashread3.result 2>&1
time ksh cat.sh ./test.txt > kshcat3.result 2>&1
time ksh read.sh ./test.txt > kshread3.result 2>&1

time sh cat.sh ./test.txt > shcat4.result 2>&1
time sh read.sh ./test.txt > shread4.result 2>&1
time bash cat.sh ./test.txt > bashcat4.result 2>&1
time bash read.sh ./test.txt > bashread4.result 2>&1
time ksh cat.sh ./test.txt > kshcat4.result 2>&1
time ksh read.sh ./test.txt > kshread4.result 2>&1

time sh cat.sh ./test.txt > shcat5.result 2>&1
time sh read.sh ./test.txt > shread5.result 2>&1
time bash cat.sh ./test.txt > bashcat5.result 2>&1
time bash read.sh ./test.txt > bashread5.result 2>&1
time ksh cat.sh ./test.txt > kshcat5.result 2>&1
time ksh read.sh ./test.txt > kshread5.result 2>&1

time sh cat.sh ./test.txt > shcat6.result 2>&1
time sh read.sh ./test.txt > shread6.result 2>&1
time bash cat.sh ./test.txt > bashcat6.result 2>&1
time bash read.sh ./test.txt > bashread6.result 2>&1
time ksh cat.sh ./test.txt > kshcat6.result 2>&1
time ksh read.sh ./test.txt > kshread6.result 2>&1

time sh cat.sh ./test.txt > shcat7.result 2>&1
time sh read.sh ./test.txt > shread7.result 2>&1
time bash cat.sh ./test.txt > bashcat7.result 2>&1
time bash read.sh ./test.txt > bashread7.result 2>&1
time ksh cat.sh ./test.txt > kshcat7.result 2>&1
time ksh read.sh ./test.txt > kshread7.result 2>&1

time sh cat.sh ./test.txt > shcat8.result 2>&1
time sh read.sh ./test.txt > shread8.result 2>&1
time bash cat.sh ./test.txt > bashcat8.result 2>&1
time bash read.sh ./test.txt > bashread8.result 2>&1
time ksh cat.sh ./test.txt > kshcat8.result 2>&1
time ksh read.sh ./test.txt > kshread8.result 2>&1

time sh cat.sh ./test.txt > shcat9.result 2>&1
time sh read.sh ./test.txt > shread9.result 2>&1
time bash cat.sh ./test.txt > bashcat9.result 2>&1
time bash read.sh ./test.txt > bashread9.result 2>&1
time ksh cat.sh ./test.txt > kshcat9.result 2>&1
time ksh read.sh ./test.txt > kshread9.result 2>&1

time sh cat.sh ./test.txt > shcatX.result 2>&1
time sh read.sh ./test.txt > shreadX.result 2>&1
time bash cat.sh ./test.txt > bashcatX.result 2>&1
time bash read.sh ./test.txt > bashreadX.result 2>&1
time ksh cat.sh ./test.txt > kshcatX.result 2>&1
time ksh read.sh ./test.txt > kshreadX.result 2>&1

