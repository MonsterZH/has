title: "w101のインストール手順書"

=begin

= はじめに

= OS

w101 に Debian GNU/Linux lenny をインストールしたときの作業ログです。

インストールには ((<URL:http://cdimage.debian.org/cdimage/lenny_di_beta2/i386/iso-cd/debian-LennyBeta2-i386-netinst.iso>)) を利用しました。

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

= sudo のインストール

common/docs/sudo.rd を参照。

= SSHのインストール

common/docs/ssh.rd を参照。

= zshのインストール

common/docs/zsh.rd を参照。

= screen のインストール

common/docs/screen.rd を参照。

以後の説明では、ssh + screen + zsh で作業することを前提にします。

= GRUBのインストール

common/docs/grub.rd を参照。

= NTPサーバのインストール

common/docs/ntp.rd を参照。

= lvのインストール

common/docs/lv.rd を参照。

= vimのインストール

common/docs/vim.rd を参照。

= MTA を Postfixに入れ替える。

common/docs/postfix.rd を参照。

= logcheck のインストール

common/docs/logcheck.rd を参照。

= ulogd のインストール

common/docs/ulogd.rd を参照。

= パケットフィルタの設定

common/docs/iptables.rd を参照。

TODO: lv1 からスクリプトを取得する。

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

TODO: root ユーザのパスワードの設定や、ユーザの追加、ファイルの配置の変更などいろいろ

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

TODO: shared なディレクトリの決定。/etc/exports の設定。/etc/fstab の設定。/etc/init.d/のどこかで nfs をマウントする。

参考URL: http://www.server-world.info/note?os=deb4&p=nfs

= syslog-ng のインストール

== インストール

  $ sudo aptitude -y install syslog-ng
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    Reading extended state information
    Initializing package states... Done
    Reading task descriptions... Done
    The following NEW packages will be installed:
      libevtlog0{a} libglib2.0-0{a} libglib2.0-data{a} syslog-ng
    The following packages will be REMOVED:
      klogd{a} sysklogd{a}
    0 packages upgraded, 4 newly installed, 2 to remove and 0 not upgraded.
    Need to get 1594kB of archives. After unpacking 5337kB will be used.

== 設定

TODO: syslog サーバとして設定する。冗長化を前提とする。

= DRBD のインストール

== インストール

  $ sudo aptitude install drbd8-modules-2.6.26-1-amd64
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Writing extended state information... Done
    Reading task descriptions... Done         
    The following NEW packages will be installed:
      drbd8-modules-2.6.26-1-amd64 
    0 packages upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 101kB of archives. After unpacking 365kB will be used.

  $ sudo aptitude install drbd8-utils drbdlinks
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

== 設定

TODO: shared のパーティションの作成。
