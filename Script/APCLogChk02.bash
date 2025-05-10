#!/bin/bash
#set -x
#
# declareの主なオプション（属性の定義、※1）
# 短いオプション	意味
# -a 名前	配列を定義する（※2）
# -A 名前	連想配列を定義する（※3）
# -i 名前	変数を数値（integer）用に定義する
# -l 名前	変数の値を常に小文字にする
# -n 名前	名前参照として定義する（第307回参照）
# -r 名前	定数（readonly）として定義する（値をセットしたい場合、定義時に「declare -r 名前=値」のように記述する）
# -t 名前	トレース可能にする（関数に用いる）
# -u 名前	変数の値を常に大文字にする
# -x 名前	環境変数として定義する（定義と同時にexportされる）
declare -A APLGEM

# 定義：LogFormat フォーマットの定義 フォーマット名
#        記述場所 httpd.conf, VirtualHost 
# 
#        ・フォーマットは複数定義可能
#        ・ログの保存場所指定の CustomLog ディレクティブ設定でどのフォーマットを利用してログ記録するか指定可能
#          CustomLog ディレクティブを使って Apache ログの保存ファイル名、およびログのフォーマット設定可能です。
#          CustomLog ディレクティブの複数記述で、複数ログファイルにログを記録可能。
#            CustomLogディレクティブの使い方
#            指定した環境変数が定義されている場合にだけログを記録する
#            CustomLogディレクティブの使い方
#            ログファイル名およびログのフォーマット設定には CustomLog ディレクティブを使用。
#              CustomLog ログファイル名 フォーマット名 [env=[!]環境変数名]
#              CustomLog ログファイル名 フォーマットの定義 [env=[!]環境変数名]
#            記述できる場所は コンテキスト(サーバ設定ファイル/ バーチャルホスト/ ディレクトリ/ .htaccess)
#            [ https://httpd.apache.org/docs/2.4/ja/mod/directive-dict.html#Context#Context ]
#            httpd.conf, VirtualHost です。
#          ログファイルの名前は ServerRoot からの相対パスを使って指定。
#          例えば ServerRoot のディレクトリの中の logs ディレクトリにある access.log という名前にする場合、
#          ログファイル名は logs/access.log となる。
#          ログのフォーマットは事前に LogFormat ディレクティブで定義したフォーマット名指定、又は LogFormat 
#          ディレクティブと同じ書式を使って直接指定することも可。
#        ・フォーマットの定義は次の設定項目を組み合わせる
# 
# 設定値	意味
# %%	パーセント記号(%)そのもの
# %a	アクセス元のIPアドレス
# %A	サーバ(Apache)のIPアドレス
# %B	送信されたバイト数(ヘッダーは含まず)
# %b	送信されたバイト数(ヘッダーは含まず)。0バイトの時は「-｣
# %D	リクエストの処理時間(マイクロ秒単位)
# %f	リクエストされたファイル名
# %h	アクセス元のホスト名
# %H	リクエストのプロトコル名
# %l	クライアントの識別子
# %m	リクエストのメソッド名
# %p	ポート番号
# %P	プロセスID
# %q	リクエストに含まれるクエリー文字列。空白以外は「?」が付く
# %r	リクエストの最初の行の値
# %s	レスポンスステータス
# %>s	最後のレスポンスのステータス
# %t	リクエストを受け付けた時刻
# %T	処理にかかった時間(秒単位)
# %u	認証ユーザー名
# %U	リクエストのURLパス
# %v	リクエストに対するバーチャルホスト名
# %V	UseCanonicalNameによるサーバ名
# %X	接続ステータス

