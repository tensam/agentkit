# /agentkit-init — AgentKit 一键部署（引导式）

在当前项目目录部署 AgentKit 框架模板，通过交互引导收集项目信息。

**前置条件**: 用户已创建好项目目录并在该目录下打开 Claude。

输入: $ARGUMENTS（可选，如果提供则跳过引导直接执行）

## 用法

```
/agentkit-init                    ← 引导模式，询问项目描述
/agentkit-init 微信自动化，读群聊  ← 快速模式，直接执行
```

## 核心路径

```
AGENTKIT_ROOT = <你的 agentkit 克隆路径，如 ~/project/agentkit>
TEMPLATE_DIR  = $AGENTKIT_ROOT/template/
FRAMEWORK     = $AGENTKIT_ROOT/FRAMEWORK.md
WORKFLOW      = $AGENTKIT_ROOT/WORKFLOW.md
REGISTRY      = <你的项目注册表路径，如 ~/project/REGISTRY.md>
```

> **安装后必须**：将上面的 `AGENTKIT_ROOT` 和 `REGISTRY` 改为你的实际绝对路径。

## 执行步骤

### 步骤 1: 询问项目描述（引导）

**如果 $ARGUMENTS 已提供 → 跳过此步。**

**用 AskUserQuestion 工具询问用户：**

问题："这个项目要做什么？（描述功能、技术栈、目标）"

用户自由输入，将回答作为 `$ARGUMENTS` 使用。

### 步骤 2: 环境检查

- `$CWD` 即为目标项目目录（**不创建目录、不切换目录**）
- 检查是否已有 AgentKit 文件（CLAUDE.md / memory/ / project.config.yml）
  - 如已存在 → 提醒用户，询问是覆盖还是跳过
- 检查目录中是否有已有代码/文档（README.md, *.py, *.ts, package.json, pyproject.toml 等）
  - 如有 → 后续用于智能填充 KNOWLEDGE

### 步骤 3: 读取模板（动态发现）

**先读取模板目录，了解当前模板包含哪些文件和格式:**

1. `ls -R $TEMPLATE_DIR` → 发现所有模板文件
2. 逐个读取每个模板文件 → 理解其用途、段落结构、占位符格式
3. 读取 `$FRAMEWORK` 和 `$WORKFLOW` → 了解框架层规则

这一步确保: **模板增删文件、修改格式后，命令自动适应。**

### 步骤 4: 解析项目信息

从 `$ARGUMENTS` 中提取:
- **项目名**: 简短英文标识（如 wechat-agent, expense-cli）
- **一句话描述**: 中文
- **技术栈**: 语言 + 框架 + 关键依赖
- **核心功能**: 拆成 2-5 个能力点
- **产物形态**: CLI / API / MCP / Library / Web App 等

### 步骤 5: Git 初始化

- 检查当前目录是否已是 git 仓库（`git rev-parse --is-inside-work-tree`）
  - 如果不是 → `git init && git branch -M main`
  - 如果已是 → 跳过
- 检查是否有 .gitignore，没有则创建基础版本（根据技术栈）

### 步骤 6: 创建目录结构

**不复制模板文件**（避免 Write 工具对已有文件要求先 Read 的限制）。只创建目录：

```bash
mkdir -p memory/KNOWLEDGE strategies
```

步骤 8 会用 Write 工具直接创建所有文件。

### 步骤 7: 扫描已有代码（如果有的话）

如果目录中已有代码:
- 读 README.md / pyproject.toml / package.json → 提取项目元信息
- 读主要源码文件 → 理解已有架构
- 读已有文档/注释 → 提取已知坑点和决策
- 用提取的信息补充 KNOWLEDGE 文件

### 步骤 8: 智能填充所有文件

**用 Write 工具逐个创建文件（文件尚不存在，无需先 Read）。根据步骤 3 读到的模板结构填充。填充原则：**

- **保留模板中的标准段落**（如 Mandatory Workflow、Knowledge Capture Rule）
- **替换占位符/注释**（`<!-- ... -->` 部分）为实际内容
- **CLAUDE.md 特殊处理**:
  - 将 `{{AGENTKIT_PATH}}` 替换为 `$AGENTKIT_ROOT` 的实际绝对路径
  - 添加 Project-Specific Rules（3-5 条纪律性规则，只写"必须/禁止"级别）
- **project.config.yml**: 根据技术栈推断 commands / entry_points / dependencies 合理默认值
- **memory/*.md**: 从 $ARGUMENTS 提取目标、约束、成功标准；STATE 写"已部署"初始状态
- **KNOWLEDGE/**: 如果扫描到已有代码 → 从中提取；空项目 → 保留模板注释不编造
- **INDEX.md**: 为所有填入的内容建立关键词索引

### 步骤 9: 初始提交

```bash
git add CLAUDE.md project.config.yml memory/
git commit -m "init: AgentKit 框架部署"
```

### 步骤 10: 注册项目

在项目注册表 `$REGISTRY` 中追加一条记录：

```
| 项目名 | $CWD | 一句话简介 | 当前日期 |
```

- 项目名、简介从步骤 4 提取的信息中获取
- 路径使用 `$CWD` 绝对路径
- 日期格式：`YYYY-MM-DD`
- 如果该路径已存在于注册表中 → 更新该行而非重复追加
- 如果 `$REGISTRY` 文件不存在 → 创建并写入表头

### 步骤 11: 输出确认

完成后输出:
- 已部署的文件清单（动态列出，不硬编码）
- 每个文件的简要说明（填了几条规则/几条索引）
- 第一个待办任务

## 注意事项

- **不创建项目目录** — 用户自己建好目录后进来执行
- 不要在 CLAUDE.md 里写大段说明，只写规则 + 指针
- KNOWLEDGE 文件宁可留空也不编造内容
- Framework/Workflow 路径使用绝对路径
- 如果用户后续补充信息，更新对应文件即可
- **模板变更自动同步**: 步骤 3 动态读取模板，新增/删除/修改的模板文件会自动被发现和处理
