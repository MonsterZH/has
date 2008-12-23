= w102

こういった場合、私は mondo を使うのだが、現在の testing には mondo がない!?
そこで、 w102 のハードディスクを w101 に接続し、 knoppix で起動し、dd
コマンドで /dev/sda をまるごと /dev/sdb にコピーする。
コピー先とコピー元を逆にしないように注意しないとね。

w101 と w102 のケースをあけ、w102 の HDD を w101 の HDD1 に接続する。

BIOS の設定で、SATA B を auto に設定する。

起動後、debian の rescue CD を利用する。

part1 と part2 は不安だな。まぁ、なんとかなるだろう。

  $ dd if=/dev/hda of=/dev/sda conv=sync,noerror bs=4096 count=1
  $ dd if=/dev/hda of=/dev/sda conv=sync,noerror bs=4096 count=10
  $ dd if=/dev/hda of=/dev/sda conv=sync,noerror bs=4096 count=100
  $ dd if=/dev/hda of=/dev/sda conv=sync,noerror bs=4096 count=1000
  $ dd if=/dev/hda of=/dev/sda conv=sync,noerror bs=4096

(SIGUSR1 を送ったら、dd が停止してしまった。)

再起動して、w101 から w102 の HDD を抜く。

w101 の BIOS の設定で、SATA B を off に設定する。

w102 に HDD を戻す。

w101 と w102 のシャーシをオープンしたことに関する設定を detected から
enable に変更する。(この機能はすごいと思う。役に立つかどうかはわからな
いけどね。)

w101 が起動することを確認する。drbd のチェックのところで、Ctrl+Alt+Del
で再起動させる。BIOS の画面で電源を切っておいた。

w102 をシングルユーザモードで起動する。予定通り w101 と全く同じようになっている。

== ホスト名の設定

/etc/hostname を自分のホスト名にする。

  # echo "w102" > /etc/hostname

hostname コマンドの実行

  # hostname `cat /etc/hostname`
  # hostname
    (以下、実行結果)
    w102

== ネットワークの設定

/etc/network/interfaces の設定を行う。アドレスやゲートウェイなどを変更する。

  # vi /etc/network/interfaces
    (address 192.168.77.102 に修正しただけ)

etch の場合、以下のようにして NIC の設定ファイルを削除する。

  # rm /etc/udev/rules.d/70-persistent-net.rules

== Postfix の設定

Postfix の設定を行う。

/etc/mailname に自分のホスト名を記述する。

  # echo "w102" > /etc/mailname

/etc/postfix/main.cf のホスト名に関する設定項目を修正する。

  # vi /etc/postfix/main.cf
    (以下、修正内容。)
    myorigin = /etc/mailname
    myhostname = w102.takao7.net
    mydestination = $myhostname, localhost.takao7.net, localhost

== LVM の設定

vg_w101 になっているが、これはしょうがない。直す方法があれば教えてほしい。

== drbd の設定

  # vi /etc/drbd.conf
    (w102 の disk を /dev/vg_101/lv_nfs に修正する。ダサイね。)

なんとなくメタディスクは作成しなおしておく。そうしないといけないとはど
こにもかいてないけどね。

== Apache の設定

index.html のホスト名を修正する。

  # vi /var/www/index.html
    (w101 を w102 に修正する。)

== 再起動

ここで一度、再起動する。

  # reboot

その後、シングルユーザモードで起動する。

== 時計合わせ

NTP サーバとして lv0 を指定する。

  # f=/etc/ntp.conf
  # cp -a -i ${f} ${f}.orig
  # vi ${f}
    (既存の server の行を全て削除し、 server lv0 のみにする。)

  # /etc/init.d/ntp stop
  # aptitude install ntpdate
  # ntpdate-debian
  # /etc/init.d/ntp start

確認する。同期までに 10 分程度かかる。

  # ntpq -pn
    (以下、想定する実行結果。delay、offset、jitter が 0.000 ではないこと。)
       remote           refid      st t when poll reach   delay   offset  jitter
  ==============================================================================
   192.168.77.10   124.41.71.123    3 u   32   64    3    0.123  -325719   1.57

date コマンドを実行し、時刻が正しいことを確認する。

  # date
    (以下、想定する実行結果)
    <現在時刻>

== SSH

SSH のホスト鍵を生成する。

  # cd /etc/ssh
  # mkdir orig
  # mv ssh_host_* orig
  # dpkg-reconfigure -p medium openssh-server
    Creating SSH2 RSA key; this may take some time ...
    Creating SSH2 DSA key; this may take some time ...
  # rm -r orig

== 再起動

シングルユーザモードを抜ける。

  # exit
