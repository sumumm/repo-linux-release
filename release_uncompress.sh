#!/bin/bash
# 增强版部署脚本(v1.2) - 带智能目录管理

# 配置区
TARGET_TFTP="$HOME/3tftp"    # TFTP服务目录
TARGET_NFS="$HOME/4nfs"     # NFS根文件系统目录
RELEASE_DIR="./release"     # 主发布包解压目录

# 带错误退出的目录创建函数
safe_mkdir() {
    for dir in "$@"; do
        if [ -d "$dir" ]; then
            echo "✓ 目录已存在: $dir"
        else
            echo "创建目录: $dir"
            mkdir -p "$dir" || {
                echo "致命错误：无法创建目录 $dir (权限问题？)"
                exit 1
            }
        fi
    done
}

# 主流程
function main() 
{
    # 阶段1：目录准备
    safe_mkdir "$TARGET_TFTP" "$TARGET_NFS"

    # 阶段2：解压主发布包
    if [ ! -f "release.tar.bz2" ]; then
        echo "错误：未找到 release.tar.bz2"
        exit 2
    fi
    echo "解压主发布包 release.tar.bz2 ..."
    tar -xjf release.tar.bz2 || exit 3

    # 阶段3：处理内核和U-Boot
    for pkg_type in kernel u-boot; do
        pkg=$(find "$RELEASE_DIR" -maxdepth 1 -type f -name "${pkg_type}-*.tar.bz2" | head -1)
        if [ -n "$pkg" ]; then
            echo "处理 $pkg → $TARGET_TFTP"
            tar -xjf "$pkg" --strip-components=1 -C "$TARGET_TFTP" 2>/dev/null || {
                echo "警告：使用默认解压方式"
                tar -xjf "$pkg" -C "$TARGET_TFTP"
            }
        else
            echo "警告：缺少 $pkg_type 包"
        fi
    done

    # 阶段4：处理根文件系统
    rootfs_pkg=$(find "$RELEASE_DIR" -maxdepth 1 -type f -name "rootfs-*.tar.bz2" | head -1)
    if [ -n "$rootfs_pkg" ]; then
        echo "解压根文件系统到 $TARGET_NFS"
        tar -xjf "$rootfs_pkg" -C "$TARGET_NFS" || exit 4
    else
        echo "错误：缺少根文件系统包"
        exit 5
    fi

    echo "操作成功完成！"
}

# 执行主流程
main
