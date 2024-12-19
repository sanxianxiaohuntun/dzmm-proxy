# DZMM Proxy 部署教程

这是一个基于 Nginx 的反向代理服务，用于转发请求到 www.saibolaopo.com，以实现用你自己的域名/服务器显示DZMM角色扮演平台。

## 前置要求

1. 一个具有独立公网 IP 的服务器（本教程以 Ubuntu 22 LTS 系统为例）
2. 服务器的 80 端口未被占用
3. 你的组织的访问密钥

## 部署步骤

### 1. 安装必要的软件

```bash
# 更新软件包列表
apt-get update

# 安装 Docker 和 Docker Compose
apt-get install -y docker.io docker-compose
```

### 2. 下载项目代码

```bash
# 克隆代码仓库
git clone https://github.com/dzmm/dzmm-proxy.git

# 进入项目目录
cd dzmm-proxy
```

### 3. 配置环境变量

```bash
# 创建环境变量文件
cp .env.example .env

# 编辑 .env 文件，设置你的访问密钥
# 将 your_access_token 替换为实际的 Organization Key
echo "ORG_ACCESS_TOKEN=your_access_token" > .env
```

### 4. 启动服务

```bash
# 构建并启动容器
docker-compose up -d --build
```

### 5. 配置防火墙

```bash
# 开放 80 端口
ufw allow 80
```

### 6. 验证服务

```bash
# 查看容器运行状态
docker ps

# 查看服务日志
docker-compose logs nginx-proxy
```

## 常见问题

### 1. 遇到 401 未授权错误
- 检查 .env 文件中的 ORG_ACCESS_TOKEN 是否正确
- 确认 token 是否已过期
- 重新构建并启动容器：
  ```bash
  docker-compose up -d --build
  ```

### 2. 服务无法访问
- 确认服务器有独立公网 IP
- 检查 80 端口是否开放：`ufw status`
- 查看错误日志：`docker-compose logs nginx-proxy`

## 更新维护

### 更新服务
```bash
# 拉取最新代码
git pull

# 重新构建并启动容器
docker-compose up -d --build
```

### 查看日志
```bash
# 查看实时日志
docker-compose logs -f nginx-proxy

# 查看最近的日志
docker-compose logs --tail=100 nginx-proxy
```

## 项目文件说明

- `nginx.conf`: Nginx 配置文件，包含代理规则和 SSL 设置
- `docker-compose.yml`: 定义容器服务配置
- `Dockerfile`: 定义容器构建步骤
- `docker-entrypoint.sh`: 容器启动脚本
- `.env`: 环境变量配置文件（需要自己创建）
- `.env.example`: 环境变量示例文件
