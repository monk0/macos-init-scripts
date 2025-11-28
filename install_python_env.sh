#!/bin/bash

# 脚本名称: install_python_env.sh
# 用途: 初始化 Python 开发环境
set -euo pipefail

export SHELL_CONFIG="${SHELL_CONFIG:-$HOME/.zshrc}"
export GREEN="${GREEN:-\033[0;32m}"
export RED="${RED:-\033[0;31m}"
export NC="${NC:-\033[0m}"

echo -e "${GREEN}开始安装 Python 环境（Miniforge + Conda）...${NC}"

# ============================================================
# 1. 安装 Miniforge（如果未安装）
# ============================================================
if brew list --cask miniforge >/dev/null 2>&1; then
    echo "Miniforge 已通过 Homebrew 安装"
else
    echo "安装 Miniforge..."
    brew install --cask miniforge || {
        echo -e "${RED}Miniforge 安装失败${NC}"
        exit 1
    }
fi

# ============================================================
# 2. 检查 conda 是否存在
# ============================================================
if ! command -v conda >/dev/null 2>&1; then
    echo -e "${RED} 未检测到 conda 命令${NC}"
    echo "可能需要重新打开终端以加载 Miniforge 的 PATH"
    exit 1
fi

# ============================================================
# 3. 判断当前 conda 是否为 Miniforge 发行版
# ============================================================
CONDA_INFO=$(conda info 2>/dev/null || true)

if ! echo "$CONDA_INFO" | grep -q "miniforge"; then
    echo -e "${RED} 检测到 conda 不是 Miniforge 发行版${NC}"
    echo "请确保系统中只存在 Miniforge 的 conda，并移除其他发行版（如 Anaconda、Miniconda）。"
    exit 1
fi

echo "已确认：当前 conda 为 Miniforge 发行版"

# ============================================================
# 4. 初始化 conda（使用默认 shell=zsh）
# ============================================================
if ! grep -q "conda initialize" "$SHELL_CONFIG"; then
    echo "→ 执行 conda init zsh..."
    conda init zsh
    echo "已在 $SHELL_CONFIG 添加 conda 初始化配置"
else
    echo "$SHELL_CONFIG 中已存在 conda 初始化配置，跳过"
fi

echo ""
echo -e "${GREEN}Python 环境初始化完成！${NC}"
echo "请重启终端使 conda 生效 或运行：source $SHELL_CONFIG"