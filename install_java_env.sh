#!/bin/bash

# 脚本名称: install_java_env.sh
# 用途: 初始化 Java 开发环境（OpenJDK 11、17 和 Maven）

set -euo pipefail
export SHELL_CONFIG="${SHELL_CONFIG:-$HOME/.zshrc}"
export GREEN="${GREEN:-\033[0;32m}"
export RED="${RED:-\033[0;31m}"
export NC="${NC:-\033[0m}"

echo -e "${GREEN}开始 Java 环境初始化...${NC}"

############################
# 1. Homebrew 环境修复加载
############################

# 自动识别 ARM / Intel 的 Homebrew 路径
if [ -d "/opt/homebrew/bin" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
elif [ -d "/usr/local/bin" ]; then
    HOMEBREW_PREFIX="/usr/local"
else
    echo -e "${RED}未找到 Homebrew，请先安装 Homebrew${NC}"
    exit 1
fi

# 避免 brew 命令找不到
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

##################################
# 2. 安装 JDK / jenv / Maven
##################################

FORMULAS=(openjdk@11 openjdk@17 jenv maven)

for pkg in "${FORMULAS[@]}"; do
    if ! brew list --formula "$pkg" &>/dev/null; then
        echo "安装 $pkg..."
        brew install "$pkg" || {
            echo -e "${RED}$pkg 安装失败${NC}"
            exit 1
        }
    else
        echo "$pkg 已安装"
    fi
done

##################################
# 3. 配置 jenv 环境变量
##################################

if ! grep -q 'jenv init' "$SHELL_CONFIG"; then
    echo "写入 jenv 环境变量到 $SHELL_CONFIG ..."
    {
        echo ''
        echo '# jenv config'
        echo 'export PATH="$HOME/.jenv/bin:$PATH"'
        echo 'eval "$(jenv init -)"'
    } >> "$SHELL_CONFIG"
fi

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

##################################
# 4. 将已安装的 JDK 添加到 jenv
##################################

echo "检测 Homebrew 中已安装的 JDK 版本..."

declare -a JDK_DIRS

# 获取所有 openjdk* 前缀的 JDK 名称
BREW_JDKS=($(brew list --formula | grep "^openjdk"))

# 遍历每个 JDK 并添加到 jenv 中
for jdk in "${BREW_JDKS[@]}"; do
    JDK_HOME="$(brew --prefix "$jdk")/libexec/openjdk.jdk/Contents/Home"

    if [ ! -d "$JDK_HOME" ]; then
        echo -e "${RED}未找到 $jdk 的 JDK_HOME，跳过...${NC}"
        continue
    fi

    echo "发现 JDK：$jdk → $JDK_HOME"
    jenv add "$JDK_HOME" || true
done

##################################
# 5. 设置全局 Java 版本（可自行调整）
##################################

echo "可用 JDK 版本："
jenv versions

echo -e "${GREEN}Java 环境初始化完成！${NC}"
echo "使用以下命令切换 JDK 版本："
echo "  jenv global 11"
echo "  jenv global 17"