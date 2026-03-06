# WORKFLOW.md — 工作节拍（跨项目复用）

> 定义 agent 的标准工作循环。所有项目共用。

---

## 启动阶段（每次新会话 / 新任务开始前）

```
1. 读取 memory/PROJECT.md  → 了解目标 & 约束
2. 读取 memory/STATE.md    → 了解当前进展
3. 读取 memory/TASK.md     → 了解下一步
4. 读取 memory/LOG.md      → 了解历史上下文
5. 查阅 memory/KNOWLEDGE/INDEX.md → 查找相关经验/链接
```

---

## 执行循环（每个薄切片）

```
Clarify → Test → Implement → Refactor → Write Memory
```

1. **Clarify** — 明确目标行为（1-3 bullet points）
2. **Test First** — 先写/更新测试
3. **Implement** — 最小代码通过测试
4. **Refactor** — 测试全绿后才重构（提取复用）
5. **Write Memory** — 写入文件（见下方触发规则）

---

## 记忆写入规则

### 触发时机（何时写）

| 事件 | 写什么 | 动作 |
|------|--------|------|
| **完成 TASK.md 中的一个步骤** | STATE.md + LOG.md + TASK.md | 覆盖 STATE，追加 LOG，勾选 TASK 步骤 |
| **发现坑点/技巧/有用链接** | KNOWLEDGE/*.md + INDEX.md | 立即写入对应文件 + 添加索引 |
| **做出技术决策** | DECISIONS.md + INDEX.md | 记录背景/选项/结论 |
| **任务受阻** | TASK.md | 记录阻塞原因和替代方案 |
| **当前任务全部完成** | STATE.md + TASK.md + LOG.md | STATE 移入已完成，TASK 清空或写下一个 |
| **用户说"先到这"/ 会话即将结束** | STATE.md + LOG.md | 确保当前进度已持久化 |

### 写入方式（怎么写）

**直接用 Edit/Write 工具修改文件，不是在聊天里打印文本。**

```
STATE.md  → 覆盖更新（只保留"现在"的状态）
LOG.md    → 追加条目（不删改历史）
TASK.md   → 覆盖更新（反映当前步骤进展）
KNOWLEDGE/*.md → 追加新条目（用 ## 锚点标题）
INDEX.md  → 追加索引行（关键词 → 文件#锚点）
```

### 写入节奏

- **不要攒着写** — 完成一步就写一步，别等做完三步再批量更新
- **不要只说不写** — 禁止"我会更新 STATE.md"然后没有实际写入动作
- **不确定要不要记？记** — KNOWLEDGE 宁多勿少，INDEX 成本很低

---

## 偏差处理

- 实现偏离预期行为 → **停下来，先解释偏差再继续**
- 发现经验/坑/有用链接 → 立即写入 KNOWLEDGE + 更新 INDEX（不等任务结束）
- 任务受阻 → 记录阻塞原因到 TASK.md，尝试替代方案

---

## 任务粒度

- 每次只做一个**薄切片**（最小可验证增量）
- 避免一次性大改动
- 每步完成后写入 STATE，再开始下一步

---

*AgentKit Workflow v1.1 | clarify→test→impl→refactor→write memory*
