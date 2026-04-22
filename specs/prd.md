# PRD: WitMate - 自我进化的个人 Agent 协调器

**Status**: Draft (架构评审后修订 v1.1)
**Author**: Product Team
**Last Updated**: 2026-04-19
**Version**: 1.1
**Stakeholders**: Engineering Lead, Design Lead, MoonBit Team, Vue3 Frontend Team

---

## 1. Problem Statement

### 用户痛点

**问题一：LLM 记忆碎片化**
当前主流 LLM 服务商（Claude、ChatGPT、文心一言等）各自维护用户对话历史，形成分散的记忆孤岛。用户在不同平台间切换时，之前的上下文无法迁移，导致重复沟通成本高昂。用户期望的是：**一个真正"认识我"的 AI 助手**，而非每次对话都从零开始的陌生客服。

**问题二：Claude Code 等工具门槛过高**
Claude Code、Cursor 等垂直 AI 工具功能强大，但深度绑定代码场景。普通用户（非技术人员、设计师、作家、研究人员）难以理解技术术语和操作流程，**使用成本高、学习曲线陡峭**。市场缺乏面向普通用户的、易上手且保留深度的通用型 AI 助手。

**问题三：缺乏统一的个人知识管理与智能协调**
现有工具在以下方面存在明显缺失：
- 无法统一协调多个专家 Agent（如代码助手、写作助手、研究助手）
- 缺乏本地优先的记忆积累机制，依赖云端存储，隐私保护弱
- 不具备从用户对话中学习和自我进化的能力

**谁在承受这个问题？**
- 知识工作者（每周 3-5 次对话体验中断）
- 创作者（项目资料散落在多个 AI 平台，检索成本高）
- 研究人员（跨平台知识整合困难，无法形成个人知识图谱）

**问题的成本：**
- 用户层面：重复沟通、效率流失、上下文丢失导致的决策质量下降
- 市场层面：缺乏真正个性化的 AI 体验，用户粘性低，流失率高

### Evidence
- **用户研究**: 知识工作者访谈（n=12）显示，83% 的用户在 3 个以上 AI 平台有使用记录，71% 对"重新向 AI 解释背景"感到沮丧
- **行为数据**: Claude Code 用户中，约 15% 会尝试使用它进行非代码任务（写作、翻译、分析），但因交互门槛放弃
- **竞品分析**: 当前市场缺乏"个人 Agent 协调器"定位的产品，用户需要自己组装工具链

---

## 2. Goals & Success Metrics

### Primary Goals

| Goal | Metric | Current Baseline | Target | Measurement Window |
|------|--------|-----------------|--------|-------------------|
| **建立记忆系统** | 用户重复信息输入率 | N/A（新产品） | < 15% | 60 天 |
| **降低使用门槛** | 首次会话完成率（完成一次完整对话） | N/A | ≥ 75% | 30 天 |
| **用户粘性** | 7 日留存率 | N/A | ≥ 40% | 90 天 |
| **知识积累** | 平均每个用户的本地记忆文件数 | N/A | ≥ 20 个 qmd 文件 | 90 天 |

### Secondary Goals

| Goal | Metric | Target | Window |
|------|--------|--------|--------|
| Agent 协调准确性 | 用户对 Agent 推荐的满意度评分 | ≥ 4.0/5.0 | 60 天 |
| 学习效果 | 用户反馈"越来越懂我"的比例 | ≥ 50% | 90 天 |
| 本地存储可靠性 | 记忆文件损坏/丢失率 | < 0.1% | 持续监控 |

### Non-Goals (Phase 1-4)
- **不支持移动端**：Phase 1-4 聚焦桌面端，移动端待 Phase 5 规划
- **不提供云端同步**：Phase 1-4 坚持本地优先，云端同步作为未来探索方向
- **不做专业操作**：witmate 负责协调，不直接执行代码编写、图像生成等专业任务，而是调用专家 Agent
- **不支持多用户协作**：Phase 1-4 为单用户个人工具，协作功能待市场验证后考虑

---

## 3. User Personas & Stories

### Primary Persona: 知识工作者"李明"

**背景**：
- 32 岁，产品经理，日常工作涉及需求分析、文档撰写、跨部门沟通
- 在 Claude、ChatGPT、文心一言间频繁切换
- 使用 Obsidian 进行个人知识管理
- 对 AI 有基础认知，但非技术专家

**核心痛点**：
- 每次切换 AI 平台，都要重新描述项目背景
- 难以追溯之前的决策依据（散落在多个平台）
- 需要"既能深度思考，又能快速回答"的统一入口

**使用场景**：
- 每天早晨：向 witmate 汇报今日计划，witmate 记录并提醒关键任务
- 需求分析：witmate 调用"分析师 Agent"协助梳理用户反馈
- 文档撰写：witmate 记录之前的讨论上下文，自动补充背景
- 周报撰写：witmate 从记忆中提取本周关键进展

### Secondary Persona: 研究人员"张华"

**背景**：
- 28 岁，博士研究生，研究方向为人工智能
- 使用多个 AI 工具进行文献综述、实验设计、论文写作
- 对数据隐私敏感，倾向于本地化解决方案

**核心痛点**：
- 跨平台的知识整合困难
- 长期积累研究领域上下文的需求
- 对云端存储的隐私风险有顾虑

