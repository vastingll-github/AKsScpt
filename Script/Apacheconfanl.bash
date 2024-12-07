#!/bin/bash
#set -x

function PSHVAL() {
	CNT=1;
	echo -n "==> Call Line:${BASH_LINENO[0]}  "
	for i in $@; do
		echo -n "$CNT:[$i] "
		CNT=`expr $CNT + 1`
	done
	echo
}

function del_kakko() {
  tr -d "(" < $1 > $APCHANLDIR/ontheway01-1.txt
  tr -d ")" < $APCHANLDIR/ontheway01-1.txt > $2
	rm $APCHANLDIR/ontheway01-1.txt
}


#読み込む補助設定ファイルの一覧を取得する
#httpd.conf ファイルの中から Include ディレクティブを使用することで補助設定ファイルを読み込む。( Include ディレクティブについては「Includeディレクティブ：補助設定ファイルを読み込む」を参照。
#Include ディレクティブを使って読み込むように設定されている補助設定ファイル一覧取得には以下実行
#httpd -t -D DUMP_INCLUDES
#上記オプションを付けてhttpdを実行。補助設定ファイル一覧出力だけで Apache は起動せず。
#
# 使用コマンド：date,echo,grep,mkdir,tr,cut,

# apache2ctl_DUMPINC.txt を設定
#APCHE_DMPINC="httpd_DUMPINC.txt"
APCHE_DMPINC="apache2ctl_DUMPINC.txt"

# 設定ファイルを編集するので、カレントディレクトリ配下に編集フォルダを作成する。
# フォルダ権限等などエラー処理は無視。作業時間をミリ秒で表示し、どの時刻の設定ファイルか明確化する。
DATETIME=`date +%Y%m%d_%H%M%S_%3N`
# カレントディレクトリにナノ秒の時刻ディレクトリを作成し、Apcheのコンフィグをコピーして解析する
APCHANLDIR="$DATETIME-apacheconf"
echo "作業フォルダ（この時刻での設定ファイルをコピーする）作成： $APCHANLDIR"
mkdir ~/$APCHANLDIR

# コマンド結果のヘッダ部分を削除
#RHEL:httpd -t -D DUMP_INCLUDES | grep -v "Includeed configuration files:" > $APCHANLDIR/$APCHE_DMPINC
apache2ctl -t -D DUMP_INCLUDES | grep -v "Included configuration files:" >  $APCHANLDIR/$APCHE_DMPINC
# 改行なし(-n)の表示
echo -n "#"

