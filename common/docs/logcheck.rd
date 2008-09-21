= logcheck のインストール

== インストール

  $ sudo aptitude install logcheck logcheck-database -y
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      lockfile-progs{a} logcheck logcheck-database logtail{a} 
    0 packages upgraded, 4 newly installed, 0 to remove and 0 not upgraded.

== 動作確認

以下のコマンドを実行し、出力結果を確認しました。

  $ sudo su -s /bin/bash -c "/usr/sbin/logcheck -t -d -o" logcheck