APLGEM[%a]="%a:アクセス元IP "; APLGEM[%A]="%A:サーバIP "; APLGEM[%h]="%h:アクセス元ホスト名 "
APLGEM[%B]="%B:Snd.バイト数(ヘッダ除外) "; APLGEM[%b]="%b:Snd.バイト数(ヘッダ除外,0byte=[-]) "
APLGEM[%D]="%D:Req.処理時間(micro秒) "; APLGEM[%f]="%f:Req.ファイル名 "; APLGEM[%H]="%H:Req.プロトコル名 "; APLGEM[%m]="%m:Req.メソッド名 "
APLGEM[%l]="%l:クライエント識別子 "
APLGEM[%p]="%p:ポート番号 "
APLGEM[%P]="%P:プロセスID "
APLGEM[%q]="%q:リクエストに含まれるクエリ文字列(空白以外は「?」)"; APLGEM[%r]="%r:リクエストの最初の行の値 "
APLGEM[%s]="%s:レスポンスのステータス "
APLGEM[%>s]="%>s:最後のレスポンスのステータス "
APLGEM[%t]="%t:リクエスト受付時刻 "
APLGEM[%T]="%T:処理時間(秒単位) "
APLGEM[%u]="%u:認証ユーザ名 "
APLGEM[%U]="%U:リクエストのURLパス "; APLGEM[%v]="%v:リクエストに対するVirtualHost名 "
APLGEM[%V]="%V:UseCanonicalNameによるサーバ名 "
APLGEM[%X]="%X:接続ステータス "

# 以下は様々なキーワードが設定されると想定し連想(ハッシュ)配列で定義しない
# 処理時に%{}? の形式は、?で判定しそのまま表示する
# %{クッキー名}C	リクエストに含まれるクッキーの値
# %{環境変数名}e	環境変数名の値
# %{ヘッダー名}i	リクエストに含まれるヘッダー名の値
# %{ヘッダー名}o	レスポンスに含まれるヘッダー名の値
# %{メモ}n	モジュールから渡されるメモの値
# %{フォーマット}t	フォーマットされたリクエストを受け付けた時刻
#
# 注意：logio_module モジュールが利用できる場合は次のフォーマットも使用可能
# 
# 設定値	意味
# %I	受け取ったバイト数
# %O	送信したバイト数
#
# これらの項目を列挙しダブルクォーテーション(")で囲って指定。フォーマット中にダブルクォーテーション記述の場合は
# 「\」でエスケープして記述します。
# 
# 項目の中には {} で囲んで記述される項目があります。
# 例えば %{ヘッダー名}i はヘッダーの中からヘッダー名に指定した値だけを取り出して記録します。
#        %{User-Agent}i と記述した場合はヘッダー中の User-Agent の値を保存します。
# 
# 例えば「アクセス元のIPアドレス」「リクエストされたファイル名」「レスポンスステータス」だけが必要であれば、
# LogFormat ディレクティブを使って次のようなフォーマットを httpd.conf に記述してください。
# 
# LogFormat "%a %f %s" mylogformat
# httpd.conファイルでの記述
# httpd.conf ファイルではデフォルト次の 2 のフォーマットを定義。
# 
# <IfModule log_config_module>
#     #
#     # The following directives define some format nicknames for use with
#     # a CustomLog directive (see below).
#     #
#     LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
#     LogFormat "%h %l %u %t \"%r\" %>s %b" common
# 
#     <IfModule logio_module>
#       # You need to enable mod_logio.c to use %I and %O
#       LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
#     </IfModule>
# 
# </IfModule>
# ￼
# 
# ログのフォーマットとして common および combined 、そして logio_module が利用できる場合には
# combinedio も使用できます。
# 
# common フォーマットは次のような構成になっています。
# ログの保存として common を指定した場合はこれらの情報が 1 行で記録されていきます。
# 
# %h    アクセス元のホスト名
# %l    クライアントの識別子
# %u    認証ユーザー名
# %t    リクエストを受け付けた時刻
# \%r\  リクエストの最初の行の値
# %>s   最後のレスポンスのステータス
# %b    送信されたバイト数
# combined フォーマットは common フォーマットに次のような項目が追加されています。
# 
# \%{Referer}i\     リファラー : 和訳 「参照者」
# \%{User-Agent}i\  User Agent
# combinedio フォーマットは combined フォーマットに次のような項目が追加されています。
# 
# %I  受け取ったバイト数
# %O  送信したバイト数
# これらのデフォルトで用意されるログフォーマットを使用可能でも良いし、
# 新しくフォーマットを定義して使用も可能
# 
# デフォルトの設定では httpd.conf ファイルで CustomLog ディレクティブで common フォーマットが指定されています。
# 
# <IfModule log_config_module>
# 
#     #
#     # The location and format of the access logfile (Common Logfile Format).
#     # If you do not define any access logfiles within a <VirtualHost>
#     # container, they will be logged here.  Contrariwise, if you *do*
#     # define per-<VirtualHost> access logfiles, transactions will be
#     # logged therein and *not* in this file.
#     #
#     CustomLog "logs/access.log" common
# 
# </IfModule>
# ￼
# 
# アクセスログには指定した common フォーマットでログが残っています。
# 
# ・新しいフォーマットを定義する
#   フォーマット名は simple で、アクセス元のIPアドレスとリクエストされたファイル名だけをログに残す。
# 
# LogFormat "%a %f" simple
# httpd.conf に先ほどの 1 行を追加し、 CustomLog ディレクティブに simple を指定します。
# httpd.conf を保存し、 Apache を再起動します。アクセスします。
# 
# ログを確認するために /logs/access.log のファイルを開いてみます。ログファイルの最後に、
# 新しく指定したフォーマットでログが記録されることを確認。
# -- --
# 
#  「ErrorLog」と「LogLevel」の2つ.
#  ErrorLog ディレクティブはログファイルの位置と名称を指定
#  LogLevel ディレクティブは記録するログのレベルを指定
# 
#  レベル	記録される内容
#  emerg	動作不能な状況、Emergency
#  alert	修正しなければ（部分的に）動作できない問題
#  crit	上記に該当しない動作上の問題、Critical
#  error	存在しないファイルへのアクセスなど各種エラー
#  warn	設定のミスなどが考えられる場合、警告、Warning
#  notice	起動停止や設定変更された場合など
#  info	あらゆる情報（プロセスの起動や停止など）
#  debug	Apache関連のデバッグに必要な情報
#  LogLevel notice
#    と指定すると、noticeから上、emerg〜noticeの情報が記録される。
#    - 運用状態のサーバーでは notice か warn
#    - テスト状態であれば、 info か debug

