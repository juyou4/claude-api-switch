#!/bin/bash

# 多语言功能测试脚本
# 用于测试claude-switch的多语言功能

echo "🧪 Testing Multi-language Functionality"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 测试语言加载器
echo -e "${BLUE}1. Testing Language Loader${NC}"
echo "=================="

if [ -f "$SCRIPT_DIR/i18n/loader.sh" ]; then
    source "$SCRIPT_DIR/i18n/loader.sh"

    # 测试中文
    echo -e "${CYAN}Testing Chinese (zh-CN):${NC}"
    if init_i18n --lang=zh-CN; then
        echo "  ✅ Language loaded: $(get_current_language)"
        echo "  📖 App title: $(get_text "app.title")"
        echo "  📖 Success message: $(format_text "messages.success.config_switched" "name" "test")"
    else
        echo "  ❌ Failed to load Chinese"
    fi

    # 测试英文
    echo -e "${CYAN}Testing English (en-US):${NC}"
    if init_i18n --lang=en-US; then
        echo "  ✅ Language loaded: $(get_current_language)"
        echo "  📖 App title: $(get_text "app.title")"
        echo "  📖 Success message: $(format_text "messages.success.config_switched" "name" "test")"
    else
        echo "  ❌ Failed to load English"
    fi
else
    echo "  ❌ Language loader not found"
fi

echo ""
echo -e "${BLUE}2. Testing claude-switch with different languages${NC}"
echo "=================="

# 测试中文界面
echo -e "${CYAN}Testing Chinese Interface:${NC}"
if ./claude-switch --lang=zh-CN help >/dev/null 2>&1; then
    echo "  ✅ Chinese help works"
    ./claude-switch --lang=zh-CN help | head -10
else
    echo "  ❌ Chinese help failed"
fi

echo ""

# 测试英文界面
echo -e "${CYAN}Testing English Interface:${NC}"
if ./claude-switch --lang=en-US help >/dev/null 2>&1; then
    echo "  ✅ English help works"
    ./claude-switch --lang=en-US help | head -10
else
    echo "  ❌ English help failed"
fi

echo ""
echo -e "${BLUE}3. Testing Language Switch Functionality${NC}"
echo "=================="

# 测试语言切换命令
echo -e "${CYAN}Testing zh-ui (Chinese):${NC}"
if timeout 10s ./claude-switch zh-ui >/dev/null 2>&1; then
    echo "  ✅ Chinese language switch works"
else
    echo "  ❌ Chinese language switch failed"
fi

echo -e "${CYAN}Testing en-ui (English):${NC}"
if timeout 10s ./claude-switch en-ui >/dev/null 2>&1; then
    echo "  ✅ English language switch works"
else
    echo "  ❌ English language switch failed"
fi

echo ""
echo -e "${GREEN}✅ Multi-language testing completed!${NC}"
echo "=============================="
echo "Summary:"
echo "- Language loader: $([ -f "$SCRIPT_DIR/i18n/loader.sh" ] && echo "✅ Available" || echo "❌ Missing")"
echo "- Chinese interface: Tested"
echo "- English interface: Tested"
echo "- Language switching: Tested"
echo ""
echo "💡 To manually test:"
echo "  ./claude-switch --lang=zh-CN status"
echo "  ./claude-switch --lang=en-US status"
echo "  ./claude-switch zh-ui"
echo "  ./claude-switch en-ui"