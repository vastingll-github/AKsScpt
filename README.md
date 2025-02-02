# AKsScpt
All Kinds of Script


からPCPへの道

目次
PCP情報の提供依頼
想定する構成
解析方法
収集対象サーバでの参照
集約収集サーバでの参照
ディレクトリ指定
ファイル指定
ホスト指定
解析環境での参照
ディレクトリ指定
ファイル指定
時間指定
（参考）アーカイブ圧縮
メトリクスを用いた解析
メトリクス検索
メトリクスの値の表示
vmstat -n / pmstat
top / pcp atop
iostat -d -x / pcp iostat
netstat -antuweeop / pcp ss
pidstat -u -l / pcp pidstat -l
pidstat -r -l / pcp pidstat -r -l
cat /proc/meminfo / pminfo -t mem.util | grep meminfo
cat /proc/net/dev / pminfo -t network.interface | grep /proc/net
cat /proc/net/snmp, netstat -s / pminfo -t network.tcp , pminfo -t network.udp, pminfo -t network.icmp
df -Ta / pminfo -t filesys
sar -b, sar -d / pcp atopsar -d
sar -B / pcp atopsar -p
sar -F / pminfo -t | grep filesys
sar -H / pminfo -t | grep hugepage
sar -r / pcp atopsar -m
sar -u / pcp atopsar -c
sar -w / pminfo -t | grep context
sar -y / pminfo -t | grep tty
sar -I / pminfo -t | grep interrup
sar -S, sar -W / pcp atopsar -s

PCP情報の提供依頼
PCPを用いてリソース情報を確認するためにPJに依頼すべき資材を以下に示す。
バージョン	RHEL、Rockyのバージョン。以下のコマンドで取得    release version sysname machine(architecht) nodename distro
# cat /etc/redhat-release | pminfo -f kernel.uname

CPU,Mem?
# pminfo -f kernel.percpu.cpu.sys

ファイル	調査対象のサーバの以下のフォルダ配下のファイルすべて
 /var/log/pcp/pmlogger/ 
このセクションを編集
想定する構成
本資料で想定する構成を以下に示す。

分類	         ホスト名	 所掌	     役割	                                       PCPアーカイブログ
集約収集サーバ	pcp00	   PJ	      複数の収集対象サーバからPCPのデータを集めるサーバ	 /var/log/pcp/pmlogger/pcp00
収集対象サーバ	web01	   PJ	      収集対象のサーバ。業務を行っているサーバ	         /var/log/pcp/pmlogger/web01
解析環境	     OST01	   OSTセンタ	PJ提供のPCP情報を解析環境。OST担当の解析環境     /root/pcp/web01
このセクションを編集
解析方法
収集したPCP情報を集約収集サーバで参照する方法、収集対象サーバでリアルタイムにPCP情報を参照する方法、PJから提供されたPCP情報をOSTセンタの解析環境で参照する方法、各環境でメトリクスを用いて解析する方法を示す。
コマンド例としてpmstatを使用しているが、他のPCPコマンドでも同様に各オプションを使用可能
-aや-hなどのオプションを使用しない場合、コマンドを実行している自サーバのシステム情報を取得するので要注意

このセクションを編集 
収集対象サーバでの参照
収集対象サーバで自サーバのpmstatを表示する方法を示す

コマンド
web01 # pmstat
このセクションを編集
集約収集サーバでの参照
集約収集サーバで収集対象サーバのpmstatを表示する方法を示す
本項の以降の「ディレクトリ指定」「ファイル指定」のコマンド・説明はOSSセンタ報告資料「2.5 PCP を使った解析の流れ」から抽出

このセクションを編集
ディレクトリ指定
アーカイブファイルが存在するディレクトリを指定してpmstatを表示する方法を示す
コマンド
pcp00 # pmstat -a /var/log/pcp/pmlogger/web01
このセクションを編集
ファイル指定
アーカイブファイルを指定してpmstatを表示する方法を示す
コマンド
pcp00 # pmstat -a /var/log/pcp/pmlogger/web01/20250101
次の理由から、本書では特に断りのない限り、ディレクトリ指定を使用する。

ファイル指定をするには事前に ls などで当該ファイル名を確認する必要がある
ファイル指定は日付をまたいだ解析を行いたい場合に適さない
これらの他に下記の指定方法がある。

このセクションを編集
ホスト指定
ホストを指定して、そのホストでの現在のpmstatの実行結果を表示する方法を示す。
指定したホストと接続されている必要がある。
コマンド
pcp00 # pmstat -h web01
このセクションを編集
解析環境での参照
pmlogger配下を受領していれば「収集対象サーバでの参照」と同様にディレクトリを指定する。

このセクションを編集
ディレクトリ指定
コマンド
OST01 # pmstat -a /root/pcp/pcp00/
このセクションを編集
ファイル指定
コマンド
OST01 # pmstat -a /root/pcp/pcp00/20250101
このセクションを編集
時間指定
時間を範囲指定してpmstatの実行結果を表示する方法を示す

コマンド
OST01 # pmstat -a /root/pcp/pcp00/　-S '@2025-01-01 10:00:00' -T '@10:10:00'
このセクションを編集
（参考）アーカイブ圧縮
複数日のアーカイブファイルを1つのファイルに圧縮する方法を示す

コマンド
OST01 # pmlogextract input_archive1 input_archive2... output_file
このセクションを編集
メトリクスを用いた解析
このセクションを編集
メトリクス検索
コマンド
1.mem.utilで始まるメトリクスのうち、メトリクス名または説明文にmeminfoを含むものを検索
# pminfo -t mem.util | grep meminfo

