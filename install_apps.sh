#!/bin/bash

# 安装常用工具
# 1.检查并安装 google-chrome wechat tencent-meeting
for package in google-chrome wechat tencent-meeting; do
    if ! brew list --cask $package &>/dev/null; then
        echo "$package is not installed. Installing $package..."
        brew install $package
    else
        echo "$package is already installed."
    fi
done