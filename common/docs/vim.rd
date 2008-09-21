= vimのインストール

vim をインストールします。

  $ sudo aptitude install vim -y

vimを通常使用するエディタに設定します。

  $ sudo update-alternatives --config editor
    (以下、想定する実行結果)
    
    There are 4 alternatives which provide `editor'.
    
      Selection    Alternative
    -----------------------------------------------
              1    /bin/ed
    *+        2    /bin/nano
              3    /usr/bin/vim.tiny
              4    /usr/bin/vim.basic
    
    Press enter to keep the default[*], or type selection number:
    (ここで 4 を入力する)

    Press enter to keep the default[*], or type selection number: 4
    Using '/usr/bin/vim.basic' to provide 'editor'.