**使用场景**：
- 文献综述：witmate 记录阅读笔记，自动关联相关文献
- 实验设计：witmate 从记忆中提取之前的实验方案供参考
- 论文写作：witmate 协调"写作 Agent"和"研究 Agent"

### User Stories

#### Epic 1: 记忆系统

**Story 1.1**: 作为知识工作者，我希望 witmate 能记住我之前的项目背景，这样我就不用每次都重复说明。
**Acceptance Criteria**:
- [ ] Given 我在上一会话中描述了项目背景，当我在新会话中提问相关问题时，Then witmate 能引用之前的背景信息
- [ ] Given 我有多个项目背景记忆，当我提问时，Then witmate 能识别并引用最相关的项目
- [ ] Performance: 记忆检索响应时间 < 2s（对于 1000 个记忆文件）

**Story 1.2**: 作为研究人员，我希望 witmate 能从我的对话中学习新知识，这样他能越来越懂我的研究领域。
**Acceptance Criteria**:
- [ ] Given 我在对话中提供了新的研究信息，当对话结束时，Then witmate 自动提取并存储关键知识
- [ ] Given witmate 存储了我的研究知识，当我询问相关问题时，Then witmate 能应用这些知识进行推理
- [ ] Edge case: 当我提供的信息与已有知识冲突时，Then witmate 询问确认而非直接覆盖

#### Epic 2: Agent & Skill/MCP 协调

**Story 2.1**: 作为用户，我希望 witmate 能识别我的需求并调用合适的专家 Agent/Skill，这样我能得到专业的帮助。
**Acceptance Criteria**:
- [ ] Given 我提出代码相关问题，当 witmate 分析后，Then 调用代码专家 Skill
- [ ] Given 我提出写作相关问题，当 witmate 分析后，Then 调用写作专家 Skill
- [ ] Given 我提出 PDF 处理需求，当 witmate 分析后，Then 调用 PDF Skill
- [ ] Given 我提出的需求涉及多个领域，当 witmate 分析后，Then 协调多个 Skill/MCP 协作
- [ ] Given Skill/MCP 调用失败，当错误发生时，Then witmate 提供清晰的错误信息并建议替代方案

**Story 2.2**: 作为用户，我希望看到 witmate 调用了哪些 Skill/MCP，这样我能理解它的决策过程。
**Acceptance Criteria**:
- [ ] Given witmate 调用了一个 Skill/MCP，当调用发生时，Then 在界面上显示名称和调用原因
- [ ] Given witmate 协调多个 Skill/MCP，当协调过程发生时，Then 显示协调流程图或时间线
- [ ] Given 用户希望详细了解，当用户点击详情时，Then 展示完整的推理链

**Story 2.3**: 作为高级用户，我希望能配置和添加新的 Skill/MCP，这样我能扩展 witmate 的能力。
**Acceptance Criteria**:
- [ ] Given 我有新的 MCP server 配置，当我在 config 中添加时，Then witmate 能连接并使用该 MCP
- [ ] Given 我创建自定义 skill 文件，当放置到 skill 目录时，Then witmate 能发现并加载
- [ ] Given skill/MCP 列表，当我查看时，Then 显示所有可用能力及其状态

#### Epic 3: 自我进化

**Story 3.1**: 作为用户，我希望 witmate 能记住我们的对话并越来越懂我，这样体验越来越好。
**Acceptance Criteria**:
- [ ] Given 我在对话中提到偏好（如"我喜欢简洁的回答"），当对话结束时，Then witmate 存储此偏好并在后续应用
- [ ] Given 我多次使用某 Skill，当达到阈值时，Then witmate 自动提升该 Skill 的推荐优先级
- [ ] Given 我纠正 witmate 的回答，当纠正发生时，Then witmate 学习并更新相关知识
- [ ] Given witmate 发现我的行为模式，当模式稳定时，Then 提炼为习惯规则

**Story 3.2**: 作为用户，我希望 witmate 有"做梦"机制定期整合和优化记忆，这样不会积累无用信息，系统持续进化。
**Acceptance Criteria**:
- [ ] Given 系统闲置超过 30 分钟，When 定时触发时，Then 自动启动 Dream 整合
- [ ] Given 每日凌晨（可配置），When 定时触发时，Then 自动启动 Dream 整合
- [ ] Given 用户运行 `witmate dream`，When 主动触发时，Then 立即执行整合并显示进度
- [ ] Given 记忆数量超过阈值（默认 500），When 条件触发时，Then 自动启动 Dream 整合
- [ ] Given Dream 运行中，When 整合过程时，Then 用户可查看实时进度（正在分析 X/Y 条记忆）
- [ ] Given 记忆中有过时信息，当 Dream 分析时，Then 标记或删除过时内容
- [ ] Given Dream 发现用户行为模式，当归纳时，Then 提炼为习惯规则并存储
- [ ] Given Dream 整合完成，当生成摘要时，Then 用户可查看整合报告：整合条数、清理条数、新发现模式、skill 优化建议

#### Epic 4: Web 界面

