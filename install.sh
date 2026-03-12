#!/bin/bash
# AgentKit 安装脚本
# 自动配置路径 + 创建 symlink，无需手动编辑

set -e

AGENTKIT_ROOT="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config/agentkit"
CONFIG_FILE="$CONFIG_DIR/config"
COMMANDS_DIR="$HOME/.claude/commands"

echo "AgentKit 安装"
echo "============="
echo ""
echo "检测到 AgentKit 路径: $AGENTKIT_ROOT"
echo ""

# 1. 写入 config
mkdir -p "$CONFIG_DIR"
cat > "$CONFIG_FILE" <<EOF
AGENTKIT_ROOT=$AGENTKIT_ROOT
REGISTRY=$HOME/project/REGISTRY.md
EOF

echo "[OK] 配置已写入 $CONFIG_FILE"

# 2. 创建 symlink
mkdir -p "$COMMANDS_DIR"
LINK="$COMMANDS_DIR/agentkit-init.md"

if [ -L "$LINK" ]; then
    rm "$LINK"
    echo "[OK] 已移除旧 symlink"
elif [ -f "$LINK" ]; then
    mv "$LINK" "$LINK.bak"
    echo "[OK] 已备份旧文件为 agentkit-init.md.bak"
fi

ln -s "$AGENTKIT_ROOT/commands/agentkit-init.md" "$LINK"
echo "[OK] Symlink 已创建: $LINK -> commands/agentkit-init.md"

echo ""
echo "安装完成! 在任意项目目录打开 Claude Code，输入 /agentkit-init 即可使用。"
echo ""
echo "如需修改项目注册表路径，编辑: $CONFIG_FILE"
