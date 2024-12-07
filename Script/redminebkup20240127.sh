#!/bin/bash

#set -x 

# ファイル名のヘッド部分の日付作成
fnmhd=`date +%Y%m%d%H%M%S`
pgbkupfnm=$fnmhd"_"pgsqlbkup.pgdump
filesbkupdir=$fnmhd"_"filesbkup

echo "pgbkupfnm:"$pgbkupfnm
echo "filesbkupdir:"$filesbkupdir

# バックアップディレクトリのファイル数格納（世代数）データディレクトリ
DBLST=`ls -r /media/kintyan3/0123-4567/redmineBackUp/`
FDIR=`ls -r /media/kintyan3/0123-4567/redmineFiles/files/`

#echo ${#DBLST}
#echo $DBLST
#echo ${#FDIR}
#echo $FDIR

# PostgreSQLのバックアップデータの世代管理
let cnt=0;
for dblst in $DBLST
do
#  echo $dblst
  let cnt++;
#  echo "CNT:"$cnt;
done
# 世代数の判定で以上であれば削除してバックアップ
if [ $cnt -ge 12 ]; then
#  echo "EXIT:"$fnmhd"_" $cnt;
  rm -f /media/kintyan3/0123-4567/redmineBackUp/$dblst
#  exit;
fi

# redmine のPostgreSQLのバックアップ
# ubuntu20.04 
#set PGPASSWORD=rie65michi;pg_dump -U redmine -h localhost -Fc --file=/media/kintyan3/0123-4567/redmineBackUp/$pgbkupfnm redmine
# ubuntu22.04
export PGPASSWORD=rie65michi;pg_dump -U redmine -h localhost -Fc --file=/media/kintyan3/0123-4567/redmineBackUp/$pgbkupfnm redmine


# redmine のfiles配下のバックアップデータの世代管理
let cnt=0;
for fdir in $FDIR
do
#  echo $fdir
  let cnt++;
#  echo "CNT:"$cnt;
done
# 世代数の判定で以上であれば削除してバックアップ
if [ $cnt -ge 12 ]; then
  echo "EXIT:"$fnmhd"_" $cnt;
  rm -rf /media/kintyan3/0123-4567/redmineFiles/files/$fdir
#  exit;
fi

# redmine のfilesディレクトリのバックアップ
mkdir /media/kintyan3/0123-4567/redmineFiles/files/$filesbkupdir
cp -rp /var/lib/redmine/files/* /media/kintyan3/0123-4567/redmineFiles/files/$filesbkupdir/

exit 0;

