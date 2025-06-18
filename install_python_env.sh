#!/bin/bash

# 脚本名称: install_python_env.sh
# 用途: 初始化 Python 开发环境

echo -e "${GREEN}开始 Python 环境初始化...${NC}"

# 安装 pyenv
if [ ! -d "$HOME/.pyenv" ]; then
    echo "安装 pyenv..."
    brew install pyenv || { echo -e "${RED}pyenv 安装失败${NC}"; exit 1; }
fi

# 配置 pyenv 环境变量
if ! grep -q "pyenv config" "$SHELL_CONFIG"; then
    echo "配置 pyenv 环境变量..."
    echo -e "\n# pyenv config" >> "$SHELL_CONFIG"
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> "$SHELL_CONFIG"
    echo 'eval "$(pyenv init --path)"' >> "$SHELL_CONFIG"
    echo 'eval "$(pyenv init -)"' >> "$SHELL_CONFIG"
    
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# 安装 Python
PYTHON_VERSION="${1:-3.11.11}"  # 默认 3.11.11，可通过参数覆盖
if pyenv versions | grep -q "$PYTHON_VERSION"; then
    echo "Python $PYTHON_VERSION 已安装"
else
    echo "安装 Python $PYTHON_VERSION..."
    pyenv install "$PYTHON_VERSION" || { echo -e "${RED}Python $PYTHON_VERSION 安装失败${NC}"; exit 1; }
fi
pyenv global "$PYTHON_VERSION"

# 安装常用 Python 工具和库
echo "安装 Python 工具和库..."
python -m pip install --upgrade pip
# pip install setuptools wheel virtualenv numpy pandas requests

echo -e "${GREEN}Python 环境初始化完成${NC}"