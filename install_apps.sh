#!/bin/bash

# 脚本名称: install_apps.sh
# 用途: 安装常用软件

echo -e "${GREEN}开始安装常用软件...${NC}"

# 安装 cask 应用
CASKS=(google-chrome wechat tencent-meeting microsoft-office visual-studio-code drawio)
for package in "${CASKS[@]}"; do
    if ! brew list --cask "$package" &>/dev/null; then
        echo "安装 $package..."
        brew install --cask "$package" || echo -e "${RED}警告: $package 安装失败${NC}"
    else
        echo "$package 已安装"
    fi
done

echo -e "${GREEN}常用软件安装完成${NC}"