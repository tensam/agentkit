明白了：你要的是三层结构，而不是“一个 CLAUDE.md + memory/ 四件套”那么简单。

你要同时满足：
 1. 跨项目复用的固定框架（团队宪法/工作流/TDD/产物要求）
 2. 单项目的配置与目标（这个项目的约束、命令、链接、架构特性）
 3. 单项目的“沉淀经验/技巧/外部文档索引”（过程中不断增长的、可查询的知识库）

这三层拆清楚，系统才会既工程化又不会乱。

下面给你一个直接可落地的结构（先用 A，不上 hook 也能稳定；未来上 team/hook 也天然兼容）。

⸻

1) 三层文件体系：Framework / Project / Project-Knowledge

A. Framework（跨项目复用，不随项目变）

放在一个你自己的模板仓库或 agentkit/ 目录里：

agentkit/
  FRAMEWORK.md          # 团队宪法：TDD、变更控制、输出格式、分层纪律
  WORKFLOW.md           # 工作节拍：plan->test->impl->refactor->update memory
  TEMPLATES/
    CLAUDE.md           # 通用入口（只含规则+指针）
    project.config.yml  # 项目变量模板
    memory/...

核心点：Framework 永远不写“果仁/guorn”这种业务词。

⸻

B. Project（单项目配置：目标/约束/命令/链接）

放在项目 repo 根目录：

project.config.yml
CLAUDE.md
memory/
  PROJECT.md
  STATE.md
  TASK.md
  LOG.md

 • CLAUDE.md：只负责引用框架 + 指向本项目的 memory 文件
 • project.config.yml：本项目变量（命令、关键入口、验收标准摘要、外部链接入口）

⸻

C. Project-Knowledge（单项目经验库：会越积越多）

这个就是你说的“过程中沉淀的经验、技巧、需要记住的查询链接”，专门给该项目用。

建议放：

memory/KNOWLEDGE/
  INDEX.md              # 索引（目录+关键字）
  DOCS.md               # 外部文档链接/查询入口（可分主题）
  GOTCHAS.md            # 坑点/怪癖/踩雷记录（最有价值）
  RECIPES.md            # 操作配方（怎么抓包、怎么刷新cookie、怎么重放等）
  DECISIONS.md          # 关键决策（为什么这样做）

这层的价值：你不用把“经验”塞进 PROJECT/STATE，也不用污染 CLAUDE.md。
它是项目的“第二大脑”。

⸻

1) 各文件应该写什么（防止混乱）

CLAUDE.md（入口，只写“必须做什么”，短）

它只做两件事：
 1. 强制工作流（先读哪些文件、TDD、产物格式）
 2. 指针（框架在哪里、本项目知识库在哪里）

示例（你可直接用）：

# CLAUDE.md

## Mandatory Workflow

- Before any work: read memory/PROJECT.md, memory/STATE.md, memory/TASK.md, memory/LOG.md
- Also consult memory/KNOWLEDGE/INDEX.md for project-specific tips/links.
- Follow TDD: tests first → minimal implementation → refactor → update memory.
- After each task output:
  ===STATE_UPDATE=== (full STATE.md)
  ===LOG_UPDATE=== (append-only entry)

## Project Config

- See project.config.yml for commands, entry points, and success criteria.

## Reusable Framework

- Follow engineering rules in agentkit/FRAMEWORK.md (if present) or the template rules above.

（你如果把 agentkit 做成独立仓库，也可以在这里写“框架规则见链接/子模块”）

⸻

PROJECT.md（只放“目标/约束/验收标准”，稳定）

不要放经验，不要放过程。

⸻

STATE/TASK/LOG（项目运行状态）
 • STATE：只写“现在”
 • TASK：下一步薄切片
 • LOG：追加记录（谁做了什么、为什么）

⸻

KNOWLEDGE/GOTCHAS/RECIPES（沉淀经验）

这就是你要的“专门记录本项目经验的地方”。

GOTCHAS.md 适合记录
 • guorn 返回 text/plain 导致 JSON parse 特别处理
 • _xsrf 必须拼在 URL query
 • 某 endpoint 字段偶尔缺失/类型漂移
 • CDP 抓包时某些请求被缓存导致漏抓

DOCS.md 适合记录
 • “这个项目独有必须查的外部文档链接”
 • 哪个页面解释了某字段、某策略语义、某因子定义
 • 你要复现策略的原帖链接（果仁帖子）

RECIPES.md 适合记录
 • 如何刷新登录 session/cookie
 • 如何跑一次 e2e backtest
 • 如何抓 factor IDs
 • 如何更新 capture fixtures

INDEX.md 适合记录
 • 一页目录 + 关键词索引（让 agent 很快命中）
例如：
 • Auth / XSRF → GOTCHAS#auth
 • Content-type → GOTCHAS#content-type
 • CDP capture → RECIPES#capture
 • Strategy source links → DOCS#sources

⸻

1) 关键机制：让 Claude “知道该把经验写去哪”

你需要一句硬规则（写进 CLAUDE.md）：

当发现任何“以后会再用到的技巧/坑/链接”，必须写入 memory/KNOWLEDGE/ 对应文件，并在 INDEX.md 增加一条索引。

这是把“沉淀”变成流程的一部分。

⸻

1) 你担心的例子：开发中发现要查某个 web 文档

按这套体系，它应该这样做：
 1. 把链接记录到 memory/KNOWLEDGE/DOCS.md（按主题分类）
 2. 在 INDEX.md 增加关键词索引（比如 “factor definition”, “strategy rule format”）
 3. 在 LOG 里记录 “Added docs link for X”

这样下次任何 agent 接手，都能通过 INDEX 快速找到。

⸻

1) 你马上可以做的最小落地（不需要 hooks）

今天你只要做三件事：
 1. 新建 memory/KNOWLEDGE/ 和 5 个文件（INDEX/DOCS/GOTCHAS/RECIPES/DECISIONS）
 2. 在 CLAUDE.md 加一条“发现经验必须沉淀到 KNOWLEDGE 并更新 INDEX”
 3. 把你已知的几条 guorn 特性（text/plain、_xsrf、CDP抓包）立刻写进 GOTCHAS + INDEX

这就完成了你想要的“项目独有经验库”。

⸻

1) 你要的“可复用固定框架”怎么迁移？

以后新项目迁移就是：
 • 复制 agentkit/template 到新 repo
 • 改 project.config.yml + memory/PROJECT.md
 • KNOWLEDGE 从空开始积累

框架不会被 guorn 污染，复用性就有了。

⸻
