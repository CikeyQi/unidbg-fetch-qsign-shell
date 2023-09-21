#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

LANG=en_US.UTF-8

script_shell="$(readlink /proc/$$/exe | sed "s/.*\///")"
if [[ "${script_shell}" != "bash" ]]; then
	echo "请使用bash命令执行本脚本！"
	exit 1
fi

# 检查系统是否有systemd服务
systemd_check="$(ps -p 1 -o comm=)"
if [[ "${systemd_check}" != "systemd" ]]; then
	echo "当前系统中没有systemd服务，执行本脚本没有意义！"
	exit 1
fi

if [ "$(whoami)" != "root" ]; then
	echo "请使用root权限执行本脚本！"
	exit 1
fi

if [ -z "$1" ]; then
	echo "请选择操作:"
	echo "0. 创建或更新 qsign 配置"
	echo "1. 重启 qsign"
	echo "2. 停止 qsign"
	echo "3. 启动 qsign"
	echo "4. 设置开机启动"
	echo "5. 禁用开机启动"
	echo "6. 查看运行状态"
	echo "7. 重载 qsign 服务"
	echo "8. 查看最近日志"
	echo "9. 查询内存和PID"
	echo "10. 导出运行日志"
	echo "11. 设置别名(qsign)"
	echo -n "请输入数字选项: "

	# shellcheck disable=SC2162
	read option
else
	option=$1
fi

case $option in
0)
	# 定义可能的 JDK 路径
	jdk_paths=(
		"/usr/lib/jvm"
		"/usr/local/java"
		"/usr/local/btjdk"
	)

	# 检查 JAVA_HOME 环境变量
	if [ -z "$JAVA_HOME" ]; then
		echo -e "\nJAVA_HOME 环境变量未找到，将查找可能的 JDK 安装目录。"

		jdk_found=false

		# 在可能的路径中查找 JDK
		for path in "${jdk_paths[@]}"; do
			if [[ -d "$path" ]]; then
				# shellcheck disable=SC2207
				jdk_dirs=($(ls -d "$path"/*jdk* 2>/dev/null))
				if [[ ${#jdk_dirs[@]} -gt 0 ]]; then
					jdk_found=true
					for jdk_dir in "${jdk_dirs[@]}"; do
						if [[ -d "$jdk_dir/jre" && ! -d "$jdk_dir/bin" ]]; then
							jdk_dir="$jdk_dir/jre"
							break
						fi
					done
					break
				fi
			fi
		done

		# 输出结果
		if [[ $jdk_found == true ]]; then
			if [[ -n "$jdk_dir" ]]; then
				echo "JDK is installed at: ${jdk_dir}"
				export JAVA_HOME="${jdk_dir}"
			else
				echo "JDK is installed at: ${jdk_dirs[0]}"
				export JAVA_HOME="${jdk_dirs[0]}"
			fi
		else
			echo "没有找到 JDK 目录，请先安装或设置 JAVA_HOME 环境变量！"
			exit 1
		fi
	fi

	#必须判断工作目录
	script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" #脚本目录
	current_dir="$PWD"                                         #当前环境目录
	if [ "$current_dir" != "$script_dir" ]; then
		echo -e "\n当前工作目录与脚本所在目录不一致，切换到脚本目录...🚀\n"
		cd "$script_dir"
	fi

	# 检查 unidbg-fetch-qsign 是否存在
	if [ ! -f "bin/unidbg-fetch-qsign" ]; then
		echo "错误：找不到 bin/unidbg-fetch-qsign 文件，在 qsign 的根目录中执行本脚本！"
		exit 1
	fi

	echo -n "输入执行版本(比如 8.9.76) : "
	read -r start_command

	while [ -z "$start_command" ] || [ ! -d "txlib/$start_command" ]; do
		if [ -z "$start_command" ]; then
			echo "不能为空，请重新输入！"
		else
			echo "错误：找不到 txlib/$start_command 文件夹，没有这个目录或参数错误。请重新输入！"
		fi

		echo -n "输入执行版本(比如 8.9.76) : "
		read -r start_command
	done

	service_file="/etc/systemd/system/qsign.service"
	working_dir=$(pwd)

	cat <<EOF | tee "$service_file" >/dev/null
[Unit]
Description=unidbg-fetch-qsign
After=network.target

[Service]
Environment="JAVA_HOME=$JAVA_HOME"
WorkingDirectory=$working_dir
ExecStart=/usr/bin/env bash bin/unidbg-fetch-qsign --basePath=txlib/$start_command
Restart=always
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF

	echo "创建 systemd 服务 $service_file 成功。"
	# 设置文件权限
	chmod 644 "$service_file"
	# 重载 systemd 服务
	systemctl daemon-reload
	# 检查 qsign 是否正在运行
	if systemctl is-active --quiet qsign; then
		echo "qsign 正在运行，即将重启..."
		systemctl restart qsign
		echo "qsign 服务已重启."
	else
		systemctl start qsign
		echo "qsign 已启动."
	fi
	;;
1)
	systemctl restart qsign
	echo "已执行重启操作 ✨"
	;;
2)
	systemctl stop qsign
	echo "已执行停止操作 ⛔️"
	;;
3)
	systemctl start qsign
	echo "已执行启动操作 🚀"
	;;
4)
	systemctl enable qsign
	echo "已设置开机启动 📥"
	;;
5)
	systemctl disable qsign
	echo "已禁用开机启动 ⛔️"
	;;
6)
	systemctl status qsign -l
	;;
7)
	systemctl daemon-reload
	echo "已执行重载服务操作 ✨"
	;;
8)
	journalctl -u qsign --pager-end
	;;
9)
	pid=$(systemctl show qsign --property=MainPID | awk -F "=" '{print $2}')
	rss=$(ps -p $pid -o rss=)
	echo "PID: $pid, RSS: $(printf "%.2f" $(echo "scale=2; $rss / 1024" | bc)) MB"
	;;
10)
	echo -n "请输入要导出最近的日志行数（如:100,直接回车将导出全部日志）："
	# shellcheck disable=SC2162
	read line_count
	if [[ -z "$line_count" || "$line_count" -le 0 ]]; then
		command="journalctl -u qsign"
	else
		command="journalctl -u qsign -n $line_count"
	fi
	script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	if [ -f "$script_dir/log-qsign.log" ]; then
	    echo -e "---------------------------------------------"
	    echo -e "检测到log-qsign.log文件已存在，是否覆盖文件？"
	    read -p "输入yes覆盖文件：" yes
	    if [ "$yes" != "yes" ]; then
	        echo -e "------------------------"
	        echo "取消覆盖，跳过导出日志操作。"
	        exit 0
	    fi
	fi
	$command >$script_dir/log-qsign.log
	echo "已导出qsign的日志,目录$script_dir,文件log-qsign.log"
	;;
11)
	echo "设置命令的别名为qsign"
	if [ "$(id -u)" != "0" ]; then
		echo "ERROR：需要使用 root 用户运行此选项。"
		exit 1
	fi
	script_name=$(basename "$0")
	script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	script_path="$script_dir/$script_name"
	if ! grep -q "alias qsign='bash $script_path'" /root/.bashrc; then
		echo "alias qsign='bash $script_path'" >>/root/.bashrc
		source /root/.bashrc
		echo "已成功设置 qsign 命令的别名，下次打开终端可用 qsign 命令来访问脚本。"
	else
		echo "qsign 命令的别名已存在。"
	fi
	;;
*)
	echo "无效的选项，请重新运行脚本并输入有效的数字选项！"
	;;
esac