2.全てのメトリクスのうち、メトリクス名または説明文にfilesysを含むものを検索
# pminfo -t | grep filesys
このセクションを編集
メトリクスの値の表示
1. 現在のメトリクスの値を表示
コマンド
# pminfo --fetch mem.util.used
出力
mem.util.used
    value 1789188
2. メトリクスの値を1秒間隔で表示し続ける
コマンド
# pmval mem.util.used
出力
metric:    mem.util.used
host:      localhost.localdomain
semantics: instantaneous value
units:     Kbyte
samples:   all
              1798256
              1798256
              1798256
              1798256
              1798256
              1798756
3. kernel.cpu.util からはじまるメトリクスの値を 1 秒間隔で表示し続ける
コマンド
# pmrep kernel.cpu.util
出力
  k.c.u.user  k.c.u.nice  k.c.u.sys  k.c.u.idle  k.c.u.intr  k.c.u.wait  k.c.u.steal

         N/A         N/A        N/A         N/A         N/A         N/A          N/A
       0.000       0.000      0.249      99.793       0.249       0.000        0.000
       0.000       0.000      0.000      99.756       0.000       0.000        0.000
       0.000       0.000      0.000      99.785       0.250       0.000        0.000
4. アーカイブログから 120 秒間隔の値を表示する
コマンド
# pmval -a /root/pcp/pcp00/ -t 3 kernel.cpu.util.idle
出力
metric:    kernel.cpu.util.idle
archive:   /root/pcp/pcp00/
host:      localhost.localdomain
start:     Tue Dec 31 00:07:58 2024
end:       Tue Jan 14 19:39:37 2025
semantics: instantaneous value
units:     none
samples:   10666
interval:  120.00 sec
00:07:58.530  No values available
00:09:58.530  No values available
00:11:58.530              98.76
00:13:58.530              99.44
00:15:58.530              99.41
00:17:58.530              99.43
00:19:58.530              99.44
00:21:58.530              99.44
00:23:58.530              99.44
00:25:58.530              99.15
00:27:58.530              99.44
00:29:58.530              99.28
00:31:58.530              99.39
--以下省略--

OSSセンタ報告資料の「4.2.2 メトリクスの詳細確認」にこの他にも値取得用コマンドの記載があるので適宜参照
このセクションを編集
vmstat -n / pmstat
CPU、ディスクI/Oの統計情報を表示する

コマンド
# pmstat -a pcpファイル/pmloggerのフォルダ/アーカイブファイル名(日付.0[.xz] or 日付.00.*)
出力例
# pmstat -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0
 Mon Apr 24 10:00:00 2023
   loadavg                      memory      swap        io    system         cpu
   1 min   swpd   free   buff  cache   pi   po   bi   bo   in   cs  us  sy  id
    0.00 223560 244724    868  1134m    0    0    0   25  138  229   2   1  98
    0.00 223560 244724    868  1134m    0    0    0   16  138  230   2   1  97
    0.00 223560 244724    868  1134m    0    0    0  18K  261  254  11   3  87
    0.00 223560 244724    868  1134m    0    0    0  22K  289  260  13   3  84
    0.08 223560 244220    868  1134m    0    0    0 3850  162  232   4   1  95
    0.08 223560 244220    868  1134m    0    0    0   23  131  225   2   1  97
    0.07 223560 244220    868  1135m    0    0    0    7  136  235   1   1  98
    0.07 223560 244220    868  1135m    0    0    0    4  137  238   1   1  98
出力される情報
vmstatで出力される情報と同じ。デフォルト5秒間隔で統計情報を出力し続ける。
pcp特有の情報を以下に示す。
項目名	説明
pi	ページインされた平均ページ数
po	ページアウトされた平均ページ数
その他、Tips
pmstatはpcp vmstatのラッパー
このセクションを編集
top / pcp atop
CPU、メモリ、ディスク、ネットワークの情報を表示

コマンド
# pcp -a pcpファイル/pmloggerのフォルダ/アーカイブファイル名(日付.0[.xz] or 日付.00.*) atop
出力例
# pcp -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz or 20241227.00.21.0 atop
PRC |  sys    0.08s  |  user   0.16s  |  #proc    328  |  #tslpi   225 |  #tslpu     0  |  #zombie    0  |  #exit      0  |
CPU |  sys       1%  |  user      2%  |  irq       0%  |  idle    397% |  wait      0%  |  ipc notavail  |  curscal   ?%  |
cpu |  sys       0%  |  user      1%  |  irq       0%  |  idle     99% |  cpu001 w  0%  |  ipc notavail  |  curscal   ?%  |
cpu |  sys       1%  |  user      0%  |  irq       0%  |  idle     99% |  cpu003 w  0%  |  ipc notavail  |  curscal   ?%  |
cpu |  sys       0%  |  user      0%  |  irq       0%  |  idle    100% |  cpu002 w  0%  |  ipc notavail  |  curscal   ?%  |
cpu |  sys       0%  |  user      0%  |  irq       0%  |  idle    100% |  cpu000 w  0%  |  ipc notavail  |  curscal   ?%  |
CPL |  avg1    0.00  |  avg5    0.00  |  avg15   0.00  |  csw     2765 |  intr    2412  |                |  numcpu     4  |
MEM |  tot     3.8G  |  free    1.1G  |  cache   1.7G  |  buff    5.3M |  slab  297.8M  |  zfarc   0.0M  |  hptot   0.0M  |
SWP |  tot     1.6G  |  free    1.6G  |  swcac   0.0M  |  zpool   0.0M |  zstor   0.0M  |  vmcom   2.3G  |  vmlim   3.5G  |
LVM |     rhel-root  |  busy      0%  |  read       0  |  write      7 |  MBr/s    0.0  |  MBw/s    0.0  |  avio  0.0 ns  |
DSK |           sda  |  busy      0%  |  read       0  |  write      5 |  MBr/s    0.0  |  MBw/s    0.0  |  avio 0.80 ms  |
NET |  transport     |  tcpi     151  |  tcpo     205  |  udpi       0 |  udpo       0  |  tcpao     12  |  tcppo      0  |
NET |  network       |  ipi      151  |  ipo      205  |  ipfrw      0 |  deliv    151  |  icmpi      0  |  icmpo      0  |
NET |  ens192    0%  |  pcki     152  |  pcko     181  |  sp   10 Gbps |  si    0 Kbps  |  so    0 Kbps  |  erro       0  |
NET |  lo      ----  |  pcki      24  |  pcko      24  |  sp    0 Mbps |  si    0 Kbps  |  so    0 Kbps  |  erro       0  |

    PID SYSCPU  USRCPU RDELAY   VGROW  RGROW   RDDSK  WRDSK  RUID      EUID     ST  EXC  THR  S CPUNR   CPU  CMD        1/2
2969265  0.02s   0.09s  0.00s  215.1M  1704K      0K     0K  root      root     --    -    1  S     1    1%  pcp-atop
   1480  0.04s   0.03s  0.00s      0K     0K      0K     0K  root      root     --    -    1  R     3    1%  pmdaproc
2336942  0.01s   0.01s  0.00s      0K     0K      0K     0K  root      root     --    -    1  S     0    0%  sshd
   2918  0.00s   0.01s  0.00s      0K     0K      0K     0K  gdm       gdm      --    -   18  S     2    0%  gnome-shell
   1096  0.00s   0.01s  0.00s      0K     0K      0K     0K  root      root     --    -    3  S     3    0%  vmtoolsd
   1483  0.00s   0.01s  0.00s      0K     0K      0K     0K  root      root     --    -    1  S     2    0%  pmdalinux
    681  0.01s   0.00s  0.00s      0K     0K      0K     0K  root      root     --    -    1  S     3    0%  xfsaild/dm-0
2349903  0.00s   0.00s  0.00s      0K     0K      0K     0K  root      root     --    -    4  S     2    0%  tuned
 310476  0.00s   0.00s  0.00s      0K     0K      0K    32K  pcp       pcp      --    -    1  S     0    0%  pmlogger
   1489  0.00s   0.00s  0.00s      0K     0K      0K     0K  root      root     --    -    1  S     0    0%  python3
      1  0.00s   0.00s  0.00s      0K     0K      0K     0K  root      root     --    -    1  S     1    0%  systemd
   5382  0.00s   0.00s  0.00s      0K     0K      0K     0K  gdm       gdm      --    -    3  S     3    0%  ibus-daemon
   1473  0.00s   0.00s  0.00s      0K     0K      0K     0K  pcp       pcp      --    -    1  S     0    0%  pmcd
   1623  0.00s   0.00s  0.00s      0K     0K      0K     0K  pcp       pcp      --    -    1  S     0    0%  pmdaapache
   3240  0.00s   0.00s  0.00s      0K     0K      0K     0K  pcp       pcp      --    -    1  S     0    0%  pmpause
   1101  0.00s   0.00s  0.00s      0K     0K      0K     0K  avahi     avahi    --    -    1  S     2    0%  avahi-daemon
     16  0.00s   0.00s  0.00s      0K     0K      0K     0K  root      root     --    -    1  I     1    0%  rcu_preempt
atop操作方法
OSSセンタ報告資料「4.7 top 相当の情報の表示」に記載
出力される情報
topで出力される情報と同じ。デフォルト10秒間隔で統計情報を出力し続ける。
pcp特有の情報を以下に示す。
操作コマンド	項目名	説明
g	SYSCPU	システムモードでのCPU使用時間
g	USRCPU	ユーザモードでのCPU使用時間
v	RUID	そのプロセスを実行したユーザ名
s	NICE	優先度（NI)
s	PRI	優先度（PR)
m	VSIZE	仮想メモリの使用量
m	RSIZE	物理メモリの使用量
このセクションを編集
iostat -d -x / pcp iostat
I/Oデバイスの統計情報を表示する
デフォルトでは1秒間隔で統計情報を出力し続ける
出力間隔や回数を設定する場合は、

pcp iostat -t <出力間隔> -s <出力回数> 

のように指定する
コマンド
# pcp -a pcpファイル/pmloggerのフォルダ/アーカイブファイル名(日付.0[.xz] or 日付.00.*) iostat
出力例
# pcp -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz or 20241227.00.21.0 iostat
# Device      rrqm/s  wrqm/s     r/s    w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await   %util
sda             0.00    0.00    0.00   0.00     0.00     0.00    0.000    0.000    0.00    0.00    0.00    0.00
sdb             0.00    0.00    0.00   0.00     0.00     0.00    0.000    0.000    0.00    0.00    0.00    0.00
sda             0.00    1.00    0.00   1.00     0.00    39.86   40.000    0.001    1.00    0.00    1.00    0.20
sdb             0.00    0.00    0.00   0.00     0.00     0.00    0.000    0.000    0.00    0.00    0.00    0.00
sda             0.00    0.00    0.00   0.00     0.00     0.00    0.000    0.000    0.00    0.00    0.00    0.00
sdb             0.00    0.00    0.00   0.00     0.00     0.00    0.000    0.000    0.00    0.00    0.00    0.00
出力される情報
iostatで出力される情報と同じ。
pcp特有の情報を以下に示す。
項目名	説明
avgrq-sz	デバイスへの読み取りと書き込みの両方の平均I/O要求サイズをKバイトで表したもの
avgqu-sz	デバイスへのリードおよびライト要求の平均キュー長
このセクションを編集
netstat -antuweeop / pcp ss
ソケット単位の情報表示
詳細はOSSセンタの報告書「Performance Co-Pilot 調査」の「4.11.3 ソケット単位の表示」に記載。
pcp ss コマンドを使用するには、pcp-pmdas-socketsパッケージをyumまたはdnfでインストールした上で
pmdasocketsをインストｰﾙする必要がある。
インストールは /var/lib/pcp/pmdas/sockets/Install スクリプトの実行で行う。
% cd /var/lib/pcp/pmdas/sockets
% ./Install

