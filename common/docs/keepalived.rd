= keepalived

LVS を実現するために使用できるソフトウェア keepalived の Debian
GNU/Linux lenny 用パッケージが Linux カーネル 2.6.26 に対応していなかっ
た。そこで、対応させた deb パッケージを作成した。その作業ログ。

使用中のカーネルの ip_vs.h をコピーする。

  $ cd ~/setup/
  $ apt-get source keepalived
  $ sudo aptitude build-dep keepalived
  $ cd keepalived-1.1.15
  $ dch -v 1.1.15-1-0takao7.net1
  $ cd ../keepalived-1.1.15-1
  $ cp /usr/src/linux-source-2.6.26/include/net/ip_vs.h debian/include/net/ip_vs.h
  $ mkdir -p debian/net/core
  $ cp /usr/src/linux-source-2.6.26/net/core/link_watch.c debian/net/core/
  $ debuild -uc -us
    (以下、実行結果)
    This package has a Debian revision number but there does not seem to be
    an appropriate original tar file or .orig directory in the parent directory;
    (expected keepalived_1.1.15-1.orig.tar.gz or keepalived-1.1.15-1.orig)
    continue anyway? (y/n) y
  $ cd ..
  $ sudo dpkg -i keepalived_1.1.15-1-0takao7.net1_i386.deb 

/etc/keepalived/keepalived.conf を作成している場合、dpkg の実行直後に
keepalived が起動してしまうことに注意する。