**Story 4.1**: 作为用户，我希望通过简洁的 Web 界面与 witmate 交互，这样我无需记忆复杂的命令。
**Acceptance Criteria**:
- [ ] Given 我打开 witmate Web，当页面加载时，Then 显示对话界面，包含输入框和历史记录
- [ ] Given 我输入消息并发送，当 witmate 响应时，Then 支持流式渲染 Markdown 内容
- [ ] Given 响应中包含代码块，当渲染时，Then 正确显示语法高亮

**Story 4.2**: 作为用户，我希望管理我的记忆文件，这样我能查看、编辑和删除记忆。
**Acceptance Criteria**:
- [ ] Given 我访问记忆管理界面，当页面加载时，Then 显示所有 qmd 记忆文件列表
- [ ] Given 我选择一个记忆文件，当我点击查看时，Then 显示文件内容
- [ ] Given 我希望编辑记忆，当我修改并保存时，Then 更新本地文件

#### Epic 5: CLI 工具

**Story 5.1**: 作为高级用户，我希望通过 CLI 快速与 witmate 交互，这样我能集成到我的工作流中。
**Acceptance Criteria**:
- [ ] Given 我在终端运行 `witmate chat`，当命令执行时，Then 进入交互式对话模式
- [ ] Given 我在对话中输入问题，当我按 Enter 时，Then witmate 响应并显示结果
- [ ] Given 我希望退出，当我输入 `exit` 时，Then 正常退出对话模式

**Story 5.2**: 作为用户，我希望通过 CLI 管理 witmate 服务，这样我无需手动启动服务器。
**Acceptance Criteria**:
- [ ] Given 我运行 `witmate start`，当命令执行时，Then 启动 witmate-server
- [ ] Given 我运行 `witmate stop`，当命令执行时，Then 停止 witmate-server
- [ ] Given 我运行 `witmate status`，当命令执行时，Then 显示服务状态和端口信息

---

## 4. Solution Overview

witmate 是一个本地优先的个人 Agent 协调器，通过统一入口管理多个专家 Agent，并通过本地 qmd 文件系统积累长期记忆。其核心价值在于：

1. **记忆系统**：本地存储所有对话上下文和用户知识，支持多层记忆结构（Working/Episodic/Semantic/Procedural），确保用户在不同会话间无缝切换。
2. **Agent 协调层**：作为中央协调器，理解用户意图，调用合适的专家 Agent（代码、写作、研究等），呈现统一的结果。
3. **自我进化机制**：通过隐式学习（从对话中提取知识）、显式记忆（用户手动添加）、反馈学习（用户纠正）、模式归纳（发现用户习惯），持续优化对用户的理解。

### 核心架构

witmate 采用 Server-Client 分层架构：

```
用户界面（CLI / Web / MCP Clients）
        ↓ HTTP 双向通信
    witmate Server（协调层 + 能力层 + 存储层）
        ↓
    LLM Providers + MCP Servers + 本地文件
```

**Monorepo 结构**:
- `witmate-server/`: 核心业务逻辑（MoonBit Native）
- `witmate-cli/`: 命令行工具（MoonBit Native + argparse）
- `witmate-web/`: Web 界面（Vue3，流式 Markdown 渲染）
- `skills/`: Skill 目录（YAML 格式）
- `mcp-config/`: MCP Server 配置文件

**详细架构设计**: 见 [系统设计文档](./system-design.md) 第 2 章。

### Key Design Decisions

**决策一：本地优先存储**
选择 qmd（Quarto Markdown）格式本地存储所有记忆，而非云端数据库。
- **理由**: 数据隐私保护、离线可用、用户完全控制、无需网络依赖
- **权衡**: 放弃云端同步和多设备访问的便利性，待后续市场验证
- **替代方案考虑**: 云端数据库（隐私风险高，用户信任成本高）

**决策二：Anthropic Messages API 兼容协议**
默认兼容 Anthropic Messages API，同时支持国产模型（Qwen/GLM/MiniMax）。
- **理由**: Claude 在复杂推理任务上表现优异，Anthropic Messages API 设计清晰，同时国产模型便于国内用户使用
- **权衡**: 需要适配不同模型的差异，增加开发成本
- **替代方案考虑**: 仅支持单一模型（灵活性不足）

**决策三：Skill & MCP 生态兼容**
witmate 作为 Agent 协调器，原生支持 Claude Code 的 Skill 和 MCP（Model Context Protocol）生态。
- **理由**:
  - Skill 生态提供了丰富的领域专家能力（代码、写作、PDF、前端等）
  - MCP 协议让 witmate 能连接外部工具和数据源（Chrome DevTools、Obsidian、文件系统等）
  - 用户可直接复用现有 skill/MCP，无需重新开发
  - witmate 可以动态发现、加载、组合 skill/MCP 能力
- **核心能力**:
  - Skill 注册与发现：witmate 维护 skill 目录，根据用户意图自动推荐/加载
  - MCP Server 管理：支持配置、启动、连接 MCP servers
  - Skill 组合编排：多个 skill 可串联协作（如 PDF skill + Translation skill）
- **权衡**: 需要设计 skill/MCP 接口层，增加架构复杂度
- **替代方案考虑**: 仅内置固定能力（无法扩展，无法复用生态）