netstat のオプションと同じく ss でも一部同様のオプションを使用可能。
使用できるオプションの詳細は man ページを確認する。
-atunwop オプションのうち -p (--processes) は実装されていない。

コマンド
# pcp -a pcpファイル/pmloggerのフォルダ/アーカイブファイル名(日付.0[.xz] or 日付.00.*) ss
出力例
# pcp -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz or 20241227.00.21.0 ss
# Time: 2025-01-14 16:41:34.172527 Filter: state all
Netid  State  Recv-Q Send-Q        Local Address:Port Peer Address:Port          Process
tcp   ESTAB         0     0            10.0.0.5:44321 10.0.0.200:53350         
tcp   ESTAB         0     0            10.0.0.5:41928 10.0.0.200:22            
tcp   ESTAB         0     0    [::ffff:10.0.0.5]:3389 [::ffff:10.0.1.4]:60988  
tcp   ESTAB         0     0                [::1]:5910 [::1]:47772              
tcp   ESTAB         0     0               [::1]:47772 [::1]:5910               
tcp   ESTAB         0     0               [::1]:44321 [::1]:39594              
tcp   ESTAB         0     0               [::1]:39594 [::1]:44321
出力される情報
netstat -antuweeopで出力される情報と同じ
このセクションを編集
pidstat -u -l / pcp pidstat -l
全てのプロセスに対してCPU関連の情報を表示する

コマンド
# pcp -a pcpファイル/pmloggerのフォルダ/アーカイブファイル名(日付.0[.xz] or 日付.00.*) pidstat -l
出力例
# pcp -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0 pidstat -l 
Timestamp        UID    PID     usr     system  guest   %CPU    CPU     Command
14:12:14         0      1       0.0     0.0     0.0     0.0     1       /usr/lib/systemd/systemd rhgb --switched-root --system --deserialize 31
14:12:14         0      2       0.0     0.0     0.0     0.0     3       (kthreadd)
14:12:14         0      3       0.0     0.0     0.0     0.0     0       (rcu_gp)
14:12:14         0      4       0.0     0.0     0.0     0.0     0       (rcu_par_gp)
14:12:14         0      5       0.0     0.0     0.0     0.0     0       (netns)
14:12:14         0      7       0.0     0.0     0.0     0.0     0       (kworker/0:0H-events_highpri)
14:12:14         0      9       0.0     0.0     0.0     0.0     0       (kworker/0:1H-events_highpri)
14:12:14         0      10      0.0     0.0     0.0     0.0     0       (mm_percpu_wq)
出力される情報
pidstat -u -lで出力される情報と同じ
このセクションを編集
pidstat -r -l / pcp pidstat -r -l
全てのプロセスに対してページフォルトとメモリ使用率関連の情報を表示する

コマンド
# pcp -a pcpファイル/pmloggerのフォルダ/アーカイブファイル名(日付.0[.xz] or 日付.00.*) pidstat -r -l
出力例
# pcp -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz or 20241227.00.21.0 pidstat -r -l
Timestamp        UID    PID     MinFlt/s        MajFlt/s        VSize   RSS     %Mem    Command
14:14:14         0      1       0.0             0.0             170116  13852   0.35    /usr/lib/systemd/systemd rhgb --switched-root --system --deserialize 31
14:14:14         0      785     0.0             0.0             108284  17864   0.45    /usr/lib/systemd/systemd-journald
14:14:14         0      799     0.0             0.0             35712   12360   0.31    /usr/lib/systemd/systemd-udevd
14:14:14         32     1047    0.0             0.0             13256   5780    0.14    /usr/bin/rpcbind -w -f
14:14:14         0      1048    0.0             0.0             91816   2400    0.06    /sbin/auditd
14:14:14         0      1053    0.0             0.0             7800    3176    0.08    /usr/sbin/sedispatch
14:14:14         81     1074    0.0             0.0             11036   4996    0.12    /usr/bin/dbus-broker-launch --scope system --audit
14:14:14         81     1075    0.0             0.0             6976    4636    0.12    dbus-broker --log 4 --controller 9 --machine-id 142b5ffd25e8454db3710a8b2794a012 --max-bytes 536870912 --max-fds 4096 --max-matches 131072 --audit
出力される情報
pidstat -r -lで出力される情報と同じ
このセクションを編集
cat /proc/meminfo / pminfo -t mem.util | grep meminfo
/proc/meminfoに関する情報を表示

