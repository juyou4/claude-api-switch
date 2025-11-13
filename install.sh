#!/bin/bash

# Claude API Switch 安装脚本
# 用于自动安装和配置 Claude API 切换工具

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目信息
PROJECT_NAME="claude-api-switch"
SCRIPT_NAME="claude-switch"
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.claude"

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}Claude API Switch 安装程序${NC}"
echo "=============================="
echo ""

# 检查依赖
check_dependencies() {
    echo -e "${YELLOW}检查系统依赖...${NC}"

    local missing_deps=()

    # 检查 jq
    if ! command -v jq >/dev/null 2>&1; then
        missing_deps+=("jq")
    fi

    # 检查 python3
    if ! command -v python3 >/dev/null 2>&1; then
        missing_deps+=("python3")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}错误: 缺少以下依赖: ${missing_deps[*]}${NC}"
        echo ""
        echo "Ubuntu/Debian 安装命令:"
        echo "  sudo apt-get update"
        echo "  sudo apt-get install jq python3"
        echo ""
        echo "CentOS/RHEL 安装命令:"
        echo "  sudo yum install jq python3"
        echo ""
        echo "macOS 安装命令:"
        echo "  brew install jq python3"
        return 1
    fi

    echo -e "${GREEN}✅ 依赖检查通过${NC}"
    return 0
}

# 创建安装目录
create_directories() {
    echo -e "${YELLOW}创建安装目录...${NC}"

    mkdir -p "$INSTALL_DIR"
    mkdir -p "$CONFIG_DIR"

    echo -e "${GREEN}✅ 目录创建完成${NC}"
}

# 安装主脚本
install_script() {
    echo -e "${YELLOW}安装主脚本...${NC}"

    # 复制脚本到安装目录
    cp "$SCRIPT_DIR/$SCRIPT_NAME" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

    echo -e "${GREEN}✅ 主脚本安装完成${NC}"
}

# 安装配置文件
install_configs() {
    echo -e "${YELLOW}安装配置文件...${NC}"

    # 创建配置目录
    mkdir -p "$CONFIG_DIR/configs"
    mkdir -p "$CONFIG_DIR/backups"

    # 复制配置文件
    if [ -d "$SCRIPT_DIR/configs" ]; then
        cp -r "$SCRIPT_DIR/configs/"* "$CONFIG_DIR/configs/"
        echo -e "${GREEN}✅ 配置文件安装完成${NC}"
    else
        echo -e "${YELLOW}⚠️ 配置文件目录不存在，跳过${NC}"
    fi
}

# 检测Shell类型
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

# Shell集成
install_shell_integration() {
    echo -e "${YELLOW}配置Shell集成...${NC}"

    local shell_type=$(detect_shell)
    local shell_config=""

    case "$shell_type" in
        "zsh")
            shell_config="$HOME/.zshrc"
            ;;
        "bash")
            shell_config="$HOME/.bashrc"
            ;;
        *)
            echo -e "${YELLOW}⚠️ 未知的Shell类型，请手动配置PATH${NC}"
            return 0
            ;;
    esac

    # 检查是否已经配置过
    if grep -q "claude-switch" "$shell_config" 2>/dev/null; then
        echo -e "${YELLOW}⚠️ Shell集成已存在，跳过配置${NC}"
        return 0
    fi

    # 备份原配置文件
    if [ -f "$shell_config" ]; then
        cp "$shell_config" "$shell_config.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${BLUE}📦 已备份原配置文件${NC}"
    fi

    # 添加Shell集成
    cat >> "$shell_config" << 'EOF'

# Claude API Switch 集成
export PATH="$HOME/.local/bin:$PATH"

# Claude Switch 基础别名
alias cs='claude-switch'
alias cslist='claude-switch list'
alias csstatus='claude-switch status'

