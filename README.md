# openvpn-vpn-client

## 配置文件

/path/to/dir 目录中应含
|配置文件|说明|
|:---|:---|
|client.ovpn|客户端配置文件|
|user-psswd.txt|用户名/密码|

user-psswd.txt 内容，一行一个
```txt
user
passwd
```

## Docker-Compose

```shell
version: '3.8'

networks:
  vpn-network:
    driver: bridge
    ipam:
      config:
        - subnet: "172.20.0.0/24"
          gateway: "172.20.0.1"

services:
  openvpn-client:
    image: freedomzzz/openvpn-vpn-client:latest
    container_name: openvpn-vpn-client
    privileged: true
    cap_add:
      - NET_ADMIN
    environment:
      - NGINX_ENABLE=0     # 设为1启用 Nginx
    volumes:
       - "/lib/modules:/lib/modules:ro"
       - "/path/to/dir:/etc/openvpn/client"    # 配置文件及用户/密码
 #      - "./nginx/conf.d:/etc/nginx/conf.d"   # 设置为1则启用 Nginx
    networks:
      vpn-network:
        ipv4_address: 172.20.0.10
    restart: unless-stopped
```

推荐的 openvpn sever 配置
```opvn
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
```
