# Flare 开发计划

**Status**: Draft
**Created**: 2026-04-19
**Last Updated**: 2026-04-19
**Version**: 2.0 (评审后修订)

---

## 计划总览

### Phase 时间线

```
Phase 0 (技术栈验证)      │███████████│ 1 周
Phase 1 (MVP 骨架)        │███████████│ 3 周
Phase 2 (CLI+Web+Capability) │███████████│ 4 周
Phase 3A (记忆系统 + 多 Provider) │███████████│ 4 周
Phase 3B (Skill 路由 + 自我进化)  │███████████│ 4 周
Phase 4 (Dream+ 多 Skill)    │███████████│ 6 周
```

**总计**: 约 22 周（5.5 个月）

### 关键里程碑

| 里程碑 | 目标日期 | 成功标准 |
|--------|----------|----------|
| Phase 0 完成 | Week 1 | MoonBit 能力验证通过/技术栈切换决策 |
| Phase 1 完成 | Week 4 | 单次完整对话可用 |
| Phase 2 完成 | Week 8 | CLI/Web 可用，Capability 框架验证通过 |
| Phase 3A 完成 | Week 12 | 记忆系统可用，1000 文件检索 < 2s |
| Phase 3B 完成 | Week 16 | Skill 路由可用，隐式学习生效 |
| Phase 4 完成 | Week 22 | Dream 整合 + 多 Skill 协调可用 |

### 用户验证里程碑

| Phase | 验证活动 | 时间 | 成功标准 |
|-------|---------|------|----------|
| Phase 3 | Beta 用户反馈 (n=20) | Week 12 | NPS ≥ 30，核心功能采用率 ≥ 60% |
| Phase 4 | GA 前用户验收 (n=50) | Week 21 | 满意度 ≥ 4.0/5.0 |

### GTM 里程碑

| 任务 | 时间 | Owner |
|------|------|-------|
| 定价策略确定 | Week 18 | PM + Stakeholders |
| 发布博客撰写 | Week 21 | Marketing |
| Product Hunt 发布 | Week 22 | Marketing |
| 用户案例收集 | Week 23-24 | PM |

---

## Phase 0: 技术栈验证（Week 1）

### 目标
验证 MoonBit Native 是否具备实现 Flare 核心功能的能力。

### 验证任务

| ID | 任务 | Owner | 输出物 | 验证标准 |
|----|------|-------|--------|----------|
| T0.1 | HTTP Server 验证 | Eng Lead | `poc/http-server/` | 能处理 GET/POST 请求 |
| T0.2 | HTTP Client 验证 | Eng Lead | `poc/http-client/` | 能调用外部 API |
| T0.3 | JSON 序列化验证 | Eng Lead | `poc/json-test/` | JSON 解析/生成正常 |
| T0.4 | 文件 I/O 验证 | Eng Lead | `poc/file-io/` | 能读写 JSON/qmd 文件 |
| T0.5 | 并发模型验证 | Eng Lead | `poc/concurrency/` | 多任务并发处理正常 |
| T0.6 | 定时任务验证 | Eng Lead | `poc/timer-test/` | 定时触发器可用 |
| T0.7 | 技术栈决策 | Eng Lead | 决策文档 | 继续使用 MoonBit 或切换 |

### 详细验证内容

**T0.1: HTTP Server 验证**
```moonbit
// 验证点：
// 1. 能否启动 HTTP 服务器？
// 2. 能否监听指定端口？
// 3. 能否处理 GET 请求？
// 4. 能否处理 POST 请求？
// 5. 能否返回 JSON 响应？
```

**T0.2: HTTP Client 验证**
```moonbit
// 验证点：
// 1. 能否发起 HTTP GET 请求？
// 2. 能否发起 HTTP POST 请求？
// 3. 能否处理 HTTPS？
// 4. 超时处理是否正常？
```

**T0.3: JSON 序列化验证**
```moonbit
// 验证点：
// 1. JSON 对象能否序列化为字符串？
// 2. JSON 字符串能否解析为对象？
// 3. 嵌套 JSON 处理是否正常？
// 4. 性能是否满足需求（10,000 条记录解析 < 10s）？
```

**T0.4: 文件 I/O 验证**
```moonbit
// 验证点：
// 1. 能否读取文件内容？
// 2. 能否写入文件内容？
// 3. 能否追加内容？
// 4. 文件锁机制是否支持？
```

