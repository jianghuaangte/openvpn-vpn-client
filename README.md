# openvpn-vpn-client
> 一个简单的 OpenVPN 客户端 Docker 容器

## 配置文件

/path/to/dir 目录中应含
|配置文件|说明|
|:---|:---|
|client.ovpn|客户端配置文件|
|user-psswd.txt|用户名/密码|
|socat-cmd.sh|socat 转发|

user-psswd.txt 内容，一行一个
```txt
user
passwd
```

## Docker-Compose

```shell
version: '3.8'

networks:
  ovpn-network:
    driver: bridge
    ipam:
      config:
        - subnet: "172.21.0.0/24"
          gateway: "172.21.0.1"

services:
  openvpn-client:
    image: freedomzzz/openvpn-vpn-client:latest
    container_name: openvpn-vpn-client
    privileged: true
    cap_add:
      - NET_ADMIN
    environment:
      - NGINX_ENABLE=0     # 设为1启用 Nginx
      - SOCAT_ENABLE=0     # 设为1启用 Socat
    volumes:
       - "/lib/modules:/lib/modules:ro"
       - "/path/to/dir:/etc/openvpn/client"    # 配置文件及用户/密码/socat
 #      - "./nginx/conf.d:/etc/nginx/conf.d"   # Nginx 配置文件（可选）
    networks:
      ovpn-network:
        ipv4_address: 172.21.0.10
    restart: unless-stopped
```

推荐的 openvpn sever 配置
```opvn
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
```

路由（可选），如果流量没有走全局VPN（一般是自动配置好的），可以设置如下：
- 10.7.7.1 指 VPN 网关
- tunx 指网络接口
```shell
ip route add 128.0.0.0/1 via 10.7.7.1 dev tunx
ip route add 0.0.0.0/1 via 10.7.7.1 dev tunx
```

**Socat 服务**
例子：
```shell
socat TCP-LISTEN:20170,fork,reuseaddr TCP:172.21.0.30:20170 &
```