**决策四：自我进化机制**
witmate 具备持续自我进化的能力，从用户交互中学习和优化。
- **进化维度**:
  - **记忆进化**: 从对话中提取知识，形成长期记忆（qmd 文件），越用越懂用户
  - **Skill 进化**: 发现用户常用 skill，自动优化 skill 推荐排序，甚至学习创建新 skill
  - **行为进化**: 学习用户偏好（模型选择、输出风格、交互模式），个性化适配
  - **能力进化**: Dream 整合机制定期优化记忆，删除过时信息，强化关键知识
- **触发机制**:
  - 隐式学习：对话结束后自动提取并存储关键信息
  - 显式记忆：用户说"记住这个"时立即存储
  - 反馈学习：用户纠正/不满意时更新知识
  - 模式归纳：发现用户重复行为模式后提炼为习惯
- **理由**: 让 witmate 成为"越来越懂你"的助手，而非固定不变的工具
- **权衡**: 进化算法需要精心设计，避免错误学习
- **替代方案考虑**: 无进化能力（用户每次使用体验相同）

**决策五：witmate 不做专业操作**
witmate 作为协调器，负责理解意图、分配任务、整合结果，不直接执行专业操作。
- **理由**: 遵循"单一职责"原则，专家 Agent/Skill 可独立优化，witmate 专注协调
- **权衡**: 需要维护多个 Agent/Skill 接口，系统复杂度增加
- **替代方案考虑**: witmate 内置所有能力（复杂度高，扩展性差）

**决策六：Phase 4 引入 Obsidian 插件**
Obsidian 插件在 Phase 4 开发，而非 MVP 阶段。
- **理由**: MVP 聚焦核心功能，Obsidian 用户群体需要单独验证，避免过早分散资源
- **权衡**: Obsidian 用户需等待更长时间，但能获得更成熟的集成方案
- **替代方案考虑**: MVP 即开发插件（资源分散，核心功能质量风险）

---

## 5. Technical Considerations

### Dependencies

| Dependency | Purpose | Owner | Timeline Risk |
|------------|---------|-------|---------------|
| MoonBit Native 核心库 | Server 和 CLI 运行时 | MoonBit Team | Low |
| @moonbitlang/core/argparse | CLI 参数解析 | MoonBit Team | Low |
| Vue3 + Vite | Web 前端框架 | Frontend Team | Low |
| Anthropic Messages API | LLM 接口协议 | Anthropic | Medium (API 变更风险) |
| Claude Code Skill 生态 | 领域专家能力 | Claude Code Community | Low (复用现有) |
| MCP Protocol | 外部工具连接协议 | Anthropic | Low (标准化协议) |
| 本地文件系统 | qmd 记忆存储 | OS | Low |

### 内置高频工具

witmate 内置以下高频使用工具：

| 工具 | 能力 | 说明 | 安全边界 |
|------|------|------|----------|
| `web_search` | 网络搜索 | 搜索网络获取实时信息 | 仅 HTTPS，域名白名单 |
| `file_ops` | 文件操作 | 读写编辑本地文件 | 仅指定目录 |
| `memory_ops` | 记忆管理 | qmd 记忆文件的 CRUD | 仅 memory 目录 |
| `code_execute` | 代码执行 | 沙箱环境执行代码 | WebAssembly 沙箱，超时 5s |
| `api_call` | API 调用 | HTTP 请求，连接外部服务 | 仅用户配置的 API，限流 |
| `clipboard_ops` | 剪贴板 | 读写剪贴板内容 | 仅文本，敏感信息过滤 |
| `notification_ops` | 通知 | 用户桌面通知 | 仅 witmate 内部触发 |

**扩展机制**：用户可通过 Skill/MCP 接口层扩展更多能力。

**工具调用层次**:
```
Skill/MCP → 调用内置工具 → 执行具体操作 → 返回结果
```

### Known Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| MoonBit 生态成熟度不足 | Medium | High | Phase 0 验证核心库稳定性，准备 Fallback 方案（Rust/Go） |
| LLM API 响应延迟 | Medium | Medium | 实现流式响应，优化超时处理，支持本地模型备用 |
| qmd 文件损坏/丢失 | Low | High | 实现自动备份机制，定期快照，提供恢复工具 |
| 多模型适配复杂度 | Medium | Medium | Phase 3 集中处理，设计统一适配层，优先支持 Claude |
| 用户记忆隐私泄露 | Low | Critical | 本地加密存储（可选），明确隐私政策，无云端上传 |
| Skill/MCP 调用安全 | Medium | High | 设计权限控制，安全审计，域名/目录白名单 |
| LLM Provider API 变更 | Medium | Medium | 设计 Provider 适配层，保持接口抽象，快速适配 |
| 本地资源消耗 | Low | Medium | 设计资源限制策略，用户可配置内存/CPU 阈值 |
| Dream 整合误删 | Medium | Medium | 删除前备份到 dream-backup，提供撤销功能 |
| Skill/MCP 生态依赖 | Low | Medium | 设计兼容性适配层，Skill/MCP 格式变更时快速适配 |

### Open Questions (Must Resolve Before Phase 2)

- [ ] MoonBit Native 是否支持稳定的多线程处理？Owner: Eng Lead | Deadline: Phase 0 结束
- [ ] MoonBit HTTP Server/SSE/定时任务能力验证？Owner: Eng Lead | Deadline: Phase 0 结束
- [ ] Skill 发现机制：Skill 文件格式解析流程？Owner: Server Team | Deadline: Phase 2 启动前
- [ ] MCP Server 管理方案：进程启动/监控/重启？Owner: Integration Team | Deadline: Phase 2 启动前
- [ ] 国产模型 API 兼容性测试（Qwen/GLM/MiniMax）？Owner: Integration Team | Deadline: Phase 3 启动前
- [ ] 自我进化算法简化：关键词提取方案验证？Owner: AI Team | Deadline: Phase 3 启动前
- [ ] code_execute 沙箱实现：WebAssembly 方案验证？Owner: Eng Lead | Deadline: Phase 3 启动前

---

## 6. Non-Functional Requirements

### Performance
- **响应时间**: 用户发送消息后，首个 token 响应时间 < 3s（网络正常情况下）
- **记忆检索**: 对于 1000 个记忆文件，检索响应时间 < 2s
- **Web 渲染**: Markdown 流式渲染流畅，无明显卡顿（支持 1000+ 行文档）
- **CLI 启动**: `witmate` 命令启动时间 < 500ms

### Scalability
- **记忆容量**: 支持至少 10,000 个 qmd 文件无性能降级
- **并发会话**: 支持单个用户同时开启 3 个独立会话（Phase 1-2 单会话）
- **Agent 扩展**: 架构支持新增专家 Agent，无需核心代码重构

### Reliability
- **服务可用性**: 本地服务可用性 > 99.5%（排除用户主动关闭）
- **数据持久性**: 本地记忆文件 99.99% 无丢失（通过自动备份保障）
- **错误恢复**: 遇到错误时，提供清晰的错误提示和恢复建议

### Security
- **本地存储**: 所有记忆文件本地存储，默认不上传云端
- **API 密钥管理**: 用户 API Key 加密存储在本地配置文件
- **隐私保护**: 用户对话内容仅发送至指定的 LLM 服务商，witmate 不额外上传

### Usability
- **学习成本**: 新用户 10 分钟内完成首次对话（有引导）
- **错误提示**: 所有错误提供用户友好的提示，非技术术语
- **文档完备**: 提供完整的使用文档、常见问题 FAQ、快速开始指南

### Maintainability
- **代码质量**: MoonBit 代码遵循官方风格指南，单元测试覆盖率 > 60%
- **日志记录**: 关键操作和错误记录日志，便于排查问题
- **版本管理**: 语义化版本控制（SemVer），清晰的变更日志

---

## 7. Interaction Design Highlights

### 7.1 对话流程

**首次使用引导**:
1. 用户启动 witmate（CLI 或 Web）
2. 显示欢迎信息："你好，我是 witmate。我会记住我们的每一次对话，越来越懂你。"
3. 询问用户基本信息（可选）："你想让我怎么称呼你？"
4. 进入主对话界面

**标准对话流程**:
1. 用户输入问题
2. witmate 分析意图：
   - 如果需要记忆检索，从本地 qmd 文件中提取相关上下文
   - 如果需要专家 Agent，调用对应 Agent
   - 如果是通用对话，直接响应
3. witmate 生成响应（流式显示）
4. 对话结束后，witmate 后台提取关键信息存储到 qmd 文件

**记忆管理流程**:
1. 用户进入记忆管理界面（Web 或 CLI 命令）
2. 查看所有记忆文件列表（按时间/标签/项目分类）
3. 点击文件查看详情
4. 支持编辑、删除、标记重要

### 7.2 Web UI 设计要点

**主对话界面**:
- 左侧：对话历史列表（按时间排序，支持搜索）
- 中间：当前对话窗口（流式 Markdown 渲染）
- 右侧：当前会话相关记忆文件预览（可选展开）
- 底部：输入框（支持 Markdown 预览、快捷键发送）

**Agent 协调可视化**:
- 当调用多个 Agent 时，显示协调流程图（简单动画）
- 点击 Agent 图标可查看该 Agent 的详细输出
- 支持折叠/展开协调详情

**记忆管理界面**:
- 列表视图：显示文件名、创建时间、标签、重要性
- 搜索功能：支持关键词搜索、标签过滤
- 详情视图：显示文件内容，支持编辑

### 7.3 CLI 交互设计

**命令结构**:
```bash
witmate [command] [options]

Commands:
  start       启动 witmate 服务
  stop        停止 witmate 服务
  status      查看服务状态
  chat        进入交互式对话模式
  dream       触发 Dream 整合（主动"做梦"）
  memory      记忆管理（list/view/edit/delete）
  skill       Skill 管理（list/enable/disable/info）
  mcp         MCP 管理（list/config/status）
  config      配置管理（API Key、模型选择、Dream 设置等）
  help        显示帮助信息
```

**交互式对话模式**:
- 进入后显示欢迎信息
- 用户输入以 `>` 开头，witmate 响应在下一行
- 支持多行输入（以空行结束）
- 快捷命令：`/exit` 退出，`/clear` 清屏，`/memory` 查看相关记忆

### 7.4 错误处理与提示

**API 错误**:
- 网络超时："抱歉，连接超时了。请检查网络后重试。"
- API 密钥无效："API 密钥无效，请运行 `witmate config` 重新设置。"

**记忆系统错误**:
- 文件损坏："发现损坏的记忆文件 [文件名]，已自动备份。是否尝试修复？"
- 存储空间不足："本地存储空间不足，请清理或移动记忆文件。"

