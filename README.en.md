# AgentKit

A framework that gives AI agents **persistent memory**, **knowledge accumulation**, and **engineering discipline** across development sessions. Built for Claude Code.

[中文文档](./README.md)

## The Problem

When using Claude Code for project development, you hit the same pain points repeatedly:

1. **Memory loss** — Each new session, the agent forgets where it left off and what pitfalls it encountered
2. **Knowledge decay** — API quirks, debugging tricks, and key links get buried in chat history
3. **Framework coupling** — Engineering rules and project config are tangled together; switching projects means rewriting everything

AgentKit solves this with three-layer separation: reusable framework, independent project config, and continuously growing knowledge.

## Project Structure

```
agentkit/
├── install.sh               One-click install (auto-config + symlink)
├── FRAMEWORK.md           ← Layer A: Engineering constitution (shared across projects)
├── WORKFLOW.md               Work cadence (TDD → memory → commit)
│
├── commands/
│   └── agentkit-init.md     /agentkit-init guided deployment command
│
└── template/              ← Layer B+C: Project template (deployed to target project)
    ├── CLAUDE.md              Entry point (CHECKPOINT + rules + pointers)
    ├── project.config.yml     Project variables (commands/links/success criteria)
    └── memory/
        ├── PROJECT.md         Goals / constraints / acceptance criteria
        ├── STATE.md           Current state (present only)
        ├── TASK.md            Next thin slice
        ├── LOG.md             Append-only log
        └── KNOWLEDGE/      ← Layer C: Project knowledge base (grows over time)
            ├── INDEX.md       Keyword index
            ├── DOCS.md        External doc links
            ├── GOTCHAS.md     Pitfalls / gotchas
            ├── RECIPES.md     How-to recipes
            └── DECISIONS.md   Key decision records
```

### Layer Responsibilities

| Layer | Location | Change Frequency | On Migration |
|---|---|---|---|
| **A. Framework** | agentkit repo | Rarely changes | Shared across all projects |
| **B. Project** | Target project root | Set once at init | Edit `project.config.yml` + `PROJECT.md` |
| **C. Knowledge** | Target project `memory/KNOWLEDGE/` | Continuously growing | Start fresh |

## Core Mechanisms

### CHECKPOINT — Background Agent Updates Memory

After completing each step, the main agent dispatches a background agent to update memory files:

```
Code change done → Dispatch background agent → Update STATE/LOG/TASK/KNOWLEDGE → git commit
```

- Runs in background, doesn't interrupt main workflow
- One checkpoint per step, no batching
- Code and memory files committed separately

### Skill Handoff Rule

When a Claude Code Skill (custom command) takes over the workflow, CHECKPOINT must still be executed after the Skill completes. Memory updates are never skipped due to Skill handoff.

### Work Cadence

```
Start → Read memory (restore context) → Execute loop → CHECKPOINT → Next step
```

The execution loop follows TDD:

```
Clarify → Test → Implement → Refactor → Write Memory → Commit
```

## Installation

```bash
git clone https://github.com/tensam/agentkit.git ~/project/agentkit
cd ~/project/agentkit && ./install.sh
```

The install script automatically:
- Writes agentkit path to `~/.config/agentkit/config` (auto-read by skill at runtime, no manual path config needed)
- Creates symlink at `~/.claude/commands/agentkit-init.md` (points to repo file, `git pull` to sync updates)

After installation, open Claude Code in any project directory to use `/agentkit-init`.

## Usage

### Deploy AgentKit to a New Project

```bash
# 1. Enter your project directory
cd ~/project/my-new-project

# 2. Launch Claude Code
claude

# 3. Run the deployment command (two modes)
/agentkit-init                          # Guided mode: Claude asks what the project does
/agentkit-init Python CLI expense tool   # Quick mode: pass description directly
```

Claude will automatically:

1. Scan the directory (existing code is analyzed automatically)
2. Read templates and intelligently populate all files
3. Initialize git + `.gitignore` + first commit
4. Output deployment checklist + first task

### Development Workflow

The agent reads `CLAUDE.md` on every startup, restores context, and enters the standard workflow. Knowledge is automatically categorized:

| Discovery | Written To |
|-----------|-----------|
| API quirks / pitfalls | `GOTCHAS.md` |
| Useful doc links | `DOCS.md` |
| Step-by-step recipes | `RECIPES.md` |
| Architecture decisions | `DECISIONS.md` |
| All keyword indexes | `INDEX.md` |

### Cross-Session Recovery

On new session startup, the agent reads `STATE.md` + `TASK.md` to restore progress, checks `INDEX.md` for existing knowledge, and avoids repeating past mistakes.

## Design Principles

- **Framework contains no business terms** — FRAMEWORK.md has zero project-specific vocabulary, zero changes when switching projects
- **Centralized config** — `project.config.yml` is the single source, ready for hooks/scripts
- **Knowledge is the project's second brain** — KNOWLEDGE grows independently, never pollutes STATE or CLAUDE.md
- **Thin-slice methodology** — One thing at a time, update state when done, then move on

## Recommended Companion

Works great with [Superpowers](https://github.com/jlowin/superpowers) for TDD, plan execution, code review, and full engineering discipline support.
