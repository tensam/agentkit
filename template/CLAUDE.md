# CLAUDE.md

## Mandatory Workflow

- Before any work: read memory/PROJECT.md, memory/STATE.md, memory/TASK.md, memory/LOG.md
- Also consult memory/KNOWLEDGE/INDEX.md for project-specific tips/links.
- Follow TDD: tests first → minimal implementation → refactor → write memory.

## Memory Write Rules（必须内化，不可遗忘）

**用 Edit/Write 工具直接修改文件，不是在聊天里打印文本。**

### 何时写

| 事件 | 写什么 |
| ---- | ------ |
| 完成一个步骤 | STATE.md（覆盖）+ LOG.md（追加）+ TASK.md（勾选） |
| 发现坑点/技巧 | KNOWLEDGE/*.md + INDEX.md |
| 做出技术决策 | DECISIONS.md + INDEX.md |
| 任务全部完成 | STATE.md + TASK.md + LOG.md |
| 会话即将结束 | STATE.md + LOG.md（确保进度已持久化） |

### 纪律

- **完成一步写一步** — 不攒着批量写
- **不说不写** — 禁止"我会更新 STATE.md"然后没有实际写入
- **不确定要不要记？记** — KNOWLEDGE 宁多勿少

### Git 提交

- 每个薄切片完成后：代码 + memory 一起 commit
- 纯 memory 更新：memory 文件单独 commit
- 会话结束前：确保所有 memory 变更已 commit
- commit message 格式：`类型: 简要描述`（feat/fix/refactor/test/docs/memory/init）

## Knowledge Capture Rule

当发现任何"以后会再用到的技巧/坑/链接"，必须写入 memory/KNOWLEDGE/ 对应文件，并在 INDEX.md 增加一条索引。

## Project Config

- See project.config.yml for commands, entry points, and success criteria.

## Reusable Framework

- Follow engineering rules in ~/project/agentkit/FRAMEWORK.md
- Follow work cadence in ~/project/agentkit/WORKFLOW.md

## Project-Specific Rules

<!-- 在此添加本项目特有的规则，不属于通用框架的部分 -->
<!-- 例如：特定 API 约束、业务语义守护、研究方法论等 -->
