= ipvsadm

IPVS を管理するためのソフトウェア ipvsadm の Debian GNU/Linux lenny 用
パッケージが Linux カーネル 2.6.26 に対応していなかった。そこで、対応さ
せた deb パッケージを作成した。その作業ログ。
あらかじめ apt-get build-dep ipvsadm などにより、必要なパッケージをイン
ストールしておくこと。

  $ cd ~/setup/
  $ apt-get source ipvsadm
  $ cd ipvsadm-1.24
  $ dch -v 1:1.24-2.1-0takao7.net1
  $ cp /usr/src/linux-source-2.6.26/include/net/ip_vs.h debian/include2.6/net/ip_vs.h
  $ debuild -uc -us
  $ cd ..
  $ sudo dpkg -i ipvsadm_1.24-2.1-0takao7.net1_i386.deb
