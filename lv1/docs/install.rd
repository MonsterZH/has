title: "lv1のインストール手順書"

=begin

############################################################
= はじめに

############################################################
= OS

lv1 に Debian GNU/Linux lenny をインストールしたときの作業ログです。

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
  * Hostname: lv1
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

パーティションの設定後。
* LVM VG vg_lv1
  * LVM LV lv_home 2.1 GB f xfs /home
  * LVM LV lv_usr 2.1 GB f xfs /usr
  * LVM LV lv_var 5.8 GB f xfs /var
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

== パケットフィルタの設定

common/docs/iptables.rd を参照。

############################################################
= ロードバランサ

IPVS NAT によるロードバランサを設定する。

== ソフトウェアのインストール

ロードバランサを実現するためのソフトウェア。

* ipvsadm(私の自作)
* keepalived(私の自作)
* iptables(インストール済み)
* iproute

自作パッケージ用の apt-line を追加する。

  lv1$ cd ~/setup/
  lv1$ svn co http://has.googlecode.com/svn/common/debian debian
  lv1$ cd debian
  lv1$ make
  lv1$ sudo vi /etc/apt/sources.list.d/mine.list
  lv1$ cat /etc/apt/sources.list.d/mine.list
    (以下、実行結果)
    deb file:///home/worker/setup/debian ./
    deb-src file:///home/worker/setup/debian ./

インストールする。

  lv1$ sudo aptitude update
  lv1$ sudo aptitude install ipvsadm keepalived iptables iproute
    (以下、実行結果。)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      ipvsadm keepalived 
    0 packages upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
    Need to get 155kB of archives. After unpacking 541kB will be used.
    ...

== 設定

IPフォワーディングを有効にする。

  lv1$ f=/etc/sysctl.conf
  lv1$ sudo cp -a -i ${f} ${f}.orig
  lv1$ diff -u ${f}.orig ${f}
    (以下、実行結果)
    --- /etc/sysctl.conf.orig       2008-04-08 07:50:18.000000000 +0900
    +++ /etc/sysctl.conf    2008-12-15 00:04:06.698002346 +0900
    @@ -19,10 +19,10 @@
     #net.ipv4.conf.all.rp_filter=1
     
     # Uncomment the next line to enable TCP/IP SYN cookies
    -#net.ipv4.tcp_syncookies=1
    +net.ipv4.tcp_syncookies=1
     
     # Uncomment the next line to enable packet forwarding for IPv4
    -#net.ipv4.ip_forward=1
    +net.ipv4.ip_forward=1
     
     # Uncomment the next line to enable packet forwarding for IPv6
     #net.ipv6.conf.all.forwarding=1
    @@ -36,10 +36,10 @@
     # settings are disabled so review and enable them as needed.
     #
     # Ignore ICMP broadcasts
    -#net.ipv4.icmp_echo_ignore_broadcasts = 1
    +net.ipv4.icmp_echo_ignore_broadcasts = 1
     #
     # Ignore bogus ICMP errors
    -#net.ipv4.icmp_ignore_bogus_error_responses = 1
    +net.ipv4.icmp_ignore_bogus_error_responses = 1
     # 
     # Do not accept ICMP redirects (prevent MITM attacks)
     #net.ipv4.conf.all.accept_redirects = 0

lv1 からリアルサーバ(w101)へ接続できることを確認する。

  lv1$ w3m http://w101/ -dump 
    (以下、実行結果)
    It works!

# <不要: ここから>
# ロードバランサ用のネットワークの設定を行う。
# 
#   lv1$ sudo vi /etc/packet-filter.d/500-lvs
#   lv1$ cat /etc/packet-filter.d/500-lvs       
#     (以下、実行結果)
#     $IPTABLES -t mangle -A PREROUTING -d $VIP -j MARK --set-mark 1
#     $IP rule delete prio 100 fwmark 1 table 100 || true
#     $IP rule add prio 100 fwmark 1 table 100 || true
#     $IP route add local default dev lo table 100 || true
# <不要: ここまで>

$IPTABLES、$IP、$VIP に設定している値は以下。VIP はテスト用の値。

  lv1$ cat /etc/default/packet-filter    
    (以下、実行結果)
    IP="/sbin/ip"
    IPTABLES="/sbin/iptables"
    SCRIPTS_DIR="/etc/packet-filter.d"
    WAN_INTERFACE="eth0"
    VIP="192.168.0.240"

設定を反映する。

  lv1$ sudo /etc/init.d/packet-filter start

