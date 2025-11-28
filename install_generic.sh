#!/bin/bash

# 脚本名称: install_generic.sh
# 用途: 配置 macOS 系统优化设置并安装基础工具（Homebrew、Git 等）

set -euo pipefail

# 颜色变量
export GREEN="${GREEN:-\033[0;32m}"
export RED="${RED:-\033[0;31m}"
export NC="${NC:-\033[0m}"

# 自动检测 shell 配置文件
export SHELL_CONFIG="${SHELL_CONFIG:-$HOME/.zshrc}"

echo -e "${GREEN}开始执行 macOS 基础环境配置...${NC}"

# =============================
# 1. Finder 配置
# =============================
echo "配置 Finder..."

# 显示路径与隐藏文件（检查是否已经设置）
POSIX_PATH_SETTING=$(defaults read com.apple.finder _FXShowPosixPathInTitle 2>/dev/null || echo "0")
if [[ "$POSIX_PATH_SETTING" != "1" ]]; then
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder AppleShowAllFiles -bool true
    killall Finder || true
    echo "Finder 设置已更新"
else
    echo "Finder 已是期望配置"
fi


# =============================
# 2. Dock 优化配置
# =============================
echo "配置 Dock..."

DOCK_DELAY=$(defaults read com.apple.dock autohide-delay 2>/dev/null || echo "0.5")
if [[ "$DOCK_DELAY" != "0" ]]; then
    defaults write com.apple.dock autohide-delay -float 0
    killall Dock || true
    echo "Dock 设置已更新"
else
    echo "Dock 已是期望配置"
fi


# =============================
# 3. 安装 Oh My Zsh（非交互模式）
# =============================
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "安装 Oh My Zsh..."
    export RUNZSH=no
    export CHSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        || { echo -e "${RED}Oh My Zsh 安装失败${NC}"; exit 1; }
else
    echo "Oh My Zsh 已存在"
fi


# =============================
# 4. 安装 Zsh 插件（自动补全 + 语法高亮）
# =============================
echo "安装 Zsh 插件..."

PLUGIN_DIR="$HOME/.oh-my-zsh/custom/plugins"

declare -a plugins=(
  "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
  "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting"
)

for entry in "${plugins[@]}"; do
    name="${entry%%:*}"
    repo="${entry##*:}"
    if [[ ! -d "$PLUGIN_DIR/$name" ]]; then
        echo "安装插件: $name"
        git clone "$repo" "$PLUGIN_DIR/$name"
    else
        echo "插件 $name 已存在"
    fi
done


# =============================
# 5. 安全更新 .zshrc 中的 plugins 配置
# =============================
echo "更新 $SHELL_CONFIG 中的插件列表..."

if ! grep -q "zsh-autosuggestions" "$SHELL_CONFIG"; then
    echo "" >> "$SHELL_CONFIG"
    echo "# Added by macOS setup script" >> "$SHELL_CONFIG"
    echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> "$SHELL_CONFIG"
    echo "插件配置已写入 .zshrc"
else
    echo "插件已配置，无需变更"
fi


# =============================
# 6. Homebrew 安装
# =============================
echo "检查 Homebrew..."

if ! command -v brew &>/dev/null; then
    echo "安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
        || { echo -e "${RED}Homebrew 安装失败${NC}"; exit 1; }
else
    echo "Homebrew 已安装"
fi


# =============================
# 7. 添加 Homebrew 到 PATH（兼容 Intel / ARM）
# =============================
if ! command -v brew &>/dev/null; then
    # Brew 可能已安装但 PATH 未加载（首次安装需要判断
    if [[ -d "/opt/homebrew" ]]; then   # Apple Silicon
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$SHELL_CONFIG"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/Homebrew" ]]; then  # Intel
        echo 'eval "$(/usr/local/Homebrew/bin/brew shellenv)"' >> "$SHELL_CONFIG"
        eval "$(/usr/local/Homebrew/bin/brew shellenv)"
    fi
fi


# =============================
# 8. 安装 Git
# =============================
echo "检查 Git..."

if ! brew list --formula git >/dev/null 2>&1; then
    echo "安装 Git..."
    brew install git || { echo -e "${RED}Git 安装失败${NC}"; exit 1; }
else
    echo "Git 已安装"
fi


echo -e "${GREEN}macOS 基础环境配置完成！${NC}"