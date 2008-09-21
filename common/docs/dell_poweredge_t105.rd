= 光学式ドライブ(CDやDVD)から起動する方法

パワーボタンを押し、マシンの電源を入れる。
起動画面でF11キーを押す。
しばらくすると、Boot Device Menu が表示される。
メディアをドライブに挿入する。
「* Embedded Optical Drive Port C」を選択する。

= CPU のコアを 2 つ認識させる方法

「Dual-Core AMD Opteron(tm) Processor 1212」という CPU を使用しているこ
とを想定。

  $ sudo aptitude install linux-image-2.6-amd64
  $ sudo update-grub

そして、再起動。