**T0.5: 并发模型验证**
```moonbit
// 验证点：
// 1. MoonBit 并发模型是什么？
// 2. 多任务能否同时执行？
// 3. 数据竞争如何处理？
// 4. 内存占用是否合理？
```

**T0.6: 定时任务验证**
```moonbit
// 验证点：
// 1. 能否实现定时触发器？
// 2. 能否实现周期性任务？
// 3. 长时间运行是否稳定？
```

### 决策检查点

**Day 3: 中期评审**
- 检查已完成的验证任务
- 如 3 项及以上核心能力不可用 → 启动切换预案

**Day 5: 最终决策**
- 继续使用 MoonBit 或切换到 Go/Rust
- 如切换，Week 2 执行切换，Phase 1 顺延 1 周

### 切换触发条件

任一条件满足即启动切换：
1. HTTP Server 不可用
2. HTTP Client 不可用
3. JSON 性能不达标（> 10s）且 1 周内无优化方案
4. 并发模型不可用
5. 关键 Bug 阻塞超过 3 天

### 切换预案

**切换流程**:
1. Eng Lead 提交书面风险评估 (24h)
2. Architect + PM 联合评审 (24h)
3. 确认切换，执行备选方案 (1 周)

**切换检查清单**:
- [ ] 已评估 Go/Rust 学习成本
- [ ] 已确认备选技术栈 HTTP/并发/文件 I/O 能力
- [ ] 已更新项目时间表 (+2 周)
- [ ] 已通知所有利益相关方

### 交付物

- [ ] `poc/http-server/` - HTTP 服务器验证代码
- [ ] `poc/http-client/` - HTTP 客户端验证代码
- [ ] `poc/json-test/` - JSON 序列化验证代码
- [ ] `poc/file-io/` - 文件 I/O 验证代码
- [ ] `poc/concurrency/` - 并发模型验证代码
- [ ] `poc/timer-test/` - 定时任务验证代码
- [ ] `docs/phase0-report.md` - Phase 0 验证报告
- [ ] `docs/tech-stack-decision.md` - 技术栈决策文档
- [ ] `poc/go-starter/` 或 `poc/rust-starter/` - 备选技术栈骨架（如切换）

---

## Phase 1: MVP 骨架（Week 2-4）

### 目标
实现 Flare 核心对话功能，完成单次完整对话。

### 范围

**包含**:
- MoonBit 项目初始化
- flare-server 基础骨架
- HTTP Server 实现
- Anthropic API 适配层
- 基础对话循环
- 配置文件加载

**不包含**:
- CLI 工具
- Web 界面
- Skill/MCP 集成
- 记忆系统
- 流式响应

### 任务分解

| ID | 任务 | 周 | Owner | 依赖 |
|----|------|----|-------|-----|
| T1.1 | MoonBit 项目初始化 | W2 | Eng Lead | Phase 0 |
| T1.2 | 配置文件加载器 | W2 | Server Team | T1.1 |
| T1.3 | HTTP Server 基础框架 | W2 | Server Team | T1.1 |
| T1.4 | Anthropic API 适配层 | W2-W3 | Server Team | T1.3 |
| T1.5 | 对话循环实现 | W3 | Server Team | T1.4 |
| T1.6 | 错误处理框架 | W3 | Server Team | T1.3 |
| T1.7 | 日志系统（分级：DEBUG/INFO/WARN/ERROR） | W3 | Server Team | T1.3 |
| T1.8 | 错误码定义 | W3 | Server Team | T1.6 |
| T1.9 | QA 测试计划框架 | W3 | QA Team | T1.1 |
| T1.10 | 集成测试 | W4 | QA Team | T1.5 |
| T1.11 | MVP 演示准备 | W4 | All | T1.10 |

### QA 早期参与

**Phase 1 QA 活动**:
- 参与需求评审（Week 2）
- 编写测试计划框架（Week 3）
- 搭建 CI 测试环境（Week 4）
- 执行集成测试（Week 4）

### 详细实现

**T1.1: MoonBit 项目初始化**
```bash
# 目录结构
flare/
├── server/           # flare-server 源码
│   ├── src/
│   │   ├── main.moon
│   │   ├── config.moon
│   │   ├── server.moon
│   │   └── api/
│   │       └── anthropic.moon
│   └── moon.pkg.json
├── cli/              # flare-cli 源码（Phase 2）
├── web/              # flare-web 源码（Phase 2）
└── specs/            # 规格文档
```

