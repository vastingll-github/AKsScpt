#!/bin/bash
#set -x

declare -A ESV

PSV="PSV"

# 他ファイル定義の関数呼出し
# source PSV_FUNCTIONS
# . PSV_FUNCTIONS

function PSV_INIT() {
	#RED_MSG $0
  ### シェル変数打出しのデバッグ文出力ための前処理
  # 打出し関数を利用する行を取得し、表示したい変数名を打出しに利用したい
  # sed や tail,head （千行以上ではtail・headが早い)でPSHVAL行を取得可能だがgrep -n で検索
  STPOUT=(`grep -n ${PSV} $0 | grep -v "^[0-9]*:[ \t]*#" | grep -v function | grep -v "PSV=" | tr -s " " | cut -d" " -f1-`)
  
  # ダブルクォーテーションで括ると改行を入れる
  for i in "${STPOUT[@]}"; do
  #for i in ${STPOUT[@]}; do
    # シェル変数の正規表現利用は以下のようにする。expre 比較1:比較2 もある
    # シェル変数が配列"[]"を含むか判定する
    if [[ $i =~ [0-9]*: ]] ;then
      GNUM=`echo $i | cut -d":" -f1`; TMPSV=`echo $i | cut -d":" -f2`
      if [[ -v $TMPSV ]] ;then
        STPOUT01[$GNUM]+=" $GNUM"; STPOUT01[$GNUM]+=" $TMPSV"
      fi
      ##else
      ##  ESV[$GNUM]+=" ${PSV}"
      ##fi
    elif [[ $i =~ \[@\] ]] ;then
      ESV[$GNUM]+=" ARRAYALL-${i}"; STPOUT01[$GNUM]+=" ${i}"
    elif [[ $i =~ \[[0-9]*\] ]] ;then
      ESV[$GNUM]+=" ARRAY-${i}"; STPOUT01[$GNUM]+=" ${i}"
    else
      if [[ ${i} =~ $PSV ]] ;then
        :
      else
        # 連想配列にスペースを入れながら追加する
        # result_ex. ESV[22]="PSHVAL $BJ2 $BJ3 .." 
        ESV[$GNUM]+=" ${i}"; STPOUT01[$GNUM]+=" ${i}"
      fi
    fi
    #echo "97 GNUM($GNUM): " ${STPOUT01[$GNUM]}
  done
}

function PSV() {
  # 打出し変数表示のためのインデックス値
  CNT=0;
  # 呼出された行番号を表示する
  echo -n "==> Call Line: ${BASH_LINENO[0]}  "
  # 配列変数の打出しの場合の対処
  DVN=(${ESV[${BASH_LINENO[0]}]})
  # この関数をコールされた引数の表示処理をする。引数の数は可変なので以下ループで処理
  for i in $@; do
    # 呼出された行番号表示。呼出しの打出し変数を表示する（大変だった）
    # 連想配列ESV[行番号]="PSHVAL $BJ2 $BJ2" をスペースで分割する。cf. ("${ESV[${dim}]}")
    # ESV[行番号]="PSHVAL $fsch3 $FILENAME $CFNAME"のため以下
    echo -n "${DVN[${CNT}]}=[${i}] "
    # CNT はコールするパラメータ変数名表示のため記述
    CNT=`expr $CNT + 1`
  done
  # 強制的に改行を挿入。デバッグ用変数打出しを目立たせるため
  echo
}

function del_kakko() {
  tr -d "(" < $1 > $APCHANLDIR/ontheway01-1.txt; tr -d ")" < $APCHANLDIR/ontheway01-1.txt > $2
  rm $APCHANLDIR/ontheway01-1.txt
}

function CP_MSG() {
	# echo -e ： backslash でEscapeSeaguenceを有効化するオプション
	# NC='\033[0m'	テキストの色をデフォルトにリセットする変数を定義
  # 出力色の変更
  # 先述した \e[0m でリセット可能。
# 文字色	背景色	色
	# BLACK='\e[30m'
	# RED='\033[0;31m'	赤色のテキストの ANSI エスケープ コードを使用して変数を定義
  # GREEN='\e[32m'
	# YELLOW='\e[33m'
  # BLUE='\e[34m'
	# MAGENTA='\e[35m'
	# SYAN='\e[36m'
  # WHITE='\e[37m'
  #   # 出力色の変更（拡張）
  #   # \e[38;5;nm	\e[48;5;nm	nを0～255のカラーコードを指定
  #   # \e[38;2;r;g;bm	\e[48;2;r;g;bm	RGBでのカラーコードを指定
  #   # 注：ターミナルによって対応してる/してないが分かれる
  #   # （対応端末少ない）
  # 


  case "$1" in
    red)
      color_code='\e[31m'
			echo -e ${color_code}$2
      ;;
    green)
      color_code='\e[32m'
			echo -e ${color_code}$2
      ;;
    yellow)
      color_code='\e[33m'
			echo -e ${color_code}$2
      ;;
    magenta)
      color_code='\e[36m'
			echo -e ${color_code}$2
      ;;
  esac

	# 文字出力例: 太字・薄字・斜字・下線字・背景字・黒字・？
  # 文字色	背景色	内容
	# \e[1m	太字
  # \e[2m	薄く表示
  # \e[3m	イタリック
  # \e[4m	アンダーライン
  # \e[5m	ブリンク
  # \e[6m	高速ブリンク
  # \e[7m	文字色と背景色の反転
  # \e[8m	表示を隠す（コピペ可能）
  # \e[9m	取り消し
	# for ((i = 1; i <= 9; i++)); do
  #  printf '\e[%dm%d\e[m ' $i $i
	# done
	#
  # \e[31m	\e[41m	赤
  # \e[32m	\e[42m	緑
  # \e[33m	\e[43m	黄色
  # \e[34m	\e[44m	青
  # \e[35m	\e[45m	マゼンダ
  # \e[36m	\e[46m	シアン
  # \e[37m	\e[47m	白
}

function RED_MSG() {
  echo -e '\e[31m'$1'\e[0m'
}
function GREEN_MSG() {
  echo -e '\e[32m'$1'\e[0m'
}
function YELLOW_MSG() {
  echo -e '\e[33m'$1'\e[0m'
}
function BLUE_MSG() {
  echo -e '\e[34m'$1'\e[0m'
}
function MAGEND_MSG() {
  echo -e '\e[35m'$1'\e[0m'
}
function CYAN_MSG() {
  echo -e '\e[36m'$1'\e[0m'
}
function WHITE_MSG() {
  echo -e '\e[37m'$1'\e[0m'
}
