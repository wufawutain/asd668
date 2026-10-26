FROM ubuntu:22.04

# 一次装完：合并成单层，并关掉推荐包
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
        tmux \
        sudo \
        curl \
        iproute2 \
        iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /run/sshd && chmod 755 /run/sshd \
    && sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# 可选：直接把二进制打进镜像（见第三节，强烈建议）
# COPY ipv6socks /usr/local/bin/ipv6socks
# COPY remote-start.sh /usr/local/bin/remote-start.sh
# RUN chmod +x /usr/local/bin/ipv6socks /usr/local/bin/remote-start.sh

COPY ssh-user-config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/ssh-user-config.sh

EXPOSE 22
CMD ["/usr/local/bin/ssh-user-config.sh"]
