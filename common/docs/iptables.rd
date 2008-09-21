= パケットフィルタの設定

iptables でパケットフィルタを実現する際の設定の方針は以下です。
* /etc/default/packet-filter に全体の設定を記述し、
  /etc/packet-filter.d/ 以下にルールを記述します。
* /etc/init.d/packet-filter を配置し、
  start で /etc/default/packet-filter を読み込んで
  /etc/packet-filter.d/ を順番に実行します
* /etc/network/interfaces の pre-up でパケットフィルタを有効にします。

== 設定

以下の内容で /etc/default/packet-filter を作成します

  IPTABLES="/sbin/iptables"
  SCRIPTS_DIR="/etc/packet-filter.d/"

/etc/packet-filter.d/ を作成します。
  
  $ sudo mkdir /etc/packet-filter.d

以下の内容で /etc/init.d/packet-filter を作成します。
作成後に実行権限を付与します。

  #! /bin/sh
  
  ### BEGIN INIT INFO
  # Provides:             packet-filter
  # Required-Start:
  # Required-Stop:
  # Default-Start:
  # Default-Stop: 
  # Short-Description:    Run iptables to filter packets.
  ### END INIT INFO
  
  set -e
  
  CONFIG_PATH=/etc/default/packet-filter
  test -e ${CONFIG_PATH} || exit 0
  . ${CONFIG_PATH}
  
  . /lib/lsb/init-functions
  
  test -x ${IPTABLES} || exit 0
  test -d ${SCRIPTS_DIR} || exit 0
  
  export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"
  
  case "$1" in
    start)
          for f in `ls ${SCRIPTS_DIR} | grep -v '\(\.[^.]\+\|~\)$' | sort`; do
              f="${SCRIPTS_DIR}/$f"
              log_action_msg "run ${f}"
              . ${f}
          done
          ;;
    *)
          log_action_msg "Usage: /etc/init.d/packet-filter start"
          exit 1
  esac
  
  exit 0

/etc/packet-filter.d/ にパケットフィルタの設定ファイルを配置します。
ファイルが多いので例をいくつか挙げます。

  ----- /etc/packet-filter.d/000-modules -----
  modprobe ip_conntrack_ftp

  ----- /etc/packet-filter.d/001-default-policy -----
  $IPTABLES -F
  $IPTABLES -P INPUT DROP
  $IPTABLES -P FORWARD DROP
  $IPTABLES -P OUTPUT ACCEPT

  ----- /etc/packet-filter.d/100-drops -----
  $IPTABLES -A INPUT -p tcp -m multiport --dports netbios-ns,netbios-dgm -j DROP
  $IPTABLES -A INPUT -p udp -m multiport --dports netbios-ns,netbios-dgm -j DROP

  ----- /etc/packet-filter.d/300-accepts -----
  $IPTABLES -A INPUT -p tcp --dport ssh -j ACCEPT
  $IPTABLES -A INPUT -p tcp --dport bootps -j ACCEPT
  $IPTABLES -A INPUT -p udp --dport bootps -j ACCEPT
  $IPTABLES -A INPUT -p tcp --dport bootpc -j ACCEPT
  $IPTABLES -A INPUT -p udp --dport bootpc -j ACCEPT
  $IPTABLES -A INPUT -p udp --sport domain -j ACCEPT
  $IPTABLES -A INPUT -p udp --dport route -j ACCEPT
  $IPTABLES -A INPUT -p udp --dport ntp -j ACCEPT
  $IPTABLES -A INPUT -p udp --dport snmp -j ACCEPT
  
  $IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  ----- /etc/packet-filter.d/999-ulogd -----
  $IPTABLES -A INPUT -j ULOG --ulog-nlgroup 1 --ulog-prefix "droped packet: "

ネットワークインタフェースのアップよりも前にパケットフィルタを設定する
ように変更します。
/etc/network/interfaces の eth0 などの設定に以下を追記します。

  pre-up /etc/init.d/packet-filter start

== 動作確認

  $ sudo /etc/init.d/packet-filter startrun /etc/packet-filter.d/000-modules.
    (以下、想定する実行結果)
    run /etc/packet-filter.d/001-default-policy.
    run /etc/packet-filter.d/010-lo.
    run /etc/packet-filter.d/020-icmp.
    run /etc/packet-filter.d/100-drops.
    run /etc/packet-filter.d/200-rejects.
    run /etc/packet-filter.d/300-accepts.
    run /etc/packet-filter.d/999-ulogd.

  $ sudo ifdown eth0; sudo ifup eth0
    (以下、想定する実行結果)
    There is already a pid file /var/run/dhclient.eth0.pid with pid 6167
    killed old client process, removed PID file
    Internet Systems Consortium DHCP Client V3.1.1
    Copyright 2004-2008 Internet Systems Consortium.
    All rights reserved.
    For info, please visit http://www.isc.org/sw/dhcp/
    
    Listening on LPF/eth0/00:1e:c9:50:6b:d3
    Sending on   LPF/eth0/00:1e:c9:50:6b:d3
    Sending on   Socket/fallback
    DHCPRELEASE on eth0 to 192.168.0.1 port 67
    run /etc/packet-filter.d/000-modules.
    run /etc/packet-filter.d/001-default-policy.
    run /etc/packet-filter.d/010-lo.
    run /etc/packet-filter.d/020-icmp.
    run /etc/packet-filter.d/100-drops.
    run /etc/packet-filter.d/200-rejects.
    run /etc/packet-filter.d/300-accepts.
    run /etc/packet-filter.d/999-ulogd.
    Internet Systems Consortium DHCP Client V3.1.1
    Copyright 2004-2008 Internet Systems Consortium.
    All rights reserved.
    For info, please visit http://www.isc.org/sw/dhcp/
    
    Listening on LPF/eth0/00:1e:c9:50:6b:d3
    Sending on   LPF/eth0/00:1e:c9:50:6b:d3
    Sending on   Socket/fallback
    DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 5
    DHCPOFFER from 192.168.0.1
    DHCPREQUEST on eth0 to 255.255.255.255 port 67
    DHCPACK from 192.168.0.1
    bound to 192.168.0.9 -- renewal in 3221224 seconds.

  $ sudo iptables -L
  (以下、想定する実行結果)
    Chain INPUT (policy DROP)
    target     prot opt source               destination         
    ACCEPT     all  --  anywhere             anywhere            
    ACCEPT     icmp --  anywhere             anywhere            
    DROP       tcp  --  anywhere             anywhere            multiport dports netbios-ns,netbios-dgm 
    DROP       udp  --  anywhere             anywhere            multiport dports netbios-ns,netbios-dgm 
    REJECT     tcp  --  anywhere             anywhere            tcp dpt:auth reject-with tcp-reset 
    ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh 
    ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:bootps 
    ACCEPT     udp  --  anywhere             anywhere            udp dpt:bootps 
    ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:bootpc 
    ACCEPT     udp  --  anywhere             anywhere            udp dpt:bootpc 
    ACCEPT     udp  --  anywhere             anywhere            udp spt:domain 
    ACCEPT     udp  --  anywhere             anywhere            udp dpt:route 
    ACCEPT     udp  --  anywhere             anywhere            udp dpt:ntp 
    ACCEPT     udp  --  anywhere             anywhere            udp dpt:snmp 
    ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED 
    ULOG       all  --  anywhere             anywhere            ULOG copy_range 0 nlgroup 1 prefix `droped packet: ' queue_threshold 1 
    
    Chain FORWARD (policy DROP)
    target     prot opt source               destination         
    
    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination
