LF="
"
for i in $(seq ${2:-10000}); do
  data=''
  while IFS= read -r line; do
    data="${data}${line}${LF}"
  done < "$1"
  data="${data}${line}" # 最終行に改行がない場合の処理です
done

