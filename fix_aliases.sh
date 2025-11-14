#!/bin/bash

# Claude API Switch 别名修复脚本
# 用于修复csen/cscn命令无法使用的问题

echo "🔧 修复Claude API Switch别名配置..."

# 添加语言切换别名到用户的.bashrc
echo "" >> ~/.bashrc
echo "# Claude API Switch 语言切换别名 (由fix_aliases.sh添加)" >> ~/.bashrc
echo "alias csen='claude-switch en-ui'" >> ~/.bashrc
echo "alias cscn='claude-switch zh-ui'" >> ~/.bashrc
echo "alias cs='claude-switch'" >> ~/.bashrc
echo "alias cslist='claude-switch list'" >> ~/.bashrc
echo "alias csstatus='claude-switch status'" >> ~/.bashrc

echo "✅ 别名配置已添加到 ~/.bashrc"
echo ""
echo "📝 请执行以下步骤激活别名："
echo "   1. 重新打开终端，或者"
echo "   2. 执行: source ~/.bashrc"
echo ""
echo "🎯 然后就可以使用以下命令："
echo "   • csen - 切换到英文界面"
echo "   • cscn - 切换到中文界面"
echo "   • cs - 显示交互菜单"
echo "   • cslist - 列出所有配置"
echo "   • csstatus - 显示当前状态"