コマンド
# pminfo -t mem.util | grep meminfo
出力例
# pminfo -t mem.util | grep meminfo -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0
mem.util.used [used memory metric from /proc/meminfo]
mem.util.free [free memory metric from /proc/meminfo]
mem.util.shared [shared memory metric from /proc/meminfo]
mem.util.bufmem [I/O buffers metric from /proc/meminfo]
mem.util.cached [page cache metric from /proc/meminfo]
mem.util.swapCached [Kbytes in swap cache, from /proc/meminfo]
mem.util.highTotal [Kbytes in high memory, from /proc/meminfo]
mem.util.highFree [Kbytes free high memory, from /proc/meminfo]
mem.util.lowTotal [Kbytes in low memory total, from /proc/meminfo]
mem.util.lowFree [Kbytes free low memory, from /proc/meminfo]
mem.util.swapTotal [Kbytes swap, from /proc/meminfo]
mem.util.swapFree [Kbytes free swap, from /proc/meminfo]
mem.util.dirty [Kbytes in dirty pages, from /proc/meminfo]
mem.util.writeback [Kbytes in writeback pages, from /proc/meminfo]
mem.util.mapped [Kbytes in mapped pages, from /proc/meminfo]
mem.util.slab [Kbytes in slab memory, from /proc/meminfo]
mem.util.committed_AS [Kbytes committed to address spaces, from /proc/meminfo]
mem.util.pageTables [Kbytes in kernel page tables, from /proc/meminfo]
mem.util.reverseMaps [Kbytes in reverse mapped pages, from /proc/meminfo]
mem.util.cache_clean [Kbytes cached and not dirty or writeback, derived from /proc/meminfo]
mem.util.anonpages [Kbytes in user pages not backed by files, from /proc/meminfo]
mem.util.commitLimit [Kbytes limit for address space commit, from /proc/meminfo]
mem.util.bounce [Kbytes in bounce buffers, from /proc/meminfo]
mem.util.NFS_Unstable [Kbytes in NFS unstable memory, from /proc/meminfo]
mem.util.slabReclaimable [Kbytes in reclaimable slab pages, from /proc/meminfo]
mem.util.slabUnreclaimable [Kbytes in unreclaimable slab pages, from /proc/meminfo]
mem.util.available [available memory from /proc/meminfo]
出力される情報
cat /proc/meminfoで出力される情報と同じ
必要なものを説明文やメトリクス名から選ぶ
このセクションを編集
cat /proc/net/dev / pminfo -t network.interface | grep /proc/net
/proc/net/devに関する情報を表示

コマンド
# pminfo -t network.interface | grep /proc/net
出力例
# pminfo -t network.interface | grep /proc/net -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0
network.interface.collisions [network send collisions from /proc/net/dev per network interface]
network.interface.in.bytes [network recv read bytes from /proc/net/dev per network interface]
network.interface.in.packets [network recv read packets from /proc/net/dev per network interface]
network.interface.in.errors [network recv read errors from /proc/net/dev per network interface]
network.interface.in.drops [network recv read drops from /proc/net/dev per network interface]
network.interface.in.fifo [network recv fifo overrun errors from /proc/net/dev per network interface]
network.interface.in.frame [network recv frames errors from /proc/net/dev per network interface]
network.interface.in.compressed [network recv compressed from /proc/net/dev per network interface]
network.interface.in.mcasts [network recv multicast packets from /proc/net/dev per network interface]
network.interface.out.bytes [network send bytes from /proc/net/dev per network interface]
network.interface.out.packets [network send packets from /proc/net/dev per network interface]
network.interface.out.errors [network send errors from /proc/net/dev per network interface]
network.interface.out.drops [network send drops from /proc/net/dev per network interface]
network.interface.out.fifo [network send fifos from /proc/net/dev per network interface]
network.interface.out.carrier [network send carrier from /proc/net/dev per network interface]
network.interface.out.compressed [network send compressed from /proc/net/dev per network interface]
network.interface.total.bytes [network total (in+out) bytes from /proc/net/dev per network interface]
network.interface.total.packets [network total (in+out) packets from /proc/net/dev per network interface]
network.interface.total.errors [network total (in+out) errors from /proc/net/dev per network interface]
network.interface.total.drops [network total (in+out) drops from /proc/net/dev per network interface]
network.interface.total.mcasts [network total (in) mcasts from /proc/net/dev per network interface]
出力される情報
cat /proc/net/devで出力される情報と同じ
必要なものを説明文やメトリクス名から選ぶ
このセクションを編集
cat /proc/net/snmp, netstat -s / pminfo -t network.tcp , pminfo -t network.udp, pminfo -t network.icmp
ネットワークプロトコル（TCP、UDP、ICMP など）に関連する統計情報を表示

コマンド
# pminfo -t network.tcp

# ppminfo -t network.udp

# pminfo -t network.icmp
出力例
# pminfo -t network.tcp -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz or 20241227.00.21.0
network.tcp.rtoalgorithm [the retransmission timeout algorithm in use]
network.tcp.rtomin [minimum retransmission timeout]
network.tcp.rtomax [maximum retransmission timeout]
network.tcp.maxconn [limit on tcp connections]
network.tcp.activeopens [count of tcp activeopens]
network.tcp.passiveopens [count of tcp passiveopens]
network.tcp.attemptfails [count of tcp attemptfails]
network.tcp.estabresets [count of tcp estabresets]
network.tcp.currestab [current established tcp connections]
network.tcp.insegs [count of tcp segments received]
network.tcp.outsegs [count of tcp segments sent]
network.tcp.retranssegs [count of tcp segments retransmitted]
--以下省略--
出力される情報
cat /proc/net/snmpで出力される情報と同じ
必要なものを説明文やメトリクス名から選ぶ
このセクションを編集
df -Ta / pminfo -t filesys
ファイルシステムに関する情報を表示

