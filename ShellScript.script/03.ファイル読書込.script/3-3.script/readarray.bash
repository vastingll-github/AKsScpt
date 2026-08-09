#!/usr/bin/env bash
#
readarray -t onelines < "$1"
# 配列を読込でIFSで繋げられる”スペース”を削除するため設定方法
IFS=''
# Bash配列を1変数にする時、配列の展開結果がスペースで区切られるを防ぐため、@ の代わりに * を使い、全体をダブルクォーテーションで囲む必要あり
alllines="${onelines[*]}"
# [ ... =~ ... ]] 条件式でパターンマッチングを行い、組み込み変数 BASH_REMATCH を活用します。
while [[ ${alllines} =~ "$2" ]];do
  match_txt="${BASH_REMATCH[0]}"
# 先頭から一番短いキーワード迄の文字を削除して残りを文字列を取得
# 一致した位置を計算（${alllines%%$match_txt*} でマッチ部分手前までの文字列の長さを計算可能）
# 以下は一致した位置より後の文字列を取得する
	afstr=${alllines#*${match_txt}}
	apos=$((${#afstr}))
	echo "Keyword[${match_txt}] 後の12バイト文字:${afstr:0:12}"
# 見つかったキーワードより後の文字列に検索範囲を絞る
	alllines="${alllines#*${match_txt}}"

done