# 一番大元の設定ファイル名(httpd.conf)取得
# tr -s " " で２つ以上連続するスペースを１つにして、３つ目のフィールドを取得
ORGhttpd=`grep "\(\*\)" $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f3`
ORGHD=$ORGhttpd
# cp -p でファイル属性を変えずにコピーする
cp -p $ORGhttpd $APCHANLDIR/
echo -n "#"
# シェル変数置換。## は、先頭から一番長いマッチした部分を削除して残りを設定(後で利用)；コマンド basename 同等 
ORGHTTPD=${ORGHD##*/}


### 同じ行番号部分の操作
## 上記Includeするファイルリストで、一行で複数設定ファイルを読込む場合の解析 ex. Include /etc/httpd/conf.module/*.conf
# 同じ行から違う複数ファイルを読込む場合は、そのファイル群をcat で連結して１ファイルにする
# まず一行で複数ファイルを羅列するため、同じ行数が何個あるか確認しファイル化
# tr -s " " で複数のスペースを１つにして結果ファイルとして纏める
# デリミタを「Space" "」指定して行番号を取得、後でこの数字を埋込み場所として活用
# uniq -c で、同じ行番号の個数を取得
# grep -v "1 " で１個のものは連結しないので除外(-v)
cat $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f2 | uniq -c | grep -v "1 " | tr -s " " | cut -d" " -f3 > $APCHANLDIR/anl01.txt
# tr -d を利用し、「(」,「)」を削除
# Perl,awk,php,python,sedを利用すれば一行で可能だが、文法が必要ない Command で極力実現
del_kakko $APCHANLDIR/anl01.txt $APCHANLDIR/anl01-2.txt
echo -n "#"

# Include対象のファイル名はこのツールで決めるので、行番号後ろから操作するので編集
# 「行番号」 「行番号_confs」
# file内容例：
#   225 225_confs
#   355 355_confs
# Perl で後方置換を実施して編集
perl -pe 's?([0-9]+)?$1 $1_confs?' $APCHANLDIR/anl01-2.txt > $APCHANLDIR/anl01-3.txt 
echo -n "#"

### 単一の行番号部分の操作
# 行数(数字)が同じ個数を数える(uniq -c)。複数行１行となることを利用して単一の行だけファイル化する
#                                          ↓s行番号だけ取出し
#                                                          ↓s複数の行番号を数えあげ(Spaceがまた入る)
# 先頭行(*)の削除 grep -v "\(\*\)"
cat $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f2 | uniq -c | tr -s " " | grep "1 " |  cut -d" " -f3 | grep -v "\(\*\)" > $APCHANLDIR/anl02.txt
# tr -d を利用し、「(」,「)」を削除
del_kakko $APCHANLDIR/anl02.txt $APCHANLDIR/anl02-1.txt
echo -n "#"

# tac 用ファイル作成
cat $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f2 | uniq -c | grep "1 " | grep -v "\(\*\)" | tr -s " " | cut -d" " -f3 > $APCHANLDIR/tac01.txt
#cat $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f2 | uniq -c | grep "1 " | grep -v "\(\*\)" | tr -s " " | cut -d" " -f3 > $APCHANLDIR/tac01.txt
echo -n "#"



###  file($APCHANLDIR/anl01.txt) から１行づつ読込grep して複数のファイルを繋げる
while read search
do
  FN=${search}; FN0=${FN%*)}; FN1=${FN0#\(*}
  # 一行で複数ファイルの場合の編集場所を作成
  EDITDIR=$APCHANLDIR/${FN1}_${DATETIME}
  mkdir $EDITDIR
  #  echo "1FN = ${FN1}"
  # 一行で複数ファイルをIncludeする場合、ファイル名の羅列を取得する
  FNM=`grep "${search}" $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f3`
  # "$FNM" ダブルクォートしてループを回すと改行を含むのでループしない、パラメータ指定形式注意要！！
  #  for HFNM in "$FNM" ; do
  for HFNM in $FNM ; do
  #    echo "$FN ==> [ $HFNM ]"
    OBFNM=$HFNM
    OBFNM2=${OBFNM##*/}
    #    echo "FN1 OBFNM2 : $FN1 $OBFNM2"
    cp -p $HFNM $EDITDIR/${FN1}_${OBFNM2}
    sed -i "1i #======= [ $HFNM ] =======(vi){\n" $EDITDIR/${FN1}_${OBFNM2}
    echo "#------- [ added($HFNM) ] -------}" >> $EDITDIR/${FN1}_${OBFNM2}
    echo -n "#"
  done
  #IFS=$' '
  # 「行番号_conf」のファイル名に、一行で複数ファイルの羅列を追記する
  echo -n "# " > $APCHANLDIR/${FN1}_confs
  echo $FNM >> $APCHANLDIR/${FN1}_confs
  #cat $FNM >> $APCHANLDIR/${FN1}_confs
  cat $EDITDIR/${FN1}_?* >> $APCHANLDIR/${FN1}_confs
  #cat `grep "${search}" $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f3` >> $APCHANLDIR/${FN1}_confs
	#rm -rf $EDITDIR
  echo "#------- [ added($HFNM) ] -------" >> $APCHANLDIR/${FN1}_confs
  #echo "検索対象は、 ${search}"
done < $APCHANLDIR/anl01.txt

### 単一ファイルとしてIncludeするファイルをコピーしヘッダー・フッターを追加
while read fsch
do
#echo "検索対象は、 ${fsch}"
  FN=${fsch}
  fsch2=${fsch%)}; fsch3=${fsch2#(}
  #echo "2fsch3 $fsch3"
  FNM=`grep "${fsch}" $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f3`
  #echo "4FNM $FNM"
  FNM2=${FNM##*/}
  CPFNAME="$fsch3"_"$FNM2"
	PSHVAL $fsch3 $FNM2 $CPFNAME
  echo "$fsch3 $CPFNAME" >> $APCHANLDIR/anl02-4.txt
  #  echo "CPFNAME $CPFNAME"
  cp $FNM $APCHANLDIR/$CPFNAME
  sed -i "1i #======= [ $FNM ] =======(vi){\n" $APCHANLDIR/$CPFNAME
  #  sed "1 s/^/#======= [ $FNM ] =======\n/" $APCHANLDIR/$CPFNAME
  echo "#------- [ added($FNM) ] -------}" >> $APCHANLDIR/$CPFNAME

  echo -n "#"
done < $APCHANLDIR/tac01.txt

# 行番号と対応するファイルを記述した anl0[12]-4.txt をソートして連結
cat $APCHANLDIR/anl01-3.txt $APCHANLDIR/anl02-4.txt | sort -r > $APCHANLDIR/anlfin.txt
#rm $APCHANLDIR/anl01-3.txt $APCHANLDIR/anl02-4.txt
echo -n "#"


# anlfin.txt 内容より、Includeするファイル群を行末より追加読込して上書きする
cp -p $APCHANLDIR/$ORGHTTPD $APCHANLDIR/${ORGHTTPD}_edit

while read line
do
#echo "解析対象 ${line}"
  BJ=${line}; BJ2=`echo $BJ | cut -d" " -f1`; BJ3=`echo $BJ | cut -d" " -f2`
	PSHVAL $BJ2 $BJ3
	sed -e "$BJ2 s/^Include/# Include/g" < $APCHANLDIR/${ORGHTTPD}_edit > $APCHANLDIR/${BJ2}_${ORGHTTPD}
  cat $APCHANLDIR/${BJ2}_${ORGHTTPD} | sed "$BJ2 r $APCHANLDIR/$BJ3" > $APCHANLDIR/${ORGHTTPD}_edit
	rm $APCHANLDIR/${BJ2}_${ORGHTTPD}

  echo -n "#"
done < $APCHANLDIR/anlfin.txt


# 不要ファイル削除
rm $APCHANLDIR/anl01*.txt $APCHANLDIR/anl02*.txt $APCHANLDIR/tac01.txt

echo "#"
echo "完了"