# 动态生成提供商别名（在下次Shell启动时生效）
cs_generate_aliases() {
    if [ -d "$HOME/.claude/configs" ]; then
        echo "# 动态生成的配置别名"
        for config_file in "$HOME/.claude/configs"/*.json; do
            if [ -f "$config_file" ]; then
                config_name=$(basename "$config_file" .json)
                # 排除语言配置和特殊配置
                case "$config_name" in
                    zh-ui|en-ui|*.tmp|*.backup*)
                        continue
                        ;;
                esac
                echo "alias cs${config_name}='claude-switch ${config_name}'"
            fi
        done
    fi
}

# 调用函数生成别名
eval "$(cs_generate_aliases)"

# 语言切换别名
alias cscn='claude-switch zh-ui'
alias csen='claude-switch en-ui'
alias cslang='claude-switch list | grep -E "(zh-ui|en-ui)"'

# Claude Switch 函数
cscreate() {
    if [ $# -eq 0 ]; then
        echo "用法: cscreate <配置名称>"
        return 1
    fi
    claude-switch save "$1"
}

csdelete() {
    if [ $# -eq 0 ]; then
        echo "用法: csdelete <配置名称>"
        return 1
    fi
    claude-switch delete "$1"
}

csbackup() {
    claude-switch backup
}

# 刷新配置别名函数
csrefresh() {
    echo "🔄 正在刷新配置别名..."
    # 重新生成配置别名
    # 安全删除cs开头的别名
    for alias_name in $(alias 2>/dev/null | grep "^cs" | cut -d'=' -f1); do
        unalias "$alias_name" 2>/dev/null || true
    done

    # 重新添加基础别名
    alias cs='claude-switch'
    alias cslist='claude-switch list'
    alias csstatus='claude-switch status'

    # 重新生成动态别名
    eval "$(cs_generate_aliases)"
    echo "✅ 配置别名已刷新"
}

# 列出所有可用的配置别名
csaliases() {
    echo "📋 可用的配置别名："
    alias | grep "^cs" | sort
}

# Claude Switch 自动补全 (如果支持)
if command -v register-python-argcomplete >/dev/null 2>&1; then
    eval "$(register-python-argcomplete claude-switch)"
fi
EOF

    echo -e "${GREEN}✅ Shell集成配置完成${NC}"
    echo -e "${YELLOW}💡 请运行以下命令使配置生效：${NC}"
    echo "  source $shell_config"
}

# 创建桌面快捷方式 (可选)
create_desktop_entry() {
    echo -e "${YELLOW}是否创建桌面快捷方式？(y/N)${NC}"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        local desktop_dir="$HOME/.local/share/applications"
        mkdir -p "$desktop_dir"

        cat > "$desktop_dir/claude-switch.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Claude API Switch
Comment=快速切换Claude API配置
Exec=$INSTALL_DIR/$SCRIPT_NAME
Icon=terminal
Terminal=true
Categories=Development;Utility;
EOF

        echo -e "${GREEN}✅ 桌面快捷方式创建完成${NC}"
    fi
}

# 验证安装
verify_installation() {
    echo -e "${YELLOW}验证安装...${NC}"

    # 检查脚本是否可执行
    if [ -x "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        echo -e "${GREEN}✅ 主脚本可执行${NC}"
    else
        echo -e "${RED}❌ 主脚本不可执行${NC}"
        return 1
    fi

    # 检查配置文件
    if [ -d "$CONFIG_DIR/configs" ]; then
        local config_count=$(find "$CONFIG_DIR/configs" -name "*.json" | wc -l)
        echo -e "${GREEN}✅ 找到 $config_count 个配置文件${NC}"
    else
        echo -e "${YELLOW}⚠️ 配置文件目录不存在${NC}"
    fi

    # 测试脚本功能
    if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 脚本可在PATH中找到${NC}"
    else
        echo -e "${YELLOW}⚠️ 脚本不在PATH中，请检查Shell配置${NC}"
    fi
}

# 显示使用说明
show_usage() {
    echo ""
    echo -e "${BLUE}安装完成！${NC}"
    echo "=========================="
    echo ""
    echo -e "${GREEN}基本使用方法：${NC}"
    echo "  $SCRIPT_NAME                    # 显示交互式菜单"
    echo "  $SCRIPT_NAME list              # 列出所有配置"
    echo "  $SCRIPT_NAME status            # 显示当前状态"
    echo "  $SCRIPT_NAME glm               # 切换到GLM配置"
    echo "  $SCRIPT_NAME kimi2             # 切换到Kimi2配置"
    echo "  $SCRIPT_NAME minimax           # 切换到MiniMax配置"
    echo ""
    echo -e "${GREEN}快捷别名：${NC}"
    echo "  cs                             # 显示交互式菜单"
    echo "  csglm                          # 切换到GLM"
    echo "  cskimi                         # 切换到Kimi2"
    echo "  csminimax                      # 切换到MiniMax"
    echo "  cslist                         # 列出配置"
    echo "  csstatus                       # 显示状态"
    echo ""
    echo -e "${GREEN}配置管理：${NC}"
    echo "  cscreate <名称>                # 保存当前配置"
    echo "  csdelete <名称>                # 删除配置"
    echo "  csbackup                       # 备份当前配置"
    echo ""
    echo -e "${YELLOW}重要提示：${NC}"
    echo "1. 请确保配置了正确的API密钥"
    echo "2. 重启终端或运行 'source ~/.bashrc' (或 ~/.zshrc) 使配置生效"
    echo "3. 使用 '$SCRIPT_NAME status' 检查当前配置状态"
    echo ""
    echo -e "${BLUE}配置文件位置：${NC}"
    echo "  主配置: $CONFIG_DIR/settings.json"
    echo "  预设配置: $CONFIG_DIR/configs/"
    echo "  脚本位置: $INSTALL_DIR/$SCRIPT_NAME"
    echo ""
}

# 主安装流程
main() {
    echo "开始安装 Claude API Switch..."
    echo ""

    # 检查是否在项目目录中
    if [ ! -f "$SCRIPT_DIR/$SCRIPT_NAME" ]; then
        echo -e "${RED}错误: 在当前目录中找不到 $SCRIPT_NAME 脚本${NC}"
        echo "请确保在项目根目录中运行此安装脚本"
        exit 1
    fi

    # 执行安装步骤
    check_dependencies || exit 1
    create_directories
    install_script
    install_configs
    install_shell_integration
    create_desktop_entry
    verify_installation
    show_usage

    echo -e "${GREEN}🎉 安装完成！${NC}"
}

# 处理命令行参数
case "${1:-}" in
    "--help"|"-h")
        echo "Claude API Switch 安装程序"
        echo ""
        echo "用法: $0 [选项]"
        echo ""
        echo "选项:"
        echo "  --help, -h     显示此帮助信息"
        echo "  --uninstall    卸载 Claude API Switch"
        echo ""
        echo "默认安装到: $INSTALL_DIR"
        echo "配置文件位置: $CONFIG_DIR"
        ;;
    "--uninstall")
        echo -e "${YELLOW}卸载 Claude API Switch...${NC}"

        # 删除脚本
        if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
            rm "$INSTALL_DIR/$SCRIPT_NAME"
            echo -e "${GREEN}✅ 已删除主脚本${NC}"
        fi

        # 删除配置目录（询问用户）
        echo -e "${YELLOW}是否删除配置文件目录 $CONFIG_DIR? (y/N)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            rm -rf "$CONFIG_DIR"
            echo -e "${GREEN}✅ 已删除配置文件${NC}"
        fi

        # 删除桌面快捷方式
        if [ -f "$HOME/.local/share/applications/claude-switch.desktop" ]; then
            rm "$HOME/.local/share/applications/claude-switch.desktop"
            echo -e "${GREEN}✅ 已删除桌面快捷方式${NC}"
        fi

        echo -e "${GREEN}🎉 卸载完成！${NC}"
        echo "请手动从Shell配置文件中删除相关别名和配置"
        ;;
    *)
        main
        ;;
esac