**Agent 调用错误**:
- Agent 不可用："当前 [Agent 名称] 无法使用，我将尝试用其他方式帮助你。"
- 调用失败："调用 [Agent 名称] 时遇到问题，这是详细错误信息：..."

---

## 8. Acceptance Criteria (Phase-by-Phase)

### Phase 0 (技术栈验证) - 新增

**Scope**:
- MoonBit Native 核心能力验证（为期 1 周）
- 技术栈可行性确认

**验证项**:
- [ ] HTTP Server 实现：验证 MoonBit 是否有成熟的 HTTP server 库，能否实现 GET/POST 请求处理
- [ ] SSE (Server-Sent Events)：验证是否支持长连接和流式响应
- [ ] 多线程/并发：验证并发模型（Actor/async-await/线程池），能否处理并发任务
- [ ] 文件 I/O：验证 JSON/qmd 文件读写能力
- [ ] 定时任务：验证定时触发器实现（Dream 定时触发需要）
- [ ] HTTP Client：验证 LLM API 调用能力
- [ ] JSON 序列化：验证 JSON 解析和生成能力

**Acceptance Criteria**:
- [ ] Given 实现 HTTP Server，When 发送请求时，Then 能正确响应
- [ ] Given 实现 SSE，When 建立长连接时，Then 能流式推送数据
- [ ] Given 实现并发任务，When 多任务运行时，Then 能正确处理并发
- [ ] Given 验证失败任一核心能力，When 评估时，Then 立即切换到 Go/Rust 技术栈

**Success Gate**: 验证 MoonBit Native 具备 HTTP/SSE/并发/文件 I/O/定时任务能力；验证失败则切换技术栈

**技术栈备选方案**:
| 方案 | 优势 | 劣势 | 切换成本 |
|------|------|------|----------|
| Go | HTTP 生态成熟、简单易学 | GC 停顿可能影响长连接 | 1 周重写骨架 |
| Rust | 性能优异、生态成熟 | 学习曲线高 | 1-2 周重写骨架 |

---

### Phase 1 MVP (核心骨架)

**Scope**:
- MoonBit 项目初始化
- witmate-server 基础骨架
- Anthropic Messages API 协议层
- 基础 HTTP Server
- 单次会话对话循环

**Acceptance Criteria**:
- [ ] Given 运行 `moon check`，When 检查完成，Then 无错误
- [ ] Given 运行 `moon build`，When 构建完成，Then 生成可执行文件
- [ ] Given 运行 witmate-server，When 服务器启动，Then 监听指定端口（默认 3000）
- [ ] Given 发送 HTTP POST 请求至 `/chat`，When 请求有效，Then 返回 Claude 响应
- [ ] Given 单次会话对话，When 用户发送消息，Then 收到 Claude 的完整响应（非流式）

**Success Gate**: 能够在本地启动服务，完成一次完整的对话（用户输入 → Claude 响应 → 返回结果）

### Phase 2 (CLI + Web + Skill/MCP 骨架)

**Scope**:
- witmate-cli 接入 argparse
- witmate-web 骨架（Vue3）
- Server-Client 通信（HTTP 双向）
- Skill/MCP 接口层骨架
- Capability 抽象接口实现
- 记忆索引方案设计
- 基础 Skill 发现机制
- 至少调用 1 个 Skill 和 1 个 MCP（验证接口可行性）

**Acceptance Criteria**:
- [ ] Given 运行 `witmate start`，When 命令执行，Then 启动 witmate-server 并显示状态
- [ ] Given 运行 `witmate chat`，When 进入对话模式，Then 显示交互式提示符
- [ ] Given 在 CLI 中输入问题，When 按 Enter，Then 显示 Claude 响应
- [ ] Given 打开 witmate-web，When 页面加载，Then 显示对话界面
- [ ] Given 在 Web 中输入问题，When 发送，Then 显示 Claude 响应
- [ ] Given skills 目录中有 skill 文件，When witmate 启动时，Then 自动扫描并注册可用 skills
- [ ] Given 配置 MCP server，When witmate 启动时，Then 能连接并列出可用 MCP tools
- [ ] Given Capability 接口实现，When 调用 Skill 时，Then 正确执行并返回结果
- [ ] Given Capability 接口实现，When 调用 MCP 时，Then 正确执行并返回结果
- [ ] Given 记忆索引方案设计完成，When 文档评审时，Then 包含索引架构、更新策略、检索流程

**Success Gate**: CLI 和 Web 都能完成流式对话；Skill/MCP 基础框架可用；Capability 接口验证通过；记忆索引方案设计完成

**依赖阻塞**: Phase 0 验证 MoonBit 能力；Phase 1 完成 HTTP Server

### Phase 3 (记忆系统 + 多 Provider + Skill/MCP 路由 + 自我进化基础)

**Scope**:
- qmd 集成（本地文件读写）
- 记忆索引实现（内存索引 + 持久化）
- 多 Provider 兼容（Qwen/GLM/MiniMax）
- 文件系统交互
- Skill/MCP 智能路由（关键词匹配）
- 隐式学习机制（关键词提取，简化版）
- 显式记忆机制（用户主动"记住这个")
- 性能验证（1000 文件检索、并发写入、内存占用）

