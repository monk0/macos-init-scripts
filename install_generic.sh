#!/bin/bash

# Finder 设置
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
#defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
killall Finder

# 1.安装 Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# 2.安装 zsh 插件：zsh-autosuggestions 和 zsh-syntax-highlighting
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/$plugin" ]; then
        echo "Installing $plugin..."
        git clone "https://github.com/zsh-users/$plugin" "$HOME/.oh-my-zsh/custom/plugins/$plugin"
    else
        echo "$plugin is already installed."
    fi
done

# 2.1配置 .zshrc 文件启用插件
echo "Configuring zsh plugins in .zshrc..."
sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# 3.检查并安装 Homebrew
if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi
