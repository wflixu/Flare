# Flare 系统设计文档

**Status**: Draft
**Author**: Software Architect
**Last Updated**: 2026-04-19
**Version**: 1.0

---

## 1. 系统概述

### 1.1 系统定位

Flare 是一个本地优先的个人 Agent 协调器，通过统一入口管理多个专家 Agent/Skill，并通过本地 qmd 文件系统积累长期记忆。

### 1.2 核心目标

1. **记忆系统**: 本地存储所有对话上下文和用户知识
2. **Agent 协调层**: 理解用户意图，调用合适的专家 Agent
3. **自我进化机制**: 从用户交互中持续学习和优化

### 1.3 设计原则

| 原则 | 说明 |
|------|------|
| 本地优先 | 所有数据本地存储，用户完全控制 |
| 简单优先 | 每个抽象必须证明其复杂度的合理性 |
| 可逆性 | 优先选择容易更改的决策 |
| 领域驱动 | 理解业务问题后再选择技术 |

---

## 2. 系统架构

### 2.1 整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                    User Interfaces                           │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐                 │
│  │   CLI    │  │   Web    │  │  Obsidian │                 │
│  │ (MoonBit)│  │  (Vue3)  │  │  Plugin   │                 │
│  └──────────┘  └──────────┘  └───────────┘                 │
│       (TUI 搁置，未来可能)                                    │
└─────────────────────────────────────────────────────────────┘
                      ↓ HTTP (双向通信)
┌─────────────────────────────────────────────────────────────┐
│              flare-server (MoonBit Native)                   │
│                                                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │              API Layer (HTTP Server)                     ││
│  │  - POST /chat (用户消息)                                  ││
│  │  - POST /stream (流式响应)                                ││
│  │  - GET  /status (服务状态)                                ││
│  └─────────────────────────────────────────────────────────┘│
│                           ↓                                  │
│  ┌─────────────────────────────────────────────────────────┐│
│  │           Coordination Layer (协调层)                    ││
│  │  - Intent Analysis (意图分析 - Phase 1:三分类)           ││
│  │  - Capability Router (能力路由)                          ││
│  │  - Response Aggregator (响应聚合)                        ││
│  │  - Session Manager (单用户单 Session)                    ││
│  └─────────────────────────────────────────────────────────┘│
│           ↓                    ↓                    ↓        │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐    │
│  │ Capability    │  │ Memory        │  │ Evolution     │    │
│  │ Manager       │  │ System        │  │ Engine        │    │
│  │               │  │               │  │               │    │
│  │ ┌───────────┐ │  │ ┌───────────┐ │  │ ┌───────────┐ │    │
│  │ │Skills     │ │  │ │Working    │ │  │ │Implicit   │ │    │
│  │ │Registry   │ │  │ │Memory     │ │  │ │Learning   │ │    │
│  │ ├───────────┤ │  │ ├───────────┤ │  │ ├───────────┤ │    │
│  │ │MCP Pool   │ │  │ │Episodic   │ │  │ │Explicit   │ │    │
│  │ │Manager    │ │  │ │Memory     │ │  │ │Memory     │ │    │
│  │ ├───────────┤ │  │ ├───────────┤ │  │ ├───────────┤ │    │
│  │ │Built-in   │ │  │ │Semantic   │ │  │ │Feedback   │ │    │
│  │ │Tools      │ │  │ │Memory     │ │  │ │Learning   │ │    │
│  │ └───────────┘ │  │ └───────────┘ │  │ └───────────┘ │    │
│  └───────────────┘  └───────────────┘  └───────────────┘    │
│           ↓                    ↓                    ↓        │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐    │
│  │ Capability    │  │ Memory Index  │  │ Dream Engine  │    │
│  │ Abstraction   │  │ Layer         │  │ (Phase 1 简化) │    │
│  │ (Interface)   │  │               │  │               │    │
│  │               │  │ ┌───────────┐ │  │ ┌───────────┐ │    │
│  │ execute()     │  │ │Keyword    │ │  │ │Snapshot   │ │    │
│  │ health_check()│  │ │Index      │ │  │ │(快照)     │ │    │
│  │               │  │ ├───────────┤ │  │ └───────────┘ │    │
│  │               │  │ │Tag Index  │ │  │               │    │
│  │               │  │ ├───────────┤ │  │               │    │
│  │               │  │ │Time Index │ │  │               │    │
│  │               │  │ └───────────┘ │  │               │    │
│  └───────────────┘  └───────────────┘  └───────────────┘    │
│                           ↓                    ↓             │
│  ┌─────────────────────────────────────────────────────────┐│
│  │              Local Storage Layer                         ││
│  │  ┌───────────┐ ┌───────────┐ ┌───────────┐              ││
│  │  │qmd files  │ │memory-    │ │dream-     │              ││
│  │  │(记忆)     │ │index.json │ │snapshots/ │              ││
│  │  └───────────┘ └───────────┘ └───────────┐              ││
│  │  ┌───────────┐ ┌───────────┐ ┌───────────┐              ││
│  │  │config.    │ │evolution- │ │skills/    │              ││
│  │  │json       │ │rules.json │ │(Skill YAML)│             ││
│  │  └───────────┘ └───────────┘ └───────────┘              ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
        ↓ API Calls            ↓ Protocol           ↓ IPC