# 連想配列宣言
declare -A ESV

PSV="PSHVAL"
# ログ出力方法でエラー詳細の位置が変化するので以下で指定 Apache , Tomcat
DTAIL_LOCATE01="4-"
DTAIL_LOCATE02="4-"

function PSHVAL() {
  # 打出し変数表示のためのインデックス値
  CNT=0;
  # 呼出された行番号を表示する
  echo -n "==> Call Line: ${BASH_LINENO[0]}  "
  # 配列変数の打出しの場合の対処
  DVN=(${ESV[${BASH_LINENO[0]}]})
  # この関数をコールされた引数を処理する。引数の数は可変なので以下ループで処理
  for i in $@; do
    if [[ ${DVN[${CNT}]} =~ ARRAYALL- || ${DVN[${CNT}]} =~ ARRAY- ]] ;then
      # 配列変数の取得
      ARINDX=`echo ${DVN[${CNT}]} | cut -d"-" -f2-`
      # {}で囲っている場合それを外し、[@]も外す、＄も外す
      # {}で囲っている場合それを外し、＄も外す。[0-9*]の数値は表示のため格納する
      ARVAL=`echo ${ARINDX} | tr -d "{" | tr -d "}" | tr -d "$" | cut -d"[" -f1` 
      # ex ${STPOUT[0]} -> $STPOUT[0] -> STPOUT[0] -> 0] -> 0
      ARINDX01=`echo ${ARINDX} | tr -d "{" | tr -d "}" | cut -d"[" -f2 | tr -d "]" ` 
      echo

      if [[ ${DVN[${CNT}]} =~ ARRAYALL- ]] ;then
##        declare -n ref=$ARVAL
##        for val in ${ref[@]}; do
##          echo -n "36 $ARINDX = [ $val ]"
##        done
         :
      # 様々な配列変数の表示に対応するため、１つ１つ配列を処理する
      elif [[ ${DVN[${CNT}]} =~ ARRAY- ]] ;then
      ##        declare -n ref=$ARVAL
      ##  echo -n "$ARINDX = [ $rel[$ARVAL01] ]"
      :
      fi
    else
      # 呼出し行番号
      # 連想配列ESV[行番号]="PSHVAL $BJ2 $BJ2" をスペースで分割する。cf. ("${ESV[${dim}]}")
      #DVN=(${ESV[${BASH_LINENO[0]}]})
      # 強制的に改行を挿入。デバッグ用変数打出しを目立たせるため
      # 呼出された打出し変数を表示する（大変だった）
      # ESV[行番号]="PSHVAL $fsch3 $FILENAME $CFNAME"のため以下
      echo -n "${DVN[${CNT}]}=[${i}] "
      # CNT はコールするパラメータ変数名表示のため記述
      CNT=`expr $CNT + 1`
    fi
  done
  # 強制的に改行を挿入。デバッグ用変数打出しを目立たせるため２行改行
  echo -e "\n\n"
}

