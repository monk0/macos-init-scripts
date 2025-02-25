#!/bin/bash

# 脚本名称: setup_macos.sh
# 用途: 主调度脚本，用于按顺序执行 macOS 初始化子脚本
# 作者: monk0
# 日期: 2025-02-24

# 设置脚本遇到错误时退出
set -e

# 定义全局变量
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export NC='\033[0m'
export SHELL_CONFIG="$HOME/.zshrc"  # 默认使用 zsh，可改为 ~/.bashrc

# 子脚本列表
SCRIPTS=(install_generic.sh install_java_env.sh install_python_env.sh install_apps.sh)

# 检查并赋予子脚本执行权限
for script in "${SCRIPTS[@]}"; do
    [ -f "$script" ] && chmod +x "$script" || { echo -e "${RED}错误: $script 不存在${NC}"; exit 1; }
done

# 按顺序执行子脚本
echo -e "${GREEN}开始 macOS 初始化...${NC}"
./install_generic.sh
./install_java_env.sh
./install_python_env.sh
./install_apps.sh

echo -e "${GREEN}所有环境配置完成！${NC}"
echo "请重启终端以确保设置生效"