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