**T1.2: 配置文件加载器**
```json
// ~/.flare/config.json
{
  "llm": {
    "default_provider": "anthropic",
    "providers": {
      "anthropic": {
        "api_key": "sk-...",
        "model": "claude-sonnet-4-20250514"
      }
    }
  }
}
```

**T1.3: HTTP Server 基础框架**
```moonbit
// Endpoints:
// - GET /health - 健康检查
// - POST /chat - 接收用户消息（同步响应）
// - GET /status - 服务状态
```

**T1.4: Anthropic API 适配层**
```moonbit
// 实现 Messages API 调用
// - 构建消息请求
// - 处理响应
// - 错误重试机制
```

**T1.5: 对话循环实现**
```
用户输入 → 构建请求 → 调用 API → 返回响应
```

### 验收标准

- [ ] 运行 `moon build` 无错误
- [ ] 运行 `flare-server` 启动成功
- [ ] 监听端口 3000（可配置）
- [ ] POST /chat 返回 Claude 响应
- [ ] 错误处理正确
- [ ] 日志记录完整

### 交付物

- [ ] `server/` - flare-server 源码
- [ ] `~/.flare/config.json` - 配置文件格式
- [ ] `docs/api.md` - API 文档
- [ ] `test/` - 集成测试

---

## Phase 2: CLI + Web + Capability（Week 5-8）

### 目标
实现用户界面和 Capability 基础框架。

### 范围

**包含**:
- flare-cli 实现
- flare-web 骨架
- Capability 抽象接口
- Skill 发现机制
- MCP 进程池基础
- 至少调用 1 个 Skill 和 1 个 MCP

**不包含**:
- 记忆系统实现
- 流式响应（Phase 2 后期可选）
- 多 Provider 支持

### 任务分解

| ID | 任务 | 周 | Owner | 依赖 |
|----|------|----|-------|-----|
| T2.1 | Capability 接口 + SkillCapability | W5 | Architect | Phase 1 |
| T2.2 | MCPCapability 实现 | W6 | Server Team | T2.1 |
| T2.3 | MCP 进程池骨架 (空闲进程获取/归还) | W6 | Server Team | T2.2 |
| T2.4 | MCP 进程生命周期管理 (spawn/cleanup) | W7 | Server Team | T2.3 |
| T2.5 | flare-cli 实现 | W5-W6 | CLI Team | T2.1 |
| T2.6 | flare-web 骨架 | W6-W7 | Frontend Team | T2.1 |
| T2.7 | Skill 发现机制 | W7 | Server Team | T2.1 |
| T2.8 | 文件锁机制实现 | W7 | Server Team | T2.1 |
| T2.9 | 安全边界检查框架 | W7 | Server Team | T2.1 |
| T2.10 | 基础监控指标实现 | W7 | Server Team | T2.1 |
| T2.11 | 配置热重载机制 | W8 | Server Team | T2.1 |
| T2.12 | 数据格式版本管理 | W8 | Server Team | T2.1 |
| T2.13 | 记忆索引方案设计 | W8 | Architect | - |
| T2.14 | QA 自动化测试 | W8 | QA Team | T2.5,T2.6 |
| T2.15 | ADR 更新 | W8 | Architect | - |

### 安全边界实现

**T2.9 安全边界检查框架**:
- 域名白名单验证
- 目录访问限制
- 审计日志记录

### 监控指标

**T2.10 基础监控指标**:
- `request_count` / `error_count`
- `capability_call_duration_ms`
- 日志文件轮转（避免无限增长）

### Capability 接口

```moonbit
interface Capability {
  fn name() -> String
  fn description() -> String
  fn execute(context: ExecutionContext, input: Json) -> Result<Json, Error>
  fn health_check() -> Bool
  fn capability_type() -> CapabilityType
  fn trigger_keywords() -> Array<String>
}

enum CapabilityType {
  Skill
  MCP
  BuiltIn
}
```

### Skill 文件格式

```yaml
# skills/code.skill.yaml
name: code
description: 代码编写和调试能力
version: "1.0"
trigger_keywords:
  - 代码
  - 编程
  - debug
system_prompt: |
  你是一个专业的代码助手...
template: |
  用户需求：{{input}}
  请帮助用户...
```

### MCP 进程池

```moonbit
struct MCPProcessPool {
  processes: Map<ProcessId, MCPProcess>,
  min_size: Int,
  max_size: Int,
  idle_timeout: Duration,
}
```

### 验收标准

