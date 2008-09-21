= MTA を Postfixに入れ替える。

Debian のデフォルト MTA は exim である。私は exim の設定方法を知らない
ため、 Postfix に入れ替える。

== インストール

  $ sudo aptitude install postfix -y
    (以下、想定する実行結果)
    ...
    The following NEW packages will be installed:
      openssl{a} openssl-blacklist{a} postfix ssl-cert{a}
    The following packages will be REMOVED:
      exim4{a} exim4-base{a} exim4-config{a} exim4-daemon-light{a}
    0 packages upgraded, 4 newly installed, 4 to remove and 0 not upgraded.
    Need to get 8541kB of archives. After unpacking 14.0MB will be used.
    ...

    (以下、debconf の設定)
    * Postfix Configuration
      * General type of mail configuration: Local only
      * System mail name: <ホスト名>.takao7.net

== 動作確認

  $ mail -s 'test' worker
    (以下、想定する実行結果)
    test
    .
    Cc: 

mutt を利用して、上記のメールが worker ユーザに届いていることを確認しました。