function del_kakko() {
  tr -d "(" < $1 > $APCHANLDIR/ontheway01-1.txt; tr -d ")" < $APCHANLDIR/ontheway01-1.txt > $2
  rm $APCHANLDIR/ontheway01-1.txt
}


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
##########################################################################
#      ここまでデバッグ出力の処理       #
##########################################################################

#1. error retreviews                       ErrexistList.result
#2. display err_num contains in one file  uniqcErrCnt.result
#3. except IP address and Time             DetailErrList.result
#4. Apach error_no retreviews              AHxxExist.result
#5. except apache pid, sid....

ERREXISTLST=ErrExistList.result
UNIQCERRCNT=uniqcErrCnt.result
DETAILERLST=DetailErrList.result
AHxEXISTLST=AHxxExist.result

### シェル変数打出し前処理
# ログファイルの検索処理場所をカレントディレクトリ配下に作成する。
# フォルダ権限等などエラー処理は無視。作業時間をミリ秒で表示し、どの時刻の設定ファイルか明確化する。
DATETIME=`date +%Y%m%d_%H%M%S_%3N`
APCLOGCHK="$DATETIME-LogChk"
mkdir ./${APCLOGCHK}

LOG_ERRCNT="errnum_collct.txt"

## Log ファイルのトップディレクトリ指定チェック
if [ $# -eq 0 ]; then
  echo -e "\n\n       $0 LogsTopDir.....[ex. upload/Logs]\n\n"
	exit 1;
fi

#1. error retreviews                       ErrexistList.result
grep -rin error $1 >  ${APCLOGCHK}/${ERREXISTLST}
if [ ! -s ${APCLOGCHK}/${ERREXISTLST} ]; then
  echo -e "\n\n   $1 配下に、error の記述されるファイルはありません\n\n"
	rm -rf ${APCLOGCHK}
	exit 0;
fi

#2. display err_num contains in one file  uniqcErrCnt.result
# sort 必要ないかも
cat ${APCLOGCHK}/${ERREXISTLST} | cut -d":" -f1 | sort | uniq -c >  ${APCLOGCHK}/${LOG_ERRCNT}

#3. except IP address and Time             DetailErrList.result
cat ${APCLOGCHK}/${ERREXISTLST} | cut -d":" -f"$DTAIL_LOCATE01" >  ${APCLOGCHK}/${DETAILERLST}

echo "EXIT Now"
exit 0

### 読み込む補助設定ファイルの一覧を取得する
# httpd.conf ファイルの中から Include ディレクティブを使用することで補助設定ファイルを読み込む。
# Include ディレクティブを使って読み込むように設定されている補助設定ファイル一覧取得には以下
# 下記オプションを付けてhttpdを実行。補助設定ファイル一覧出力だけで Apache は起動せず。
# apacheの機能にあるものを実行
# httpd -t -D DUMP_INCLUDES
#
# このスクリプト内で使用コマンド：date,echo,grep,mkdir,tr,cut,

# apache2ctl_DUMPINC.txt を設定
# APCHE_DMPINC="httpd_DUMPINC.txt"

echo "作業フォルダ（この時刻での設定ファイルをコピー）作成、結果はこの配下： $APCHANLDIR"
mkdir ~/$APCHANLDIR

# コマンド結果のヘッダ部分を削除
#RHEL:httpd -t -D DUMP_INCLUDES | grep -v "Includeed configuration files:" > $APCHANLDIR/$APCHE_DMPINC
apache2ctl -t -D DUMP_INCLUDES | grep -v "Included configuration files:" >  $APCHANLDIR/$APCHE_DMPINC
# 改行なし(-n)の表示
# #echo -n "#"

# 一番大元の設定ファイル名(httpd.conf)取得
# tr -s " " で２つ以上連続するスペースを１つにして、３つ目のフィールドを取得
ORGhttpd=`grep "\(\*\)" $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f3`
ORGHD=$ORGhttpd
# cp -p でファイル属性を変えずにコピーする
cp -p $ORGhttpd $APCHANLDIR/
#echo -n "#"

## シェル変数置換。
## 「##」は、先頭から一番長いマッチした部分を削除して残りを設定(後で利用)
## 以下は、コマンド basename 同等
ORGHTTPD=${ORGHD##*/}
PSHVAL $ORGHD $ORGHTTPD


### 同じ行番号部分の操作
## 上記Includeするファイルリストで、一行で複数設定ファイルを読込む場合の解析
## ex. Include /etc/httpd/conf.module/*.conf
# ・httpd.confの同じ行から違う複数ファイルを読込む場合、そのファイル群をcat して１ファイルとする
# ・まず一行で複数ファイルを羅列するか、同じ行数が何個あるかDUMPINCをuniq -c で確認しファイル化
# ・tr -s " " で複数のスペースを１つにして結果ファイルとして纏める
# ・デリミタを「Space" "」指定して行番号を取得、後でこの数字を埋込み場所として活用
# ・uniq -c で、同じ行番号の個数を取得
# ・grep -v "1 " で１個のものは連結しないので除外(-v)
# set -x  # 以下のコマンドだけ実行文を表示する設定
cat $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f2 | uniq -c | grep -v "1 " | tr -s " " | cut -d" " -f3 > $APCHANLDIR/anl01.txt
# set +x  # ここまで実行文を表示する設定
# tr -d を利用し、「(」,「)」を削除
# Perl,awk,php,python,sedを利用すれば一行で可能だが、文法が必要ない Command で極力実現
del_kakko $APCHANLDIR/anl01.txt $APCHANLDIR/anl01-2.txt
#echo -n "#"

# Include対象のファイル名はこのツールで決めるので、行番号後ろから操作するので編集
# 「行番号」 「行番号_confs」
# file内容例：
#   225 225_confs
#   355 355_confs
# Perl で後方置換を実施して編集
perl -pe 's?([0-9]+)?$1 $1_confs?' $APCHANLDIR/anl01-2.txt > $APCHANLDIR/anl01-3.txt
#echo -n "#"

### 単一の行番号部分の操作
# 行数(数字)が同じ個数を数える(uniq -c)。
# 複数行１行となることを利用して単一の行だけファイル化する
#                                          ↓s行番号だけ取出し
#                                                          ↓s複数の行番号を数えあげ(Spaceがまた入る)
# 先頭行(*)の削除 grep -v "\(\*\)"
cat $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f2 | uniq -c | tr -s " " | grep "1 " |  cut -d" " -f3 | grep -v "\(\*\)" > $APCHANLDIR/anl02.txt
# tr -d を利用し、「(」,「)」を削除
del_kakko $APCHANLDIR/anl02.txt $APCHANLDIR/anl02-1.txt
#echo -n "#"

# tac 用ファイル作成
cat $APCHANLDIR/$APCHE_DMPINC | tr -s " " | cut -d" " -f2 | uniq -c | grep "1 " | grep -v "\(\*\)" | tr -s " " | cut -d" " -f3 > $APCHANLDIR/tac01.txt
#echo -n "#"



###  file($APCHANLDIR/anl01.txt) から１行づつ読込 grep して複数のファイルを繋げる
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
    #echo -n "#"
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

  #echo -n "#"
done < $APCHANLDIR/tac01.txt

# 行番号と対応するファイルを記述した anl0[12]-4.txt をソートして連結
cat $APCHANLDIR/anl01-3.txt $APCHANLDIR/anl02-4.txt | sort -r > $APCHANLDIR/anlfin.txt
#rm $APCHANLDIR/anl01-3.txt $APCHANLDIR/anl02-4.txt
#echo -n "#"


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

  #echo -n "#"
done < $APCHANLDIR/anlfin.txt


# 不要ファイル削除
rm $APCHANLDIR/anl01*.txt $APCHANLDIR/anl02*.txt $APCHANLDIR/tac01.txt

#echo "#"
echo
# ErrorLog Add , mylog 汎用化
pcre2grep -Mnri 'LogLevel|BufferedLogs|CustomLog|SetEnvIf|GlobalLog|TransferLog|^LogFormat [\s\S\w.]* vhost_combined [\w]*|^LogFormat [\s\S\w.]* combined [\w\W]*|^LogFormat [\s\S\w.]* common [\w\W]*|^LogFormat [\s\S\w.]* referer [\w\W]*|^LogFormat [\s\S\w.]* agent [\w\W]*|^LogFormat [\s\S\W.]*\n' /etc/apache2/apache2.conf > $APCHANLDIR/LogSettingINFO.important

echo "完了"


