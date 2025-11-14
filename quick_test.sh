#!/bin/bash

echo "🧪 Claude API Switch 快速测试"
echo "=================================="

# 检查claude-switch是否存在
if [ ! -f "./claude-switch" ]; then
    echo "❌ 错误: 在当前目录中找不到claude-switch文件"
    echo "请确保在正确的项目目录中运行此脚本"
    exit 1
fi

echo "✅ 找到claude-switch文件"

# 检查配置文件
if [ ! -d "$HOME/.claude/configs" ]; then
    echo "❌ 错误: 找不到配置目录"
    echo "请先运行 ./install.sh 安装配置"
    exit 1
fi

echo "✅ 配置目录存在"

# 测试语言配置
echo ""
echo "🌐 测试语言配置切换..."

echo "📝 测试英文界面切换:"
./claude-switch en-ui

echo ""
echo "📝 测试中文界面切换:"
./claude-switch zh-ui

echo ""
echo "📝 测试API配置切换:"
./claude-switch glm

echo ""
echo "✅ 所有测试完成！"
echo ""
echo "💡 使用提示："
echo "   • 在新终端中运行: source ~/.bashrc 来加载别名"
echo "   • 或者手动设置: alias csen='./claude-switch en-ui'"
echo "   • 然后就可以使用: csen 和 cscn 命令"