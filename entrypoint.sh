#!/bin/sh
set -e

# 默认值
NGINX_ENABLE="${NGINX_ENABLE:-0}"
SOCAT_ENABLE="${SOCAT_ENABLE:-0}"

# 建立 VPN 连接
connect_vpn() {
    # 建立连接
    openvpn --config /etc/openvpn/client/client.ovpn --auth-user-pass /etc/openvpn/client/user-passwd.txt &
}

# Nginx
start_nginx_if_enabled() {
  if [ "$NGINX_ENABLE" = "1" ]; then
    nginx
  fi
}

# Socat
start_socat_if_enabled() {
  if [ "$SOCAT_ENABLE" = "1" ]; then
    chmod +x /etc/openvpn/client/socat-cmd.sh
    source /etc/openvpn/client/socat-cmd.sh
  fi
}

# 主函数
main() {
    # 建立连接
    connect_vpn
    # Nginx
    start_nginx_if_enabled
    # 保持容器运行
    tail -f /dev/null
}

# 运行主函数
main
