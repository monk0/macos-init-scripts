#!/bin/bash

# 安装 Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# 安装 zsh 插件：zsh-autosuggestions 和 zsh-syntax-highlighting
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/$plugin" ]; then
        echo "Installing $plugin..."
        git clone "https://github.com/zsh-users/$plugin" "$HOME/.oh-my-zsh/custom/plugins/$plugin"
    else
        echo "$plugin is already installed."
    fi
done

# 配置 .zshrc 文件启用插件
echo "Configuring zsh plugins in .zshrc..."
sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# 检查并安装 Homebrew
if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# 检查并安装 git openjdk@11 openjdk@17
for package in git openjdk@11 openjdk@17; do
    if ! brew list --formula $package &>/dev/null; then
        echo "$package is not installed. Installing $package..."
        brew install $package
    else
        echo "$package is already installed."
    fi
done

# 向 .zshrc 添加 JDK 切换 alias
echo "Adding JDK version switch aliases to .zshrc..."
echo 'alias jdk-11="export JAVA_HOME=`/usr/libexec/java_home -v 11`;java -version"' >> ~/.zshrc
echo 'alias jdk-17="export JAVA_HOME=`/usr/libexec/java_home -v 17`;java -version"' >> ~/.zshrc


# 检查并安装 iTerm2,Google-Chrome,Visual-studio-code
for package in iterm2 google-chrome; do
    if ! brew list --cask $package &>/dev/null; then
        echo "$package is not installed. Installing $package..."
        brew install $package
    else
        echo "$package is already installed."
    fi
done

# 提示用户完成安装
echo "Environment setup complete! Please restart your terminal."
