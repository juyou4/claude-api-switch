#!/bin/bash

# 路由器配置修复脚本
# 用于解决已生成的路由器配置文件中API端点错误的问题

echo "🔧 路由器配置修复工具"
echo "===================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ROUTER_CONFIG="$HOME/.claude-code-router/config.json"

# 检查路由器配置是否存在
if [ ! -f "$ROUTER_CONFIG" ]; then
    echo -e "${YELLOW}⚠️ 路由器配置文件不存在: $ROUTER_CONFIG${NC}"
    echo ""
    echo "请先切换到路由器配置以生成配置文件："
    echo "  claude-switch glm-router"
    echo "  claude-switch deepseek-router"
    echo "  claude-switch minimax-router"
    exit 1
fi

echo "📋 检查当前配置..."
echo ""

# 检查API端点是否有问题（根据 issue #398 的正确配置）
# GLM 必须包含 /chat/completions，缺少的是错误的
GLM_WRONG=0
if grep -q "bigmodel.cn/api/paas/v4\"" "$ROUTER_CONFIG" 2>/dev/null; then
    # 找到了不包含 /chat/completions 的配置（缺少后缀）
    GLM_WRONG=1
fi

# DeepSeek 不应包含 /v1/ 前缀
DEEPSEEK_WRONG=$(grep -c "deepseek.com/v1/chat/completions" "$ROUTER_CONFIG" 2>/dev/null || echo "0")

# MiniMax 不应该是旧的 v1/text/chatcompletion 端点
MINIMAX_WRONG=$(grep -c "minimaxi.com/v1/text/chatcompletion" "$ROUTER_CONFIG" 2>/dev/null || echo "0")

TOTAL_ISSUES=$((GLM_WRONG + DEEPSEEK_WRONG + MINIMAX_WRONG))

if [ $TOTAL_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ 配置文件正确，无需修复！${NC}"
    echo ""
    echo "当前API端点配置："
    cat "$ROUTER_CONFIG" | grep "api_base_url" | head -3
    exit 0
fi

echo -e "${RED}❌ 发现 $TOTAL_ISSUES 个API端点错误！${NC}"
echo ""

if [ $GLM_WRONG -gt 0 ]; then
    echo -e "${YELLOW}⚠️ GLM API端点缺少/chat/completions后缀：${NC}"
    echo "   错误: https://open.bigmodel.cn/api/paas/v4"
    echo "   正确: https://open.bigmodel.cn/api/paas/v4/chat/completions"
    echo "   参考: https://github.com/musistudio/claude-code-router/issues/398"
    echo ""
fi

if [ $DEEPSEEK_WRONG -gt 0 ]; then
    echo -e "${YELLOW}⚠️ DeepSeek API端点包含不必要的/v1/前缀：${NC}"
    echo "   错误: https://api.deepseek.com/v1/chat/completions"
    echo "   正确: https://api.deepseek.com/chat/completions"
    echo ""
fi

if [ $MINIMAX_WRONG -gt 0 ]; then
    echo -e "${YELLOW}⚠️ MiniMax API端点使用了旧的API格式：${NC}"
    echo "   错误: https://api.minimaxi.com/v1/text/chatcompletion*"
    echo "   正确: https://api.minimaxi.com/anthropic"
    echo ""
fi

echo "===================="
echo "修复方案："
echo "===================="
echo ""
echo "方案1：删除并重新生成（推荐）"
echo "  1. 停止路由器: ccr stop"
echo "  2. 删除配置: rm ~/.claude-code-router/config.json"
echo "  3. 重新切换: claude-switch glm-router"
echo "  4. 启动路由器: ccr start"
echo ""
echo "方案2：手动修改配置文件"
echo "  nano ~/.claude-code-router/config.json"
echo ""
echo -n "是否自动执行方案1？(y/N): "
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo ""
    echo "🔄 开始自动修复..."
    echo ""

    # 停止路由器
    echo "1. 停止路由器..."
    if command -v ccr >/dev/null 2>&1; then
        ccr stop 2>/dev/null || true
        echo -e "${GREEN}✅ 路由器已停止${NC}"
    else
        echo -e "${YELLOW}⚠️ ccr命令未找到，跳过停止步骤${NC}"
    fi
    echo ""

    # 备份旧配置
    echo "2. 备份旧配置..."
    BACKUP_FILE="$HOME/.claude-code-router/config.json.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$ROUTER_CONFIG" "$BACKUP_FILE"
    echo -e "${GREEN}✅ 已备份到: $BACKUP_FILE${NC}"
    echo ""

    # 删除旧配置
    echo "3. 删除旧配置..."
    rm "$ROUTER_CONFIG"
    echo -e "${GREEN}✅ 已删除旧配置${NC}"
    echo ""

    # 获取当前配置名称
    CURRENT_CONFIG=$(claude-switch status 2>/dev/null | grep "当前配置:" | awk '{print $2}')
    if [ -z "$CURRENT_CONFIG" ]; then
        CURRENT_CONFIG="glm-router"
    fi

    echo "4. 重新生成配置..."
    echo "   当前配置: $CURRENT_CONFIG"
    echo ""

    # 重新切换配置
    claude-switch "$CURRENT_CONFIG"

    echo ""
    echo "5. 验证新配置..."
    if [ -f "$ROUTER_CONFIG" ]; then
        echo -e "${GREEN}✅ 新配置已生成${NC}"
        echo ""
        echo "API端点："
        cat "$ROUTER_CONFIG" | grep "api_base_url"
        echo ""

        # 启动路由器
        echo "6. 启动路由器..."
        if command -v ccr >/dev/null 2>&1; then
            ccr start
            echo -e "${GREEN}✅ 路由器已启动${NC}"
        else
            echo -e "${YELLOW}⚠️ 请手动启动路由器: ccr start${NC}"
        fi
    else
        echo -e "${RED}❌ 配置生成失败${NC}"
        echo "请手动切换配置: claude-switch $CURRENT_CONFIG"
    fi

    echo ""
    echo -e "${GREEN}🎉 修复完成！${NC}"
else
    echo ""
    echo "已取消自动修复"
    echo "请手动执行修复步骤"
fi
