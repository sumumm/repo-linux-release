#!/bin/bash

# 组件版本信息生成脚本（优化版）
# 作者：智能助手
# 版本：2.0

# 配置区
REPOSITORIES=("u-boot" "linux-kernel" "linux-rootfs")
OUTPUT_FILE="version.md"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S %Z")
TEMP_FILE=$(mktemp)

# 颜色定义
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
RESET='\033[0m'

# 错误处理函数
handle_error() {
    echo -e "${RED}[错误] $1${RESET}" >&2
    [[ -n "$2" ]] && echo "  位置: $2"
    exit 1
}

# 仓库信息收集函数
function get_repo_info() 
{
    local repo="$1"
    # 验证仓库目录
    [[ ! -d "$repo" ]] && handle_error "仓库目录不存在" "${repo}"
    
    # 进入仓库目录（使用子shell避免目录切换问题）
    (
        cd "$repo" || handle_error "无法进入目录" "$repo"
        
        # 验证Git仓库
        git rev-parse --is-inside-work-tree &>/dev/null || handle_error "不是Git仓库" "$repo"
        
        # 收集信息
        local branch_info=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached HEAD")
        local commit_hash=$(git log -1 --format=%H)
        local short_hash=$(git log -1 --format=%h)
        local commit_date=$(git log -1 --format=%ai)
        local author=$(git log -1 --format=%an)
        local message=$(git log -1 --format=%s)
        local remote_url=$(git remote get-url origin 2>/dev/null || echo "未配置远程仓库")
        
        # 生成Markdown内容
        cat << EOL
### ${repo^} 版本信息

| 项目 | 内容 |
|---|---|
| **仓库路径**  | \`$(pwd)\` |
| **远程地址**  | ${remote_url} |
| **分支状态**  | \`${branch_info}\` |
| **完整哈希**  | \`${commit_hash}\` |
| **短提交ID**  | ${short_hash} |
| **提交时间**  | ${commit_date} |
| **提交作者**  | ${author} |
| **提交摘要**  | ${message} |

EOL
    ) || handle_error "处理仓库时发生错误" "$repo"
}

# 生成报告头
cat > "$TEMP_FILE" << EOL
# 系统组件版本信息

**生成时间**: ${TIMESTAMP}  
**脚本版本**: 1.0  

---

EOL

# 主处理流程
for repo in "${REPOSITORIES[@]}"; do
    echo -e "${BLUE}▶ 正在处理仓库: ${repo}${RESET}"
    get_repo_info "$repo" >> "$TEMP_FILE" 2>&1
done

# 生成最终文件
mv "$TEMP_FILE" "$OUTPUT_FILE"

# 输出统计信息
total_repos=${#REPOSITORIES[@]}
processed_repos=$(grep -c "^### " "$OUTPUT_FILE")
echo -e "\n${GREEN}✅ 报告生成完成${RESET}"
echo -e "  处理仓库数: ${processed_repos}/${total_repos}"
echo -e "  输出文件: ${BLUE}$(realpath "$OUTPUT_FILE")${RESET}"
