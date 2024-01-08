#!/bin/bash

# 添加颜色变量
RED="\e[31m"           # 红色
GREEN="\e[32m"         # 绿色
YELLOW="\e[33m"        # 黄色
RESET="\e[0m"          # 重置颜色

QSIGN_URL="https://mirror.ghproxy.com/https://github.com/CikeyQi/unidbg-fetch-qsign-shell/releases/download/1.1.9/unidbg-fetch-qsign-1.1.9.zip"
QSIGN_SCRIPT_URL="https://mirror.ghproxy.com/https://github.com/CikeyQi/unidbg-fetch-qsign-shell/releases/download/1.1.9/qsign_operations.sh"

# 添加函数以显示不同颜色的消息
print_message() {
    local message="$1"
    local color="$2"
    echo -e "${color}${message}${RESET}"
}

# 检查是否具有 root 权限
if [ "$(whoami)" != "root" ]; then
    print_message "请使用 root 权限执行本脚本！" "$RED"
    exit 1
fi

# 选择使用 systemd 还是 Docker 进行管理
print_message "请选择使用 systemd 或 Docker 进行管理" "$YELLOW"
echo "1. systemd管理（官方推荐）"
echo "2. Docker管理"
read -p "请输入数字以选择管理方式: " choice_manage
choice_manage=${choice_manage:-1}

# 如果选择了 systemd
if [ "$choice_manage" == "1" ]; then
    # 检查是否有 systemd 服务
    systemd_check="$(ps -p 1 -o comm=)"

    if [[ "${systemd_check}" != "systemd" ]]; then
        # 如果系统中没有 systemd 服务，则建议使用 Docker 进行管理
        print_message "当前系统中没有 systemd 服务，请重新运行脚本并选择使用 Docker 进行管理" "$YELLOW"

        # 结束脚本
        exit 1
    else
        # 如果系统有 systemd 服务
        print_message "当前系统中存在 systemd 服务" "$GREEN"

        print_message "正在下载并检查所需软件包，请稍等..." "$GREEN"

        # 检查是否安装 unzip
        if ! command -v unzip &> /dev/null; then
            print_message "未检测到 unzip 工具，开始安装..." "$YELLOW"

            if command -v apt &> /dev/null; then
                apt install -y unzip > /dev/null
            elif command -v apt-get &> /dev/null; then
                apt-get install -y unzip > /dev/null
            elif command -v dnf &> /dev/null; then
                dnf install -y unzip > /dev/null
            elif command -v yum &> /dev/null; then
                yum install -y unzip > /dev/null
            elif command -v pacman &> /dev/null; then
                pacman -Syu --noconfirm unzip > /dev/null
            else
                print_message "无法确定操作系统的包管理器，请手动安装 unzip" "$RED"
                exit 1
            fi
            print_message "unzip 工具安装完成" "$GREEN"
        else
            print_message "已安装 unzip 工具，跳过安装" "$GREEN"
        fi

        # 检查是否安装 java
        if ! command -v java &> /dev/null; then
            print_message "未检测到 Java 环境，开始安装 JDK..." "$YELLOW"

            if command -v apt &> /dev/null; then
                apt install -y openjdk-11-jdk > /dev/null
            elif command -v apt-get &> /dev/null; then
                apt-get install -y openjdk-11-jdk > /dev/null
            elif command -v dnf &> /dev/null; then
                dnf install -y java-11-openjdk-devel > /dev/null
            elif command -v yum &> /dev/null; then
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

        print_message "正在下载 unidbg-fetch-qsign，请稍等..." "$GREEN"

        # 删除旧的文件
        if [ -f "unidbg-fetch-qsign-1.1.9.zip" ]; then
            rm "unidbg-fetch-qsign-1.1.9.zip"
        fi
        
        # 下载文件并检查错误
        if ! { curl -L "$QSIGN_URL" 2>/dev/null > unidbg-fetch-qsign-1.1.9.zip; } then
            print_message "下载失败，请检查网络连接或稍后再试" "$RED"
            exit 1
        fi

        print_message "下载 unidbg-fetch-qsign 完成，开始解压..." "$GREEN"

        # 解压压缩包并检查错误
        if ! unzip -q "unidbg-fetch-qsign-1.1.9.zip"; then
            print_message "解压失败，请确保 zip 工具已安装并可用" "$RED"
            exit 1
        fi

        # 删除压缩包
        rm "unidbg-fetch-qsign-1.1.9.zip"

                    
        # 进入解压后的文件夹
        cd "unidbg-fetch-qsign-1.1.9"

        # 下载官方管理脚本
        print_message "正在下载 qsign_operations 脚本，请稍等..." "$GREEN"

        # 下载文件并检查错误
        if ! { curl -L "$QSIGN_SCRIPT_URL" 2>/dev/null > qsign_operations.sh; } then
            print_message "下载失败，请检查网络连接或稍后再试" "$RED"
            exit 1
        fi

        # 如果没有设置 JAVA_HOME，则获取 JAVA_HOME
        if [ -z "$JAVA_HOME" ]; then
            export JAVA_HOME=$(which java)
            print_message "未设置 JAVA_HOME 环境变量，设置 JAVA_HOME 为 $JAVA_HOME" "$YELLOW"
        fi

        # 给予脚本执行权限
        chmod +x "qsign_operations.sh"

        print_message "下载 qsign_operations 脚本成功，5 秒钟后启动..." "$GREEN"

        print_message "请选择 0 开始配置Qsign服务，若配置错误或需要修改请重新运行脚本并选择 启动qsign_operations.sh " "$YELLOW"

        sleep 5

        # 运行脚本

        ./qsign_operations.sh

    fi
