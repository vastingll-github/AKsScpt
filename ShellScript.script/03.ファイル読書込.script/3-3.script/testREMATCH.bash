#!/bin/bash
string="User ID: 12345"
# 正規表現（数字部分にマッチ）
regex="[0-9]+"

if [[ "$string" =~ $regex ]]; then
    # 一致した文字列
    matched_text="${BASH_REMATCH[0]}"
		echo "REMATCH: ${BASH_REMATCH[0]}" "matched: $matched_text"
    
    # 一致した位置を取得（${string%%$matched_text*} でマッチした部分の手前までの文字列の長さを計算）
    position=$((${#string%%$matched_text*} + 1))
    
    echo "一致した文字列: $matched_text"
    echo "一致した位置: $position"       # 結果: 10
fi
