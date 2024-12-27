#!/bin/bash
# * =====================================================
# * Copyright © hk. 2022-2025. All rights reserved.
# * File name  : build.sh
# * Author     : 苏木
# * Date       : 2024-12-27
# * ======================================================
##

##======================================================
BLACK="\033[1;30m"
RED='\033[1;31m'    # 红
GREEN='\033[1;32m'  # 绿
YELLOW='\033[1;33m' # 黄
BLUE='\033[1;34m'   # 蓝
PINK='\033[1;35m'   # 紫
CYAN='\033[1;36m'   # 青
WHITE='\033[1;37m'  # 白
CLS='\033[0m'       # 清除颜色

INFO="${GREEN}[INFO]${CLS}"
WARN="${YELLOW}[WARN]${CLS}"
ERR="${RED}[ERR ]${CLS}"

SCRIPT_NAME=${0#*/}
SCRIPT_CURRENT_PATH=${0%/*}
SCRIPT_ABSOLUTE_PATH=`cd $(dirname ${0}); pwd`

SYSTEM_ENVIRONMENT_FILE=/etc/profile # 系统环境变量位置
USER_ENVIRONMENT_FILE=~/.bashrc
SOFTWARE_DIR_PATH=~/2software        # 软件安装目录

TIME_START=
TIME_END=

#===============================================
function get_start_time()
{
	TIME_START=$(date +'%Y-%m-%d %H:%M:%S')
}
function get_end_time()
{
	TIME_END=$(date +'%Y-%m-%d %H:%M:%S')
}

function get_execute_time()
{
	start_seconds=$(date --date="$TIME_START" +%s);
	end_seconds=$(date --date="$TIME_END" +%s);
	duration=`echo $(($(date +%s -d "${TIME_END}") - $(date +%s -d "${TIME_START}"))) | awk '{t=split("60 s 60 m 24 h 999 d",a);for(n=1;n<t;n+=2){if($1==0)break;s=$1%a[n]a[n+1]s;$1=int($1/a[n])}print s}'`
	echo "===*** 运行时间：$((end_seconds-start_seconds))s,time diff: ${duration} ***==="
}

function get_ubuntu_info()
{
    # 获取内核版本信息
    local kernel_version=$(uname -r) # -a选项会获得更详细的版本信息
    # 获取Ubuntu版本信息
    local ubuntu_version=$(lsb_release -ds)

    # 获取Ubuntu RAM大小
    local ubuntu_ram_total=$(cat /proc/meminfo |grep 'MemTotal' |awk -F : '{print $2}' |sed 's/^[ \t]*//g')
    # 获取Ubuntu 交换空间swap大小
    local ubuntu_swap_total=$(cat /proc/meminfo |grep 'SwapTotal' |awk -F : '{print $2}' |sed 's/^[ \t]*//g')
    #显示硬盘，以及大小
    #local ubuntu_disk=$(sudo fdisk -l |grep 'Disk' |awk -F , '{print $1}' | sed 's/Disk identifier.*//g' | sed '/^$/d')
    
    #cpu型号
    local ubuntu_cpu=$(grep 'model name' /proc/cpuinfo |uniq |awk -F : '{print $2}' |sed 's/^[ \t]*//g' |sed 's/ \+/ /g')
    #物理cpu个数
    local ubuntu_physical_id=$(grep 'physical id' /proc/cpuinfo |sort |uniq |wc -l)
    #物理cpu内核数
    local ubuntu_cpu_cores=$(grep 'cpu cores' /proc/cpuinfo |uniq |awk -F : '{print $2}' |sed 's/^[ \t]*//g')
    #逻辑cpu个数(线程数)
    local ubuntu_processor=$(grep 'processor' /proc/cpuinfo |sort |uniq |wc -l)
    #查看CPU当前运行模式是64位还是32位
    local ubuntu_cpu_mode=$(getconf LONG_BIT)

    # 打印结果
    echo "ubuntu: $ubuntu_version - $ubuntu_cpu_mode"
    echo "kernel: $kernel_version"
    echo "ram   : $ubuntu_ram_total"
    echo "swap  : $ubuntu_swap_total"
    echo "cpu   : $ubuntu_cpu,physical id is$ubuntu_physical_id,cores is $ubuntu_cpu_cores,processor is $ubuntu_processor"
}
#===============================================
# 开发环境信息
function dev_env_info()
{
    echo "Development environment: "
    echo "ubuntu : 20.04.2-64(1核12线程 16GB RAM,512GB SSD)"
    echo "VMware : VMware® Workstation 17 Pro 17.6.0 build-24238078"
    echo "Windows: "
    echo "          处理器 AMD Ryzen 7 5800H with Radeon Graphics 3.20 GHz 8核16线程"
    echo "          RAM	32.0 GB (31.9 GB 可用)"
    echo "          系统类型	64 位操作系统, 基于 x64 的处理器"
}
#===============================================

function time_count_down
{
    for i in {3..1}
    do     

        echo -ne "${INFO}after ${i} is end!!"
        echo -ne "\r\r"        # echo -e 处理特殊字符  \r 光标移至行首，但不换行
        sleep 1
    done
    echo "" # 打印一个空行，防止出现混乱
}

function echo_menu()
{
    echo "================================================="
	echo -e "${GREEN}               build project ${CLS}"
	echo -e "${GREEN}                by @苏木    ${CLS}"
	echo "================================================="
    echo -e "${PINK}current path         :$(pwd)${CLS}"
    echo -e "${PINK}SCRIPT_CURRENT_PATH  :${SCRIPT_CURRENT_PATH}${CLS}"
    echo ""
    echo -e "* [0] 获取当前ubuntu信息"
    echo "================================================="
}

function func_process()
{
	read -t 3 -p "请选择功能(3s后超时自动执行),默认选择0:" choose
    echo "" # 换行一下
    if [ -z "${choose}" ]; then
        echo -e "${WARN}输入超时，没有收到任何输入。"
        choose=0
    else
        echo -e "${INFO}你输入了：${choose}"
    fi

	case "${choose}" in
		"0") 
            dev_env_info
            get_ubuntu_info
            ;;
		*) 
            dev_env_info
            get_ubuntu_info
            ;;
	esac
}

echo_menu
func_process
