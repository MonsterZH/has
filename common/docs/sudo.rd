= sudo のインストール

私のサーバ管理のポリシーとして、作業は基本的に作業用の worker ユーザ で行う。
そして、root 権限が必要な操作は sudo を利用する。

== インストール

以下、root ユーザで実行する。

  # aptitude install sudo
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      sudo 
    0 packages upgraded, 1 newly installed, 0 to remove and 12 not upgraded.

== 設定

以下のように設定します。
* sudo グループに属するユーザはパスワードを入力すれば 
  root 権限で任意のコマンドを実行できる。
* worker ユーザを sudo グループに追加する。(※)

このように設定している場合、worker ユーザを乗っ取られるとなんでもできて
しまう。SSH でパスワード認証を無効にしているので、よっぽどのことがない
限り問題ないと思うんだけど、他の人はなんかしているのかな。

※これまで Debian GNU/Linux sarge や etch では作業用のユーザを追加する
グループは staff にしていました。
しかし、今回の lenny での sudo の設定では sudo グループにしました。これ
は、lenny の sudoers に「# %sudo ALL=NOPASSWD: ALL」という記述があった
からです。lenny では sudo グループに追加するのを想定しているのでしょう
かね。

以下、root ユーザで実行する。

  # sed -i.orig 's|# %sudo ALL=NOPASSWD: ALL|%sudo ALL=(ALL) ALL|' /etc/sudoers
  # diff -u /etc/sudoers.orig /etc/sudoers
    (以下、想定する実行結果)
    --- /etc/sudoers.orig	2008-08-09 22:16:40.893009889 +0900
    +++ /etc/sudoers	2008-08-09 22:38:32.042667735 +0900
    @@ -19,4 +19,4 @@
     # Uncomment to allow members of group sudo to not need a password
     # (Note that later entries override this, so you might need to move
     # it further down)
    -# %sudo ALL=NOPASSWD: ALL
    +%sudo ALL=(ALL) ALL
  
  # adduser worker sudo
    (以下、想定する実行結果)
    Adding user `worker' to group `sudo' ...
    Adding user worker to group sudo
    Done.

動作確認をします。
以下、worker ユーザで作業します。

  $ sudo -v
    (以下、想定する実行結果)

    We trust you have received the usual lecture from the local System
    Administrator. It usually boils down to these three things:
    
        #1) Respect the privacy of others.
        #2) Think before you type.
        #3) With great power comes great responsibility.
    
    [sudo] password for worker: 

  $ sudo ls
  $ sudo -k
  $ sudo -v
    (以下、想定する実行結果)
    [sudo] password for worker: 