- [ ] CLI 能启动对话
- [ ] Web 显示对话界面
- [ ] Capability 接口正确实现
- [ ] 至少调用 1 个 Skill
- [ ] 至少调用 1 个 MCP
- [ ] 记忆索引方案设计完成

### 交付物

- [ ] `server/src/capability/` - Capability 实现
- [ ] `server/src/mcp/pool.moon` - MCP 进程池
- [ ] `cli/` - flare-cli 源码
- [ ] `web/` - flare-web 源码
- [ ] `skills/` - Skill 定义示例
- [ ] `docs/skill-format.md` - Skill 格式文档
- [ ] `docs/memory-index-design.md` - 记忆索引设计

---

## Phase 3A: 记忆系统 + 多 Provider（Week 9-12）

### 目标
实现记忆系统和多 LLM Provider 兼容。

### 范围

**包含**:
- qmd 文件存储
- 记忆索引实现
- 记忆检索应用
- 多 Provider 兼容
- Circuit Breaker 模式
- 性能验证

**不包含**:
- 隐式学习（Phase 3B）
- 显式记忆（Phase 3B）
- Dream 整合机制

### 任务分解

| ID | 任务 | 周 | Owner | 依赖 |
|----|------|----|-------|-----|
| T3A.1 | qmd 文件读写实现 | W9 | Server Team | Phase 2 |
| T3A.2 | 记忆索引实现 | W9-W10 | Server Team | T3A.1 |
| T3A.3 | 记忆检索实现 | W10 | Server Team | T3A.2 |
| T3A.4 | 记忆应用（对话上下文） | W11 | Server Team | T3A.3 |
| T3A.5 | Circuit Breaker 模式实现 | W11 | Server Team | T3A.4 |
| T3A.6 | Qwen Provider 适配 | W11 | Server Team | T3A.4 |
| T3A.7 | GLM Provider 适配 | W12 | Server Team | T3A.6 |
| T3A.8 | SQLite 备选方案验证 | W12 | QA Team | T3A.2 |
| T3A.9 | 性能验证 | W12 | QA Team | T3A.3 |
| T3A.10 | 并发写入验证 | W12 | QA Team | T3A.1 |
| T3A.11 | 集成测试 | W12 | QA Team | T3A.7 |
| T3A.12 | ADR 更新 | W12 | Architect | - |

### 性能目标

| 指标 | 目标值 | 验证方法 |
|------|--------|----------|
| 1000 文件检索 | < 2s | 压力测试 |
| 10,000 文件索引加载 | < 5s | 启动测试 |
| 并发写入（10 会话） | 无冲突 | 并发测试 |
| 内存占用（10,000 文件） | < 100MB | 监控测试 |

### SQLite 备选方案

**触发条件**（任一满足）:
- JSON 索引解析 > 10s
- 内存索引 > 100MB
- 单索引文件 > 50MB

**验证内容**:
- SQLite 嵌入方案
- 迁移工具（JSON → SQLite）
- 性能对比测试

### 验收标准

- [ ] 对话结束生成 qmd 记忆文件
- [ ] 用户提问能引用相关记忆
- [ ] Qwen/GLM 调用成功
- [ ] 1000 文件检索 < 2s
- [ ] 并发写入无冲突
- [ ] Circuit Breaker 正常运作

### 交付物

- [ ] `server/src/memory/` - 记忆系统源码
- [ ] `server/src/provider/` - 多 Provider 适配
- [ ] `~/.flare/memory/` - 记忆文件目录
- [ ] `~/.flare/memory-index.json` - 记忆索引
- [ ] `test/memory/` - 记忆系统测试
- [ ] `docs/performance-report.md` - 性能报告

---

## Phase 3B: Skill 路由 + 自我进化（Week 13-16）

### 目标
实现 Skill/MCP 智能路由和基础自我进化能力。

### 范围

**包含**:
- Skill/MCP 智能路由（关键词匹配）
- 隐式学习机制
- 显式记忆机制
- 用户验证（Beta 反馈）

**不包含**:
- Dream 整合机制（Phase 4）
- 反馈学习（Phase 4）
- 模式归纳（Phase 4）

### 任务分解

