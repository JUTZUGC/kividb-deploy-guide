# KiviDB 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/kividbio/kividb/blob/main/README.md
# 更新日期：2026-10-28
# 类型：docker
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

foreach ($cmd in @('git', 'docker')) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "需要先安装 $cmd" }
}
docker compose version | Out-Null
if ($LASTEXITCODE -ne 0) { throw '需要 Docker Compose v2（docker compose 子命令）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

docker run -d --name kividb -p 6380:6380 kividb/kividb
docker logs --tail 20 kividb
Write-Host '部署完成：客户端连 127.0.0.1:6380，PING 应返回 PONG'

Write-Host ''

Write-Host '部署完成：客户端连 127.0.0.1:6380，执行 PING 应返回 PONG；生产环境记得挂载数据卷'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/kividbio/kividb/blob/main/README.md'
