#!/usr/bin/env bash
set -Ceu

#   echo -e "$color_code""$@"'\e[m' 
#
# Terminal のコマンドラインの色情報
#
# NC='\033[0m'  テキストの色をデフォルトにリセットする変数を定義
# 出力色の変更
# 先述した \e[0m でリセット可能。
# 文字色        背景色  色
# BLACK='\e[30m'
# RED='\033[0;31m'      赤色のテキストの ANSI エスケープ コードを使用して変数を定義
# GREEN='\e[32m'
# YELLOW='\e[33m'
# BLUE='\e[34m'
# MAGENTA='\e[35m'
# SYAN='\e[36m'
# WHITE='\e[37m'
#
# 出力色の変更（拡張）
# 文字色          背景色          内容
# \e[38;5;nm      \e[48;5;nm      nを0～255のカラーコードを指定
# \e[38;2;r;g;bm  \e[48;2;r;g;bm  RGBでのカラーコードを指定
# 注：ターミナルによって対応してる/してないが分かれる
# （対応端末少ない）
#
# 文字出力例: 太字・薄字・斜字・下線字・背景字・黒字・？
# 文字色      背景色  内容
# \e[1m               太字
# \e[2m               薄く表示
# \e[3m               イタリック
# \e[4m               アンダーライン
# \e[5m               ブリンク開始
# \e[6m               高速ブリンク
# \e[7m               文字色と背景色の反転
# \e[8m               表示を隠す（コピペ可能）
# \e[9m               取消
# \033[25m            ブリンク停止
# \033[0m             全てのリセット
# \033[2J             画面のクリア。画面全体をクリアし、一旦リセットする。
# \e[6m               高速ブリンク
# \e[7m               文字色と背景色の反転
# \e[8m               表示を隠す（コピペ可能）
# \e[9m               取り消し
# \e[31m      \e[41m  赤
# \e[32m      \e[42m  緑
# \e[33m      \e[43m  黄色
# \e[34m      \e[44m  青
# \e[35m      \e[45m  マゼンダ
# \e[36m      \e[46m  シアン
# \e[37m      \e[47m  白

# プロジェクトフォルダの絶対パス取得
cd "$(dirname "$0")"  # このスクリプトがあるフォルダに移動
cd ./                 # ＝ここをプロジェクトフォルダとします。
dir_project=$(pwd)

# 共通部分読み込み
. "$dir_project/coloring_msg.bash"

# 使用
ECHO_TXTYELLOW  'ちょっと'"$SHELL"'黄色いハンカチ'"$SHELL"'大好き'
ECHO_TXTRED  'ちょっと'"$SHELL"'黄色いハンカチ'"$SHELL"'大好き'
ECHO_TXTGREEN  'ちょっと'"$SHELL"'黄色いハンカチ'"$SHELL"'大好き'
ECHO_TXTMAGENTA  'ちょっと'"$SHELL"'黄色いハンカチ'"$SHELL"'大好き'
ECHO_TXTCYAN  'ちょっと'"$SHELL"'黄色いハンカチ'"$SHELL"'大好き'
ECHO_TXTWHITE  'ちょっと'"$SHELL"'黄色いハンカチ'"$SHELL"'大好き'
ECHO_TXTLOG  'ちょっと'"$SHELL"'黄色いハンカチ'"$SHELL"'大好き'
ECHO_WEBERR  'ちょっと'"$SHELL"'黄色いハンカチ'"$SHELL"'大好き'

echo "太字 薄くItalc  UL_ Blnq  高B 反転 隠蔽 取消" 
# 文字・文字色・背景色指定出力確認
for i in {1..9} {30..37} {40..47}; do
    printf '\e[%dmBASH\e[m ' $i 
    if [[ "$i" -eq "9" ]];then
      echo -en "\n"
      echo -en "色\n  黒   赤   緑   黄   青   朱   水   白\n" 
    fi
    if [[ "$i" -eq "37" ]];then
      echo -en "\n"
      echo -en "反転\n  黒   赤   緑   黄   青   朱   水   白\n" 
    fi
done
echo
# 文字色
#for i in {30..37}; do
#    printf '\e[%dm%d\e[m ' $i $i 
#done
#echo

# 背景色
#for i in {40..47}; do
#    printf '\e[%dm%d\e[m ' $i $i 
#done
#echo

# echo -e "\n====\n"
# # 文字色      背景色  内容
# echo -e '\e[1m'BASH'\e[0m'
# echo -e '\e[2m'BASH'\e[0m'
# echo -e '\e[3m'BASH'\e[0m'
# echo -e '\e[4m'BASH'\e[0m'
# echo -e '\e[5m'BASH'\e[0m'
# echo -e '\e[5m'BASH5'\e[25m'
# echo -e '\e[6m'BASH'\e[0m'
# echo -e '\e[6m'BASH6'\e[0m'
# echo -e '\e[7m'BASH'\e[0m'
# echo -e '\e[8m'BASH'\e[0m'
# echo -e '\e[9m'BASH'\e[0m'
# echo -e '\033[25m'
# echo -e '\033[0m'