コマンド
# pminfo -t filesys
出力例
# pminfo -t filesys -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0
filesys.capacity [Total capacity of mounted filesystem (Kbytes)]
filesys.used [Total space used on mounted filesystem (Kbytes)]
filesys.free [Total space free on mounted filesystem (Kbytes)]
filesys.maxfiles [Inodes capacity of mounted filesystem]
filesys.usedfiles [Number of inodes allocated on mounted filesystem]
filesys.freefiles [Number of unallocated inodes on mounted filesystem]
filesys.mountdir [File system mount point]
filesys.full [Percentage of filesystem in use]
filesys.blocksize [Size of each block on mounted filesystem (Bytes)]
filesys.avail [Total space free to non-superusers on mounted filesystem (Kbytes)]
filesys.readonly [Indicates whether a filesystem is mounted readonly]
出力される情報
ファイルシステムに関する情報
必要なものを説明文やメトリクス名から選ぶ
このセクションを編集
sar -b, sar -d / pcp atopsar -d
ディスクに関するI/O情報を表示

コマンド
# pcp -a pcpファイル/pmloggerのフォルダ/アーカイブファイル名(日付.0[.xz] or 日付.00.*) atopsar -d
出力例
# pcp a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0 atopsar -d 
00:00:20  disk           busy read/s KB/read  writ/s KB/writ avque avserv _dsk_
00:00:20  sda              0%    0.0     0.0     0.1   234.7   2.3   0.91667 ms
          sdb              0%    0.0     0.0     0.0     0.0   0.0   0.00000 ms
00:00:30  sda              0%    0.0     0.0     0.2    14.3   1.7   0.40000 ms
00:00:40  sda              0%    0.0     0.0     0.3    67.8   2.6   0.60000 ms
00:00:50  sda              0%    0.0     2.5     0.2   133.1   2.2   1.14286 ms
00:01:00  sda              0%    0.0     0.0     0.3    15.5   4.2   0.13793 ms
出力される情報
sar -dで出力される情報と同じ
pcp特有の情報を以下に示す。
項目名	説明
busy	デバイスのビジー率（デバイスがリクエストの処理に忙しかった時間、%utilに相当）
read/s	1秒間に発行される読み込み要求数
KB/read	読み込み要求数あたりの平均転送キロバイト数
writ/s	1秒間に発行される書き込み要求数
KB/writ	書き込み要求1回あたりの平均転送キロバイト数
avque	ビジー状態である間の、キューに残っているリクエストの平均数
avserv	リクエストに必要な平均ミリ秒数（シーク時間、待ち時間、データ転送時間）
このセクションを編集
sar -B / pcp atopsar -p
ページング情報を表示

コマンド
# pcp -a pcpファイル/pmloggerのフォルダ/アーカイブファイル名(日付.0[.xz] or 日付.00.*)  atopsar -p
出力例
# pcp -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz or 20241227.00.21.0 atopsar -p
00:00:20  pswch/s devintr/s  clones/s  loadavg1 loadavg5 loadavg15       _load_
00:00:20     2359      2217    126.30      0.02     0.01      0.00
00:00:30     2763      2732     86.50      0.25     0.06      0.02
00:00:40     1690      1800      0.20      0.36     0.09      0.03
00:00:50      788       839      0.20      0.38     0.10      0.03
00:01:00      156       131      0.90      0.32     0.10      0.03
出力される情報
sar -Bで出力される情報と同じ
このセクションを編集
sar -F / pminfo -t | grep filesys
ファイルシステムに関する入出力情報を表示

コマンド
# pminfo -t | grep filesys
出力例
# pminfo -t | grep filesys -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0
hinv.nfilesys [number of (local) file systems currently mounted]
filesys.capacity [Total capacity of mounted filesystem (Kbytes)]
filesys.used [Total space used on mounted filesystem (Kbytes)]
filesys.free [Total space free on mounted filesystem (Kbytes)]
filesys.maxfiles [Inodes capacity of mounted filesystem]
filesys.usedfiles [Number of inodes allocated on mounted filesystem]
filesys.freefiles [Number of unallocated inodes on mounted filesystem]
filesys.mountdir [File system mount point]
filesys.full [Percentage of filesystem in use]
filesys.blocksize [Size of each block on mounted filesystem (Bytes)]
filesys.avail [Total space free to non-superusers on mounted filesystem (Kbytes)]
filesys.readonly [Indicates whether a filesystem is mounted readonly]
tmpfs.capacity [Total capacity of mounted tmpfs filesystem (Kbytes)]
tmpfs.used [Total space used on mounted tmpfs filesystem (Kbytes)]
tmpfs.free [Total space free on mounted tmpfs filesystem (Kbytes)]
tmpfs.maxfiles [Inodes capacity of mounted tmpfs filesystem]
tmpfs.usedfiles [Number of inodes allocated on mounted tmpfs filesystem]
tmpfs.freefiles [Number of unallocated inodes on mounted tmpfs filesystem]
tmpfs.full [Percentage of tmpfs filesystem in use]
cgroup.mounts.count [count of cgroup filesystem mount points]
proc.id.fsgid_nm [filesystem group name based on filesystem group ID from /proc/<pid>/status]
proc.id.fsuid_nm [filesystem user name based on filesystem user ID from /proc/<pid>/status]
proc.id.fsgid [filesystem group ID from /proc/<pid>/status]
proc.id.fsuid [filesystem user ID from /proc/<pid>/status]
hotproc.id.fsgid_nm [filesystem group name based on filesystem group ID from /proc/<pid>/status]
hotproc.id.fsuid_nm [filesystem user name based on filesystem user ID from /proc/<pid>/status]
hotproc.id.fsgid [filesystem group ID from /proc/<pid>/status]
hotproc.id.fsuid [filesystem user ID from /proc/<pid>/status]
quota.project.space.hard [hard limit for this project and filesys in Kbytes]
quota.project.space.soft [soft limit for this project and filesys in Kbytes]
quota.project.space.used [space used for this project and filesys in Kbytes]
quota.project.files.hard [file count hard limit for this project and filesys]
quota.project.files.soft [file count soft limit for this project and filesys]
quota.project.files.used [file count for this project and filesys]
出力される情報
sar -Fで出力される情報と同じ
必要なものを説明文やメトリクス名から選ぶ
このセクションを編集
sar -H / pminfo -t | grep hugepage
ヒュージページに関する情報を表示