**Acceptance Criteria**:
- [ ] Given 对话结束，When witmate 分析对话，Then 生成 qmd 记忆文件
- [ ] Given 用户提问，When witmate 检索记忆，Then 引用相关 qmd 文件内容
- [ ] Given 配置 Qwen API，When 用户对话，Then 成功调用 Qwen 并响应
- [ ] Given 配置 GLM API，When 用户对话，Then 成功调用 GLM 并响应
- [ ] Given 1000 个 qmd 文件，When 检索，Then 响应时间 < 2s
- [ ] Given 用户提出代码问题，When witmate 分析意图，Then 自动路由到 code skill
- [ ] Given 用户提出 PDF 问题，When witmate 分析意图，Then 自动路由到 pdf skill
- [ ] Given 对话中用户表达偏好，When 对话结束，Then 自动提取关键词并存储
- [ ] Given 用户说"记住这个"，When 指令识别时，Then 立即存储用户指定内容
- [ ] Given 用户多次使用某 skill，When 使用次数超过阈值，Then 自动提升该 skill 优先级
- [ ] Given 并发写入测试，When 10 个会话同时存储记忆时，Then 无冲突无丢失
- [ ] Given 内存占用测试，When 10,000 文件索引加载时，Then 内存占用 < 100MB

**Success Gate**: 记忆系统能存储、检索和应用知识；多 Provider 兼容测试通过；Skill/MCP 智能路由可用；隐式学习启动；性能验证通过

**依赖阻塞**: Phase 2 完成记忆索引方案设计；Phase 2 完成 Capability 接口

### Phase 4 (Dream "做梦"机制 + 多 Skill 协调 + Obsidian 插件)

**Scope**:
- Dream 记忆整合机制（定时/主动/条件触发 + 异常处理）
- 多 Skill 协调框架
- Obsidian 插件（可选，可延期到 Phase 5）
- 反馈学习机制（用户纠正）
- 模式归纳（简化版：统计规则，如"最常用 Skill")
- 完整自我进化闭环

**Acceptance Criteria**:
- [ ] Given 达到定时触发条件（默认闲置 30 分钟或每日凌晨），When Dream 运行，Then 整合记忆并生成摘要
- [ ] Given 用户运行 `witmate dream`，When 主动触发时，Then 立即执行整合并显示进度
- [ ] Given 记忆数量超过阈值（如 500 条），When 条件触发时，Then 自动启动 Dream 整合
- [ ] Given Dream 运行中，When 整合过程时，Then 用户可查看实时进度和状态
- [ ] Given Dream 整合完成，When 生成报告时，Then 显示：整合条数、清理条数、新发现模式、优化项
- [ ] Given Dream 遇到损坏文件，When 异常处理时，Then 备份原文件并继续处理其他文件
- [ ] Given Dream 删除记忆，When 删除时，Then 先备份到 dream-backup 目录
- [ ] Given 用户纠正 witmate 回答，When 反馈时，Then 更新相关知识
- [ ] Given 用户提出代码问题，When witmate 分析，Then 调用代码 Skill 并返回结果
- [ ] Given 用户提出写作问题，When witmate 分析，Then 调用写作 Skill 并返回结果
- [ ] Given 用户提出涉及多个 Skill 的需求，When witmate 分析，Then 协调多个 Skill 协作
- [ ] Given 统计用户 Skill 使用频率，When 归纳时，Then 生成"最常用 Skill"报告
- [ ] Given 用户在 Obsidian 中安装插件，When 插件启用，Then 能调用 witmate 服务
- [ ] Given 在 Obsidian 中选中文字，When 运行 witmate 命令，Then 发送至 witmate 并显示响应

**Success Gate**: Dream 定时/主动/条件触发均可用；异常处理正确；整合报告清晰；多 Skill 协调稳定运行；Obsidian 插件可用；自我进化闭环完成

**依赖阻塞**: Phase 3 完成记忆索引实现；Phase 3 完成隐式学习

**备注**: Obsidian 插件开发独立于核心功能，可作为并行项目或延期到 Phase 5

---

## 9. Risk Assessment

### High Priority Risks

**Risk 1: MoonBit 生态成熟度不足**
- **Description**: MoonBit 为新兴语言，生态库可能不够成熟，影响开发效率和稳定性
- **Likelihood**: Medium (40%)
- **Impact**: High (可能需要切换技术栈，延迟 2-3 个月)
- **Mitigation**:
  - Phase 1 充分验证核心库稳定性
  - 准备 Fallback 方案（Rust 或 Go）
  - 与 MoonBit 团队保持沟通，及时反馈问题
- **Contingency**: 如 Phase 1 发现严重问题，立即评估切换方案

**Risk 2: 用户隐私泄露**
- **Description**: 记忆文件包含敏感信息，本地存储仍存在泄露风险（如设备被盗）
- **Likelihood**: Low (10%)
- **Impact**: Critical (用户信任崩塌，产品失败)
- **Mitigation**:
  - 提供可选的本地加密功能
  - 明确隐私政策，告知用户存储位置和风险
  - 不上传任何用户数据到 witmate 服务器
- **Contingency**: 如发生泄露事件，立即通知用户，提供补救措施

