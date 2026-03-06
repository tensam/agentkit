# CLAUDE.md

## Mandatory Workflow

- Before any work: read memory/PROJECT.md, memory/STATE.md, memory/TASK.md, memory/LOG.md
- Also consult memory/KNOWLEDGE/INDEX.md for project-specific tips/links.
- Follow TDD: tests first → minimal implementation → refactor → write memory.
- 完成每个步骤后，直接用 Edit/Write 工具更新 memory 文件（不是在聊天里打印文本）。
- 记忆写入的触发时机和具体规则见 WORKFLOW.md「记忆写入规则」。

## Knowledge Capture Rule

当发现任何"以后会再用到的技巧/坑/链接"，必须写入 memory/KNOWLEDGE/ 对应文件，并在 INDEX.md 增加一条索引。

## Project Config

- See project.config.yml for commands, entry points, and success criteria.

## Reusable Framework

- Follow engineering rules in agentkit/FRAMEWORK.md
- Follow work cadence in agentkit/WORKFLOW.md

## Project-Specific Rules

<!-- 在此添加本项目特有的规则，不属于通用框架的部分 -->
<!-- 例如：特定 API 约束、业务语义守护、研究方法论等 -->
