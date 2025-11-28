#!/bin/bash

# 脚本名称: install_apps.sh
# 用途: 安装常用软件
set -euo pipefail

export SHELL_CONFIG="${SHELL_CONFIG:-$HOME/.zshrc}"
export GREEN="${GREEN:-\033[0;32m}"
export RED="${RED:-\033[0;31m}"
export NC="${NC:-\033[0m}"

echo -e "${GREEN}开始安装常用软件...${NC}"

#################################
# 1. 确保 Homebrew 可用
#################################
if ! command -v brew &>/dev/null; then
    # 自动检测 ARM / Intel Homebrew 路径
    if [ -d "/opt/homebrew/bin" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    else
        echo -e "${RED}错误：未检测到 Homebrew，请先安装 Homebrew${NC}"
        exit 1
    fi
fi

#################################
# 2. Cask 软件列表
#################################
CASKS=(
    google-chrome
    wechat
    tencent-meeting
    microsoft-office
    notion
    visual-studio-code
    drawio
    podman-desktop
    dbeaver-community
    redis-insight
    apipost
)

#################################
# 3. 安装 Cask 应用（更稳健）
#################################
for package in "${CASKS[@]}"; do
    if brew list --cask | grep -q "^${package}$"; then
        echo "$package 已安装"
        continue
    fi

    echo "安装 $package..."
    if ! brew install --cask "$package"; then
        echo -e "${RED}警告: $package 安装失败，请稍后重试${NC}"
    fi
done

echo -e "${GREEN}常用软件安装完成${NC}"