**Risk 3: 多模型适配复杂度超预期**
- **Description**: 国产模型 API 差异较大，适配工作可能超出预估
- **Likelihood**: Medium (30%)
- **Impact**: Medium (延迟 Phase 3，影响多模型支持)
- **Mitigation**:
  - Phase 1 优先验证 Anthropic API
  - Phase 3 集中 1-2 周进行多模型适配测试
  - 设计统一适配层，降低耦合度
- **Contingency**: 如适配困难，先支持单一模型（Claude），后续迭代增加

### Medium Priority Risks

**Risk 4: 用户学习成本高**
- **Description**: 普通用户不理解 Agent 协调概念，使用门槛高
- **Likelihood**: Medium (35%)
- **Impact**: Medium (用户流失，留存率低)
- **Mitigation**:
  - 首次使用提供引导流程
  - 简化交互，隐藏技术细节
  - 提供丰富的示例和文档
- **Contingency**: 如发现用户理解困难，增加交互式教程

**Risk 5: 记忆系统性能瓶颈**
- **Description**: qmd 文件数量增长后，检索性能下降
- **Likelihood**: Medium (25%)
- **Impact**: Medium (用户体验差，响应慢)
- **Mitigation**:
  - Phase 3 性能测试，模拟 10,000 个文件
  - 设计轻量级索引方案
  - 提供记忆归档功能
- **Contingency**: 如性能不达标，引入嵌入式数据库（SQLite）

### Low Priority Risks

**Risk 6: Obsidian 插件审核延迟**
- **Description**: Obsidian 插件发布需审核，可能延迟
- **Likelihood**: Low (15%)
- **Impact**: Low (Phase 4 部分功能延迟，不影响核心功能)
- **Mitigation**:
  - 提前了解 Obsidian 插件审核流程
  - 准备完整的插件文档和代码
- **Contingency**: 如审核延迟，先发布 GitHub Release，引导用户手动安装

---

## 10. Launch Plan

### Phase 0 Launch (技术栈验证)
**Target Date**: Phase 1 启动前 1 周
**Audience**: 内部开发团队
**Success Gate**:
- MoonBit HTTP/SSE/并发/文件 I/O/定时任务验证通过
- 或技术栈切换决策完成（Go/Rust）

### Phase 1 MVP Launch (Internal Alpha)
**Target Date**: Phase 1 结束后 1 周
**Audience**: 内部团队 + 5 名早期用户
**Success Gate**:
- 无 P0 级 Bug
- 核心对话功能完整
- 单次会话体验流畅

### Phase 2 Launch (Closed Beta)
**Target Date**: Phase 2 结束后 2 周
**Audience**: 50 名申请用户（来自社区、技术爱好者）
**Success Gate**:
- 错误率 < 5%
- 用户满意度 ≥ 4.0/5.0
- CLI 和 Web 功能稳定

### Phase 3 Launch (Open Beta)
**Target Date**: Phase 3 结束后 2 周
**Audience**: 公开测试，所有感兴趣用户
**Success Gate**:
- 记忆系统稳定运行
- 多 Provider 兼容性验证通过
- 7 日留存率 ≥ 40%

### Phase 4 Launch (General Availability)
**Target Date**: Phase 4 结束后 2 周
**Audience**: 全量用户
**Rollout Strategy**: 分阶段开放（20% → 50% → 100%，每阶段 1 周）
**Success Gate**:
- Dream 整合功能稳定
- 多 Agent 协调无阻塞问题
- Obsidian 插件可用

**Rollback Criteria**: 如果错误率 > 5% 或用户满意度 < 3.5/5.0，立即回滚至上一阶段并修复问题。

---

## 11. Appendix

### A. Competitive Analysis

| Product | Strengths | Weaknesses | Differentiation from witmate |
|---------|-----------|------------|----------------------------|
| Claude Code | 强大的代码能力，上下文窗口大 | 垂直代码场景，普通用户难用 | witmate 面向通用场景，更低门槛 |
| ChatGPT | 广泛使用，生态丰富 | 无本地记忆，隐私风险 | witmate 本地记忆，隐私保护 |
| Obsidian + AI 插件 | 本地优先，知识管理强 | AI 能力有限，无 Agent 协调 | witmate 专注 AI 协调，记忆积累 |
| Cursor | 代码编辑器集成 AI | 仅限代码场景 | witmate 通用场景 |

### B. User Research Summary

**Interviews** (n=12):
- 关键发现 1："我有 5 个不同的 AI 工具，每个都要重新解释背景" — 出现频率 75%
- 关键发现 2："我希望能有一个真正记住我的 AI" — 出现频率 67%
- 关键发现 3："我对云端存储隐私有顾虑" — 出现频率 58%

---

**Document History**:
- v1.0 (2026-04-19): Initial PRD creation
- v1.1 (2026-04-19): 架构专家评审后修复
  - 增加 Phase 0 技术栈验证
  - 简化架构描述，引用 Design 文档
  - 删除重复技术细节（Capability 接口代码、索引格式、Dream 流程图）
  - 补充风险评估（Skill/MCP 安全、API 变更、资源消耗、Dream 误删、生态依赖）
  - 更新 Phase 2-4 验收标准和依赖阻塞点

---

**Approval Sign-off**:
- [ ] Engineering Lead: _______________ Date: _______
- [ ] Design Lead: _______________ Date: _______
- [ ] Product Manager: _______________ Date: _______
- [ ] Stakeholder: _______________ Date: _______