# <不要: ここから>
# 設定内容を確認する。
# 
#   lv1$ sudo ip rule                    
#     (以下、実行結果)
#     0:      from all lookup local 
#     100:    from all fwmark 0x1 lookup 100 
#     32766:  from all lookup main 
#     32767:  from all lookup default 
# 
#   lv1$ sudo ip route
#     (以下、実行結果)
#     192.168.0.0/24 dev eth0  proto kernel  scope link  src 192.168.0.240 
#     192.168.77.0/24 dev eth1  proto kernel  scope link  src 192.168.77.11 
#     default via 192.168.0.1 dev eth0 
# <不要: ここまで>

keepalived の設定を行う。設定値として、w101 などのホスト名は使用できな
いようだ。IP アドレスを直接記述する必要がある。

  lv1$ sudo vi /etc/keepalived/keepalived.conf
  lv1$ cat /etc/keepalived/keepalived.conf 
    (以下、実行結果)
    virtual_server_group HTTP100 {
      192.168.0.240 80
    }
    
    virtual_server group HTTP100 {
      delay_loop 3
      lvs_sched rr
      lvs_method NAT
      protocol TCP
      virtualhost www.takao7.net
    #  sorry_server 192.168.77.100 80
      real_server 192.168.77.101 80 {
        weight 1
        inhibit_on_failure
        HTTP_GET {
          url {
            path /health.html
            status_code 200
          }
          connect_timeout 3
        }
      }
    #  real_server 192.168.77.102 80 {
    #    weight 1
    #    inhibit_on_failure
    #    HTTP_GET {
    #      url {
    #        path /health.html
    #        status_code 200
    #      }
    #      connect_timeout 3
    #    }
    #  }
    }

w101 に /health.html を配置する。

  w101$ sudo vi /var/www/health.html
  w101$ cat /var/www/health.html
    (以下、実行結果)
    OK

  w101$ sudo vi /var/www/index.html
  w101$ cat /var/www/index.html
    (以下、実行結果)
    <html><body><h1>w101 works!</h1></body></html>

  lv1$ w3m http://w101/health.html -dump
    (以下、実行結果)
    OK

  lv1$ w3m http://w101/test.html -dump
    (以下、実行結果)
    w101 works!

keepalived を起動する。

  lv1$ sudo /etc/init.d/keepalived start
    (以下、実行結果)
    Starting keepalived: keepalived.

  lv1$ sudo ipvsadm -L -n
    (以下、実行結果)
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
      -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    TCP  192.168.0.240:80 rr
      -> 192.168.77.101:80            Masq    1      0          0  

起動時の syslog。

  Dec 14 17:05:05 lv1 Keepalived: Starting Keepalived v1.1.15 (12/14,2008) 
  Dec 14 17:05:05 lv1 Keepalived_healthcheckers: Using LinkWatch kernel netlink reflector...
  Dec 14 17:05:05 lv1 Keepalived_healthcheckers: Registering Kernel netlink reflector
  Dec 14 17:05:05 lv1 Keepalived_healthcheckers: Registering Kernel netlink command channel
  Dec 14 17:05:05 lv1 Keepalived_healthcheckers: Opening file '/etc/keepalived/keepalived.conf'. 
  Dec 14 17:05:05 lv1 Keepalived: Starting Healthcheck child process, pid=16760
  Dec 14 17:05:05 lv1 Keepalived_vrrp: Using LinkWatch kernel netlink reflector...
  
  Dec 14 17:05:05 lv1 Keepalived_vrrp: Registering Kernel netlink reflector
  Dec 14 17:05:05 lv1 Keepalived_vrrp: Registering Kernel netlink command channel
  Dec 14 17:05:05 lv1 Keepalived_vrrp: Registering gratutious ARP shared channel
  Dec 14 17:05:05 lv1 Keepalived_vrrp: Opening file '/etc/keepalived/keepalived.conf'. 
  Dec 14 17:05:05 lv1 Keepalived: Starting VRRP child process, pid=16762
  Dec 14 17:05:05 lv1 Keepalived_healthcheckers: Configuration is using : 9185 Bytes
  Dec 14 17:05:05 lv1 Keepalived_vrrp: Configuration is using : 30043 Bytes
  Dec 14 17:05:06 lv1 kernel: [15855.040885] IPVS: [rr] scheduler registered.
  Dec 14 17:05:06 lv1 Keepalived_healthcheckers: Activating healtchecker for service [192.168.77.101:80]

/etc/packet-filter/300-accepts を修正し、 80 ポートを開ける。
そして、クライアントから / にアクセスする。

  ragdoll$ w3m -dump http://192.168.0.240/
    (以下、実行結果)
    w101 works!

これでロードバランサの設定が完了。

