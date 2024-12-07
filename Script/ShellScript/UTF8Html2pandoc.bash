#!/bin/bash
# 1. vivaldy のbookmark エクスポートでhtml ファイルを保存
# 2. このhtmlファイルを、pandoc -f html -t asciidoc bookmark.html > $HTTPINFO.asciidoc
# 3. bookmark.html のShellScript 部分を切り出す　　　sed -n 10,20p file
# 4. bookmark で章(ShellScript)節(制御・変数等)項(htmlの題目) でディレクトリやasciidoc ファイルを作成する

DTTM=`date +%Y%m%d_%H%M%S`
CMDNM00=${0%\.*}
CMDNM01=${CMDNM00#\./}
URL=$1
HTTPINFO=`basename $URL`
#CREATEDIR="${CMDNM01}_${DTTM}"
CREATEDIR="${DTTM}-$2"
#echo  "CREATEDIR : $CREATEDIR" "HTTP : $HTTPINFO" 
mkdir $CREATEDIR
echo $URL > ${CREATEDIR}/${HTTPINFO}

curl  $URL | pandoc -f html -t asciidoc >  $CREATEDIR/$HTTPINFO.asciidoc

