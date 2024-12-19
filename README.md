# DZMM Proxy 部署教程

这是一个基于 Nginx 的反向代理服务，用于转发请求到 www.saibolaopo.com，以实现用你自己的域名/服务器显示DZMM角色扮演平台。

## 前置要求

1. 一个具有独立公网 IP 的服务器（本教程以 Ubuntu 22 LTS 系统为例）
2. 服务器的 80 端口未被占用
3. 你的组织的访问密钥

## 服务器推荐配置

### 基础配置推荐
- CPU: 1核心及以上
- 内存: 1GB及以上
- 硬盘: 10GB及以上（系统+Docker镜像）
- 带宽: 建议至少5Mbps，推荐10Mbps以上

### 承载能力参考
- 1核1G配置：可支持约100-200个并发用户
- 2核2G配置：可支持约500-1000个并发用户
- 4核4G配置：可支持约1000-3000个并发用户

注意：实际承载能力取决于用户的使用模式和网络质量，一些情况下，你可能需要调整虚拟机和Nginx的配置。

### 网络线路选择指南

#### 机房位置选择
1. 国内机房
   - 优点：访问延迟低，连接稳定
   - 缺点：需要备案，价格相对较高
   - 推荐：阿里云、腾讯云的国内机房

2. 国外机房
   - 优点：无需备案，价格相对便宜
   - 缺点：延迟较高，可能存在不稳定
   - 推荐区域（按延迟从低到高排序）：
     * 香港/台湾（延迟约50-100ms）
     * 日本/韩国（延迟约80-150ms）
     * 新加坡（延迟约120-200ms）
     * 美国西海岸（延迟约150-250ms）

#### 线路优化建议
1. 优先选择带有CN2/GIA线路的机房
   - 相比普通线路更稳定，延迟更低
   - 高峰期表现更好

2. 建议选择带有 BGP 优化的线路
   - 可以智能选择最优线路
   - 减少绕路，提高访问速度

3. 避免使用以下线路
   - 普通 CN2 GT 线路（高峰期拥堵严重）
   - 使用共享 IP 的 VPS
   - 线路跳转节点过多的机房

#### 性能优化建议
1. 使用 CDN 加速
   - 可以大幅降低源站压力
   - 提升用户访问速度
   - 防止 DDoS 攻击

2. 启用 Gzip 压缩
   - 减少传输数据量
   - 提升页面加载速度

3. 合理设置缓存
   - 减少源站压力
   - 提升响应速度

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

## 已知问题

1. 流式响应不稳定
   - 症状：长时间的流式响应可能会中断或卡住，文本生成输出一些字以后会停下来
   该问题和反代配置有关，目前尚不清楚具体原因。

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
