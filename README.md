# AgentKit

让 AI Agent 在项目开发中拥有**长期记忆**、**经验沉淀**和**工程纪律**的框架。

## 为什么做这个

用 Claude Code 做项目开发时，反复遇到几个问题：

1. **记忆断裂** — 每次新会话，agent 不记得上次做到哪、踩过什么坑
2. **经验丢失** — 开发中发现的 API 怪癖、调试技巧、关键链接，散落在聊天记录里，下次找不到
3. **框架耦合** — 工程规则（TDD、变更控制）和项目配置混在一起，换个项目又要重写一遍

AgentKit 用三层分离解决这些问题：框架复用、项目配置独立、经验持续积累。

## 三层结构

```
agentkit/
│
├── FRAMEWORK.md              ← Layer A: 框架层（跨项目复用）
├── WORKFLOW.md                  工程宪法 + 工作节拍
│                                不含任何项目特定词汇
│
├── template/                 ← Layer B: 项目模板（复制即用）
│   ├── CLAUDE.md                入口文件（规则 + 指针）
│   ├── project.config.yml       项目变量（命令/链接/验收标准）
│   └── memory/
│       ├── PROJECT.md           目标 / 约束 / 验收标准
│       ├── STATE.md             当前状态（只写"现在"）
│       ├── TASK.md              下一步薄切片
│       ├── LOG.md               追加日志（不删改历史）
│       └── KNOWLEDGE/        ← Layer C: 项目经验库（越积越多）
│           ├── INDEX.md         关键词索引（让 agent 快速命中）
│           ├── DOCS.md          外部文档链接
│           ├── GOTCHAS.md       坑点 / 踩雷记录
│           ├── RECIPES.md       操作配方（how-to）
│           └── DECISIONS.md     关键决策（为什么这样做）
```

### 各层职责

| 层 | 改动频率 | 内容 | 迁移时 |
|---|---|---|---|
| **A. Framework** | 几乎不变 | TDD、变更控制、DoD、分层纪律、经验沉淀规则 | 直接复用 |
| **B. Project** | 项目初始化时改一次 | 目标、命令、链接、验收标准 | 改 `project.config.yml` + `PROJECT.md` |
| **C. Knowledge** | 持续增长 | 坑点、配方、决策、外部链接 | 从空开始积累 |

## 使用方法

### 1. 一键初始化（推荐）

在目标项目目录下打开 Claude Code，输入：

```
/agentkit-init 这个项目做什么、技术栈、目标...
```

示例：
```
/agentkit-init 微信自动化，读群聊、读收藏文章，暴露为 MCP 供其他项目调用
/agentkit-init Python CLI 记账工具，解析招行/支付宝/微信 CSV，自动分类生成报表
/agentkit-init React + Node 电商后台，管理商品和订单
```

Claude 会自动：复制模板 → 扫描已有代码 → 智能填充所有文件 → 输出确认清单。

### 2. 手动初始化

```bash
# 复制模板到目标项目
cp -r /path/to/agentkit/template/* /path/to/your-project/

# 手动编辑项目配置
vim project.config.yml
vim memory/PROJECT.md
```

### 3. 开发过程

agent 启动时自动读取 CLAUDE.md，进入标准工作流：

```
读取 memory → 了解状态 → 执行任务 → 更新 STATE + LOG → 沉淀经验到 KNOWLEDGE
```

经验自动分类沉淀：
- API 怪癖 → `GOTCHAS.md`
- 有用文档 → `DOCS.md`
- 操作步骤 → `RECIPES.md`
- 架构决策 → `DECISIONS.md`
- 所有索引 → `INDEX.md`

### 4. 跨会话恢复

新会话启动时，agent 读取 `STATE.md` + `TASK.md` 恢复进度，查 `INDEX.md` 找已有经验，避免重复踩坑。

## 设计原则

- **框架不含业务词** — FRAMEWORK.md 不含任何项目特定词汇，换项目零修改
- **配置集中管理** — `project.config.yml` 一处改，未来可接 hook/脚本自动读取
- **经验是项目的第二大脑** — KNOWLEDGE 不污染 STATE，不污染 CLAUDE.md，独立增长
- **薄切片工作法** — 每次只做一件事，做完更新状态，再做下一件
