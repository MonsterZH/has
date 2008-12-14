= DNSサーバのインストール

現在の takao7.net と同様の DNS サーバを設定します。

== インストール

  lv1$ sudo aptitude install bind9
  (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      bind9 bind9utils{a} 
    0 packages upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
    Need to get 328kB of archives. After unpacking 991kB will be used.
    ...
    Adding group `bind' (GID 106) ...
    Done.
    Adding system user `bind' (UID 105) ...
    Adding new user `bind' (UID 105) with group `bind' ...
    ...

== 設定

現在の takao7.net の設定は次のようになっています。
* bind8 を使用。
* DNS サーバは persian.takao7.net で 210.251.121.186。
* 管理者のメールアドレスは admin@takao7.net。
* MX は persian。
* セカンダリ DNS は ns.tokyo.netlab.jp。
* サブドメインはメール用の mail と WWW 用の www。
* シリアル番号は 2008081001 のように <年><月><日><番号>。
今回は、bind8 から bind9 への移行も行います。

まずはデフォルトの設定を保存しておき、あとで diff が取れるようにしておきます。

  lv1$ sudo cp -r /etc/bind/ /etc/bind.orig

設定を変更します。現在の takao7.net の設定を worker@lv1:~/setup/bind/
に配置しておきましたので、それをコピーして修正するということを行います。

  lv1$ sudo cp ~/setup/bind/db.takao7.net /etc/bind/
  lv1$ sudo vi /etc/bind/db.takao7.net
  (いろいろ修正。)

  lv1$ sudo cp ~/setup/bind/db.210.251.121 /etc/bind/
  lv1$ sudo vi /etc/bind/db.210.251.121
  (いろいろ修正。)

  lv1$ sudo vi setup/bind/named.conf.local /etc/bind/named.conf.local
  (setup/bind/named.conf.local のコメント以外の内容を /etc/bind/named.conf.local に転記した。)

とりあえず、bind9 を再起動して動作を確認する。

  lv1$ sudo /etc/init.d/bind9 restart
    (以下、想定する実行結果)
    Stopping domain name service...: bind9.
    Starting domain name service...: bind9.

dig コマンドで動作を確認します。
  lv1$ dig lv1.takao7.net ANY @localhost  
    (以下、想定する実行結果)
    
    ; <<>> DiG 9.5.0-P1 <<>> lv1.takao7.net ANY @localhost
    ;; global options:  printcmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43183
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 2
    
    ;; QUESTION SECTION:
    ;lv1.takao7.net.                        IN      ANY
    
    ;; ANSWER SECTION:
    lv1.takao7.net.         500     IN      A       210.251.121.186
    
    ;; AUTHORITY SECTION:
    takao7.net.             500     IN      NS      lv1.takao7.net.
    takao7.net.             500     IN      NS      ns.tokyo.netlab.jp.
    
    ;; ADDITIONAL SECTION:
    ns.tokyo.netlab.jp.     604080  IN      A       219.114.106.18
    ns.tokyo.netlab.jp.     604080  IN      AAAA    2001:380:17a:1::1
    
    ;; Query time: 1 msec
    ;; SERVER: 127.0.0.1#53(127.0.0.1)
    ;; WHEN: Sun Aug 10 22:23:17 2008
    ;; MSG SIZE  rcvd: 138

  lv1$ dig mail.takao7.net ANY @localhost
    (以下、想定する実行結果)
    
    ; <<>> DiG 9.5.0-P1 <<>> mail.takao7.net ANY @localhost
    ;; global options:  printcmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 38786
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3
    
    ;; QUESTION SECTION:
    ;mail.takao7.net.               IN      ANY
    
    ;; ANSWER SECTION:
    mail.takao7.net.        500     IN      A       210.251.121.186
    
    ;; AUTHORITY SECTION:
    takao7.net.             500     IN      NS      ns.tokyo.netlab.jp.
    takao7.net.             500     IN      NS      lv1.takao7.net.
    
    ;; ADDITIONAL SECTION:
    ns.tokyo.netlab.jp.     604059  IN      A       219.114.106.18
    ns.tokyo.netlab.jp.     604059  IN      AAAA    2001:380:17a:1::1
    lv1.takao7.net.         500     IN      A       210.251.121.186
    
    ;; Query time: 0 msec
    ;; SERVER: 127.0.0.1#53(127.0.0.1)
    ;; WHEN: Sun Aug 10 22:23:38 2008
    ;; MSG SIZE  rcvd: 159

  lv1$ dig www.takao7.net ANY @localhost
    (以下、想定する実行結果)
    
    ; <<>> DiG 9.5.0-P1 <<>> www.takao7.net ANY @localhost
    ;; global options:  printcmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 46640
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3
    
    ;; QUESTION SECTION:
    ;www.takao7.net.                        IN      ANY
    
    ;; ANSWER SECTION:
    www.takao7.net.         500     IN      A       210.251.121.186
    
    ;; AUTHORITY SECTION:
    takao7.net.             500     IN      NS      ns.tokyo.netlab.jp.
    takao7.net.             500     IN      NS      lv1.takao7.net.
    
    ;; ADDITIONAL SECTION:
    ns.tokyo.netlab.jp.     604044  IN      A       219.114.106.18
    ns.tokyo.netlab.jp.     604044  IN      AAAA    2001:380:17a:1::1
    lv1.takao7.net.         500     IN      A       210.251.121.186
    
    ;; Query time: 0 msec
    ;; SERVER: 127.0.0.1#53(127.0.0.1)
    ;; WHEN: Sun Aug 10 22:23:53 2008
    ;; MSG SIZE  rcvd: 158

  lv1$ dig 186.121.251.210.in-addr.arpa PTR @localhost
    (以下、想定する実行結果)
    
    ; <<>> DiG 9.5.0-P1 <<>> 186.121.251.210.in-addr.arpa PTR @localhost
    ;; global options:  printcmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 48286
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3
    
    ;; QUESTION SECTION:
    ;186.121.251.210.in-addr.arpa.  IN      PTR
    
    ;; ANSWER SECTION:
    186.121.251.210.in-addr.arpa. 86400 IN  PTR     lv1.takao7.net.
    
    ;; AUTHORITY SECTION:
    121.251.210.in-addr.arpa. 86400 IN      NS      lv1.takao7.net.
    121.251.210.in-addr.arpa. 86400 IN      NS      ns.tokyo.netlab.jp.
    
    ;; ADDITIONAL SECTION:
    ns.tokyo.netlab.jp.     604031  IN      A       219.114.106.18
    ns.tokyo.netlab.jp.     604031  IN      AAAA    2001:380:17a:1::1
    lv1.takao7.net.         500     IN      A       210.251.121.186
    
    ;; Query time: 0 msec
    ;; SERVER: 127.0.0.1#53(127.0.0.1)
    ;; WHEN: Sun Aug 10 22:24:06 2008
    ;; MSG SIZE  rcvd: 180

ブラウザを使い、DNS のチェックサイトで設定内容を確認します。
TODO: これはあとでやります。
((<URL:http://www.dnsstuff.com/tools/dnsreport.ch?domain=takao7.net>))
