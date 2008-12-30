title: "w101のインストール手順書"

=begin

############################################################
= はじめに

############################################################
= OS

w101 に Debian GNU/Linux lenny をインストールしたときの作業ログです。

インストールには 
((<URL:http://cdimage.debian.org/cdimage/lenny_di_beta2/i386/iso-cd/debian-LennyBeta2-i386-netinst.iso>))
を利用しました。

インストーラを起動する。

Installer boot menu で Install を選択する。

以下、設定項目と設定した値。
* Choose a language
  * Choose a language: English
  * Chose a country, territory or area: Japan
* Select a keyboard layout
  * Keymap to use: Japanese
* Configure the network
  * Hostname: w101
  * Domain name: takao7.net
* Partition disks
  * Partitioning method: Manual
  * パーティションについては後述
* root ユーザのパスワードの設定
* Set up users and passwords
  * Full name for the new user: Worker
  * Username for your account: worker
  * workerユーザのパスワードの設定
* Confgure the package manager
  * Debian archive mirror country: Japan
  * Debian archive mirror: ftp.nara.wide.ad.jp
  * HTTP proxy information (blank for none):
* Configuring popularity* contest
  * Paricipate in the package usage survey? No
* Software selection
  * Choose software to install: Standard system
* Install the LILO boot loader on a hard disk
  * LILO installation target: /dev/sda
* Finish the installation: Continue

再起動後、ログインできることを確認した。

== パーティション

パーティションの初期状態。
* #1 primary  65.8 MB   fat16
* #2 primary   2.2 GB B fat32
*    pri/log 157.8 GB   FREE SPACE

パーティションの設定後。とりあえず lv1 と同じにした。
* LVM VG vg_lv1
  * LVM LV lv_home 2.1 GB f xfs /home
  * LVM LV lv_usr 2.1 GB f xfs /usr
  * LVM LV lv_var 5.7 GB f xfs /var
* #1 primary  65.8 MB   fat16
* #2 primary   2.2 GB B fat32
* #3 primary   4.0 GB   F swap swap
* #5 logical   1.0 GB B F xfs /
* #6 logical  10.0 GB   K lvm

== sudo のインストール

common/docs/sudo.rd を参照。

== SSHのインストール

common/docs/ssh.rd を参照。

== zshのインストール

common/docs/zsh.rd を参照。

== screen のインストール

common/docs/screen.rd を参照。

以後の説明では、ssh + screen + zsh で作業することを前提にします。

== GRUBのインストール

common/docs/grub.rd を参照。

== NTPサーバのインストール

common/docs/ntp.rd を参照。

== lvのインストール

common/docs/lv.rd を参照。

== vimのインストール

common/docs/vim.rd を参照。

== MTA を Postfixに入れ替える。

common/docs/postfix.rd を参照。

== logcheck のインストール

common/docs/logcheck.rd を参照。

== ulogd のインストール

common/docs/ulogd.rd を参照。

== syslog-ng のインストール

common/docs/syslog-ng.rd を参照。

== パケットフィルタの設定

common/docs/iptables.rd を参照。

== パッケージいろいろ

追加でインストールしたパッケージ。

* resolvconf

############################################################
= Web サーバの設定

= Apache のインストール

== インストール

  $ sudo aptitude install apache2-mpm-prefork -y

ブラウザで http://<サーバのIPアドレス>/ にアクセスする。
すると、「It works!」と表示される。

== 設定

* httpd デーモンのユーザ権限: www-data (Debian のデフォルト)
* httpd デーモンのグループ権限: www-data (Debian のデフォルト)
* サイト管理者のアドレス: admin@takao7.net
* ホスト名: www.takao7.net

作業手順。

  $ sudo cp -a /etc/apache2/sites-available /etc/apache2/sites-available.orig
  $ sudo vi /etc/apache2/sites-available/default
  $ diff -ur /etc/apache2/sites-available.orig /etc/apache2/sites-available
    (以下、想定する実行結果)
    diff -ur /etc/apache2/sites-available.orig/default /etc/apache2/sites-available/default
    --- /etc/apache2/sites-available.orig/default   2008-08-09 02:32:34.000000000 +0900
    +++ /etc/apache2/sites-available/default        2008-09-21 23:06:08.577717011 +0900
    @@ -1,5 +1,6 @@
     <VirtualHost *:80>
    -       ServerAdmin webmaster@localhost
    +       ServerAdmin admin@takao7.net
    +       ServerName www.takao7.net
     
            DocumentRoot /var/www/
            <Directory />

== 設定

TODO: root ユーザのパスワードの設定や、ユーザの追加、ファイルの配置の変更などいろいろ

= Ruby on Rails のインストール

== インストール

  w101$ sudo aptitude install ruby ruby1.8 irb irb1.8 ri ri1.8 rdoc rdoc1.8 ruby1.8-dev libopenssl-ruby1.8
    (以下、実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      irb irb1.8 libopenssl-ruby1.8 libreadline-ruby1.8{a} libruby1.8{a} rdoc 
      rdoc1.8 ri ri1.8 ruby ruby1.8 ruby1.8-dev 
    0 packages upgraded, 12 newly installed, 0 to remove and 0 not upgraded.
    Need to get 5553kB of archives. After unpacking 58.8MB will be used.
    ...

  w101$ cd ~/setup                                                         
  w101$ wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
  w101$ tar xzf rubygems-1.3.1.tgz
  w101$ cd rubygems-1.3.1
  w101$ sudo ruby setup.rb

  w101$ sudo gem1.8 install rails --no-ri --no-rdoc
    Successfully installed rake-0.8.3
    Successfully installed activesupport-2.2.2
    Successfully installed activerecord-2.2.2
    Successfully installed actionpack-2.2.2
    Successfully installed actionmailer-2.2.2
    Successfully installed activeresource-2.2.2
    Successfully installed rails-2.2.2
    7 gems installed

  w101$ sudo aptitude install libmysqlclient-dev 
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    Note: selecting "libmysqlclient15-dev" instead of the
          virtual package "libmysqlclient-dev"
    The following NEW packages will be installed:
      libmysqlclient15-dev zlib1g-dev{a} 
    0 packages upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
    Need to get 7347kB of archives. After unpacking 20.9MB will be used.

  w101$ sudo gem1.8 install mysql --no-ri --no-rdoc
    Building native extensions.  This could take a while...
    Successfully installed mysql-2.7
    1 gem installed

  w101$ sudo gem1.8 install mongrel thin --no-ri --no-rdoc 
    Building native extensions.  This could take a while...
    Building native extensions.  This could take a while...
    Successfully installed gem_plugin-0.2.3
    Successfully installed daemons-1.0.10
    Successfully installed fastthread-1.0.1
    Successfully installed cgi_multipart_eof_fix-2.5.0
    Successfully installed mongrel-1.1.5
    Building native extensions.  This could take a while...
    Building native extensions.  This could take a while...
    Successfully installed rack-0.4.0
    Successfully installed eventmachine-0.12.2
    Successfully installed thin-1.0.0
    8 gems installed

  w101$ sudo gem1.8 install mongrel_cluster --no-ri --no-rdoc
    Successfully installed mongrel_cluster-1.0.5
    1 gem installed

= Radiant

CMS として Radiant を導入する。
ruby-lang.org のように NEWS とかをそこにはれればいいだろうね。

== インストール

現在、公式サイトの情報によると Radiant 0.6.9 は rails 2.2 に対応していない。
rails 2.1.2をインストールする。

  w101$ sudo gem1.8 install rails --version=2.1.2 --no-ri --no-rdoc
    Successfully installed activesupport-2.1.2
    Successfully installed activerecord-2.1.2
    Successfully installed actionpack-2.1.2
    Successfully installed actionmailer-2.1.2
    Successfully installed activeresource-2.1.2
    Successfully installed rails-2.1.2
    6 gems installed

  w101$ sudo gem1.8 install radiant --no-ri --no-rdoc
    Successfully installed radiant-0.6.9
    1 gem installed

== 設定

: 配置する場所
  /var/share/data/nfs/radiant/

  実際には NFS で /var/share/nfs/radiant/ にマウントする。

: DB
  MySQL

NFS 上に Radiant を配置する。
マウントポイントを用意する。

  w10[12]$ sudo mkdir /var/share/nfs

マウントする。

  w10[12]$ sudo mount -t nfs -o rw,hard,intr,noac data:/var/share/data/nfs /var/share/nfs

== 参考資料

: Downloading and Installing Radiant
  http://wiki.radiantcms.org/Downloading_and_Installing_Radiant

############################################################
= ファイルサーバの設定

= DRBD のインストール

== インストール

  w101$ sudo aptitude install drbd8-modules-2.6-686
    (以下、実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      drbd8-modules-2.6-686 drbd8-modules-2.6.26-1-686{a} 
    0 packages upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
    Need to get 104kB of archives. After unpacking 344kB will be used.
    ...

  w101$ sudo aptitude install drbd8-utils drbdlinks
    (以下、想定する実行結果) 
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      drbd8-utils drbdlinks 
    0 packages upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
    Need to get 147kB of archives. After unpacking 430kB will be used.
    ...

== 設定

パーティションを作成する。

  /dev/sda7 Linux LVM(8e) 100GB

使用中のディスクの場合、オンラインでは Linux はパーティションを再読み込
みできないため、再起動する。

  w101$ sudo reboot

LVM の設定をする。

  w101$ sudo pvcreate /dev/sda7
    Physical volume "/dev/sda7" successfully created

  w101$ sudo vgextend vg_w101 /dev/sda7
    Volume group "vg_w101" successfully extended

  w101$ sudo lvcreate -nlv_data -L50g vg_w101
    Logical volume "lv_data" created

DRBD の設定をする。
w102 をまだ用意していないが、とりあえず設定をしておく。
参考書によると DRBD の設定は protocol B にしてあったので、それに従っている。

  w101$ f=/etc/drbd.conf
  w101$ sudo cp -a -i ${f} ${f}.orig
  w101$ sudo vi ${f}                
  w101$ cat ${f}
    global {
        usage-count yes;
    }
    
    common {
      protocol B;
    
      net {
        after-sb-0pri disconnect;
        after-sb-1pri disconnect;
        after-sb-2pri disconnect;
        rr-conflict disconnect;
      } 
    
      startup {
        wfc-timeout 120;
        degr-wfc-timeout 120;
      } 
    
      disk {
        on-io-error call-local-io-error;
      }
    
      syncer { 
        rate 10M;
        al-extents 257;
      }
    }
    
    resource data {
      handlers {
        pri-on-incon-degr "echo o > /proc/sysrq-trigger ; halt -f";
        pri-lost-after-sb "echo o > /proc/sysrq-trigger ; halt -f";
        local-io-error "echo o > /proc/sysrq-trigger ; halt -f";
      }
    
      on w101 {
        device /dev/drbd0;
        disk /dev/vg_w101/lv_data;
        address 192.168.77.101:7788;
        meta-disk internal;
      }
    
      on w102 {
        device /dev/drbd0;
        disk /dev/vg_w102/lv_data;
        address 192.168.77.102:7788;
        meta-disk internal;
      }
    }

  w101$ sudo drbdadm create-md data
    Writing meta data...
    initialising activity log
    NOT initialized bitmap
    New drbd meta data block sucessfully created.
    success

  w101$ sudo /etc/init.d/drbd start
    Starting DRBD resources:    [ d(data) s(data) n(data) ].
    ... 省略 ...
      --==  Thank you for participating in the global usage survey  ==--
    The server's response is:
    
    node already registered
    ..........
    ***************************************************************
     DRBD's startup script waits for the peer node(s) to appear.
     - In case this node was already a degraded cluster before the
       reboot the timeout is 120 seconds. [degr-wfc-timeout]
     - If the peer was available before the reboot the timeout will
       expire after 120 seconds. [wfc-timeout]
       (These values are for resource 'data'; 0 sec -> wait forever)
     To abort waiting enter 'yes' [  14]:yes
    (上記で、 yes と入力した。)

  w101$ /etc/init.d/drbd status
    drbd driver loaded OK; device status:
    version: 8.0.14rc1 (api:86/proto:86)
    GIT-hash: 1ff3a9d7337173a26f7265e5025df23741d9cc7e build by phil@fat-tyre, 2008-10-29 12:32:14
    m:res   cs            st                 ds                     p  mounted  fstype
    0:data  WFConnection  Secondary/Unknown  Inconsistent/DUnknown  B

もし、上記の出力のうち ds が Diskless であれば、
「drbdadm create-md <リソース名>」を実行する必要がある。

  w101$ /etc/init.d/drbd status
    ... 省略 ...
    m:res   cs            st                 ds                 p  mounted  fstype
    0:data  WFConnection  Secondary/Unknown  Diskless/DUnknown  B

ここで、w101 をベースにして、w102 を作成する。

w102/docs/install.rd を参照。

  w101$ /etc/init.d/drbd status
    drbd driver loaded OK; device status:
    version: 8.0.14rc1 (api:86/proto:86)
    GIT-hash: 1ff3a9d7337173a26f7265e5025df23741d9cc7e build by phil@fat-tyre, 2008-10-29 12:32:14
    m:res   cs         st                   ds                         p  mounted  fstype
    0:data  Connected  Secondary/Secondary  Inconsistent/Inconsistent  B
    (ds が Inconsistent/Inconsistent になっていること)

ディスクの同期を行う。

  w101$ sudo drbdadm -- --overwrite-data-of-peer primary all
    (※ 0.7 系は sudo drbdadm -- --do-what-I-say primary all でした。)

状態を確認しながら、同期されるまで待つ。約 2 時間かかるようだ。
(一番最初の初期化であれば、もっとはやくできないのだろうかね。)

  w101$ /etc/init.d/drbd status
    drbd driver loaded OK; device status:
    version: 8.0.14rc1 (api:86/proto:86)
    GIT-hash: 1ff3a9d7337173a26f7265e5025df23741d9cc7e build by phil@fat-tyre, 2008-10-29 12:32:14
    m:res   cs          st                 ds                     p  mounted  fstype
    0:data  SyncSource  Primary/Secondary  UpToDate/Inconsistent  B
    ...     sync'ed:    0.2%               (51144/51198)M

同期が完了した状態。st が Primary/Secondary、ds が UpToDate/UpToDate　である。

  w101$ /etc/init.d/drbd status
    drbd driver loaded OK; device status:
    version: 8.0.14rc1 (api:86/proto:86)
    GIT-hash: 1ff3a9d7337173a26f7265e5025df23741d9cc7e build by phil@fat-tyre, 2008-10-29 12:32:14
    m:res   cs         st                 ds                 p  mounted  fstype
    0:data  Connected  Primary/Secondary  UpToDate/UpToDate  B
  
ファイルシステムを作成する。

  w101$ sudo mkfs.xfs /dev/drbd0
    meta-data=/dev/drbd0             isize=256    agcount=4, agsize=3276698 blks
             =                       sectsz=512   attr=2
    data     =                       bsize=4096   blocks=13106791, imaxpct=25
             =                       sunit=0      swidth=0 blks
    naming   =version 2              bsize=4096  
    log      =internal log           bsize=4096   blocks=6399, version=2
             =                       sectsz=512   sunit=0 blks, lazy-count=0
    realtime =none                   extsz=4096   blocks=0, rtextents=0

マウントポイントを用意する。

  w10[12]$ sudo install -o root -g root -d -m 755 /var/share/data

手動でマウントしやすいように、w101 と w102 の /etc/fstab に以下を追加。

  /etc/fstab
    # drbd
    /dev/drbd0 /var/share/data xfs rw,suid,dev,exec,noauto,nouser,async 0 0

w101 で /var/share/data をマウントできることを確認する。

  w101$ sudo mount /var/share/data

w101 でファイルを書き込んだあとでアンマウントする。
w102 でマウントしてファイルが同期されていることを確認する。

  w101$ sudo sh -c 'echo "foo" > /var/share/data/foo'
  w101$ sudo umount /var/share/data
  w101$ sudo drbdadm secondary all

  w102$ sudo drbdadm primary all
  w102$ sudo mount /var/share/data
  w102$ cat /var/share/data/foo
    foo
  w102$ sudo rm /var/share/data/foo
  w102$ sudo umount /var/share/data
  w102$ sudo drbdadm secondary all

== 参考資料

: DRBD日本語サイト | DRBD入門ガイド:
  http://www.drbd.jp/documentation/drbd8-howto.html

: drbdを復旧させるメモ - うまい棒blog:
  http://d.hatena.ne.jp/hogem/20080706/1215341445

= NFS のインストール

== インストール

  $ sudo aptitude -y install nfs-kernel-server
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      nfs-kernel-server 
    0 packages upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 150kB of archives. After unpacking 373kB will be used.

== 設定

ディレクトリ構成。

: /var/share/data/nfs
  NFS の管理情報を格納するディレクトリ。
  既存の /var/lib/nfs を本ディレクトリに移動する。
  /var/lib/nfs から本ディレクトリへの symlink を作成する。
: /var/share/data/nfs_data
  NFS で export するディレクトリ。
  /var/www を export したい場合、var/share/data/nfs_data/var/www を作成する。

NFS のホスト名は data とする。/etc/hosts に追加する。

  192.168.77.200  data.takao7.net data

w101 の /dev/drbd を primary にする。

  w101$ sudo drbdadm primary all
  w101$ /etc/init.d/drbd status
    drbd driver loaded OK; device status:
    version: 8.0.14rc1 (api:86/proto:86)
    GIT-hash: 1ff3a9d7337173a26f7265e5025df23741d9cc7e build by phil@fat-tyre, 2008-10-29 12:32:14
    m:res   cs         st                 ds                 p  mounted  fstype
    0:data  Connected  Primary/Secondary  UpToDate/UpToDate  B

/var/share/data をマウントする。

  w101$ sudo mount /var/share/data

/var/lib/nfs を DRBD 上に移動する。

  w101$ sudo mv -v /var/lib/nfs /var/share/data/nfs
    `/var/lib/nfs' -> `/var/share/data/nfs'
    `/var/lib/nfs/sm' -> `/var/share/data/nfs/sm'
    `/var/lib/nfs/sm.bak' -> `/var/share/data/nfs/sm.bak'
    `/var/lib/nfs/rpc_pipefs' -> `/var/share/data/nfs/rpc_pipefs'
    `/var/lib/nfs/state' -> `/var/share/data/nfs/state'
    `/var/lib/nfs/v4recovery' -> `/var/share/data/nfs/v4recovery'
    `/var/lib/nfs/etab' -> `/var/share/data/nfs/etab'
    `/var/lib/nfs/rmtab' -> `/var/share/data/nfs/rmtab'
    `/var/lib/nfs/xtab' -> `/var/share/data/nfs/xtab'
    removed directory: `/var/lib/nfs/sm'
    removed directory: `/var/lib/nfs/sm.bak'
    removed directory: `/var/lib/nfs/rpc_pipefs'
    removed `/var/lib/nfs/state'
    removed directory: `/var/lib/nfs/v4recovery'
    removed `/var/lib/nfs/etab'
    removed `/var/lib/nfs/rmtab'
    removed `/var/lib/nfs/xtab'
    removed directory: `/var/lib/nfs'

  w101$ sudo ln -vs /var/share/data/nfs /var/lib/nfs
    `/var/lib/nfs' -> `/var/share/data/nfs'

w102 で作業する。

  w102$ sudo mv -v /var/lib/nfs /var/lib/nfs.old
    `/var/lib/nfs' -> `/var/lib/nfs.old'

  w102$ sudo ln -vs /var/share/data/nfs /var/lib/nfs
    (TODO: 実行結果をペーストする。)

NFS で export するディレクトリを作成、設定する。

  w101$ sudo install -o root -g root -d -m 755 /var/share/data/nfs_data
  w101$ f=/etc/exports
  w101$ sudo cp -a -i ${f} ${f}.orig
  w101$ sudo vi ${f}
  w101$ tail -n 1 ${f}
    /var/share/data/nfs_data 192.168.77.0/24(rw,sync,no_root_squash,no_subtree_check,fsid=1)

w102 に /etc/exports をコピーする。

VIP を使用するため、/etc/default/nfs-common に VIP に対応するホスト名を記述する。

  w101$ f=/etc/default/nfs-common
  w101$ sudo cp -a -i ${f} ${f}.orig
  w101$ sudo vi ${f}
  w101$ diff -u ${f}.orig ${f}
    --- /etc/default/nfs-common.orig        2008-12-23 12:09:25.907374383 +0900
    +++ /etc/default/nfs-common     2008-12-23 12:09:11.511363061 +0900
    @@ -10,7 +10,7 @@
     #   when you have a port-based firewall. To use a fixed port, set this
     #   this variable to a statd argument like: "--port 4000 --outgoing-port 4001".
     #   For more information, see rpc.statd(8) or http://wiki.debian.org/?SecuringNFS
    -STATDOPTS=""
    +STATDOPTS="-n data"
     
     # Do you want to start the idmapd daemon? It is only needed for NFSv4.
     NEED_IDMAPD=

w102 に /etc/default/nfs-common をコピーする。

w101 でのみ NFS のサービスを開始する。クライアントでマウントできることを確認する。

  w101$ sudo /etc/init.d/nfs-kernel-server restart
  w101$ sudo ifconfig eth0:0 192.168.77.200

  lv1$ sudo install -o root -g root -d -m 755 /var/share/data
  lv1$ sudo mount -t nfs -o rw,hard,noac data:/var/share/data/nfs_data /var/share/data
  lv1$ sudo umount /var/share/data

  w101$ sudo ifconfig eth0:0 down
  w101$ sudo /etc/init.d/nfs-kernel-server stop

== 参考資料

: Server World - Debian GNU/Linux 4.0 - NFSサーバー構築:
  http://www.server-world.info/note?os=deb4&p=nfs

= Heartbeat のインストール

NFS の冗長化と、DRBD の自動切り替えを実現するため、heatbeat を導入する。
サービス用の IP アドレスは 192.168.77.200 (data、data.takao7.net)とする。

== インストール

  w10[12]$ sudo aptitude install heartbeat-2
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    Reading extended state information
    Initializing package states... Done
    Reading task descriptions... DoneThe following NEW packages will be installed:
      gawk{a} heartbeat{a} heartbeat-2 libcurl3{a} libltdl3{a} libnet1{a}
      libopenhpi2{a} libperl5.10{a} libsensors3{a} libsnmp-base{a} libsnmp15{a}
      libssh2-1{a} libsysfs2{a} libxml2-utils{a} openhpid{a}
    0 packages upgraded, 15 newly installed, 0 to remove and 1 not upgraded.
    Need to get 7313kB of archives. After unpacking 18.6MB will be used.

== 設定

マシンを LAN とシリアルのクロスケーブルで接続する。

/etc/ha.d/ha.cf を作成する。

  w101$ sudo cp /usr/share/doc/heartbeat/ha.cf.gz /etc/ha.d 
  w101$ sudo gzip -d /etc/ha.d/ha.cf.gz 
  w101$ f=/etc/ha.d/ha.cf
  w101$ sudo cp -a -i ${f} ${f}.orig
  w101$ sudo vi ${f}
  w101$ cat ${f}
    #debugfile /var/log/ha-debug
    #logfile /var/log/ha-log
    logfacility local0
    keepalive 2
    deadtime 30
    warntime 10
    initdead 120
    
    udpport 694
    baud 19200
    serial /dev/ttyS0
    #bcast eth1 eth2
    #mcast eth0 225.0.0.1 694 1 0
    ucast eth0 192.168.77.102
    
    auto_failback off
    
    #stonith baytech /etc/ha.d/conf/stonith.baytech
    #stonith_host *     baytech 10.0.0.3 mylogin mysecretpassword
    #stonith_host ken3  rps10 /dev/ttyS1 kathy 0 
    #stonith_host kathy rps10 /dev/ttyS1 ken3 0 
    
    #watchdog /dev/watchdog
    
    node w101 w102
    
    ping 192.168.77.10
    #ping_group group1 10.10.10.254 10.10.10.253
    
    #hbaping fc-card-name
    
    #respawn userid /path/name/to/run
    respawn hacluster /usr/lib/heartbeat/ipfail
    
    #apiauth client-name gid=gidlist uid=uidlist
    apiauth ipfail gid=haclient uid=hacluster

/etc/ha.d/haresources を作成する。

  w101$ f=/etc/ha.d/haresources
  w101$ sudo vi ${f}
  w101$ cat ${f}
    w101 drbddisk Filesystem::/dev/drbd0::/var/share/data::xfs 192.168.77.200/24/eth0 killnfsd nfs-common nfs-kernel-server 

killnfsd は自作の Ruby スクリプトで、nfsd に SIGKILL を送る。
has レポジトリの /common/scripts/heartbeat/killnfsd に配置している。

  w10[12]$ sudo cp -a -i ~/setup/has/common/scripts/heartbeat/{killnfsd,resource.rb} /etc/ha.d/resource.d/
  w10[12]$ chmod +x /etc/ha.d/resource.d/killnfsd

/etc/ha.d/authkeys を作成する。

  w101$ f=/etc/ha.d/haresources
  w101$ sudo vi ${f}
  w101$ cat ${f}
    auth 1
    1 crc

  w101$ sudo chmod 600 /etc/ha.d/authkeys

サービスを起動できるようにする。

  w10[12]$ sudo /etc/init.d/nfs-common stop
  w10[12]$ sudo update-rc.d -f nfs-common remove
     Removing any system startup links for /etc/init.d/nfs-common ...
       /etc/rc0.d/K20nfs-common
       /etc/rc1.d/K20nfs-common
       /etc/rc2.d/S20nfs-common
       /etc/rc3.d/S20nfs-common
       /etc/rc4.d/S20nfs-common
       /etc/rc5.d/S20nfs-common
       /etc/rc6.d/K20nfs-common
       /etc/rcS.d/S44nfs-common
    
  w10[12]$ sudo /etc/init.d/nfs-kernel-server stop
  w10[12]$ sudo update-rc.d -f nfs-kernel-server remove
     Removing any system startup links for /etc/init.d/nfs-kernel-server ...
       /etc/rc0.d/K80nfs-kernel-server
       /etc/rc1.d/K80nfs-kernel-server
       /etc/rc2.d/S20nfs-kernel-server
       /etc/rc3.d/S20nfs-kernel-server
       /etc/rc4.d/S20nfs-kernel-server
       /etc/rc5.d/S20nfs-kernel-server
       /etc/rc6.d/K80nfs-kernel-server

設定内容を確認するため w101 だけで、heartbeat を起動してみる。

  w101$ sudo /etc/init.d/heartbeat start
    Starting High-Availability services: 
    Done.
  
ログ (/var/log/syslog) を確認する。2 分後に w101 でサービスが開始できていること。

  heartbeat[5013]: 2008/12/17_21:28:45 info: Local status now set to: 'up'
  (2 分後)
  heartbeat[5013]: 2008/12/17_21:30:45 WARN: node w102: is dead

drbd の状態。

  w101$ sudo /etc/init.d/drbd status    
    drbd driver loaded OK; device status:
    version: 8.0.14rc1 (api:86/proto:86)
    GIT-hash: 1ff3a9d7337173a26f7265e5025df23741d9cc7e build by phil@fat-tyre, 2008-10-29 12:32:14
    m:res   cs         st                 ds                 p  mounted          fstype
    0:data  Connected  Primary/Secondary  UpToDate/UpToDate  B  /var/share/data  xfs

nfs の状態。

  w101$ showmount
    Hosts on w101:
    192.168.77.11
  w101$ showmount -e
    Export list for w101:
    /var/share/data/nfs_data 192.168.77.0/24

うまく動作していることを確認したら、w102 でも同様に設定する。

  w101$ sudo /etc/init.d/heartbeat stop
    Stopping High-Availability services: 
    Done.

w101 から次のファイルをコピーする。

* /etc/ha.d/ha.cf
* /etc/ha.d/haresources
* /etc/ha.d/authkeys

authkeys のパーミションが 600 であることを確認すること。

w101、w102 の順に heatbeat を起動する。

  w10[12]$ sudo /etc/init.d/heartbeat start

しばらくすると、DRBD のディスクをマウントし、クライアントから NFS で
export しているディレクトリをマウントできる。

  w101$ sudo /etc/init.d/drbd status    
    drbd driver loaded OK; device status:
    version: 8.0.14rc1 (api:86/proto:86)
    GIT-hash: 1ff3a9d7337173a26f7265e5025df23741d9cc7e build by phil@fat-tyre, 2008-10-29 12:32:14
    m:res   cs         st                 ds                 p  mounted          fstype
    0:data  Connected  Primary/Secondary  UpToDate/UpToDate  B  /var/share/data  xfs

nfs の状態。

  w101$ showmount
    Hosts on w101:
    192.168.77.11
  w101$ showmount -e
    Export list for w101:
    /var/share/data/nfs_data 192.168.77.0/24

フェイルオーバとフェイルバックを試す。

  w10[1]$ sudo /etc/init.d/heartbeat standby
    auto_failback: off
    Attempting to enter standby mode
    2008/12/23_13:52:24 Going standby [all].
    Done.

lv1 で /var/share/data をマウントして、watch コマンドで 0.5 秒間隔でファ
イルの読み込みを行った。だいたい、 30 秒でフェイルオーバできる。

続いて、サービスの監視スクリプトを作成する。

== ログ

* standby 開始。

  heartbeat[8846]: 2008/12/17_22:40:59 info: w101 wants to go standby [all]

* standby 完了。

  heartbeat[8846]: 2008/12/17_22:41:00 info: Local standby process completed [all].

== 参考資料

: DRBD公式サイト NFS
  http://www.linux-ha.org/DRBD/NFS

############################################################
= DB サーバの設定

= MySQL のインストール

== インストール

  $ sudo aptitude install mysql-server mysql-client -y
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      libdbd-mysql-perl{a} libdbi-perl{a} libhtml-template-perl{a} 
      libnet-daemon-perl{a} libplrpc-perl{a} libterm-readkey-perl{a} 
      mysql-client mysql-client-5.0{a} mysql-server mysql-server-5.0{a} 
      psmisc{a} 
    0 packages upgraded, 11 newly installed, 0 to remove and 0 not upgraded.
    Need to get 35.6MB of archives. After unpacking 105MB will be used.

== 設定

: データベース領域のトップディレクトリ
  /var/share/data/mysql
: ユーザ
  mysql
: グループ
  mysql
: ポート
  3306
: ソケット
  /var/run/mysqld/mysqld.sock
: PID
  /var/run/mysqld/mysqld.pid

MySQL のデータディクレクトリを /var/share/data/mysql に移動させる。

  w101$ sudo /etc/init.d/mysql stop
  w101$ sudo mv -v /var/lib/mysql /var/share/data/

また、w102 は .old にリネームしておく。

  w102$ sudo /etc/init.d/mysql stop
  w102$ sudo mv -v /var/lib/mysql /var/lib/mysql.old

mysql のデータディクレクトリの指定を変更する。

mysql を heartbeat のリソースに追加するための準備。

  w10[12]$ sudo update-rc.d -f mysql remove
     Removing any system startup links for /etc/init.d/mysql ...
       /etc/rc0.d/K21mysql
       /etc/rc1.d/K21mysql
       /etc/rc2.d/S19mysql
       /etc/rc3.d/S19mysql
       /etc/rc4.d/S19mysql
       /etc/rc5.d/S19mysql
       /etc/rc6.d/K21mysql

  w10[12]$ sudo vi /etc/mysql/conf.d/my.cnf
  w10[12]$ cat /etc/mysql/conf.d/my.cnf
    [mysqld]
    datadir = /var/share/data/mysql
    bind-address = 0.0.0.0

  w101$ sudo /etc/init.d/mysql start
    Starting MySQL database server: mysqld.
    Checking for corrupt, not cleanly closed and upgrade needing tables..

  w101$ netstat -ln | grep 3306
    tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN     

  w101$ mysql --user=root
    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema | 
    | mysql              | 
    | test               | 
    +--------------------+
    3 rows in set (0.00 sec)

    mysql> quit;

root ユーザのパスワードを設定する。

  w101$ mysql -u root -D mysql
    mysql> UPDATE user SET password=password('new-password') WHERE user='root';
      (new-password の箇所に root ユーザの実際のパスワードを指定する。)
      Query OK, 3 rows affected (0.00 sec)
      Rows matched: 3  Changed: 3  Warnings: 0

    mysql> FLUSH PRIVILEGES;
      Query OK, 0 rows affected (0.00 sec)

    mysql> quit

  w101$ mysql -u root -D mysql -p
    Enter password: (MySQL の root ユーザのパスワードを入力する。)
    mysql> quit

heartbeat に mysql リソースを追加する。

  w10[12]$ sudo vi /etc/heartbeat/haresources
  w10[12]$ cat /etc/heartbeat/haresources
    w101 drbddisk Filesystem::/dev/drbd0::/var/share/data::xfs 192.168.77.200/24/eth0 killnfsd nfs-common nfs-kernel-server mysql

サービスが起動できることを確認する。

standby のあと w102 で kernel のエラーが出力された。
マジック sysrq パターンだ。

w102$  w102 kernel: [140706.471113] ------------[ cut here ]------------
 w102 kernel: [140706.471113] invalid opcode: 0000 [#1] SMP
 w102 kernel: [140706.471113] Process mount (pid: 12812, ti=f59e0000 task=f77aea40 task.ti=f59e0000)
 w102 kernel: [140706.471113] Stack: f77bac00 c0175a07 c01761c2 c017557b f6b46cc0 f8d8a900 00000000 00000000
 w102 kernel: [140706.471113]        c0176404 00000000 f6b46cc0 f8d75376 f6b46cc0 f8d8a900 00000000 fffffff4
 w102 kernel: [140706.471113]        c0175e2d f8d75376 f6b46cc0 f7f14000 00000000 f7f14000 ffffffed f8d8a900
 w102 kernel: [140706.471113] Call Trace:
 w102 kernel: [140706.471113]  [<c0175a07>] sget+0x2c2/0x2cb
 w102 kernel: [140706.471113]  [<c01761c2>] set_anon_super+0x0/0x93
 w102 kernel: [140706.471113]  [<c017557b>] compare_single+0x0/0x6
 w102 kernel: [140706.471113]  [<c0176404>] get_sb_single+0x2b/0x97
 w102 kernel: [140706.471113]  [<f8d75376>] rpc_fill_super+0x0/0x85 [sunrpc]
 w102 kernel: [140706.471113]  [<c0175e2d>] vfs_kern_mount+0x7b/0xed
 w102 kernel: [140706.471113]  [<f8d75376>] rpc_fill_super+0x0/0x85 [sunrpc]
 w102 kernel: [140706.471113]  [<c0175edd>] do_kern_mount+0x2f/0xb4
 w102 kernel: [140706.471113]  [<c01882d6>] do_new_mount+0x55/0x89
 w102 kernel: [140706.471113]  [<c01884b1>] do_mount+0x1a7/0x1c6
 w102 kernel: [140706.471113]  [<c01864c3>] copy_mount_options+0x26/0x109
 w102 kernel: [140706.471113]  [<c018853d>] sys_mount+0x6d/0xa8
 w102 kernel: [140706.471113]  [<c0103853>] sysenter_past_esp+0x78/0xb1
 w102 kernel: [140706.471113]  =======================
 w102 kernel: [140706.471113] Code: 85 c0 75 f8 f0 ff 05 e0 66 35 c0 eb 05 bb ea ff ff ff 89 d8 5b 5e 5f c3 53 8b 58 10 85 db 74 1f 89 d8 e8 2d 70 fb ff 85 c0 75 04 <0f> 0b eb fe 64 a1 04 40 3b c0 c1 e0 05 ff 84 18 00 01 00 00 5b
 w102 kernel: [140706.471113] EIP: [<c0185d86>] get_filesystem+0x13/0x29 SS:ESP 0068:f59e1e78

mysql コマンドにより、 w102 でサービスが提供される事は確認した。
しかし、 kernel のエラーメッセージは気持ちが悪い。
エラーメッセージの中に mount という文字がある。
また、 w102 で mount コマンドを実行しても sunrpc が存在しない。
もしかすると、また以前発生したエラーなのだろうか。

フェイルバックする。

1分から2分経過後、w102 に一瞬アクセスできなかった。
SSH が切断された。
しかしながら、フェイルバックはできた。状況を確認する。

w102 に mount プロセスが止まっているということはない。
しかし、w102 の mount の実行結果には以下はなかった。
これは問題なのではないだろうか。

  rpc_pipefs on /var/share/data/nfs/rpc_pipefs type rpc_pipefs (rw)

NFS は奥が深いね。

サービスは再開できたようだ。

今日はここまで。
