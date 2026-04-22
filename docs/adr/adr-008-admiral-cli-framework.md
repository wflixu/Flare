# ADR-008: 采用 Admiral 作为 CLI 框架

**Status**: Accepted  
**Date**: 2026-04-20  
**Version**: Phase 0 技术选型

---

## 背景

WitMate 需要一个 CLI 框架来实现用户交互：
- 命令解析（start, chat, dream, status 等）
- 参数解析（-p PORT, -m MODEL, --verbose 等）
- 帮助信息自动生成
- 错误处理

---

## 决策

**采用 Admiral (mizchi/admiral v0.1.0) 作为 CLI 框架**

### 选择理由

1. **声明式 API** - 代码简洁，易读易维护
2. **类型安全** - string/int/bool 类型检查
3. **子命令支持** - 天然支持多级命令
4. **自动生成 help** - 无需手写帮助信息
5. **AI-agent friendly** - 设计现代化
6. **错误处理完善** - try/catch 集成

### 框架对比

| 框架 | 推荐度 | 说明 |
|------|--------|------|
| **Admiral** | ⭐⭐⭐⭐⭐ | 最推荐，声明式 API |
| ArgParser | ⭐⭐⭐ | 简单参数解析 |
| 官方 argparse | ⭐⭐ | 功能基础 |

### 使用示例

```moonbit
import {
  "mizchi/admiral",
}

let app = @admiral.cli(
  name="witmate",
  version="0.1.0",
  description="WitMate - 自我进化的个人 Agent 协调器",
  commands=[
    @admiral.command(
      name="start",
      description="启动 WitMate 服务",
      options=[
        @admiral.int("port", short='p', description="服务器端口", default=Some(8080)),
        @admiral.bool("verbose", short='v', description="详细输出"),
      ],
      run=Some(fn(ctx) {
        let port = match ctx.get_int("port") { Some(n) => n; None => 8080 }
        let verbose = ctx.get_bool("verbose")
        println("Starting WitMate server on port " + port.to_string())
      }),
    ),
    @admiral.command(
      name="chat",
      description="进入交互式对话",
      options=[
        @admiral.string("model", short='m', description="LLM 模型", default=Some("claude-sonnet-4")),
        @admiral.bool("stream", short='s', description="流式输出"),
      ],
      run=Some(fn(ctx) {
        let model = match ctx.get_string("model") { Some(m) => m; None => "claude-sonnet-4" }
        println("Entering chat mode with model: " + model)
      }),
    ),
    @admiral.command(
      name="dream",
      description="触发 Dream 整合机制",
      options=[
        @admiral.bool("force", short='f', description="强制整合"),
      ],
      run=Some(fn(ctx) {
        println("Starting Dream integration...")
      }),
    ),
  ],
)
try { app.run() } catch { err => println(err) }
```

### 运行效果

```bash
$ witmate --help
Usage: witmate [command]

WitMate - 自我进化的个人 Agent 协调器

Commands:
  start   启动 WitMate 服务
  chat    进入交互式对话
  dream   触发 Dream 整合机制

$ witmate start -p 3000 --verbose
Starting WitMate server on port 3000
```

---

## 替代方案

| 方案 | 状态 | 说明 |
|------|------|------|
| ArgParser | ⚠️ 备选 | 简单工具适用，不支持子命令 |
| 官方 argparse | ⚠️ 待发布 | 长期支持保证 |
| 手写参数解析 | ❌ 不推荐 | 重复造轮子 |

---

## 影响

### 正面影响
- ✅ 快速实现 CLI 原型
- ✅ 代码简洁，可读性强
- ✅ 自动生成 help，减少文档维护
- ✅ 类型安全，减少运行时错误

### 负面影响
- ⚠️ 依赖社区库，需要跟踪更新
- ⚠️ Admiral 较新，可能存在未发现的 Bug

---

## 执行计划

1. **Phase 0**: 验证 Admiral CLI 框架 ✅
2. **Phase 1**: 实现完整 CLI 命令（start, chat, dream, status）
3. **Phase 2**: 添加 memory, skill, mcp, config 等管理命令

---

## 命令设计

```
witmate
├── start [-p PORT] [-v]         # 启动服务
├── chat [-m MODEL] [-s]         # 对话模式
├── dream [-f]                   # Dream 整合
├── status                       # 查看状态
├── memory (list|view|edit|delete)  # 记忆管理
├── skill (list|enable|disable)     # Skill 管理
├── mcp (list|config|status)        # MCP 管理
└── config (get|set|list)           # 配置管理
```

---

## 参考资源

- [Admiral GitHub](https://github.com/mizchi/admiral)
- [CLI 框架对比文档](/docs/moonbit-cli-frameworks.md)
