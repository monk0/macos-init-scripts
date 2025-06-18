#!/bin/bash

# 脚本名称: install_java_env.sh
# 用途: 初始化 Java 开发环境（OpenJDK 11、17 和 Maven）

echo -e "${GREEN}开始 Java 环境初始化...${NC}"

# 安装 OpenJDK 11、OpenJDK 17 、Jenv 、 Maven
FORMULAS=(openjdk@11 openjdk@17 jenv maven)
for package in "${FORMULAS[@]}"; do
    if ! brew list --formula "$package" &>/dev/null; then
        echo "安装 $package..."
        brew install "$package" || { echo -e "${RED}$package 安装失败${NC}"; exit 1; }
    fi
done

if ! grep -q "jenv config" "$SHELL_CONFIG"; then
    echo "配置 jenv 环境变量..."
    echo -e "\n# jenv config" >> "$SHELL_CONFIG"
    echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> "$SHELL_CONFIG"
    echo 'eval "$(jenv init -)"' >> "$SHELL_CONFIG"

    export PATH="$HOME/.jenv/bin:$PATH" 
    eval "$(jenv init -)"
fi

JDKS=($(brew list | grep ^openjdk))
for jdk in "${JDKS[@]}"; do
    JDK_PATH=$(brew --prefix "$jdk")/libexec/openjdk.jdk/Contents/Home
    if [ "openjdk" = "$jdk" ]; then
        JAVA_VERSION="latest"
    else
        JAVA_VERSION=${jdk#openjdk@}
    fi

    jenv add $(/usr/libexec/java_home -v $JAVA_VERSION)  
done

echo -e "${GREEN}Java 环境初始化完成${NC}"
echo "在命令行切换 JDK 版本"