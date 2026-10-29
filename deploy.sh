#!/usr/bin/env bash
set -euo pipefail
# KiviDB 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/kividbio/kividb/blob/main/README.md
# 更新日期：2026-10-28
# 类型：docker
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "需要先安装 Docker"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "需要 Docker Compose v2（docker compose 子命令）"; exit 1; }

mkdir -p .download
cd .download

docker run -d --name kividb -p 6380:6380 kividb/kividb
docker logs --tail 20 kividb
echo "部署完成：客户端连 127.0.0.1:6380，PING 应返回 PONG"

echo ""

echo "部署完成：客户端连 127.0.0.1:6380，执行 PING 应返回 PONG；生产环境记得挂载数据卷"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/kividbio/kividb/blob/main/README.md"
