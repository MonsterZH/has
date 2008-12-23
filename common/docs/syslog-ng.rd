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

TODO: syslog サーバとして設定する。