コマンド
# pminfo -t | grep hugepage
出力例
# pminfo -t | grep hugepage -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0
hinv.hugepagesize [Huge page size from /proc/meminfo]
mem.util.hugepagesTotal [a count of total hugepages]
mem.util.hugepagesFree [a count of free hugepages]
mem.util.hugepagesRsvd [a count of reserved hugepages]
mem.util.hugepagesSurp [a count of surplus hugepages]
mem.util.anonhugepages [amount of memory in anonymous huge pages]
mem.util.hugepagesTotalBytes [amount of memory in total hugepages]
mem.util.hugepagesFreeBytes [amount of memory in free hugepages]
mem.util.hugepagesRsvdBytes [amount of memory in reserved hugepages]
mem.util.hugepagesSurpBytes [amount of memory in surplus hugepages]
mem.numa.util.hugepagesTotal [per-node total count of hugepages]
mem.numa.util.hugepagesFree [per-node count of free hugepages]
mem.numa.util.hugepagesSurp [per-node count of surplus hugepages]
mem.numa.util.hugepagesTotalBytes [per-node total amount of hugepages memory]
mem.numa.util.hugepagesFreeBytes [per-node amount of free hugepages memory]
mem.numa.util.hugepagesSurpBytes [per-node amount of surplus hugepages memory]
mem.vmstat.nr_anon_transparent_hugepages [number of anonymous transparent huge pages]
mem.vmstat.nr_file_hugepages [count of hugepages used for files]
mem.vmstat.nr_shmem_hugepages [number of huge pages used for shared memory]
mem.zoneinfo.nr_anon_transparent_hugepages [number of anonymous transparent huge pages in each zone for each NUMA node]
mem.zoneinfo.nr_shmem_hugepages [shared memory huge pages in each zone for each NUMA node]
mem.zoneinfo.nr_file_hugepages [file-backed huge pages in each zone for each NUMA node]
cgroup.memory.stat.rss [Anonymous and swap memory (incl transparent hugepages)]
cgroup.memory.stat.rss_huge [Anonymous transparent hugepages]
proc.smaps.anonhugepages [AnonHugePages mappings size from /proc/<pid>/smaps_rollup]
hotproc.smaps.anonhugepages [AnonHugePages mappings size from /proc/<pid>/smaps_rollup]
出力される情報
sar -Hで出力される情報と同じ
必要なものを説明文やメトリクス名から選ぶ
このセクションを編集
sar -r / pcp atopsar -m
メモリに関する情報を表示

コマンド
# pcp atopsar -m
出力例
# pcp -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0 atopsar -m
00:00:20  memtotal memfree buffers cached dirty slabmem  swptotal swpfree _mem_
00:00:20     3910M   1979M      4M   917M    0M    215M     1639M   1636M
00:00:30     3910M   1928M      4M   971M    1M    215M     1639M   1636M
00:00:40     3910M   1874M      4M  1024M    0M    215M     1639M   1636M
出力される情報
sar -rで出力される情報と同じ
このセクションを編集
sar -u / pcp atopsar -c
CPUに関する情報を表示

コマンド
# pcp atopsar -c
出力例
# pcp  -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0 atopsar -c
00:00:20  cpu  %usr %nice %sys %irq %softirq  %steal %guest  %wait %idle  _cpu_
00:00:20  all    87     0   27    1        1       0      0      7   277
            0    21     0    8    0        0       0      0      1    70
            1    46     0    3    0        0       0      0      1    49
            2    10     0    8    0        0       0      0      3    78
            3    10     0    8    0        0       0      0      2    80
00:00:30  all    95     0    3    1        0       0      0      3   298
            0     4     0    0    0        0       0      0      0    96
            1    74     0    1    0        0       0      0      0    24
            2     9     0    2    0        0       0      0      3    86
            3     8     0    0    0        0       0      0      0    91
00:00:40  all    66     0    3    1        0       0      0      4   327
            0     0     0    0    0        0       0      0      0   100
            1    65     0    0    0        0       0      0      0    34
            2     0     0    2    0        0       0      0      4    94
            3     0     0    0    0        0       0      0      0   100
出力される情報
sar -uで出力される情報と同じ
このセクションを編集
sar -w / pminfo -t | grep context
task creation and system switching activityに関する情報を表示

