= ハードウェア仕様

http://www1.jp.dell.com/content/products/productdetails.aspx/pedge_t105?c=jp&cs=jpbsd1&l=ja&s=bsd

: 型番
  DELL PowerEdge T105
: CPU
  デュアルコアAMD Opteron プロセッサ-1212 2.0GHz 2MB L2 Cache, 103W
: メモリ
  1GB (2x512MB 1R) DDR2/667MHz バッファ無し SDRAM DIMM ECC
  ECC DDR2 667/800 SDRAM バッファ無し DIMMソケット×4（システム最大8GB）
: ハードディスク
  160GB 3.5インチ SATAハート゛テ゛ィスク (7,200回転)
: 光学ドライブ
  16倍速 SATA DVD Drive
: チップセット
  NVIDIA CK804Pro
: グラフィックス	
  ATI ES1000 VGA コントローラ
: NIC
  オンボードBroadcom ギガビットイーサネットコントローラ
: I/Oスロット
  * PCI Expressx8(2) 「ハーフレングスフルハイト」
  * PCI Expressx1(1) 「ハーフレングスフルハイト」
  * PCI 32ビット/33MHz(1) 「ハーフレングスフルハイト」
: IOポート
  * 背面：シリアル× 1、USB 2.0×5、NIC×1、ビデオ×1
  * 前面：USB 2.0×2
: シャーシ	
  * 外形寸法：413×187×458mm(高さ x 幅 x 奥行)
  * 12.97Kg(最大構成)
: 電源
  標準305W×1基（冗長電源未対応）

= 光学式ドライブ(CDやDVD)から起動する方法

パワーボタンを押し、マシンの電源を入れる。
起動画面でF11キーを押す。
しばらくすると、Boot Device Menu が表示される。
メディアをドライブに挿入する。
「* Embedded Optical Drive Port C」を選択する。

= CPU のコアを 2 つ認識させる方法

「Dual-Core AMD Opteron(tm) Processor 1212」という CPU を使用しているこ
とを想定。

  $ sudo aptitude install linux-image-2.6-i686
  $ sudo update-grub

そして、再起動。

最初は linux-image-2.6-amd64 をインストールしていたが、
64 ビットな環境では IPVS が正しく動作できなかったため、
i686 に乗り換えた。

参考 URL: http://d.hatena.ne.jp/rx7/20080120/p5