┌───────────────────┐   ┌───────────────┐   ┌───────────────┐
│    LLM Providers  │   │  MCP Servers  │   │ Skill Files   │
│  ┌───────────────┐│   │ ┌───────────┐ │   │ ┌───────────┐ │
│  │ Anthropic     ││   │ │ Obsidian  │ │   │ │code.skill │ │
│  │ (Claude)      ││   │ │ MCP       │ │   │ │yaml       │ │
│  ├───────────────┤│   │ ├───────────┤ │   │ ├───────────┤ │
│  │ Qwen          ││   │ │ File      │ │   │ │write.skill│ │
│  ├───────────────┤│   │ │ System MCP│ │   │ │yaml       │ │
│  │ GLM           ││   │ ├───────────┤ │   │ ├───────────┤ │
│  │ MiniMax       ││   │ │ Chrome    │ │   │ │pdf.skill  │ │
│  └───────────────┘│   │ │ DevTools  │ │   │ │yaml       │ │
└───────────────────┘   │ └───────────┘ │   │ └───────────┘ │
                        └───────────────┘   └───────────────┘
```

**架构说明**:
- **通信协议**: HTTP 双向通信（废弃 SSE，改用纯 HTTP）
- **Session 模型**: 单用户单 Session（Phase 1）
- **MCP 连接**: 常驻进程池，非每次 spawn
- **Dream Engine**: Phase 1 仅实现快照功能
- **TUI**: 已搁置（未来可能）

### 2.2 模块依赖关系

```
API Layer
    ↓
Coordination Layer
    ↓
┌──────────────────┬──────────────────┬──────────────────┐
│ Capability Mgr   │ Memory System    │ Evolution Engine │
└──────────────────┴──────────────────┴──────────────────┘
         ↓                  ↓                    ↓
┌──────────────────┬──────────────────┬──────────────────┐
│ Built-in Tools   │ Memory Index     │ Dream Engine     │
└──────────────────┴──────────────────┴──────────────────┘
                              ↓
                    ┌─────────────────┐
                    │ Local Storage   │
                    └─────────────────┘
```

**依赖说明**:
- API Layer → Coordination Layer: 处理 HTTP/SSE 请求
- Coordination Layer → 各模块: 路由请求到对应模块
- Memory System → Memory Index: 依赖索引实现高效检索
- Evolution Engine → Dream Engine: 依赖 Dream 执行整合
- Evolution Engine → Memory System: 获取记忆数据
- Dream Engine → Memory Index: 扫描记忆文件

---

## 3. 核心模块设计

### 3.1 API Layer

**职责**: 处理外部 HTTP 请求

**Endpoints**:

| Method | Path | 说明 |
|--------|------|------|
| POST | /chat | 接收用户消息（同步响应） |
| POST | /stream | 流式响应（SSE 可选） |
| GET | /status | 服务状态 |
| POST | /dream | 主动触发 Dream |
| GET | /memories | 记忆列表 |
| GET | /memories/:id | 记忆详情 |
| PUT | /memories/:id | 编辑记忆 |
| DELETE | /memories/:id | 删除记忆 |

**通信协议说明**:
- 废弃 SSE，使用纯 HTTP 双向通信
- POST /chat 返回完整响应（Phase 1）
- POST /stream 返回流式响应（Phase 2+，可选）

### 3.1.1 Session 并发模型

**Phase 1: 单用户单 Session**

```
┌─────────────┐
│   Client    │
│ (CLI/Web)   │
└─────────────┘
       ↓
┌─────────────┐
│   Server    │
│ (单 Session) │
└─────────────┘
```

**设计说明**:
- Phase 1 仅支持单个活跃 Session
- 新请求自动结束旧 Session（或排队等待）
- 不支持多客户端并发连接
- 不支持多用户共享 Server

**Session 状态**:
```moonbit
enum SessionState {
  Active       // 活跃状态
  Idle         // 空闲状态
  Processing   // 处理请求中
  Closing      // 关闭中
}

struct Session {
  id: String,
  state: SessionState,
  created_at: Timestamp,
  last_activity: Timestamp,
  context: SessionContext,
}
```

**Phase 2+ 规划**:
- 支持单用户多 Session（多个客户端同时连接）
- Session 上下文共享
- 并发请求处理（请求队列）

**Phase 3+ 规划**:
- 多用户支持（可选）
- Session 持久化（重启恢复）

### 3.2 Coordination Layer (协调层)

**职责**: 意图分析、能力路由、响应聚合、会话管理

**核心接口**:

```moonbit
interface CoordinationLayer {
  // 分析用户意图
  fn analyze_intent(input: UserInput, context: SessionContext) -> Intent
  
  // 路由到合适的 Capability
  fn route_capability(intent: Intent) -> Option<Capability>
  
  // 执行并聚合响应
  fn execute_and_aggregate(capability: Capability, input: UserInput) -> Stream<Response>
  
