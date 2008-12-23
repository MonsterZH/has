# -*- coding: utf-8 -*-
# SSH のユーザ名
set :user, "worker"

# ホスト名と IP アドレスのハッシュ
$hosts = {
  "lv0" => "192.168.77.10",
  "lv1" => "192.168.77.11",
  "lv2" => "192.168.77.12",

  "w101" => "192.168.77.101",
  "w102" => "192.168.77.102",

  "data" => "192.168.77.200",
}

# ゲートウェイ
set :gateway, "210.251.121.180"

# ロードバランサ
role :lv, $hosts["lv1"]

# Web サーバ
role :web, $hosts["w101"], $hosts["w102"]

# データベースサーバ
role :db, $hosts["data"], :primary => true

# ストレージサーバ
role :storage, $hosts["w101"], $hosts["w102"]

# アプリケーションサーバ
role :app, $hosts["w101"], $hosts["w102"]

# 全てのサーバ
role :server, $hosts["lv1"], $hosts["w101"], $hosts["w102"]

# サイト
server "www.takao7.net", :app, :web, :db, :primary => true

set :tmpdir, File.expand_path("../tmp", File.dirname(__FILE__))

# Local Variables:
# mode: ruby
# End:
