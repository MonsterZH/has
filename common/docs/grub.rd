= GRUBのインストール

root ファイルシステムが xfs なので、OS のインストール時にブートローダと
して LILO を選択しました。
今後は GRUB を使用するので、インストールします。また、 LILO は不要なた
めパッケージや設定の削除などをします。

== インストール

  $ sudo aptitude install grub -y
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Writing extended state information... Done
    Reading task descriptions... Done         
    The following NEW packages will be installed:
      grub grub-common{a} 
    0 packages upgraded, 2 newly installed, 0 to remove and 12 not upgraded.
    Need to get 574kB of archives. After unpacking 1057kB will be used.

== 設定

  $ sudo grub-install /dev/sda
    (以下、想定する実行結果)
    Searching for GRUB installation directory ... found: /boot/grub
    The file /boot/grub/stage1 not read correctly.

  $ sudo grub
    (以下、想定する実行結果)
    GNU GRUB  version 0.97  (640K lower / 3072K upper memory)

       [ Minimal BASH-like line editing is supported.   For
         the   first   word,  TAB  lists  possible  command
         completions.  Anywhere else TAB lists the possible
         completions of a device/filename. ]

    grub> root (hd0,4)
     Filesystem type is xfs, partition type 0x83
    
    grub> setup (hd0)
     Checking if "/boot/grub/stage1" exists... yes
     Checking if "/boot/grub/stage2" exists... yes
     Checking if "/boot/grub/xfs_stage1_5" exists... yes
     Running "embed /boot/grub/xfs_stage1_5 (hd0)"...  21 sectors are embedded.
    succeeded
     Running "install /boot/grub/stage1 (hd0) (hd0)1+21 p (hd0,4)/boot/grub/stage2
    /boot/grub/menu.lst"... succeeded
    Done.

    grub> quit

  $ sudo update-grub 
    (以下、想定する実行結果)
    Searching for GRUB installation directory ... found: /boot/grub
    Searching for default file ... found: /boot/grub/default
    Testing for an existing GRUB menu.lst file ... 
    
    
    Generating /boot/grub/menu.lst
    Searching for splash image ... none found, skipping ...
    Found kernel: /boot/vmlinuz-2.6.24-1-486
    Updating /boot/grub/menu.lst ... done

  $ sudo sed -i.orig -e 's|\(timeout.*\)5|\11|' /boot/grub/menu.lst
  $ diff -u /boot/grub/menu.lst.orig /boot/grub/menu.lst
    (以下、想定する実行結果)
    --- /boot/grub/menu.lst.orig    2008-08-10 22:26:19.285898720 +0900
    +++ /boot/grub/menu.lst 2008-08-10 22:29:22.030630560 +0900
    @@ -16,7 +16,7 @@
     ## timeout sec
     # Set a timeout, in SEC seconds, before automatically booting the default entry
     # (normally the first entry defined).
    -timeout                5
    +timeout                1
     
     # Pretty colours
     color cyan/blue white/blue

LILO をアンインストールする。

  $ sudo aptitude remove --purge lilo -y
    (以下、想定する実行結果)
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following packages will be REMOVED:
      lilo mbr{pu} 
    0 packages upgraded, 0 newly installed, 2 to remove and 12 not upgraded.
    Need to get 0B of archives. After unpacking 1286kB will be freed.

あと、カーネルのインストール時にブートローダの設定が更新されないようにする。

  $ sudo sed -i.orig 's|do_bootloader = yes|do_bootloader = no|' /etc/kernel-img.conf 
  $ diff -u /etc/kernel-img.conf.orig /etc/kernel-img.conf 
    (以下、想定する実行結果)
    --- /etc/kernel-img.conf.orig   2008-08-09 15:01:41.932219228 +0900
    +++ /etc/kernel-img.conf        2008-08-10 00:51:37.392003048 +0900
    @@ -2,7 +2,7 @@
     # See kernel-img.conf(5) for details
     do_symlinks = yes
     relative_links = yes
    -do_bootloader = yes
    +do_bootloader = no
     do_bootfloppy = no
     do_initrd = yes
     link_in_boot = no