  // 管理会话
  fn get_or_create_session(session_id: String) -> Session
}
```

**意图分析流程 (Phase 1 简化版：三分类)**:

```
用户输入 → 预处理 → 关键词匹配 → 意图分类
                                      ↓
                              ┌───────────────┐
                              │ Phase 1 简化  │
                              ├───────────────┤
                              │ General       │ - 通用对话
                              │ Skill         │ - 调用 Skill
                              │ MCP           │ - 调用 MCP
                              └───────────────┘
                                  
                              后续迭代:
                              - MemoryQuery 意图
                              - MemoryStore 意图
                              - Dream 意图
                              - 多意图识别
                              - 上下文指代消解
```

**Phase 1 意图分类规则**:
1. **Skill 意图**: 输入匹配 Skill 的 `trigger_keywords` → 调用对应 Skill
2. **MCP 意图**: 输入匹配 MCP 的 `trigger_keywords` → 调用对应 MCP
3. **General 意图**: 无匹配 → 通用 LLM 对话

**简化说明**:
- Phase 1 不做语义理解，仅关键词匹配
- Phase 1 不处理多意图，仅单意图路由
- Phase 1 不处理上下文指代（如"这里"、"这个"）
- Phase 2+ 引入语义向量匹配
- Phase 3+ 引入多意图识别和上下文消解

### 3.3 Capability Manager (能力管理器)

**职责**: Skill/MCP 的发现、注册、调用、健康检查

**Capability 抽象接口**:

```moonbit
// Capability 抽象接口
interface Capability {
  // 能力名称
  fn name() -> String
  
  // 能力描述 (用于路由决策)
  fn description() -> String
  
  // 执行能力
  fn execute(context: ExecutionContext, input: Json) -> Result<Json, Error>
  
  // 健康检查
  fn health_check() -> Bool
  
  // 能力类型
  fn capability_type() -> CapabilityType
  
  // 触发关键词 (用于路由匹配)
  fn trigger_keywords() -> Array<String>
}

enum CapabilityType {
  Skill      // Skill 实现 (基于 prompt template)
  MCP        // MCP 实现 (基于 JSON-RPC/HTTP)
  BuiltIn    // 内置工具
}
```

**SkillCapability 实现**:

```moonbit
class SkillCapability : Capability {
  name: String
  description: String
  trigger_keywords: Array<String>
  system_prompt: String
  template: String
  
  fn execute(context: ExecutionContext, input: Json) -> Result<Json, Error> {
    // 1. 构建 prompt
    let prompt = self.template.replace("{{input}}", input.to_string())
    
    // 2. 调用 LLM
    let response = llm_client.chat(
      system_prompt=self.system_prompt,
      user_message=prompt
    )
    
    // 3. 返回结果
    Ok(response.to_json())
  }
  
  fn health_check() -> Bool {
    // 检查 skill 文件是否存在且格式正确
    File.exists(self.file_path)
  }
}
```

**MCPCapability 实现 (进程池 + 长连接)**:

```moonbit
// MCP 进程池 - 维护长连接
struct MCPProcessPool {
  processes: Map<ProcessId, MCPProcess>,
  min_size: Int,
  max_size: Int,
  idle_timeout: Duration,
}

struct MCPProcess {
  pid: ProcessId,
  process: Process,      // 常驻进程
  stdin: Channel,
  stdout: Channel,
  state: ProcessState,   // Idle, Busy, Stopped
  last_used: Timestamp,
}

class MCPCapability : Capability {
  name: String
  description: String
  trigger_keywords: Array<String>
  command: String
  args: Array<String>
  timeout: Int
  pool: MCPProcessPool   // 进程池，非每次 spawn
  
  fn execute(context: ExecutionContext, input: Json) -> Result<Json, Error> {
    // 1. 从进程池获取空闲进程 (关键：复用长连接)
    let process = self.pool.get_idle_process()?
    
    // 2. 发送 JSON-RPC 请求 (通过长连接)
    let request = JsonRpcRequest(
      method="execute",
      params=input
    )
    process.stdin.write(request.to_string())
    
    // 3. 等待响应 (带超时)
    let response = process.stdout.read_with_timeout(self.timeout)
    
    // 4. 归还进程到池 (关键：不关闭进程)
    self.pool.return_process(process)
    
    Ok(response.to_json())
  }
  
  fn health_check() -> Bool {
    // 检查进程池健康状态
    self.pool.check_health()
  }
}

// 进程池管理流程
impl MCPProcessPool {
  // 初始化进程池 (启动时)
  fn init() {
    // 启动 min_size 个常驻进程
    for i in 0..self.min_size {
      let process = self.spawn_process()
      self.processes.insert(process.pid, process)
    }
  }
  
  // 获取空闲进程
  fn get_idle_process() -> Result<MCPProcess, Error> {
    // 查找 Idle 状态的进程
    for process in self.processes.values() {
      if process.state == Idle {
        process.state = Busy
        return Ok(process)
      }
    }
    // 没有空闲进程，创建新的 (不超过 max_size)
    if self.processes.len() < self.max_size {
      let process = self.spawn_process()
      self.processes.insert(process.pid, process)
      return Ok(process)
    }
    Err(Error::NoAvailableProcess)
  }
  
  // 归还进程
  fn return_process(process: MCPProcess) {
    process.state = Idle
    process.last_used = now()
  }
  
