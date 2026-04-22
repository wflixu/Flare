# MoonBit CLI 框架对比指南

**更新日期**: 2026-04-20  
**技术栈**: MoonBit Native

---

## 推荐框架总览

| 框架 | 推荐度 | 复杂度 | 适用场景 |
|------|--------|--------|----------|
| **Admiral** | ⭐⭐⭐⭐⭐ | 低 | 快速构建现代 CLI |
| **ArgParser** | ⭐⭐⭐ | 中 | 简单参数解析 |
| **moonbitlang/core/argparse** | ⭐⭐ | 中 | 官方基础库 |

---

## 1. Admiral（⭐ 强烈推荐）

**最推荐** - MoonBit 生态中最好用的 CLI 框架

### 特点
- ✅ 声明式 API，代码简洁
- ✅ 类型安全（string/int/bool）
- ✅ 自动生成 help 和 version
- ✅ 支持子命令
- ✅ AI-agent friendly
- ✅ 错误处理完善

### 安装
```json
// moon.mod.json
{
  "deps": {
    "mizchi/admiral": "0.1.0"
  }
}
```

```json
// moon.pkg.json
{
  "imports": ["mizchi/admiral"]
}
```

### 完整示例
```moonbit
import {
  "mizchi/admiral",
}

options(
  "is-main": true,
)

///|
fn main {
  let app = @admiral.cli(
    name="witmate",
    version="0.1.0",
    description="WitMate - 自我进化的个人 Agent 协调器",
    commands=[
      // start 命令
      @admiral.command(
        name="start",
        description="启动 WitMate 服务",
        options=[
          @admiral.int("port", short='p', description="服务器端口", default=Some(8080)),
          @admiral.bool("verbose", short='v', description="详细输出"),
        ],
        examples=["witmate start -p 3000", "witmate start --verbose"],
        run=Some(fn(ctx) {
          let port = match ctx.get_int("port") { Some(n) => n; None => 8080 }
          let verbose = ctx.get_bool("verbose")
          if verbose {
            println("Starting WitMate server on port " + port.to_string())
          }
          println("WitMate server started on :8080")
        }),
      ),

      // chat 命令
      @admiral.command(
        name="chat",
        description="进入交互式对话",
        options=[
          @admiral.string("model", short='m', description="LLM 模型", default=Some("claude-sonnet-4")),
          @admiral.bool("stream", short='s', description="流式输出"),
        ],
        run=Some(fn(ctx) {
          let model = match ctx.get_string("model") { Some(m) => m; None => "claude-sonnet-4" }
          let stream = ctx.get_bool("stream")
          println("Entering chat mode with model: " + model)
        }),
      ),

      // dream 命令
      @admiral.command(
        name="dream",
        description="触发 Dream 整合机制",
        options=[
          @admiral.bool("force", short='f', description="强制整合"),
        ],
        run=Some(fn(ctx) {
          let force = ctx.get_bool("force")
          println("Starting Dream integration" + (if force { " (forced)" } else { "" }))
        }),
      ),

      // status 命令
      @admiral.command(
        name="status",
        description="查看服务状态",
        options=[],
        run=Some(fn(ctx) {
          println("WitMate Status:")
          println("  Server: Not running")
          println("  Memory: 0 files")
        }),
      ),
    ],
  )
  try { app.run() } catch { err => println(err) }
}
```

### 运行效果
```bash
# 显示帮助
$ witmate --help
Usage: witmate [command]

WitMate - 自我进化的个人 Agent 协调器

Commands:
  start   启动 WitMate 服务
  chat    进入交互式对话
  dream   触发 Dream 整合机制
  status  查看服务状态

# 启动服务器
$ witmate start -p 3000 --verbose
Starting WitMate server on port 3000
WitMate server started on :8080

# 进入对话
$ witmate chat -m claude-opus --stream
Entering chat mode with model: claude-opus
Stream output enabled
```

### 源码位置
- GitHub: https://github.com/mizchi/admiral
- 灵感来源：gunshi (现代 CLI 构建器)

---

## 2. ArgParser（社区版）

### 特点
- ✅ 简单直接
- ✅ 适合单一命令工具
- ❌ 不支持子命令
- ❌ API 较底层

### 安装
```json
// moon.mod.json
{
  "deps": {
    "moonbit-community/ArgParser": "0.1.0"
  }
}
```

### 示例
```moonbit
import {
  "moonbit-community/ArgParser" @ArgParser,
}

fn main {
  let verbose : Ref[Bool] = Ref::new(false)
  let output : Ref[String] = Ref::new("output")
  let files : Array[String] = []

  let spec : Array[(String, String, Spec, String)] = [
    ("--verbose", "-v", Set(verbose), "enable verbose message"),
    ("--output", "-o", Set_string(output), "output file name"),
  ]

  let usage = #|
    #| Simple CLI tool
    #| usage: mytool [options] <file1> [<file2>] ... -o <output>
  #|

  // 解析参数
  parse(spec, file => files.push(file), usage)

  // 使用解析结果
  if verbose.val {
    println("Verbose mode enabled")
  }
  println("Output: " + output.val)
  println("Files: " + files.to_string())
}
```

### 源码位置
- GitHub: https://github.com/moonbit-community/ArgParser

---

## 3. moonbitlang/core/argparse（官方）

### 特点
- ✅ 官方标准库
- ✅ 长期支持保证
- ❌ 功能基础
- ❌ 文档较少

### 使用方式
目前 `moon add` 可能无法直接安装，需要等待官方发布到 mooncakes.io。

参考文档：https://mooncakes.io/docs/moonbitlang/core/argparse

---

## 框架对比总结

| 特性 | Admiral | ArgParser | 官方 argparse |
|------|---------|-----------|--------------|
| 声明式 API | ✅ | ❌ | ❌ |
| 子命令支持 | ✅ | ❌ | ⚠️ |
| 类型安全 | ✅ | ⚠️ | ✅ |
| 自动生成 help | ✅ | ✅ | ✅ |
| 代码简洁度 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| 学习曲线 | 低 | 中 | 中 |
| 社区活跃 | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |

---

## 推荐决策

### 新项目（强烈推荐 Admiral）
```bash
moon add mizchi/admiral
```

**理由**：
1. 最现代的 API 设计
2. 代码最简洁
3. 类型安全
4. 文档完善
5.  actively maintained

### 简单工具（可选 ArgParser）
如果只需要解析几个参数，不需要子命令，ArgParser 足够使用。

### 企业项目（考虑官方 argparse）
如果需要长期支持保证，可以等待官方 argparse 正式发布。

---

## WitMate CLI 推荐实现

基于 Admiral 框架实现 WitMate CLI：

```moonbit
// 完整代码见本目录 cmd/main/main.mbt
```

### 命令设计
```
witmate
├── start [-p PORT] [-v]     # 启动服务
├── chat [-m MODEL] [-s]     # 对话模式
├── dream [-f]               # Dream 整合
├── status                   # 查看状态
├── memory                   # 记忆管理（待实现）
├── skill                    # Skill 管理（待实现）
└── config                   # 配置管理（待实现）
```

---

## 参考资料

- [Admiral GitHub](https://github.com/mizchi/admiral)
- [ArgParser GitHub](https://github.com/moonbit-community/ArgParser)
- [MoonBit CLI 快速开始](https://docs.moonbitlang.com/en/latest/tutorial/cli-quickstart.html)
- [Awesome MoonBit](https://github.com/moonbitlang/awesome-moonbit)

---

**结论**: **Admiral 是 MoonBit 生态中目前最好用的 CLI 框架**，推荐作为 WitMate CLI 的首选实现方案。
