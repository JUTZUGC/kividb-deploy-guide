# KiviDB 一键部署指南

> 第三方部署指南 · 非 KiviDB 官方仓库。官方项目：[kividbio/kividb](https://github.com/kividbio/kividb)
> 内容来自官方文档（2026-10-28）。项目迭代快，请以[官方文档](https://github.com/kividbio/kividb/blob/main/README.md)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用自己编译 Rust，让百度搭子用 Docker 把 KiviDB 跑起来，Redis 客户端直接连。

⚠️ 需要 Docker。默认监听 0.0.0.0:6380，并开启 protected mode；对外提供服务前先配认证与网络隔离。内存数据库的数据持久化要按官方文档挂载卷并配置快照 / AOF。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/kividb-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会拉取官方 Docker 镜像、启动 6380 端口，并提示用 redis-cli 验证，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）



## KiviDB 是什么？

KiviDB 是开源的0.8k stars，AGPL-3.0，兼容 Redis 协议的 Rust 内存数据库（协议：AGPL-3.0，<img src="https://img.shields.io/github/stars/kividbio/kividb?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

兼容 Redis 的 RESP2 / RESP3 协议，现有客户端与 redis-cli 不用改；多线程分片的内存键值引擎，内置全文与向量检索，支持快照和可选 AOF 持久化。

- 协议兼容：Redis 客户端、库与 redis-cli 直接可用
- 多线程：分片内存设计，压满多核
- 内置检索：FT.* 全文、标签、数值与向量检索
- 持久化：快照 + 可选 append-only file
- 可选能力：Lua 脚本与 TLS 作为编译特性
- 默认 6380：可以和 Redis 6379 并存

（来源：[官方仓库](https://github.com/kividbio/kividb)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 0.8k stars | 10 月新项目，名字搜索竞争很低 |
| 协议兼容 | Redis 客户端与工具直接可用 |
| 多线程 | 分片设计能吃满多核 |
| 内置检索 | 全文与向量检索不用额外组件 |
| 部署简单 | 一条 docker run 就能起 |
| Rust 实现 | 内存安全，便于审计 |

| 需要注意 | 说明 |
|---|---|
| AGPL-3.0 | 修改后对外提供服务有额外义务 |
| 生态较新 | 客户端兼容度仍在补齐 |
| 默认 6380 | 老旧客户端要改端口 |
| 生产配置要自己补 | 认证、TLS、持久化都需按文档配 |
| 内存型 | 数据量受内存限制 |

> 以上基于官方文档与社区反馈整理（2026-10-28），以官方最新文档为准。

## 快速部署（官方方式）

```bash
docker run -d --name kividb -p 6380:6380 kividb/kividb
docker logs --tail 20 kividb
echo "部署完成：客户端连 127.0.0.1:6380，PING 应返回 PONG"
```

部署步骤来源：[https://github.com/kividbio/kividb#quick-start](https://github.com/kividbio/kividb#quick-start)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 docker run 命令、6380 端口与 protected mode | 已核对 2026-10-28 |
| Release v1.1.2 的多平台二进制资产与校验文件已核对 | 已核对 2026-10-28 |
| 未实测启动与 Redis 兼容性（未拉取镜像） | 说明 2026-10-28 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-28 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

KiviDB 是数据库，不含 MCP；本仓库的 MCP 只提供部署步骤、端口与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-28）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\kividb-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 验证连接

```bash
docker run --rm -it --network host redis:7 redis-cli -p 6380 PING
# PONG
```

也可以把现有客户端端口从 6379 改成 6380，或启动时加 `--port 6379`。

## 持久化与生产配置

- 默认用快照持久化；需要更低丢失窗口时开启 AOF
- 数据目录要挂载到宿主机卷，容器重建才不会丢数据
- 默认 protected mode 开启；跨机访问前先配认证、TLS 与防火墙
- 需要 Lua 或 TLS 时，用带对应特性的构建或镜像

## 许可

AGPL-3.0：使用数据库不会让你的应用变成 AGPL，但修改并对外提供数据库服务时要遵守协议。

> ⚠️ 先在自己的负载上压测，再替换生产 Redis；内存数据库请预留足够内存并监控淘汰与持久化状态。

## 常见坑

- 端口冲突：6380 被占用时换宿主机端口，或停掉占用进程
- 连不上：确认容器在运行，且客户端连的是 6380 不是 6379
- 容器重建丢数据：先把数据目录挂到宿主机卷
- 跨机访问被拒：默认 protected mode，先配认证与 TLS
- 需要 Lua / TLS：用带对应特性的构建，默认镜像不一定开启
- 不要直接替换生产 Redis：先跑兼容性测试与压测

## 免责声明

本仓库为第三方指南，与 KiviDB 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-28），项目迭代快，请以[官方文档](https://github.com/kividbio/kividb/blob/main/README.md)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
