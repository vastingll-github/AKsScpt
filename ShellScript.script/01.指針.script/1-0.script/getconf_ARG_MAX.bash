echo -e " コマンド引数（ARG_MAX:コマンドに渡せる引数リストの合計バイト数には上限があり）"
getconf ARG_MAX
echo -e "systemconf all parameter\n"
read YN
getconf -a | less
