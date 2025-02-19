#!/bin/bash

# 检查并安装 git maven openjdk@11 openjdk@17
for package in git maven openjdk@11 openjdk@17; do
    if ! brew list --formula $package &>/dev/null; then
        echo "$package is not installed. Installing $package..."
        brew install $package
    else
        echo "$package is already installed."
    fi
done

# 向 .zshrc 添加 JDK 切换 alias 先判断是否已添加相同别名
echo "Adding JDK version switch aliases to .zshrc..."
if grep -q "jdk-11" ~/.zshrc; then
    echo "JDK version switch aliases are already added to .zshrc."
else
    echo 'alias jdk-11="export JAVA_HOME=`/usr/libexec/java_home -v 11`;java -version"' >> ~/.zshrc
fi

if grep -q "jdk-17" ~/.zshrc; then
    echo "JDK version switch aliases are already added to .zshrc."
else
    echo 'alias jdk-17="export JAVA_HOME=`/usr/libexec/java_home -v 17`;java -version"' >> ~/.zshrc
fi

# 检查并安装 iTerm2,Visual-studio-code
for package in iterm2 visual-studio-code; do
    if ! brew list --cask $package &>/dev/null; then
        echo "$package is not installed. Installing $package..."
        brew install $package
    else
        echo "$package is already installed."
    fi
done