FROM alpine:edge

# 安装必要的软件包
RUN apk update && apk upgrade openssl libcrypto3 libssl3 && apk add --no-cache \
    openvpn \
    net-tools \
    nginx \
    nginx-mod-stream \
    socat \
    curl \
    neovim \
    && rm -rf /var/cache/apk/*

# 创建目录
RUN mkdir -p /etc/openvpn/client

# 复制入口脚本
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x \
    /usr/local/bin/entrypoint.sh

# 设置入口点
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