| ID | 任务 | 周 | Owner | 依赖 |
|----|------|----|-------|-----|
| T3B.1 | Skill/MCP 关键词路由 | W13 | Server Team | Phase 3A |
| T3B.2 | 意图分析（三分类） | W13 | Server Team | T3B.1 |
| T3B.3 | 隐式学习（关键词提取） | W14 | Server Team | T3B.2 |
| T3B.4 | 显式记忆（"记住这个"） | W14 | Server Team | T3B.3 |
| T3B.5 | Beta 用户测试准备 | W14 | PM | - |
| T3B.6 | Beta 用户反馈收集 (n=20) | W15 | PM + QA | T3B.5 |
| T3B.7 | Beta 问题修复 | W16 | Server Team | T3B.6 |
| T3B.8 | 集成测试 | W16 | QA Team | T3B.4 |
| T3B.9 | ADR 更新 | W16 | Architect | - |

### 隐式学习流程

```
对话结束 → 提取关键词 → 构建记忆摘要 → 
检查重复 → 生成 qmd → 存储 → 更新索引
```

### 验收标准

- [ ] 用户提出代码问题自动路由到 code skill
- [ ] 用户提出 PDF 问题自动路由到 pdf skill
- [ ] 对话中用户表达偏好自动存储
- [ ] 用户说"记住这个"立即存储
- [ ] Beta 用户 NPS ≥ 30
- [ ] 核心功能采用率 ≥ 60%

### 交付物

- [ ] `server/src/router/` - 路由系统源码
- [ ] `server/src/learning/` - 自我进化源码
- [ ] `docs/beta-feedback-report.md` - Beta 反馈报告

---

---

## Phase 4: Dream + 多 Skill 协调（Week 17-22）

### 目标
实现 Dream 整合机制和多 Skill 协调能力。

### 范围

**包含**:
- Dream 定时触发
- Dream 主动触发
- Dream 条件触发
- Dream 整合逻辑（简化版）
- 多 Skill 协调框架
- 反馈学习机制
- 模式归纳（简化版）
- Obsidian 插件（可选）
- GTM 发布准备

**不包含**:
- Dream Checkpoint/Rollback
- 复杂模式归纳

### 任务分解

| ID | 任务 | 周 | Owner | 依赖 |
|----|------|----|-------|-----|
| T4.1 | Dream 调度器实现 | W17 | Server Team | Phase 3B |
| T4.2 | Dream 分析模块 | W17-W18 | Server Team | T4.1 |
| T4.3 | Dream 整合模块 | W18 | Server Team | T4.2 |
| T4.4 | Dream 异常处理（简化版） | W19 | Server Team | T4.3 |
| T4.5 | Dream 报告生成 | W19 | Server Team | T4.4 |
| T4.6 | 多 Skill 协调框架 | W19 | Server Team | Phase 3B |
| T4.7 | 反馈学习实现 | W20 | Server Team | T4.6 |
| T4.8 | 模式归纳（简化版：统计规则） | W20 | Server Team | T4.7 |
| T4.9 | Obsidian 插件开发 | W20-W21 | Frontend Team | T4.6 |
| T4.10 | 集成测试 | W21 | QA Team | T4.8 |
| T4.11 | GA 发布准备 | W22 | All | T4.10 |
| T4.12 | 定价策略确定 | W18 | PM + Stakeholders | - |
| T4.13 | 发布博客撰写 | W21 | Marketing | - |
| T4.14 | ADR 更新 | W22 | Architect | - |

### Dream 触发方式

| 方式 | 条件 | 优先级 |
|------|------|--------|
| 主动触发 | `flare dream` 命令 | P0 |
| 条件触发 | 记忆 > 500 或会话 > 50 | P1 |
| 定时触发 | 每日 2:00 或闲置 30min | P2 |

### Dream 简化版范围

**Phase 4 实现**:
- ✅ 扫描所有 qmd 文件
- ✅ 时间衰减计算
- ✅ 冗余内容检测
- ✅ 简单整合（合并相似记忆）
- ✅ 生成整合报告
- ✅ 备份删除的记忆

**延期到后续 Phase**:
- ❌ Checkpoint 进度持久化
- ❌ Rollback 回滚机制
- ❌ 增量整合
- ❌ LLM 辅助模式归纳

### 多 Skill 协调

```
用户需求 → 意图分析 → 识别多意图 → 
├─→ Skill A 调用 → 结果 A
├─→ Skill B 调用 → 结果 B
└─→ 聚合结果 → 返回用户
```

### 验收标准

- [ ] Dream 定时触发正常
- [ ] Dream 主动触发正常
- [ ] Dream 条件触发正常
- [ ] Dream 整合报告正确
- [ ] 多 Skill 协调正常
- [ ] 反馈学习生效
- [ ] Obsidian 插件可用（可选）
- [ ] GA 发布完成

