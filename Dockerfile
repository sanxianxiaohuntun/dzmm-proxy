# 使用官方 Nginx 镜像作为基础镜像
FROM nginx:mainline-alpine

# 安装必要的工具
RUN apk add --no-cache curl ca-certificates

# 优化 Alpine 设置
RUN echo "net.core.somaxconn = 65535" >> /etc/sysctl.conf && \
    echo "net.ipv4.tcp_max_tw_buckets = 1440000" >> /etc/sysctl.conf && \
    echo "net.ipv4.tcp_fin_timeout = 15" >> /etc/sysctl.conf && \
    echo "net.ipv4.tcp_max_syn_backlog = 3240000" >> /etc/sysctl.conf && \
    echo "net.core.netdev_max_backlog = 300000" >> /etc/sysctl.conf

# 复制 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 创建缓存目录并设置权限
RUN mkdir -p /var/cache/nginx && \
    chown -R nginx:nginx /var/cache/nginx && \
    chmod -R 755 /var/cache/nginx

# 暴露 80 端口
EXPOSE 80

# 使用非 root 用户运行
USER nginx

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
