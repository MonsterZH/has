= zsh のインストール

私が通常使用するシェルは zsh です。早速 zsh をインストールします。

== インストール

これまでの作業で SSH サーバと sudo の設定が終わっています。今後の作業は、
作業 PC から SSH を使用して worker ユーザでログインして行います。root
権限が必要な作業は、sudo を利用します。

  $ sudo aptitude install zsh 
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      zsh 
    0 packages upgraded, 1 newly installed, 0 to remove and 12 not upgraded.
    Need to get 3997kB of archives. After unpacking 11.8MB will be used.

== 設定

  $ chsh -s /bin/zsh
    (以下、想定する実行結果)
    Password: <- ここで worker ユーザのパスワードを入力。

  $ exit

  MyPC$ slogin worker@<サーバのアドレス>
    (以下、想定する実行結果)
    This is the Z Shell configuration function for new users, zsh-newuser-install.
    You are seeing this message because you have no zsh startup files
    (the files .zshenv, .zprofile, .zshrc, .zlogin in the directory
    ~).  This function can help you with a few settings that should
    make your use of the shell easier.
    
    You can:
    
    (q)  Quit and do nothing.  The function will be run again next time.
    
    (0)  Exit, creating the file ~/.zshrc containing just a comment.
         That will prevent this function being run again.
    
    (1)  Continue to the main menu.
    
    --- Type one of the keys in parentheses --- 0 <- ここで 0 を入力しました。

へぇ、lenny の zsh は設定ファイルがなければ、デフォルトの設定ファイルを
作るためのウィザードが起動するんですね。今回は、これまで私が使っていた
.zshrc があるので、それをコピーします。

  MyPC$ scp ~/work/private/dot.zshrc worker@<サーバのアドレス>:.zshrc
    (以下、想定する実行結果)
    dot.zshrc                                     100% 4789     4.7KB/s   00:00    

  MyPC$ slogin worker@<サーバのアドレス>
    (以下、想定する実行結果)
    Last login: Sat Aug  9 23:43:49 2008 from 192.168.0.3
    worker:/home/worker:0
    <ホスト名>$ 

== .zshrc

以下が私の .zshrc です。このファイルはかなり前に作成したきりで、最近は
更新していません。
zsh はいろんなことができるので、便利な設定があればどんどん取り込んでい
きたいですね。

  #############################
  #! Is colorful terminal ?
  
  export COLOR_P
  if [ "$TERM" = "dumb" -o "$TERM" = "emacs" ]; then
      COLOR_P="nil"
  else # color
      COLOR_P="t"
  fi
  
  ##############################
  #! autoload
  
  if [ "$COLOR_P" = "t" ]; then
  #! colorful
      autoload -U colors
      colors
  fi
  
  #! ultimate completion
  if [ ! "x$TERM" = "xemacs" ]; then
      autoload -U compinit
      compinit -u
  fi
  
  ##############################
  #! customize prompt
  
  #! left prompt
  PS1='%n:%c:%j
  %m%(!,#,$) ' # non color
  
  RPS1='' # nothing
  
  precmd() { }
  preexec () { }
  
  ##############################
  #! zstyle
  
  #! don't differentiation upcase and downcase completion
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
  
  #! color completion
  if [ "$COLOR_P" = "t" ]; then
      # Linux
      #eval `dircolors`
      LS_COLORS='di=00;36:'
      zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  fi
  
  ##############################
  #! keybing
  
  # emacs
  bindkey -e
  
  # vi
  #bindkey -v
  
  ##############################
  #! extented function
  
  #! logout Control-D
  setopt  IGNORE_EOF
  
  setopt	HIST_IGNORE_DUPS
  setopt	HIST_REDUCE_BLANKS
  setopt	HIST_IGNORE_SPACE
  setopt	HIST_NO_STORE
  setopt	SHARE_HISTORY
  setopt	PRINT_EIGHT_BIT
  setopt	INTERACTIVE_COMMENTS
  setopt	NUMERIC_GLOB_SORT
  
  path=(
  $HOME/local/sbin
  $HOME/local/bin
  /sbin
  /bin
  /usr/sbin
  /usr/bin
  /usr/local/sbin
  /usr/local/bin
  /usr/X11R6/bin
  )
  
  export  EDITOR=vi
  #export	LESS='--buffers=512 --quit-if-one-screen --LONG-PROMPT'
  export	LESS='--LONG-PROMPT'
  export	LESSCHARSET=ascii
  export	JLESSCHARSET=japanese-euc
  export	PAGER=less
  export	GZIP=-9
  export	BZIP2=-9
  export	CVS_RSH=ssh
  export	PERL_BADLANG=
  export	G_FILENAME_ENCODING=UTF-8
  export	G_BROKEN_FILENAMES=UTF-8
  
  # Linux
  if [ "$COLOR_P" = "t" ]; then
      alias ls='ls --color=auto -h'
      alias dir='ls --color=auto --format=vertical'
      alias vdir='ls --color=auto --format=long'
  else
      alias ls='ls -h'
      alias dir='ls --format=vertical'
      alias vdir='ls --format=long'
  fi
  
  #alias   rm='$HOME/local/bin/trash'
  alias	j='jobs -l'
  alias	sl=ls
  alias	llh='ls -lhF'
  alias	ll='ls -lF'
  alias	lf='ls -F'
  alias	la='ls -aF'
  #alias	svn='LC_ALL=C svn'
  alias	iv='vi -R'
  
  if which jless >& /dev/null
  then
      alias	less='jless -n'
  else
      alias	less='less -n'
  fi
  
  # backup files display and remove command
  alias chkbackups='/usr/bin/find . -maxdepth 1 -name "?*~" -o -name "?*.bak" -o -name ".[^.]?*~" -o -name ".[^.]?*.bak"'
  alias rmbackups='chkbackups | xargs rm'
  
  fignore=(.o \~)
  WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
  HISTFILE=$HOME/.zsh_history
  HISTSIZE=99999
  SAVEHIST=99999
  LISTMAX=0
  APPENDHISTORY=
  
  [ -e $HOME/.login ] && . $HOME/.login
  umask 022
  
  export LD_LIBRARY_PATH=/usr/lib/debug:$HOME/local/lib:/opt/local/lib
  ulimit -c 1000000
  
  #! for creating debian package
  export DEBFULLNAME="TAKAO Kouji"
  export EMAIL="kouji@takao7.net"
  
  #! ruby
  #export RUBYLIB=$HOME/local/lib/site_ruby/1.8
  #export REFE_DATA_DIR=$HOME/local/share/refe
  
  export WHOIS_SERVER=whois.jp
  
  ############################################################
  # completion
  
  # Rake
  # http://weblog.rubyonrails.org/2006/03/09/fast-rake-task-completion-for-zsh/
  
  _rake_does_task_list_need_generating () {
    if [[ ! -f .rake_tasks ]]; then return 0;
    else
      return $([[ Rakefile -nt .rake_tasks ]])
    fi
  }
  
  _rake () {
    if [[ -f Rakefile ]]; then
      if _rake_does_task_list_need_generating; then
        echo "\nGenerating .rake_tasks..." >&2
        rake --silent --tasks | cut -d " " -f 2 >| .rake_tasks
      fi
      compadd $(<.rake_tasks)
    fi
  }
  
  compdef _rake rake
