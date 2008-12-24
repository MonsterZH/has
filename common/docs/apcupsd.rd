= apcupsd

APC 製の UPS を管理するデーモン。

lv1 を UPS とシリアルケーブルで接続する。
lv1 をマスターとして、lv1 以外も停電時にシャットダウンできるようにする。

== インストール

  $ sudo aptitude install apcupsd
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    Reading extended state information
    Initializing package states... Done
    Reading task descriptions... Done
    The following NEW packages will be installed:
      apcupsd apcupsd-doc{a} libperl5.10{a} libsensors3{a} libsnmp-base{a}
      libsnmp15{a} libsysfs2{a}
    0 packages upgraded, 7 newly installed, 0 to remove and 1 not upgraded.
    Need to get 6836kB/6949kB of archives. After unpacking 44.8MB will be used.

== 設定

まずは、マスター(lv1)。

/etc/apcupsd/apcupsd.conf を修正する。

  lv1$ f=/etc/apcupsd/apcupsd.conf 
  lv1$ sudo cp -a -i ${f} ${f}.orig
  lv1$ sudo vi ${f}
    (以下を設定)
    TIMEOUT 30
    NISIP 0.0.0.0

  lv1$ diff -u ${f}.orig ${f}      
    --- /etc/apcupsd/apcupsd.conf.orig      2008-05-21 17:37:30.000000000 +0900
    +++ /etc/apcupsd/apcupsd.conf   2008-12-23 20:53:31.854680402 +0900
    @@ -147,7 +147,7 @@
     #    if you pull the power plug.   
     #  If you have an older dumb UPS, you will want to set this to less than
     #    the time you know you can run on batteries.
    -TIMEOUT 0
    +TIMEOUT 30
     
     #  Time in seconds between annoying users to signoff prior to
     #  system shutdown. 0 disables.
    @@ -188,7 +188,7 @@
     #  NIS will listen for connections only on that interface. Use the
     #  loopback address (127.0.0.1) to accept connections only from the
     #  local machine.
    -NISIP 127.0.0.1
    +NISIP 0.0.0.0
     
     # NISPORT <port> default is 3551 as registered with the IANA
     #  port to use for sending STATUS and EVENTS data over the network.

/etc/default/apcupsd を修正する。

  lv1$ f=/etc/default/apcupsd
  lv1$ sudo cp -a -i ${f} ${f}.orig
  lv1$ sudo vi ${f}
  lv1$ diff -u ${f}.orig ${f}
    --- /etc/default/apcupsd.orig   2008-05-21 16:36:25.000000000 +0900
    +++ /etc/default/apcupsd        2008-12-23 20:55:01.186748875 +0900
    @@ -2,4 +2,4 @@
     
     # Apcupsd-devel internal configuration
     APCACCESS=/sbin/apcaccess
    -ISCONFIGURED=no
    +ISCONFIGURED=yes

起動する。

  lv1$ sudo /etc/init.d/apcupsd start
    Starting UPS power management: apcupsd.

  lv1$ /etc/init.d/apcupsd status | grep STATUS
    STATUS   : ONLINE 

次は、スレーブ(w101とw102)。

/etc/apcupsd/apcupsd.conf を修正する。

  w10[12]$ f=/etc/apcupsd/apcupsd.conf 
  w10[12]$ sudo cp -a -i ${f} ${f}.orig
  w10[12]$ sudo vi ${f}
    (以下を設定)
    UPSCABLE ether
    UPSTYPE net
    DEVICE 192.168.77.11:3551
    TIMEOUT 30

  w10[12]$ diff -u ${f}.orig ${f}      
    --- /etc/apcupsd/apcupsd.conf.orig      2008-05-21 17:37:30.000000000 +0900
    +++ /etc/apcupsd/apcupsd.conf   2008-12-23 21:37:50.123362621 +0900
    @@ -26,7 +26,7 @@
     #     940-1524C, 940-0024G, 940-0095A, 940-0095B,
     #     940-0095C, M-04-02-2000
     #
    -UPSCABLE smart
    +UPSCABLE ether
     
     # To get apcupsd to work, in addition to defining the cable
     # above, you must also define a UPSTYPE, which corresponds to
    @@ -72,8 +72,8 @@
     #                            credentials for which the card has been
     #                            configured.
     #
    -UPSTYPE apcsmart
    -DEVICE /dev/ttyS0
    +UPSTYPE net
    +DEVICE 192.168.77.11:3551
     
     # POLLTIME <int>
     #   Interval (in seconds) at which apcupsd polls the UPS for status. This
    @@ -147,7 +147,7 @@
     #    if you pull the power plug.   
     #  If you have an older dumb UPS, you will want to set this to less than
     #    the time you know you can run on batteries.
    -TIMEOUT 0
    +TIMEOUT 30
     
     #  Time in seconds between annoying users to signoff prior to
     #  system shutdown. 0 disables.

/etc/default/apcupsd を修正する。

  w10[12]$ f=/etc/default/apcupsd
  w10[12]$ sudo cp -a -i ${f} ${f}.orig
  w10[12]$ sudo vi ${f}
  w10[12]$ diff -u ${f}.orig ${f}
    --- /etc/default/apcupsd.orig   2008-05-21 16:36:25.000000000 +0900
    +++ /etc/default/apcupsd        2008-12-23 20:55:01.186748875 +0900
    @@ -2,4 +2,4 @@
     
     # Apcupsd-devel internal configuration
     APCACCESS=/sbin/apcaccess
    -ISCONFIGURED=no
    +ISCONFIGURED=yes

起動する。

  w10[12]$ sudo /etc/init.d/apcupsd start
    Starting UPS power management: apcupsd.

  w10[12]$ /etc/init.d/apcupsd status | grep STATUS
    STATUS   : ONLINE SLAVE 

== 参考資料

: Lipwood - Apcupsd 3.14.1のapcupsd.confの日本語訳
  http://local.lipwood.com/content/view/68/128/

== トラブルシューティング

スレーブからマスタに接続できない。

パケットフィルタによって、eth1 からのパケットを遮断している。

/var/log/ulog/syslogemu.log

  Dec 23 21:43:36 lv1 droped packet:  IN=eth1 OUT= MAC=00:1e:c9:50:6b:d3:00:1e:c9:
  50:69:d6:08:00  SRC=192.168.77.101 DST=192.168.77.11 LEN=60 TOS=00 PREC=0x00 TTL
  =64 ID=18988 DF PROTO=TCP SPT=33141 DPT=3551 SEQ=736929682 ACK=0 WINDOW=5840 SYN
   URGP=0 

パケットフィルタを解除すればいい。
