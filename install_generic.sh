#!/bin/bash

# 脚本名称: install_generic.sh
# 用途: 配置 macOS 系统优化设置并安装基础工具（Homebrew、Git 等）

echo -e "${GREEN}开始 macOS 优化配置和基础工具安装...${NC}"

# Finder 设置
if ! defaults read com.apple.finder _FXShowPosixPathInTitle &>/dev/null; then
    echo "配置 Finder 显示 POSIX 路径..."
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
    defaults write com.apple.finder ShowPathbar -bool true      # 显示路径栏
    defaults write com.apple.finder AppleShowAllFiles -bool true # 显示隐藏文件
    killall Finder
else
    echo "Finder 已优化"
fi

# Dock 设置
if ! defaults read com.apple.dock autohide-time-modifier | grep -q "0.3" &>/dev/null; then
    echo "配置 Dock 动画和延迟..."
    defaults write com.apple.dock autohide-delay -float 0           # 移除 Dock 延迟
    killall Dock
else
    echo "Dock 已优化"
fi

# 安装 Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "安装 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
        echo -e "${RED}Oh My Zsh 安装失败${NC}"
        exit 1
    }
fi

# 安装 zsh 插件
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/$plugin" ]; then
        echo "安装 $plugin..."
        git clone "https://github.com/zsh-users/$plugin" "$HOME/.oh-my-zsh/custom/plugins/$plugin"
    fi
done

# 配置 .zshrc 文件启用插件，替换现有 plugins 配置
if grep -q "plugins=" "$SHELL_CONFIG"; then
    echo "替换 .zshrc 中的 plugins 配置..."
    sed -i '' 's/plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$SHELL_CONFIG"
else
    echo "新增 .zshrc 中的 plugins 配置..."
    echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> "$SHELL_CONFIG"
fi

# 检查并安装 Homebrew
if ! command -v brew &>/dev/null; then
    echo "安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        echo -e "${RED}Homebrew 安装失败${NC}"
        exit 1
    }
else
    echo "Homebrew 已安装"
fi

# 安装 Git
if ! brew list --formula git &>/dev/null; then
    echo "安装 Git..."
    brew install git || { echo -e "${RED}Git 安装失败${NC}"; exit 1; }
else
    echo "Git 已安装"
fi

echo -e "${GREEN}macOS 优化配置和基础工具安装完成${NC}"