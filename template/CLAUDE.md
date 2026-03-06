# CLAUDE.md

## ⚠️ CHECKPOINT — 每完成一步必须执行（不可跳过）

**完成任何代码修改、调试、或决策后，立即执行以下动作，再做下一步：**

1. `memory/STATE.md` → 覆盖为当前状态
2. `memory/LOG.md` → 追加一条记录
3. `memory/TASK.md` → 勾选已完成的步骤
4. 如发现坑点/技巧 → 写入 `memory/KNOWLEDGE/*.md` + `INDEX.md`
5. `git add` 代码 + memory → `git commit`

**用 Edit/Write 工具直接修改文件。说"我会更新"但没有实际写入 = 违规。**

---

## Mandatory Workflow

- Before any work: read memory/PROJECT.md, memory/STATE.md, memory/TASK.md, memory/LOG.md
- Also consult memory/KNOWLEDGE/INDEX.md for project-specific tips/links.
- Follow TDD: tests first → minimal implementation → refactor → checkpoint.
- 会话即将结束时：确保 STATE.md + LOG.md 已写入并 commit。

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