コマンド
# pminfo -t | grep context
出力例
# pminfo -t | grep context -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0
kernel.all.pswitch [context switches metric from /proc/stat]
network.tcp.directcopyfrombacklog [Number of bytes directly in process context from backlog]
network.tcp.directcopyfromprequeue [Number of bytes directly received in process context from prequeue]
proc.psinfo.nvctxsw [number of non-voluntary context switches (from /proc/<pid>/status)]
proc.psinfo.vctxsw [number of voluntary context switches (from /proc/<pid>/status)]
hotproc.psinfo.nvctxsw [number of non-voluntary context switches (from /proc/<pid>/status)]
hotproc.psinfo.vctxsw [number of voluntary context switches (from /proc/<pid>/status)]
hotproc.predicate.ctxswitch [number of context switches per second over refresh interval]
出力される情報
hotproc.predicate.ctxswitchがsar -wで出力されるcswch/sと同じ
必要なものを説明文やメトリクス名から選ぶ
このセクションを編集
sar -y / pminfo -t | grep tty
ttyデバイスの活動に関する情報を表示

コマンド
# pminfo -t | grep tty
出力例
# pminfo -t | grep tty -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0
kernel.all.nptys [number of in-use pseudo-ttys from /proc/sys/kernel/pty/nr]
network.icmpmsg.outtype [count of icmp message types sent]
tty.serial.tx [Number of transmit interrupts for current serial line.]
tty.serial.rx [Number of receive interrupts for current serial line.]
tty.serial.frame [Number of frame errors for current serial line.]
tty.serial.parity [Number of parity errors for current serial line.]
tty.serial.brk [Number of breaks for current serial line.]
tty.serial.overrun [Number of overrun errors for current serial line.]
tty.serial.irq [IRQ number.]
proc.psinfo.ttyname [name of controlling tty device, or ? if none. See also proc.psinfo.tty.]
proc.psinfo.tty_pgrp [controlling tty process group identifier]
proc.psinfo.tty [controlling tty device number (zero if none)]
hotproc.psinfo.ttyname [name of controlling tty device, or ? if none. See also proc.psinfo.tty.]
hotproc.psinfo.tty_pgrp [controlling tty process group identifier]
hotproc.psinfo.tty [controlling tty device number (zero if none)]
acct.psinfo.tty [Controlling terminal device number]
acct.psinfo.ttyname [Controlling terminal name]
出力される情報
sar -yで出力される情報と同じ
必要なものを説明文やメトリクス名から選ぶ
このセクションを編集
sar -I / pminfo -t | grep interrup
割り込みに関する情報を表示

コマンド
# pminfo -t | grep interrup
出力例
# pminfo -t | grep interrup -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz     or 20241227.00.21.0
kvm.irq_exits [Number of guest exits due to external interrupts.]
kvm.irq_injections [Number of interrupts sent to guests.]
kvm.irq_window [Number of guest exits from an outstanding interrupt window.]
kvm.request_irq [Number of guest interrupt request exits.]
kvm.irq_window_exits [Number of guest interrupt window request exits.]
kvm.nmi_window_exits [Number of guest non-maskable interrupt exits.]
kvm.request_irq_exits [Number of guest interrupt request exits.]
kernel.all.intr [interrupt count metric from /proc/stat]
kernel.all.cpu.intr [total interrupt CPU time from /proc/stat for all CPUs]
kernel.all.cpu.irq.soft [soft interrupt CPU time from /proc/stat for all CPUs]
kernel.all.cpu.irq.hard [hard interrupt CPU time from /proc/stat for all CPUs]
kernel.all.interrupts.total [total interrupts counts from /proc/interrupts]
kernel.all.interrupts.missed [MIS count from /proc/interrupts]
kernel.all.interrupts.errors [interrupt error count from /proc/interrupts]
kernel.all.softirqs.total [total interrupts counts from /proc/softirqs]
kernel.percpu.interrupts [interrupt counters from /proc/interrupts]
kernel.percpu.softirqs [per CPU per soft interrupt counts from /proc/softirqs]
kernel.percpu.intr [interrupt count metric from /proc/interrupts]
kernel.percpu.sirq [per CPU aggregate soft interrupt counts from /proc/softirqs]
kernel.percpu.cpu.intr [percpu interrupt CPU time]
kernel.percpu.cpu.irq.soft [percpu soft interrupt CPU time]
kernel.percpu.cpu.irq.hard [percpu hard interrupt CPU time]
kernel.pernode.cpu.intr [total interrupt CPU time from /proc/stat for each node]
kernel.pernode.cpu.irq.soft [soft interrupt CPU time from /proc/stat for each node]
kernel.pernode.cpu.irq.hard [hard interrupt CPU time from /proc/stat for each node]
network.softnet.processed [number of packets (not including netpoll) received by the interrupt handler]
network.softnet.percpu.processed [number of packets (not including netpoll) received by the interrupt handler]
tty.serial.tx [Number of transmit interrupts for current serial line.]
tty.serial.rx [Number of receive interrupts for current serial line.]
proc.runq.blocked [number of processes in uninterruptible sleep]
kernel.cpu.util.intr [percentage of interrupt time across all CPUs]
出力される情報
sar -Iで出力される情報と同じ
必要なものを説明文やメトリクス名から選ぶ
このセクションを編集
sar -S, sar -W / pcp atopsar -s
スワップ領域の使用状況に関する情報を表示

コマンド
# pcp atopsar -s
出力例
# pcp -a /var/log/pcp/pmlogger/pcp00/20241226.0.xz or 20241227.00.21.0 atopsar -s
00:00:20  pagescan/s   swapin/s  swapout/s        commitspc  commitlim   _swap_
00:00:20        0.00       0.00       0.00            2378M      3595M
00:00:30        0.00       0.00       0.00            2378M      3595M
00:00:40        0.00       0.00       0.00            2378M      3595M
出力される情報
sar -S, sar -Wで出力される情報と同じ