  // 定期清理超时空闲进程
  fn cleanup_idle_processes() {
    for process in self.processes.values() {
      if now() - process.last_used > self.idle_timeout {
        process.process.kill()
        self.processes.remove(process.pid)
      }
    }
  }
}
```

**MCP 进程池生命周期**:
```
启动时 → 初始化进程池 (min_size 个常驻进程)
   ↓
请求 → 获取空闲进程 → 发送请求 → 接收响应 → 归还进程
   ↓
定期扫描 → 清理超时空闲进程 → 补充最小进程数
   ↓
关闭时 → 优雅关闭所有进程
```

**Built-in Tools**:

| 工具 | 职责 | 安全边界 |
|------|------|----------|
| `web_search` | 网络搜索 | 仅 HTTPS，域名白名单 |
| `file_ops` | 文件操作 | 仅指定目录 |
| `memory_ops` | 记忆管理 | 仅 memory 目录 |
| `code_execute` | 代码执行 | WebAssembly 沙箱，超时 5s |
| `api_call` | HTTP 请求 | 仅配置的 API，限流 |
| `clipboard_ops` | 剪贴板 | 仅文本，敏感信息过滤 |
| `notification_ops` | 通知 | 仅 Flare 内部触发 |

### 3.4 Memory System (记忆系统)

**职责**: 记忆的存储、检索、应用

**记忆类型**:

| 类型 | 说明 | 存储方式 |
|------|------|----------|
| Working Memory | 当前会话上下文 | 内存，会话结束清除 |
| Episodic Memory | 对话事件记录 | qmd 文件 |
| Semantic Memory | 事实性知识 | qmd 文件 |
| Procedural Memory | 行为习惯/规则 | evolution-rules.json |

**记忆索引架构**:

```
┌─────────────────────────────────────────────┐
│              Memory Index Layer              │
│                                              │
│  ┌─────────────┐  ┌─────────────┐           │
│  │ Keyword     │  │ Tag         │           │
│  │ Index       │  │ Index       │           │
│  │ (倒排索引)   │  │ (标签索引)   │           │
│  └─────────────┘  └─────────────┘           │
│                                              │
│  ┌─────────────┐  ┌─────────────┐           │
│  │ Time        │  │ File        │           │
│  │ Index       │  │ Metadata    │           │
│  │ (时间索引)   │  │ (文件元数据) │           │
│  └─────────────┘  └─────────────┘           │
│                    ↓ 持久化                  │
│              memory-index.json               │
└─────────────────────────────────────────────┘
```

**索引文件格式**:

```json
{
  "version": "1.0",
  "updated_at": "2026-04-19T12:00:00",
  "files": {
    "memory1.qmd": {
      "keywords": ["API", "设计", "架构"],
      "tags": ["project", "work"],
      "created_at": "2026-04-18",
      "updated_at": "2026-04-19",
      "size": 2048
    }
  },
  "keyword_index": {
    "API": ["memory1.qmd", "memory3.qmd"],
    "设计": ["memory1.qmd"]
  },
  "tag_index": {
    "project": ["memory1.qmd", "memory4.qmd"]
  }
}
```

**检索流程**:

```
查询请求 → 关键词/标签匹配 → 索引返回文件列表 → 
仅读取匹配文件内容 → 返回结果

性能估算:
- 10,000 文件索引加载：~1s
- 索引查询：~50ms
- 匹配文件内容读取：~500ms (假设 10 个匹配)
- 总计：< 1s
```

**记忆存储流程**:

```
对话结束 → 提取关键信息 → 生成 qmd 内容 → 
检查冲突 (文件锁) → 写入文件 → 更新索引
```

### 3.5 Evolution Engine (进化引擎)

**职责**: 从用户交互中学习和优化

**四种学习方式**:

| 方式 | 触发条件 | 实现难度 | Phase |
|------|----------|----------|-------|
| 隐式学习 | 对话结束自动提取 | Medium | Phase 3 |
| 显式记忆 | 用户主动"记住这个" | Low | Phase 3 |
| 反馈学习 | 用户纠正/不满意 | Medium | Phase 4 |
| 模式归纳 | 发现重复行为模式 | High | Phase 4 |

**隐式学习流程** (简化版 - 关键词提取):

```
对话结束 → 提取关键词和实体 → 构建记忆摘要 → 
检查重复 → 生成 qmd 文件 → 存储到 memory 目录
```

**模式归纳流程** (简化版 - 统计规则):

```
定期扫描 → 统计 Skill 使用频率 → 发现 Top N 常用 Skill → 
更新推荐权重 → 存储到 evolution-rules.json
```

### 3.6 Dream Engine (Phase 1 简化版：仅快照)

**职责**: 记忆的定期整合和优化

**Phase 1 范围 (简化)**:
- ✅ 快照：对话结束后将记忆写入 qmd 文件
- ✅ 恢复：从 qmd 文件读取记忆
- ❌ 增量整合（Phase 2+）
- ❌ 冗余删除（Phase 2+）
- ❌ 模式归纳（Phase 2+）
- ❌ Checkpoint/Rollback（Phase 3+）

**简化原因**:
1. **复杂度高**: Checkpoint + Rollback + 异步处理 = 小型分布式系统
2. **恢复复杂**: Server 崩溃时 Dream 进行到一半，需要协调机制恢复
3. **并发冲突**: Dream 和用户对话同时访问同一个 qmd 文件，需要冲突处理
4. **Phase 1 聚焦**: 先验证核心能力（记忆存储、检索、应用）

**Phase 1 快照流程**:
```
对话结束 → 提取关键信息 → 写入 qmd 文件 → 更新索引 → 完成
```

**Phase 2 规划**:
- 定时触发（每日凌晨）
- 条件触发（记忆数量阈值）
- 简单的冗余检测

**Phase 3 规划**:
- Checkpoint 进度持久化
- Rollback 回滚机制
- 并发冲突处理（文件锁）

**Phase 4 规划**:
- 增量整合
- 时间衰减计算
- 模式归纳（LLM 辅助）
- Dream 报告生成

**触发方式 (Phase 2+)**:
| 方式 | 条件 | 优先级 |
|------|------|--------|
| 主动触发 | `flare dream` 命令 | P0 |
| 条件触发 | 记忆 > 500 或会话 > 50 | P1 |
| 定时触发 | 每日 2:00 或闲置 30min | P2 |

**触发冲突处理 (Phase 3+)**:
| 场景 | 处理策略 |
|------|----------|
| 主动触发时 Dream 已在运行 | 提示"正在整合中"或排队 |
| 条件触发时用户正在对话 | 推迟到对话结束后 5 分钟 |
| 定时和条件同时满足 | 条件触发优先 |
| Dream 运行中达到另一条件 | 忽略，等待完成 |
    ]
  }
}
```