### 交付物

- [ ] `server/src/dream/` - Dream Engine 源码
- [ ] `~/.flare/dream-backup/` - Dream 备份目录
- [ ] `~/.flare/evolution-rules.json` - 进化规则
- [ ] `obsidian-plugin/` - Obsidian 插件（可选）
- [ ] `test/dream/` - Dream 系统测试
- [ ] `docs/gtm-release-notes.md` - 发布说明

---

## 资源规划

### 团队组成

| 角色 | 人数 | 职责 |
|------|------|------|
| Engineering Lead | 1 | 技术决策、架构评审、Phase 0 验证 |
| Server Team | 2-3 | flare-server 开发 |
| CLI Team | 1 | flare-cli 开发 |
| Frontend Team | 1-2 | flare-web 和 Obsidian 插件 |
| QA Team | 1 | 测试计划、性能验证 |
| Architect | 1 | 系统设计、ADR 维护 |
| Product Manager | 1 | 产品方向、用户验证、GTM |

### 开发环境

| 工具 | 用途 |
|------|------|
| MoonBit CLI | 编译、构建 |
| Git | 版本控制 |
| VS Code | 开发 IDE |
| Obsidian | 文档协作 |

---

## 风险管理

### 技术风险

| 风险 | 概率 | 影响 | 缓解措施 | 触发条件 |
|------|------|------|----------|----------|
| MoonBit 生态不足 | Medium | High | Phase 0 验证，准备 Go/Rust 备选 | HTTP/SSE/并发不可用 |
| MCP 协议变更 | Low | Medium | 设计适配层，快速响应 | 协议重大更新 |
| 记忆性能不达标 | Medium | Medium | 备选 SQLite 方案 | JSON 索引 > 10s |
| Dream 复杂度高 | Medium | Medium | 分阶段实现，简化 Phase 4 范围 | - |

### 进度风险

| 风险 | 概率 | 影响 | 缓解措施 | 应对预案 |
|------|------|------|----------|----------|
| Phase 0 延期 | Low | High | 1 周严格时间盒，Day 3 中期评审 | 切换技术栈 |
| Phase 3A 性能调优耗时 | Medium | Medium | 提前设计 SQLite 备选方案 | 启用 SQLite |
| Phase 3B 自我进化效果不佳 | Medium | Medium | Beta 用户反馈快速迭代 | 延期到 Phase 4 |
| Obsidian 插件审核延迟 | Low | Low | 可延期发布，先 GitHub Release | 手动安装 |

### 产品风险

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|----------|
| 用户验证反馈负面 | Medium | High | Beta 小范围测试，快速迭代 |
| 竞品发布类似功能 | Medium | Medium | 保持 15% 资源用于竞争响应 |
| Skill/MCP 生态发展缓慢 | Low | Medium | 自建核心 Skill，等待生态成熟 |
| 用户付费意愿低 | Medium | High | Phase 3 验证付费意愿，调整定价策略 |

---

## 成功指标追踪

| 指标 | Phase | 目标值 | 测量方法 | 追踪频率 |
|------|-------|--------|----------|----------|
| 单次对话成功率 | Phase 1 | ≥ 90% | 日志分析 | 每日 |
| CLI/Web 可用性 | Phase 2 | ≥ 95% | 错误率统计 | 每周 |
| 记忆检索延迟 | Phase 3A | < 2s | 压力测试 | 每周 |
| 用户满意度 | Phase 3B | ≥ 3.5/5.0 | Beta 问卷 | 每两周 |
| Dream 整合有用性 | Phase 4 | ≥ 4.0/5.0 | 用户评分 | 每周 |
| NPS | Phase 3B/4 | ≥ 30 | Beta/GA 调研 | 每 Phase |

---

## 变更日志

| 版本 | 日期 | 变更内容 | Author |
|------|------|----------|--------|
| 1.0 | 2026-04-19 | 初始版本 | Architect |
| 2.0 | 2026-04-19 | 评审后修订：<br>- Phase 3 拆分为 3A + 3B<br>- 增加 Phase 0 决策检查点<br>- 增加 QA 早期参与<br>- 增加用户验证里程碑<br>- 增加 GTM 任务<br>- 补充安全/监控/配置任务<br>- 更新风险管理 | Architect |

---

**Approval Sign-off**:
- [ ] Engineering Lead: _______________ Date: _______
- [ ] Product Manager: _______________ Date: _______
- [ ] Architect: _______________ Date: _______
