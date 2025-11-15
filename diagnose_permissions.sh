#!/bin/bash

# Claude API Switch 权限诊断脚本
# 用于诊断和解决 ~/.claude/ 目录权限问题

echo "🔍 Claude API Switch 权限诊断"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. 基本权限检查
echo -e "${BLUE}1. 基本权限检查${NC}"
echo "=================="

echo "当前用户: $(whoami)"
echo "用户ID: $(id -u)"
echo "用户组: $(id -gn)"

if [ -d "$HOME/.claude" ]; then
    echo -e "${GREEN}✅ ~/.claude 目录存在${NC}"
    ls -ld "$HOME/.claude"
    echo "目录权限: $(stat -c '%a %U:%G' "$HOME/.claude")"
else
    echo -e "${RED}❌ ~/.claude 目录不存在${NC}"
    exit 1
fi

# 2. 写入权限测试
echo -e "\n${BLUE}2. 写入权限测试${NC}"
echo "=================="

# 测试文件创建
test_file="$HOME/.claude/.write-test-$$"
if touch "$test_file" 2>/dev/null; then
    echo -e "${GREEN}✅ 文件创建测试通过${NC}"
    rm -f "$test_file"
else
    echo -e "${RED}❌ 文件创建测试失败${NC}"
    echo "错误信息: $(touch "$test_file" 2>&1)"
fi

# 测试settings.json写入
if echo '{"test": "permission-check"}' > "$HOME/.claude/.settings-test.json" 2>/dev/null; then
    echo -e "${GREEN}✅ settings.json写入测试通过${NC}"
    rm -f "$HOME/.claude/.settings-test.json"
else
    echo -e "${RED}❌ settings.json写入测试失败${NC}"
    echo "错误信息: $(echo '{}' > "$HOME/.claude/.settings-test.json" 2>&1)"
fi

# 3. 文件系统信息
echo -e "\n${BLUE}3. 文件系统信息${NC}"
echo "=================="

if command -v df >/dev/null 2>&1; then
    echo "文件系统信息:"
    df -h "$HOME/.claude" 2>/dev/null || echo "无法获取文件系统信息"
fi

if command -v mount >/dev/null 2>&1; then
    echo "挂载信息:"
    mount | grep -E "$(dirname "$HOME/.claude")|$(df "$HOME/.claude" | tail -1 | awk '{print $1}')" 2>/dev/null || echo "无法获取挂载信息"
fi

# 4. ACL权限检查
echo -e "\n${BLUE}4. ACL权限检查${NC}"
echo "=================="

if command -v getfacl >/dev/null 2>&1; then
    echo "ACL权限信息:"
    getfacl "$HOME/.claude" 2>/dev/null || echo "无法获取ACL信息"
else
    echo "getfacl命令不可用"
fi

# 5. 安全模块检查
echo -e "\n${BLUE}5. 安全模块检查${NC}"
echo "=================="

# 检查AppArmor
if command -v aa-status >/dev/null 2>&1; then
    echo "AppArmor状态:"
    aa-status 2>/dev/null | head -10
fi

# 检查SELinux
if command -v sestatus >/dev/null 2>&1; then
    echo "SELinux状态:"
    sestatus 2>/dev/null
else
    echo "SELinux未安装或未启用"
fi

# 6. 测试claude-switch脚本
echo -e "\n${BLUE}6. claude-switch脚本测试${NC}"
echo "=================="

if [ -f "./claude-switch" ]; then
    echo "claude-switch脚本存在"
    ls -la ./claude-switch

    # 尝试运行一个简单的配置切换测试
    echo "尝试运行配置切换测试..."
    if timeout 10s ./claude-switch en-ui >/dev/null 2>&1; then
        echo -e "${GREEN}✅ claude-switch运行测试通过${NC}"
    else
        echo -e "${RED}❌ claude-switch运行测试失败${NC}"
        echo "详细错误信息:"
        timeout 10s ./claude-switch en-ui 2>&1 | head -10
    fi
else
    echo -e "${RED}❌ claude-switch脚本不存在${NC}"
    echo "请确保在正确的项目目录中运行此脚本"
fi

# 7. 解决方案建议
echo -e "\n${BLUE}7. 解决方案建议${NC}"
echo "=================="

if [ ! -w "$HOME/.claude" ]; then
    echo -e "${YELLOW}⚠️  检测到权限问题，建议以下解决方案:${NC}"
    echo ""
    echo "方案1: 修复目录权限"
    echo "  chmod 755 ~/.claude"
    echo "  chmod 644 ~/.claude/settings.json 2>/dev/null || true"
    echo ""
    echo "方案2: 重新创建.claude目录"
    echo "  mv ~/.claude ~/.claude.backup.\$(date +%s)"
    echo "  mkdir -p ~/.claude"
    echo "  chmod 755 ~/.claude"
    echo ""
    echo "方案3: 使用替代配置目录"
    echo "  export CLAUDE_CONFIG_DIR=\$HOME/.claude-config"
    echo "  mkdir -p \$CLAUDE_CONFIG_DIR"
    echo ""
else
    echo -e "${GREEN}✅ 基本权限检查通过，如果仍有问题，请查看上面的详细错误信息${NC}"
fi

echo -e "\n${BLUE}诊断完成${NC}"
echo "=================="