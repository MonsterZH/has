= screen のインストール

サーバのリモート管理には screen が必須です。
リモート管理だけではなく、ローカルマシンでの作業でも必須ですが...

== インストール

  $ sudo aptitude install screen
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      screen 
    0 packages upgraded, 1 newly installed, 0 to remove and 12 not upgraded.
    Need to get 601kB of archives. After unpacking 942kB will be used.

== 設定

.zshrc と同様にこれまで私が使っていた .screenrc があるので、それをコピー
します。

  MyPC$ scp ~/work/private/dot.screenrc worker@<サーバのアドレス>:.screenrc
    (以下、想定する実行結果)
    dot.screenrc                                  100%  388     0.4KB/s   00:00    

動作を確認します。

  $ screen

^zがコマンドキーになっていることと、ハードステータスが表示されているこ
とを確認しました。

== .screenrc

以下が私の .screenrc です。

  startup_message off
  
  defscrollback	10000
  
  #defencoding eucJP
  #defkanji euc
  bind z windows
  bind x windows
  bind ^x windows
  bind ^g windows
  bind ^w vbell
  # bind ^b other
  bind ^b windowlist -b
  bind b other
  bind o focus
  #bind ^s sessionname
  escape ^z^z
  vbell off
  bell "Bell in window % ~"
  
  hardstatus alwayslastline "screen: %w"
  
  screen -t work3
  screen -t work2
  screen -t work1
  screen -t main
