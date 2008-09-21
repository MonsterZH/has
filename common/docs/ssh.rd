= SSHのインストール

Debian GNU/Linux lenny は、インストールした時点で SSH クライアントはイ
ンストール済みでした。

  $ ssh -v
    (以下、想定する実行結果)
    OpenSSH_4.7p1 Debian-12, OpenSSL 0.9.8g 19 Oct 2007
    usage: ssh [-1246AaCfgKkMNnqsTtVvXxY] [-b bind_address] [-c cipher_spec]
               [-D [bind_address:]port] [-e escape_char] [-F configfile]
               [-i identity_file] [-L [bind_address:]port:host:hostport]
               [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port]
               [-R [bind_address:]port:host:hostport] [-S ctl_path]
               [-w local_tun[:remote_tun]] [user@]hostname [command]

しかし、 SSH サーバはインストールされていませんでしたのでインストールし
ます。SSH サーバの導入後は、全ての作業を作業マシンから作業対象のサーバ
にログインしてリモートで作業する予定です。

== インストール

以下、worker ユーザで作業しています。

  $ sudo aptitude install openssh-server -y
    (以下、想定する実行結果)
    Reading package lists... Done
    Reading state information... Done
    The following extra packages will be installed:
      libx11-6 libx11-data libxau6 libxcb-xlib0 libxcb1 libxdmcp6 libxext6
      libxmuu1 openssh-blacklist openssh-blacklist-extra x11-common xauth
    Suggested packages:
      ssh-askpass rssh molly-guard
    The following NEW packages will be installed:
      libx11-6 libx11-data libxau6 libxcb-xlib0 libxcb1 libxdmcp6 libxext6
      libxmuu1 openssh-blacklist openssh-blacklist-extra openssh-server x11-common
      xauth
    0 upgraded, 13 newly installed, 0 to remove and 12 not upgraded.
    Need to get 5805kB of archives.
    After this operation, 13.8MB of additional disk space will be used.
    Do you want to continue [Y/n]?  <- ここでエンターキーを押しました。

== 設定

現在の SSH サーバの設定から次のように変更します。
* root ユーザのログインを許可しない。
* パスワード認証を許可しない。
* 公開鍵認証は許可する。

まずは、作業マシン(MyPC)の公開鍵を対象のサーバに配置し、worker ユーザで
ログインできるようにします。
ここでは、対象のサーバとして lv1(IPアドレス:192.168.0.9) を想定しています。

  MyPC$ scp ~/.ssh/id_rsa.pub worker@192.168.0.9:
    (以下、想定する実行結果)
    id_rsa.pub                                    100%  222     0.2KB/s   00:00 

  MyPC$ slogin worker@192.168.0.9
    (以下、想定する実行結果)
    worker@192.168.0.9's password: <- ここで lv1 の worker ユーザのパスワードを入力しました。
  ...

  worker@lv1:~$ install -d -m 700 ~/.ssh
  worker@lv1:~$ mv id_rsa.pub ~/.ssh/authorized_keys
  worker@lv1:~$ chmod 600 ~/.ssh/authorized_keys

動作確認をします。

  MyPC$ slogin worker@192.168.0.9
  (ここで、パスワード入力なしでログインできました。)
  worker@lv1:~$ 

次は 対象のサーバのSSH サーバの設定を変更します。

  # sed -i.orig \
  -e 's|PermitRootLogin yes|PermitRootLogin no|' \
  -e 's|#PasswordAuthentication yes|PasswordAuthentication no|' \
  -e 's|UsePAM yes|UsePAM no|' \
  /etc/ssh/sshd_config

  # diff -u /etc/ssh/sshd_config.orig /etc/ssh/sshd_config
    (以下、想定する実行結果)
    --- /etc/ssh/sshd_config.orig	2008-08-09 19:49:28.388127181 +0900
    +++ /etc/ssh/sshd_config	2008-08-09 21:10:05.716333303 +0900
    @@ -23,7 +23,7 @@
     
     # Authentication:
     LoginGraceTime 120
    -PermitRootLogin yes
    +PermitRootLogin no
     StrictModes yes
     
     RSAAuthentication yes
    @@ -47,7 +47,7 @@
     ChallengeResponseAuthentication no
     
     # Change to no to disable tunnelled clear text passwords
    -#PasswordAuthentication yes
    +PasswordAuthentication no
     
     # Kerberos options
     #KerberosAuthentication no
    @@ -74,4 +74,4 @@
     
     Subsystem sftp /usr/lib/openssh/sftp-server
     
    -UsePAM yes
    +UsePAM no

  # /etc/init.d/ssh restart
    (以下、想定する実行結果)
    Restarting OpenBSD Secure Shell server: sshd.

最後は動作確認です。
ここでは、対象のサーバとして lv1(IPアドレス:192.168.0.9) を想定しています。

  worker@lv1:~$ slogin root@192.168.0.9
    (以下、想定する実行結果)
    The authenticity of host '192.168.0.9 (192.168.0.9)' can't be established.
    RSA key fingerprint is 19:d3:e9:26:3a:85:2b:05:64:d6:b6:da:32:c3:c5:47.
    Are you sure you want to continue connecting (yes/no)? 
    (ここで yes を入力)

    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '192.168.0.9' (RSA) to the list of known hosts.
    Permission denied (publickey).
  
  worker@lv1:~$ slogin worker@192.168.0.9
    (以下、想定する実行結果)
    Permission denied (publickey).
  
  MyPC$ slogin root@192.168.0.9
    (以下、想定する実行結果)
    Permission denied (publickey).
  
  MyPC$ slogin worker@192.168.0.9
    (以下、想定する実行結果)
    Last login: Sat Aug  9 21:04:46 2008 from 192.168.0.3
  worker@lv1:~$ exit

今後の作業は、メンテナンスPCからログインしてリモートで作業します。
