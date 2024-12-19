# 使用官方 Nginx 镜像作为基础镜像
FROM nginx:mainline-alpine

# 安装必要的工具
RUN apk add --no-cache curl ca-certificates

# 复制 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 创建必要的目录并设置权限
RUN mkdir -p /var/cache/nginx /var/log/nginx && \
    chown -R nginx:nginx /var/cache/nginx /var/log/nginx && \
    chmod -R 755 /var/cache/nginx /var/log/nginx && \
    # 删除默认的配置文件
    rm -f /etc/nginx/conf.d/default.conf && \
    # 确保 /tmp 目录权限正确
    chmod 1777 /tmp

# 暴露 80 端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
