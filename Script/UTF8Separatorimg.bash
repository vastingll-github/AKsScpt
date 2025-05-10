#!/usr/bin/bash

source ~/GIT/Github-vastingll/Script/DEBUG.bash
PSV_INIT

# コマンドのオプション数のチェックの書き方
# parameteer setting exist?
# [[ comand ]]  = testコマンドと同等
[[ $# -ne 1 ]] && echo -e "このスクリプトは画像データをテキストにエンコードした部分をデコードする。\n\nError!!\n $0 AdocTopDir \n" && exit 1

# find exec 利用方法
#FindLst=`fine . -name *.adoc -exec cp {} {}_img.adoc \;`

# adoc 画像データのbase64データ部分の切出しのため含むファイルを検索する
# base64 でエンコードされた画像テキストデータをデコードするシェルスクリプト
#
#
DATETIME=`date +%Y%m%d_%H%M%S_%3N` 
RetGrafDt="GrafDtSplit_${DATETIME}"

# adoc ファイル内に記述された以下のパターンを検索する
grep -nr "image\:data\:image" $1 | grep base64 | grep \.adoc  > ${RetGrafDt}

# line 例 画像データとしてbase64, で分離する
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc:2:link:/[image:data:image/svg+xml;base64,PHN2ZyB2.......
# ↑                                               ↑        ^^^^^^^^^^^^^^^^^^^^^^^ grep で検索する部分
# ｜                                                Line Number
# File Name 相対パス
while read line
do
	# 一行に「：」が何個あるか確認する
	RIGT=`echo "${line}" | sed -e 's/[^:]//g' `
  #PSV  "RIGT ==> ${#RIGT}"
	# File Info と、GraficDataを分離抽出
  DFGINF00=${line}
	# base64, の「，」の前半と後半に分離
	# 「，」や「；」では分離できない
	# DFLINF01=${DFGINF00#,*}; DFLINF01=${DFGINF00#*,}; DFLINF01=${DFGINF00%%,*}; DFLINF01=${DFGINF00%,*}
	# DFLINF01=${DFGINF00#;*}; DFLINF01=${DFGINF00#*;}; DFLINF01=${DFGINF00%%;*}; DFLINF01=${DFGINF00%;*}

	# %%,* は画像データに「,」が含まれていても後ろからlineの先頭にある「base64,」 まで取除くため
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc:2:link:/[image:data:image/svg+xml;base64,PHN2ZyB2.......
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc:2:link:/[image:data:image/svg+xml;base64
	DFLINF01=${DFGINF00%%,*}
	# #,* は画像データに「,」が含まれていても前からlineにある「base64,」 まで取除くため
	GRAFDT01=${DFGINF00#*,}
		# %% はマッチする後ろから一番長い部分を削除し残りを返却(ディレクトリファイル名取得,行数以降を削除)
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc:2:link:/[image:data:image/svg+xml;base64
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc
	  FNAM=${DFLINF01%%:*}
	  # ディレクトリの切出し 
# 20250308_test/ShellScript大全/6.配列/6-1
	  DNAM=${FNAM%/*}
		# ファイル名の切出し
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc
# 6-1.adoc
	  OFNM=${FNAM##*/}
		# 拡張子adoc を削除したファイル名
    EXFN=${OFNM%.*}
	  # Line Number 抽出 「相対パスファイル名:」 迄一致し残ったLineNumber以降を返却 
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc:2:link:/[image:data:image/svg+xml;base64
# 2:link:/[image:data:image/svg+xml;base64
	  LNUM=${DFLINF01#*:}
		# LineNumber以降のlink:にマッチしLineNumberを返却 
	  ARNM=${LNUM%%:*}
	  # Graphic Data の元ファイル種別抽出
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc:2:link:/[image:data:image/svg+xml;base64
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc:2:https://xxx.yyy.zz〜/[image:data:image/svg+xml;base64
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc:2:link:/[image:data:image/svg+xml
# 20250308_test/ShellScript大全/6.配列/6-1/6-1.adoc:2:https://xxx.yyy.zz〜/[image:data:image/svg+xml
	  GRFD=${LNUM%%;*}
		# svg+xml の抽出
	  GDAT=${GRFD##*/}
	  # フラフィックデータのencode前の拡張子を明確化する(svg+xml部分)
		# svg 切出し 想定では svg+xml, svg+html+xml に対応するため
		GEXT=${GDAT%%+*}
		#GEXT2=${GDAT%%*/}
	#PSV $DFLINF01 #$GRDINF01
  #PSV ${FNAM} ${OFNM} ${EXFN} ${ARNM} ${GEXT}
  #PSV ${FNAM} ${OFNM} ${EXFN} ${ARNM} ${GRFD} ${GDAT} ${GEXT} #${GEXT2}
  #PSV ${OFNM} ${EXFN} ${ARNM} ${GRFD} ${GDAT} ${GEXT} #${GEXT2}

	# 画像データをデコードする
	# ファイル化
	echo -n ${GRAFDT01} > gd_tmp.img
	base64 -d gd_tmp.img > ${DNAM}/${EXFN}_${ARNM}.${GEXT} 2> /dev/null
	rm gd_tmp.img
  # adoc ファイルからimg データを抜取りlink情報を書換える
	PSV ${FNAM}
	if [ -w ${FNAM}.ORG ]; then
	  PSV ${ARNM} ${DNAM} ${EXFN} ${GEXT} ${OFNM}
	  sed -i "${ARNM}c image:~/${DNAM}/${EXFN}_${ARNM}.${GEXT}" ${FNAM} 
  else
	  cp ${FNAM} ${FNAM}.ORG
	  sed -i "${ARNM}c image:~/${DNAM}/${EXFN}_${ARNM}.${GEXT}" ${FNAM} 
  fi
  #sed -e "${ARNM} s;^$;image:~/${DNAM}/excluimg_${EXFN}.${GEXT};" ${FNAM} > ${DNAM}/excluimg_${OFNM} 
  #PSV "${ARNM}c@image:~/${DNAM}/excluimg_${EXFN}.${GEXT}" ${DNAM}/excluimg_${OFNM}

done < ${RetGrafDt}


#rm ${RetGrafDt}
