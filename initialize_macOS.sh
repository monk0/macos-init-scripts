#!/bin/bash

# ----------------------------------------
chmod +x install_generic.sh install_dev_env.sh install_apps.sh


# 1.安装 基础环境
./install_generic.sh
# 提示用户完成安装
echo " -------------->  1. base environment setup complete! <--------------"

# 2.安装 JDK 环境
./install_dev_env.sh
# 提示用户完成安装
echo " -------------->  2. jdk environment setup complete! <--------------"

# 3.安装 常用工具
./install_apps.sh
# 提示用户完成安装
echo " -------------->  3. application setup complete! <--------------"


# 提示用户完成安装
echo " -------------->  4. all environment setup complete! <--------------"