else
    # 如果选择了 Docker
    # 检查是否安装 Docker
    if ! command -v docker &> /dev/null; then
        print_message "未检测到 Docker 环境，开始安装 Docker..." "$YELLOW"

        if command -v apt &> /dev/null; then
            apt update > /dev/null
            apt install -y docker.io > /dev/null
        elif command -v apt-get &> /dev/null; then
            apt-get update > /dev/null
            apt-get install -y docker.io > /dev/null
        elif command -v dnf &> /dev/null; then
            dnf install -y docker > /dev/null
            systemctl enable --now docker > /dev/null
        elif command -v yum &> /dev/null; then
            yum install -y docker-ce > /dev/null
            systemctl enable --now docker > /dev/null
        elif command -v pacman &> /dev/null; then
            pacman -Syu --noconfirm docker > /dev/null
            systemctl enable --now docker > /dev/null
        else
            print_message "无法确定操作系统的包管理器，请手动安装 Docker" "$RED"
            exit 1
        fi
        print_message "Docker 环境安装完成" "$GREEN"
    else
        print_message "已安装 Docker 环境，跳过安装" "$GREEN"
    fi

    # 检查 Docker 是否已启动
    if ! systemctl is-active --quiet docker; then
        print_message "Docker 未启动，正在启动 Docker..." "$YELLOW"
        systemctl start docker
        print_message "Docker 启动完成" "$GREEN"
    else
        print_message "Docker 已启动，跳过启动" "$GREEN"
    fi

    print_message "正在拉取 unidbg-fetch-qsign-docker 镜像..." "$YELLOW"

    # 拉取镜像并检查错误
    docker pull cikeyqi/unidbg-fetch-qsign-docker

    print_message "镜像拉取完成" "$GREEN"

    read -p "请输入容器名称(默认随机): " container_name
    read -p "请输入TXLIB_VERSION(默认8.9.96): " txlib_version
    read -p "请输入签名服务端口号(默认8080): " port

    # 检查容器名称是否为空，如果为空则生成一个随机名称
    if [ -z "$container_name" ]; then
    container_name=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8 ; echo '')
    fi

    # 检查 TXLIB_VERSION 是否为空，如果为空则使用默认值
    if [ -z "$txlib_version" ]; then
    txlib_version="8.9.96"
    fi

    # 检查 port 是否为空，如果为空则使用默认值
    if [ -z "$port" ]; then
    port="8080"
    fi

    print_message "=========================" "$GREEN"
    print_message "容器名称: $container_name" "$GREEN"
    print_message "协议版本: $txlib_version" "$GREEN"
    print_message "端口号: $port" "$GREEN"
    print_message "=========================" "$GREEN"

   # 等待用户确认
    read -p "请确认以上信息是否正确？[Y/n] " confirm
    if [[ $confirm != "Y" && $confirm != "y" ]]; then
        print_message "用户取消操作，退出脚本。" "$RED"
        exit 1
    fi

    print_message "正在启动容器，请稍等..." "$GREEN"

    # 启动容器
    docker run -d --name "$container_name" -e TXLIB_VERSION="$txlib_version" -p "$port":8080 --restart=always cikeyqi/unidbg-fetch-qsign-docker

    print_message "容器启动完成" "$GREEN"

    # 获取公网 IP
    ip=$(curl -s https://api.ipify.org)

    # 获取内网 IP
    ip2=$(hostname -I | awk '{print $1}')

    print_message "=========================" "$GREEN"
    print_message "签名服务已启动" "$GREEN"
    print_message "签名版本: $txlib_version" "$GREEN"
    print_message "公网地址: "http://$ip:$port"" "$GREEN"
    print_message "内网地址: "http://$ip2:$port"" "$GREEN"
    print_message "=========================" "$GREEN"

    print_message "unidbg-fetch-qsign-docker 安装完成" "$GREEN"
fi