---

## 4. 数据存储设计

### 4.1 目录结构

```
~/.flare/
├── config.json           # 配置文件 (API Key、模型选择等)
├── memory-index.json     # 记忆索引
├── evolution-rules.json  # 进化规则
├── dream-progress.json   # Dream 进度 (临时)
├── memory/               # 记忆文件目录
│   ├── memory1.qmd
│   ├── memory2.qmd
│   └── ...
├── skills/               # Skill 定义目录 (Phase 1 必需)
│   ├── code.skill.yaml
│   ├── writing.skill.yaml
│   └── pdf.skill.yaml
├── mcp/                  # MCP 配置目录
│   ├── obsidian.json
│   └── filesystem.json
├── dream-backup/         # Dream 备份目录 (7 天自动清理)
│   └── 2026-04-19/
└── logs/                 # 日志目录
    └── flare.log
```

### 4.2 Skill 文件格式 (YAML) - Phase 1 必需

**Phase 1 最小格式**:

```yaml
# skills/code.skill.yaml
name: code
description: 代码编写、调试和审查能力
version: "1.0"

# 触发关键词（用于意图路由）
trigger_keywords:
  - 代码
  - 编程
  - debug
  - 函数
  - 算法
  - 实现
  - 修复 bug

# 系统提示词
system_prompt: |
  你是一个专业的代码助手，擅长：
  - 编写清晰、可维护的代码
  - 调试和修复 bug
  - 代码审查和优化建议
  
  请用简洁的方式回答，代码示例优先。

# Prompt 模板
template: |
  用户需求：{{input}}
  
  上下文：
  {{context}}
  
  请提供帮助。
```

### 4.3 qmd 记忆文件格式

```markdown
---
type: memory
tags: [project, work]
keywords: [API, 设计，架构]
created_at: 2026-04-18T10:00:00
updated_at: 2026-04-19T12:00:00
session_id: session-123
importance: 0.8
---

# 记忆标题

## 内容

这里是记忆的具体内容...

## 相关上下文

- 相关项目：XXX
- 相关人物：XXX
```

### 4.3 配置文件格式

```json
{
  "llm": {
    "default_provider": "anthropic",
    "providers": {
      "anthropic": {
        "api_key": "sk-...",
        "model": "claude-sonnet-4-20250514"
      },
      "qwen": {
        "api_key": "sk-...",
        "model": "qwen-max"
      }
    }
  },
  "dream": {
    "schedule": "02:00",
    "idle_threshold": 30,
    "memory_threshold": 500,
    "session_threshold": 50,
    "time_decay_factor": 0.1,
    "auto_cleanup": true
  },
  "security": {
    "allowed_domains": ["api.anthropic.com", "api.qwen.ai"],
    "allowed_directories": ["~/projects", "~/documents"],
    "code_execution_timeout": 5000
  }
}
```

### 4.4 并发控制

**写入保护机制**:

```
写入请求 → 获取文件锁 → 写入内容 → 释放锁
         ↓
    [锁被占用 → 等待或失败]
```

**实现方案**:

- 使用 `.lock` 文件作为标记
- 锁超时时间：5 秒
- 超时后返回错误，提示用户稍后重试

---

## 5. 接口设计

### 5.1 外部接口

#### POST /chat

**请求**:

```json
{
  "session_id": "session-123",
  "message": "帮我设计一个 API",
  "context": {
    "previous_message_id": "msg-456"
  }
}
```

**响应**:

```json
{
  "session_id": "session-123",
  "message_id": "msg-789",
  "status": "processing"
}
```

#### SSE /stream

**事件流**:

