= ulogd のインストール

== インストール

  $ sudo aptitude install ulogd
    (以下、想定する実行結果)
    ...
    The following NEW packages will be installed:
      ulogd 
    0 packages upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 48.6kB of archives. After unpacking 246kB will be used.

== 設定

ulogd によるパケットフィルタのログを logcheck の対象に追加します。

  $ sudo cp -i /etc/logcheck/logcheck.logfiles \
               /etc/logcheck/logcheck.logfiles.orig 
  $ sudo vi /etc/logcheck/logcheck.logfiles
  (/var/log/ulog/syslogemu.logを追加)

  $ sudo diff -u /etc/logcheck/logcheck.logfiles.orig /etc/logcheck/logcheck.logfiles
    (以下、想定する実行結果)
    --- /etc/logcheck/logcheck.logfiles.orig        2008-08-10 23:59:51.005899560 +0900
    +++ /etc/logcheck/logcheck.logfiles     2008-08-11 00:00:07.629378920 +0900
    @@ -2,3 +2,4 @@
     # This has been tuned towards a default syslog install
     /var/log/syslog
     /var/log/auth.log
    +/var/log/ulog/syslogemu.log
