# Flare

**自我进化的个人 Agent 协调器**

Flare 是一个本地优先的个人 Agent 协调器，通过统一入口管理多个专家 Agent/Skill，并通过本地 qmd 文件系统积累长期记忆。

---

## 核心特性

- **记忆系统**: 本地存储所有对话上下文和用户知识，支持多层记忆结构
- **Agent 协调**: 理解用户意图，调用合适的专家 Agent（代码、写作、研究等）
- **自我进化**: 从用户交互中持续学习和优化，越来越懂你
- **本地优先**: 所有数据本地存储，用户完全控制，隐私保护

---

## 项目状态

**当前 Phase**: Phase 0 (技术栈验证)

| Phase | 状态 | 时间 |
|-------|------|------|
| Phase 0 - 技术栈验证 | 🔄 进行中 | Week 1 |
| Phase 1 - MVP 骨架 | ⏳ 待启动 | Week 2-4 |
| Phase 3A - 记忆系统 | ⏳ 待启动 | Week 9-12 |
| Phase 3B - 自我进化 | ⏳ 待启动 | Week 13-16 |
| Phase 4 - Dream+ 多 Skill | ⏳ 待启动 | Week 17-22 |

---

## 快速开始

> **注意**: 项目正在开发中，以下命令将在 Phase 1 完成后可用。

```bash
# 启动服务
flare start

# 进入对话
flare chat

# 触发 Dream 整合
flare dream

# 查看服务状态
flare status
```

---

## 项目结构

```
flare/
├── server/              # flare-server (MoonBit Native)
│   ├── src/
│   │   ├── main.moon
│   │   ├── config.moon
│   │   ├── server.moon
│   │   ├── api/
│   │   ├── capability/
│   │   ├── memory/
│   │   ├── dream/
│   │   └── learning/
│   └── moon.pkg.json
├── cli/                 # flare-cli (MoonBit Native)
├── web/                 # flare-web (Vue3)
├── poc/                 # Phase 0 技术验证
│   ├── http-server/
│   ├── http-client/
│   ├── json-test/
│   ├── file-io/
│   ├── concurrency/
│   └── timer-test/
├── specs/               # 规格文档
│   ├── prd.md           # 产品需求文档
│   ├── system-design.md # 系统设计文档
│   └── plan.md          # 开发计划
└── docs/                # 项目文档
```

---

## 技术栈

| 组件 | 技术 |
|------|------|
| 后端 | MoonBit Native (Phase 0 验证中) |
| 前端 | Vue3 + Vite |
| CLI | MoonBit Native + argparse |
| 存储 | 本地 qmd 文件 + JSON 索引 |
| LLM | Anthropic Claude (默认), Qwen, GLM |

**备选方案**: 如 MoonBit 验证失败，切换到 Go 或 Rust

---

## 文档

- [产品需求文档 (PRD)](specs/prd.md)
- [系统设计文档](specs/system-design.md)
- [开发计划](specs/plan.md)

---

## 开发

### 前置条件

- MoonBit CLI (安装指南：https://www.moonbitlang.com)
- Node.js 18+ (用于 Web 前端)

### 构建

```bash
# 构建 server
cd server && moon build

# 构建 CLI
cd cli && moon build

# 构建 Web
cd web && npm install && npm run build
```

### 测试

```bash
# 运行测试
moon test
```

---

## 架构决策记录 (ADR)

| ADR | 标题 | 状态 |
|-----|------|------|
| ADR-001 | Phase 0 技术栈验证优先 | Accepted |
| ADR-002 | Skill/MCP 统一 Capability 抽象 | Accepted |
| ADR-003 | 记忆系统内存索引 (含备选方案) | Accepted |
| ADR-004 | 本地优先存储 | Accepted |
| ADR-005 | HTTP 双向通信 (废弃 SSE) | Accepted |
| ADR-006 | Dream Engine 分阶段实现 | Accepted |

---

## 许可证

MIT License

---

**Status**: 🚧 开发中