```
event: ResponseStart
data: {"message_id": "msg-789"}

event: ResponseChunk
data: {"content": "好的，我来帮你设计 API..."}

event: CapabilityCall
data: {"capability": "code", "reason": "检测到代码相关需求"}

event: ResponseChunk
data: {"content": "```typescript\ninterface API {..."}

event: ResponseEnd
data: {"message_id": "msg-789", "status": "completed"}
```

### 5.2 内部接口

#### Capability Router

```moonbit
interface CapabilityRouter {
  // 根据意图路由到 Capability
  fn route(intent: Intent) -> Option<CapabilityRef>
  
  // 获取所有可用的 Capability
  fn list_capabilities() -> Array<CapabilityInfo>
  
  // 注册新的 Capability
  fn register(capability: Capability) -> Result<Unit, Error>
  
  // 注销 Capability
  fn unregister(name: String) -> Result<Unit, Error>
}
```

#### Memory Operations

```moonbit
interface MemoryOperations {
  // 存储记忆
  fn store(memory: Memory) -> Result<String, Error>
  
  // 检索记忆
  fn search(query: String, filters: MemoryFilters) -> Result<Array<Memory>, Error>
  
  // 获取记忆详情
  fn get(id: String) -> Result<Memory, Error>
  
  // 更新记忆
  fn update(id: String, content: String) -> Result<Unit, Error>
  
  // 删除记忆
  fn delete(id: String) -> Result<Unit, Error>
}
```

---

## 6. 错误处理设计

### 6.1 错误分类

| 类型 | 说明 | 处理策略 |
|------|------|----------|
| UserError | 用户输入错误 | 友好提示，引导正确输入 |
| NetworkError | 网络/ API 错误 | 重试 (最多 3 次)，降级方案 |
| SystemError | 系统内部错误 | 记录日志，返回通用错误消息 |
| SecurityError | 安全相关错误 | 立即拒绝，记录审计日志 |

### 6.2 错误码定义

```moonbit
enum ErrorCode {
  // 用户错误 (1xxx)
  InvalidInput = 1001,
  SessionNotFound = 1002,
  MemoryNotFound = 1003,
  
  // 网络错误 (2xxx)
  NetworkTimeout = 2001,
  APIUnavailable = 2002,
  APIRateLimited = 2003,
  
  // 系统错误 (3xxx)
  InternalError = 3001,
  StorageError = 3002,
  IndexCorrupted = 3003,
  
  // 安全错误 (4xxx)
  Unauthorized = 4001,
  PermissionDenied = 4002,
  SecurityViolation = 4003
}
```

### 6.3 Circuit Breaker 模式

```
正常状态 → [失败计数 >= 阈值] → 打开状态
                          ↓
                    [等待冷却时间]
                          ↓
                    半开状态 → [成功] → 正常状态
                           → [失败] → 打开状态
```

**配置**:

```json
{
  "circuit_breaker": {
    "failure_threshold": 5,
    "success_threshold": 2,
    "timeout": 30000,
    "half_open_max_calls": 1
  }
}
```

---

## 7. 性能设计

### 7.1 性能目标

| 指标 | 目标值 | 测量方法 |
|------|--------|----------|
| 首个 token 响应时间 | < 3s | 从用户发送到首个 SSE 事件 |
| 记忆检索 (1000 文件) | < 2s | 从查询到返回结果 |
| Web 渲染流畅度 | 60fps | 1000+ 行文档 |
| CLI 启动时间 | < 500ms | 命令执行到显示提示符 |

### 7.2 性能优化策略

**记忆检索优化**:

1. 内存索引，避免每次扫描文件
2. 索引持久化，启动时直接加载
3. 增量更新，避免全量重建
4. 仅读取匹配文件内容

**SSE 流式优化**:

1. 分块发送，避免等待完整响应
2. 压缩传输，减少网络开销
3. 连接复用，避免重复建立连接

**并发处理**:

1. 异步 I/O，避免阻塞主线程
2. 连接池管理，复用资源
3. 批量操作，减少系统调用

---

## 8. 安全设计

### 8.1 安全边界

| 组件 | 安全边界 | 违规处理 |
|------|----------|----------|
| Skill/MCP 调用 | 权限检查，白名单 | 拒绝执行，记录审计 |
| 文件操作 | 仅允许指定目录 | 拒绝访问，提示用户 |
| 网络请求 | 仅 HTTPS，域名白名单 | 拦截请求，记录日志 |
| 代码执行 | WebAssembly 沙箱 | 超时终止，无文件系统 |

### 8.2 API Key 管理

```
用户配置 → 加密存储 (本地) → 运行时解密 → 调用 API
          ↓
    永不上传到 Flare 服务器
```

### 8.3 审计日志

所有敏感操作记录日志:

```json
{
  "timestamp": "2026-04-19T12:00:00",
  "action": "capability_call",
  "capability": "file_ops",
  "input_summary": "读取文件: ~/projects/flare/README.md",
  "result": "success",
  "duration_ms": 150
}
```

---

## 9. 可观测性设计

### 9.1 日志级别

| 级别 | 说明 | 示例 |
|------|------|------|
| DEBUG | 调试信息 | API 请求详情 |
| INFO | 正常操作 | 服务启动，对话开始 |
| WARN | 警告 | 重试，降级 |
| ERROR | 错误 | API 失败，存储失败 |

### 9.2 监控指标

| 指标 | 类型 | 说明 |
|------|------|------|
| `request_count` | Counter | 请求总数 |
| `request_latency_ms` | Histogram | 请求延迟分布 |
| `capability_call_count` | Counter | Capability 调用次数 |
| `capability_call_duration_ms` | Histogram | Capability 调用耗时 |
| `memory_search_latency_ms` | Histogram | 记忆检索耗时 |
| `dream_execution_count` | Counter | Dream 执行次数 |
| `error_count` | Counter | 错误计数 (按类型) |

### 9.3 分布式追踪

```
Trace ID: trace-123
  ├── Span 1: API Layer (POST /chat)
  │       └── Span 2: Coordination Layer
  │           ├── Span 3: Intent Analysis
  │           ├── Span 4: Capability Router
  │           └── Span 5: Capability Execute
  │               └── Span 6: LLM API Call
  └── Span 7: Memory Store
```

---

## 10. 部署设计

### 10.1 部署模式

**本地部署** (主要模式):

```
用户设备
    └── flare-server (本地进程)
        ├── flare-web (本地 HTTP 服务)
        └── flare-cli (命令行工具)
```

### 10.2 启动流程

```
flare start
    ↓
1. 检查配置文件
    ↓
2. 加载记忆索引 (或重建)
    ↓
3. 启动 HTTP Server
    ↓
4. 扫描并注册 Skills
    ↓
5. 启动 MCP Servers
    ↓
6. 检查定时任务 (Dream)
    ↓
服务就绪
```

### 10.3 健康检查

```
GET /health

响应:
{
  "status": "healthy",
  "checks": {
    "http_server": "ok",
    "memory_index": "ok",
    "skills": "ok (3 registered)",
    "mcp_servers": "ok (2 connected)"
  }
}
```

---

## 11. 架构决策记录 (ADR)

### ADR-001: Phase 0 技术栈验证优先

**Status**: Accepted

**Context**: MoonBit Native 作为核心技术栈，但其生态成熟度未充分验证。HTTP Server、SSE、并发等核心能力的可用性直接决定项目成败。

**Decision**: 在 Phase 1 启动前，增加为期 1 周的 Phase 0 技术栈验证。验证内容包括 HTTP Server、SSE、并发、文件 I/O、定时任务。如验证失败，立即切换到 Go 或 Rust。

**Consequences**:
- 优点：尽早发现技术栈问题，避免 Phase 1 中途返工
- 缺点：增加 1 周前期时间，但可节省潜在的 2-3 个月返工时间

---

### ADR-002: Skill/MCP 统一 Capability 抽象

**Status**: Accepted

**Context**: Skill 和 MCP 是不同的概念和调用方式，需要一个统一抽象层让 Coordination Layer 不关心具体实现细节。

**Decision**: 设计 Capability 抽象接口，包含 name、description、execute、health_check 方法。SkillCapability 和 MCPCapability 分别实现该接口。Coordination Layer 通过 Capability 接口调用所有能力。

**Consequences**:
- 优点：统一接口，易于扩展新能力类型
- 缺点：需要设计适配层，增加少量抽象开销

---

### ADR-003: 记忆系统内存索引 (含备选方案)

**Status**: Accepted (with fallback)

**Context**: qmd 文件存储方案简单，但文件遍历性能无法满足 1000 文件 < 2s 检索的要求。

**Decision**: 设计内存索引方案：
1. 启动时扫描所有 qmd 文件，构建关键词和标签索引
2. 索引持久化到本地 JSON 文件，下次启动直接加载
3. 新增/修改记忆时增量更新索引
4. 检索时直接查询内存索引，仅读取匹配文件内容

**性能估算**:
- 10,000 文件索引加载：~1-5s（JSON 解析）
- 索引查询：~50ms（内存查询）
- 匹配文件内容读取：~500ms（假设 10 个匹配文件）
- 总计：< 6s（首次加载），后续 < 1s

**备选方案 (如果 JSON 索引性能不满足)**:

| 方案 | 说明 | 触发条件 |
|------|------|----------|
| MessagePack | 二进制序列化，解析更快 | JSON parse > 10s |
| SQLite | 嵌入式数据库，支持 SQL 查询 | 内存索引 > 100MB |
| 分片索引 | 按时间/标签分片，按需加载 | 单索引文件 > 50MB |

**Consequences**:
- 优点：检索性能从 O(n) 文件遍历提升到 O(1) 索引查询
- 缺点：需要维护索引一致性，启动时需要扫描时间
- 风险：MoonBit JSON 库性能未验证，需 Phase 0 验证

---

### ADR-004: 本地优先存储

**Status**: Accepted

**Context**: 用户数据隐私和自主控制是核心需求，云端存储存在隐私泄露风险。

**Decision**: 所有记忆数据本地存储 (qmd 文件)，不上传云端。提供可选的本地加密功能。

**Consequences**:
- 优点：用户数据完全自主，隐私保护，离线可用
- 缺点：放弃多设备同步便利性，待后续市场验证

---

### ADR-005: HTTP 双向通信 (废弃 SSE)

**Status**: Accepted (Updated)

**Context**: Server-Client 通信需要支持双向通信。原设计选择 SSE，但 SSE 是单向协议（Server→Client），需要额外 HTTP POST 处理 Client→Server 请求。

**Decision**: 使用纯 HTTP 双向通信，废弃 SSE。
- POST /chat：接收用户消息，返回完整响应（Phase 1）
- POST /stream：流式响应（Phase 2+，可选）

**Consequences**:
- 优点：协议统一，实现简单，无需处理 SSE 连接管理
- 缺点：流式响应需要额外处理（chunked transfer 或轮询）
- 变更：从原 SSE 方案迁移到纯 HTTP 需要修改 API Layer 设计

**备选方案 (Phase 2+ 评估)**:
- WebSocket：双向通信，统一协议，但实现复杂度更高

---

### ADR-006: Dream Engine 分阶段实现

**Status**: Accepted

**Context**: Dream Engine 是系统中最复杂的部分，涉及 Checkpoint + Rollback + 异步处理 + 并发冲突处理。Phase 1 实现完整功能的复杂度高、风险大。

**Decision**: Dream Engine 分阶段实现：

| Phase | 范围 | 复杂度 |
|-------|------|--------|
| Phase 1 | 仅快照（对话结束后写入 qmd） | 低 |
| Phase 2 | 定时触发 + 条件触发 + 简单冗余检测 | 中 |
| Phase 3 | Checkpoint + Rollback + 并发冲突处理 | 高 |
| Phase 4 | 增量整合 + 时间衰减 + 模式归纳 | 高 |

**简化原因**:
1. **复杂度高**: Checkpoint + Rollback + 异步处理 = 小型分布式系统
2. **恢复复杂**: Server 崩溃时 Dream 进行到一半，需要协调机制恢复
3. **并发冲突**: Dream 和用户对话同时访问同一个 qmd 文件，需要冲突处理
4. **Phase 1 聚焦**: 先验证核心能力（记忆存储、检索、应用）

**Consequences**:
- 优点：降低 Phase 1 风险，聚焦核心能力验证
- 缺点：完整 Dream 功能延迟到 Phase 4
- 缓解：Phase 1 快照功能已满足基本记忆需求

---

## 12. 待解决问题

| 问题 | 描述 | Owner | 截止 |
|------|------|-------|------|
| MoonBit 多线程支持 | 验证并发模型 | Eng Lead | Phase 0 |
| Skill 文件格式解析 | 定义解析流程 | Server Team | Phase 2 前 |
| MCP Server 进程管理 | 启动/监控/重启 | Integration Team | Phase 2 前 |
| 国产模型兼容性 | Qwen/GLM/MiniMax | Integration Team | Phase 3 前 |
| 代码执行沙箱 | WebAssembly 方案 | Eng Lead | Phase 3 前 |

---

## 13. 附录

### 13.1 C4 模型 - Context 图

```
┌──────────────────────────────────────────────────────────────┐
│                         Flare System                        │
│                                                              │
│   一个本地优先的个人 Agent 协调器，记忆用户对话并协调专家 Agent    │
└──────────────────────────────────────────────────────────────┘
           ↑                    ↑                    ↑
           │                    │                    │
    ┌──────┴──────┐     ┌───────┴───────┐   ┌───────┴───────┐
    │    User     │     │  LLM Provider │   │  MCP Servers  │
    │ (CLI/Web)   │     │ (Claude/Qwen) │   │ (Obsidian/    │
    │             │     │               │   │  FileSystem)  │
    └─────────────┘     └───────────────┘   └───────────────┘
```

### 13.2 C4 模型 - Container 图

```
┌─────────────────────────────────────────────────────────────┐
│                         Flare System                        │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  flare-web  │  │  flare-cli  │  │    flare-server     │ │
│  │  (Vue3)     │  │  (MoonBit)  │  │    (MoonBit)        │ │
│  │             │  │             │  │                     │ │
│  │ - 对话界面   │  │ - 命令交互   │  │ - HTTP/SSE Server  │ │
│  │ - 记忆管理   │  │ - 服务管理   │  │ - Coordination     │ │
│  │ - SSE 客户端  │  │ - SSE 客户端  │ │ - Memory System    │ │
│  └──────┬──────┘  └──────┬──────┘  │ - Capability Mgr   │ │
│         │ SSE           │ SSE     │ - Evolution Engine │ │
│         │               │         │ - Dream Engine     │ │
│         └───────────────┼─────────┘                     │ │
│                         │                               │ │
│                         ↓                               │ │
│              ┌─────────────────────────────┐           │ │
│              │      Local Storage          │           │ │
│              │  (qmd / config / index)     │           │ │
│              └─────────────────────────────┘           │ │
└─────────────────────────────────────────────────────────┘
```

### 13.3 术语表

| 术语 | 说明 |
|------|------|
| Capability | 能力抽象接口，Skill 和 MCP 的统一封装 |
| Dream | 做梦机制，定期整合记忆 |
| Evolution | 自我进化，从用户交互中学习 |
| MCP | Model Context Protocol，连接外部工具 |
| qmd | Quarto Markdown，记忆文件格式 |
| Skill | 专家能力，基于 prompt template |
| SSE | Server-Sent Events，流式通信协议 |

---

**文档完成**
