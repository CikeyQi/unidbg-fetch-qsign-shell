#!/bin/bash

# 添加颜色变量
RED="\e[31m"           # 红色
GREEN="\e[32m"         # 绿色
YELLOW="\e[33m"        # 黄色
RESET="\e[0m"          # 重置颜色

# 添加常量
QSIGN_VERSION="1.1.9"
QSIGN_URL="https://github.com/CikeyQi/unidbg-fetch-qsign-shell/releases/download/$QSIGN_VERSION/unidbg-fetch-qsign-$QSIGN_VERSION.zip"
QSIGN_SCRIPT_URL="https://github.com/CikeyQi/unidbg-fetch-qsign-shell/releases/download/$QSIGN_VERSION/qsign_operations.sh"

# 添加函数以显示不同颜色的消息
print_message() {
    local message="$1"
    local color="$2"
    echo -e "${color}${message}${RESET}"
}

# 定义协议内容
protocol="欢迎使用本程序，请阅读以下协议：

1. 本程序仅供学习和演示目的使用。
2. 禁止用于非法目的。
3. 作者对使用本程序造成的任何后果不承担责任。

如果您并不清楚这是什么，请立即退出该脚本
"

print_message "$protocol" "$YELLOW"

sleep 3

# 提示用户输入确认信息
read -p "请输入'我同意该协议并知道我在干什么'以同意协议并确认您了解您的操作： " confirmation

# 判断用户输入是否正确
if [ "$confirmation" != "我同意该协议并知道我在干什么" ]; then
    print_message "您的确认信息不正确，程序将退出" "$RED"
    exit 1
fi

# 检查是否具有 root 权限
if [ "$(whoami)" != "root" ]; then
    print_message "请使用 root 权限执行本脚本！" "$RED"
    exit 1
fi

print_message "正在下载并检查所需软件包，请稍等..." "$GREEN"

sleep 1

# 函数：安装软件包
install_package() {
    local package_name="$1"
    local message="$2"

    if ! command -v "$package_name" &> /dev/null; then
        print_message "$message" "$YELLOW"
        
        if command -v apt &> /dev/null; then
            apt install -y "$package_name" > /dev/null
        elif command -v apt-get &> /dev/null; then
            apt-get install -y "$package_name" > /dev/null
        elif command -v dnf &> /dev/null; then
            dnf install -y "$package_name" > /dev/null
        elif command -v yum &> /dev/null; then
            yum install -y "$package_name" > /dev/null
        elif command -v pacman &> /dev/null; then
            pacman -Syu --noconfirm "$package_name" > /dev/null
        else
            print_message "无法确定操作系统的包管理器，请手动安装软件包 $package_name" "$RED"
            exit 1
        fi
        print_message "$package_name 工具安装完成" "$GREEN"
    else
        print_message "已安装 $package_name 工具，跳过安装" "$GREEN"
    fi
}

# 检查并安装 pv
install_package "pv" "未检测到 pv 工具，开始安装..."

sleep 1

# 检查并安装 unzip
install_package "unzip" "未检测到 unzip 工具，开始安装..."

sleep 1

# 检查是否安装 jdk
if ! command -v java &> /dev/null; then
    print_message "未检测到 Java 环境，开始安装 JDK..." "$YELLOW"

    if command -v apt &> /dev/null; then
        apt update > /dev/null
        apt install -y openjdk-11-jdk > /dev/null
    elif command -v apt-get &> /dev/null; then
        apt-get update > /dev/null
        apt-get install -y openjdk-11-jdk > /dev/null
    elif command -v dnf &> /dev/null; then
        dnf update -y > /dev/null
        dnf install -y java-11-openjdk-devel > /dev/null
    elif command -v yum &> /dev/null; then
        yum update -y > /dev/null
        yum install -y java-11-openjdk-devel > /dev/null
    elif command -v pacman &> /dev/null; then
        pacman -Syu --noconfirm jdk11-openjdk > /dev/null
    else
        print_message "无法确定操作系统的包管理器，请手动安装 Java JDK" "$RED"
        exit 1
    fi
    print_message "Java JDK 环境安装完成" "$GREEN"
