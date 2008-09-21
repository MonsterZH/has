= NTPサーバのインストール

サーバの時計を合わせるため、NTPサーバをインストールする。

== インストール

  $ sudo aptitude install ntp -y
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      libcap1{a} ntp 
    0 packages upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
    Need to get 443kB of archives. After unpacking 1126kB will be used.

== 確認

  $ ntpq -pn
    (以下、想定する実行結果)
         remote           refid      st t when poll reach   delay   offset  jitter
    ==============================================================================
    *202.234.64.222  4.67.66.168      2 u   41   64  377   23.302   -2.462   1.029
    -219.117.196.238 133.243.238.163  2 u    6   64  377   24.173  -14.736   0.443
    +122.249.242.246 204.152.184.72   2 u   36   64  377   32.659   -3.036   0.207
    +210.167.182.10  210.173.160.87   3 u    6   64  377   27.049   -2.107   1.136

時刻の同期先は、とりあえず Debian のデフォルトの設定で良いだろう。

* server 0.debian.pool.ntp.org iburst dynamic
* server 1.debian.pool.ntp.org iburst dynamic
* server 2.debian.pool.ntp.org iburst dynamic
* server 3.debian.pool.ntp.org iburst dynamic

実際に運用するときに最寄りの NTP サーバのアドレスに設定を変更する。
また、w101 や w102 のような lv1 配下のサーバは lv1 を見に行くことにする。
