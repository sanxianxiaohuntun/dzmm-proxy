#!/bin/sh

if [ -z "$ORG_ACCESS_TOKEN" ]; then
    echo "Error: ORG_ACCESS_TOKEN is required"
    exit 1
fi

# 替换配置文件中的占位符
sed -i "s/\${TOKEN}/$ORG_ACCESS_TOKEN/g" /etc/nginx/nginx.conf

exec nginx -g 'daemon off;'