else
    print_message "已安装 Java 环境，跳过安装" "$GREEN"
fi

sleep 1

# 如果非第一次启动
if [ -d "unidbg-fetch-qsign-$QSIGN_VERSION" ]; then
    options=("启动 qsign_operations.sh" "重新配置 unidbg-fetch-qsign" "退出脚本")

    PS3="发现已有目录 unidbg-fetch-qsign-$QSIGN_VERSION，请选择操作: "
    select choice in "${options[@]}"; do
        case $choice in
            "启动 qsign_operations.sh")
                if [ -f "unidbg-fetch-qsign-$QSIGN_VERSION/qsign_operations.sh" ]; then
                    cd "unidbg-fetch-qsign-$QSIGN_VERSION"
                    ./qsign_operations.sh
                    exit
                else
                    print_message "文件 qsign_operations.sh 不存在，请重新配置（若是 nohup 管理请直接使用 nohup 命令）" "$RED"
                    exit 1
                fi
                ;;
            "重新配置 unidbg-fetch-qsign")
                print_message "正在进入配置流程中..." "$YELLOW"
                rm -r "unidbg-fetch-qsign-$QSIGN_VERSION"
                sleep 1
                break
                ;;
            "退出脚本")
                print_message "已退出脚本，Have a Fun!" "$RED"
                exit 0
                break
                ;;
            *)
                print_message "输入错误，无效的选择！" "$RED"
                ;;
        esac
    done
fi

# 提示用户选择线路
options=("国内线路" "国外线路(暂时无法使用)")

# 显示菜单
PS3="请选择线路："
select option in "${options[@]}"; do
    case "$REPLY" in
        1) # 选择了国内线路
            break
            ;;
        2) # 选择了国外线路
            break
            ;;
        *)
            print_message "输入错误，请重新输入！" "$RED"
            ;;
    esac
done

sleep 1

print_message "正在下载 unidbg-fetch-qsign，请稍等..." "$GREEN"

if [ -f "unidbg-fetch-qsign-$QSIGN_VERSION.zip" ]; then
    rm "unidbg-fetch-qsign-$QSIGN_VERSION.zip"
fi

# 下载相应线路的压缩包
if [ "$option" == "国内线路" ]; then
    download_url="https://mirror.ghproxy.com/$QSIGN_URL"  # 国内镜像地址
else
    download_url="$QSIGN_URL"  # 原始地址
fi

# 下载文件并检查错误
if ! { curl -L "$download_url" 2>/dev/null | pv -bep -s "$(curl -I -s -L "$download_url" | grep -i 'Content-Length' | awk '{print $2}' | tr -d '\r')" > unidbg-fetch-qsign-$QSIGN_VERSION.zip; } then
    print_message "下载失败，请检查网络连接或稍后再试" "$RED"
    exit 1
fi

sleep 1

print_message "下载 unidbg-fetch-qsign 完成，开始解压..." "$GREEN"

# 解压压缩包并检查错误
if ! unzip -q "unidbg-fetch-qsign-$QSIGN_VERSION.zip"; then
    print_message "解压失败，请确保 zip 工具已安装并可用" "$RED"
    exit 1
fi

# 删除压缩包
rm "unidbg-fetch-qsign-$QSIGN_VERSION.zip"

sleep 1

# 查找 Java 路径并设置 JAVA_HOME
java_path=$(readlink -f $(which java))
if [ -n "$java_path" ]; then
    java_home=$(dirname $(dirname "$java_path"))
    export JAVA_HOME="$java_home"
    print_message "已设置 JAVA_HOME 为：$JAVA_HOME" "$GREEN"
else
    print_message "未找到 Java 安装路径，等待程序自动识别" "$YELLOW"
fi

