# AgentKit

让 AI Agent 在项目开发中拥有**长期记忆**、**经验沉淀**和**工程纪律**的框架。专为 Claude Code 设计。

## 解决什么问题

用 Claude Code 做项目开发时，反复遇到几个痛点：

1. **记忆断裂** — 每次新会话，agent 不记得上次做到哪、踩过什么坑
2. **经验丢失** — 开发中发现的 API 怪癖、调试技巧、关键链接，散落在聊天记录里
3. **框架耦合** — 工程规则和项目配置混在一起，换个项目又要重写一遍

AgentKit 用三层分离解决：框架跨项目复用、项目配置独立、经验持续积累。

## 项目结构

```
agentkit/
├── install.sh               一键安装（自动配路径 + symlink）
├── FRAMEWORK.md           ← Layer A: 工程宪法（跨项目复用）
├── WORKFLOW.md               工作节拍（TDD → 记忆 → 提交）
│
├── commands/
│   └── agentkit-init.md     /agentkit-init 引导式部署命令
│
└── template/              ← Layer B+C: 项目模板（部署到目标项目）
    ├── CLAUDE.md              入口文件（CHECKPOINT + 规则 + 指针）
    ├── project.config.yml     项目变量（命令/链接/验收标准）
    └── memory/
        ├── PROJECT.md         目标 / 约束 / 验收标准
        ├── STATE.md           当前状态（只写"现在"）
        ├── TASK.md            下一步薄切片
        ├── LOG.md             追加日志（不删改历史）
        └── KNOWLEDGE/      ← Layer C: 项目经验库（越积越多）
            ├── INDEX.md       关键词索引
            ├── DOCS.md        外部文档链接
            ├── GOTCHAS.md     坑点 / 踩雷记录
            ├── RECIPES.md     操作配方（how-to）
            └── DECISIONS.md   关键决策记录
```

### 各层职责

| 层 | 位置 | 改动频率 | 迁移时 |
|---|---|---|---|
| **A. Framework** | agentkit 仓库 | 几乎不变 | 所有项目共享，无需复制 |
| **B. Project** | 目标项目根目录 | 初始化时配一次 | 改 `project.config.yml` + `PROJECT.md` |
| **C. Knowledge** | 目标项目 `memory/KNOWLEDGE/` | 持续增长 | 从空开始积累 |

## 核心机制

### CHECKPOINT — 后台 agent 更新记忆

每完成一步工作，主 agent 派出后台 agent 更新 memory 文件：

```
完成代码修改 → 派后台 agent → 更新 STATE/LOG/TASK/KNOWLEDGE → git commit
```

- 后台执行，不打断主工作流
- 完成一步派一次，不攒着批量写
- 代码文件和 memory 文件分开提交

### Skill 接管规则

当 Claude Code 的 Skill（自定义命令）接管工作流时，Skill 执行完毕后仍需执行 CHECKPOINT，不因 Skill 接管而跳过 memory 更新。

### 工作节拍

```
启动 → 读取 memory（恢复上下文）→ 执行循环 → CHECKPOINT → 下一步
```

执行循环遵循 TDD：

```
Clarify → Test → Implement → Refactor → Write Memory → Commit
```

## 安装

```bash
git clone https://github.com/tensam/agentkit.git ~/project/agentkit
cd ~/project/agentkit && ./install.sh
```

安装脚本会自动完成：
- 将 agentkit 路径写入 `~/.config/agentkit/config`（skill 运行时自动读取，无需手动配路径）
- 创建 symlink `~/.claude/commands/agentkit-init.md`（指向仓库文件，`git pull` 即可同步更新）

安装完成后，在任意项目目录打开 Claude Code 即可使用 `/agentkit-init`。

## 使用方法

### 为新项目部署 AgentKit

```bash
# 1. 进入你的项目目录
cd ~/project/my-new-project

# 2. 启动 Claude Code
claude

# 3. 输入部署命令（两种模式）
/agentkit-init                      # 引导模式：Claude 会问你项目做什么
/agentkit-init Python CLI 记账工具    # 快速模式：直接传入描述，跳过询问
```

Claude 会根据你的描述自动完成：

1. 扫描目录（已有代码会自动提取信息）
2. 读取模板，智能填充所有文件
3. 初始化 git + `.gitignore` + 首次提交
4. 输出部署清单 + 第一个待办任务

### 开发过程

agent 每次启动自动读取 `CLAUDE.md`，恢复上下文后进入标准工作流。经验自动分类沉淀：

| 发现内容 | 写入位置 |
|---------|---------|
| API 怪癖 / 踩雷 | `GOTCHAS.md` |
| 有用的文档链接 | `DOCS.md` |
| 操作步骤 / 配方 | `RECIPES.md` |
| 架构决策及原因 | `DECISIONS.md` |
| 所有关键词索引 | `INDEX.md` |

### 跨会话恢复

新会话启动时，agent 读取 `STATE.md` + `TASK.md` 恢复进度，查 `INDEX.md` 找已有经验，避免重复踩坑。

## 设计原则

- **框架不含业务词** — FRAMEWORK.md 不含任何项目特定词汇，换项目零修改
- **配置集中管理** — `project.config.yml` 一处改，未来可接 hook/脚本自动读取
- **经验是项目的第二大脑** — KNOWLEDGE 独立增长，不污染 STATE 和 CLAUDE.md
- **薄切片工作法** — 每次只做一件事，做完更新状态，再做下一件

## 推荐搭配

推荐配合 [Superpowers](https://github.com/jlowin/superpowers) 共同使用，获得 TDD、计划执行、代码审查等完整的工程纪律支持。