sleep 1

# 进入解压后的文件夹
cd "unidbg-fetch-qsign-$QSIGN_VERSION"

# 检查 8080 端口是否被占用
if netstat -tuln | grep ":8080" > /dev/null; then
    print_message "默认端口 8080 已被占用，请自行前往 txlib/<协议版本>/config.json 修改端口号（若已修改可无视本提示）" "$RED"
else
    print_message "默认端口 8080 未被占用" "$GREEN"
fi

# 检查系统是否有 systemd 服务
systemd_check="$(ps -p 1 -o comm=)"
if [[ "${systemd_check}" != "systemd" ]]; then
    # 如果系统中没有 systemd 服务，则使用 nohup 进行管理
    print_message "当前系统中没有 systemd 服务，尝试使用 nohup 进行管理" "$YELLOW"

    # 读取 txlib 文件夹下的子文件夹名称
    txlib_folders=($(ls -d txlib/*/))

    # 让用户选择协议版本
    print_message "请选择协议版本：" "$GREEN"
    for ((i=0; i<${#txlib_folders[@]}; i++)); do
        folder_name=$(basename "${txlib_folders[$i]}")  # 获取文件夹名称，不包含 "txlib"
        print_message "$((i+1)): $folder_name" "$GREEN"
    done

    read -p "输入选择的协议版本数字: " version_choice

    # 验证用户输入是否有效
    if [[ ! "$version_choice" =~ ^[0-9]+$ || "$version_choice" -lt 1 || "$version_choice" -gt ${#txlib_folders[@]} ]]; then
        print_message "无效的选择，请输入有效的协议版本数字" "$RED"
        exit 1
    fi

    # 获取用户选择的协议版本
    selected_version=$(basename "${txlib_folders[$((version_choice-1))]}")

    print_message "已选择协议版本: $selected_version" "$GREEN"

    # 创建一个新的 nohup 任务并运行命令
    nohup bash bin/unidbg-fetch-qsign --basePath=txlib/$selected_version > qsign.log 2>&1 &

    # 获取 nohup 任务的 PID
    qsign_pid=$!

    # 显示 nohup 任务的 PID
    print_message "已创建 nohup 任务并运行命令，PID 为: $qsign_pid" "$GREEN"

    # 循环检测进程是否存活，如果进程丢失了就再启动一个
    while true; do
        if ! kill -0 $qsign_pid 2>/dev/null; then
            # 进程不存在，重新启动
            nohup bash bin/unidbg-fetch-qsign --basePath=txlib/$selected_version > qsign.log 2>&1 &
            qsign_pid=$!
            print_message "进程已丢失，已重新启动，新的PID为: $qsign_pid" "$RED"
        fi
        # 每隔一段时间检测一次，可以根据需要调整 sleep 的时间
        sleep 1
    done

else
    # 如果系统有 systemd 服务
    print_message "当前系统中存在 systemd 服务" "$GREEN"
    
    # 下载官方管理脚本
    print_message "正在下载 qsign_operations 脚本，请稍等..." "$GREEN"

    # 下载相应线路的脚本
    if [ "$option" == "国内线路" ]; then
        download_url="https://mirror.ghproxy.com/$QSIGN_SCRIPT_URL"
    else
        download_url="$QSIGN_SCRIPT_URL"
    fi

    # 下载脚本文件并检查错误
    if ! { curl -L "$download_url" 2>/dev/null | pv -bep -s "$(curl -I -s -L "$download_url" | grep -i 'Content-Length' | awk '{print $2}' | tr -d '\r')" > qsign_operations.sh; } then
        print_message "下载失败，请检查网络连接或稍后再试" "$RED"
        exit 1
    fi

    # 给予脚本执行权限
    chmod +x "qsign_operations.sh"

    print_message "下载 qsign_operations 脚本成功，5 秒钟后启动..." "$GREEN"

    sleep 5

    # 运行脚本
    ./qsign_operations.sh
fi
