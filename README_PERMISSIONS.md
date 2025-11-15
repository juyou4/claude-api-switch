# Claude API Switch 权限问题完整解决方案

## 问题描述

用户报告在使用csen/cscn命令时遇到权限错误：
```
cp: cannot create regular file '/home/ubuntu/.claude/settings.json': Permission denied
```

## 问题分析

### 根本原因
1. **系统权限限制** - 某些环境中的安全策略或文件系统限制禁止写入~/.claude/目录
2. **文件系统权限异常** - overlay文件系统或sandbox环境可能限制写入操作
3. **SELinux/AppArmor限制** - 安全模块可能阻止文件写入

### 验证方法
```bash
# 测试基本写入权限
touch ~/.claude/test-write

# 测试settings.json写入
echo '{"test": "write"}' > ~/.claude/settings.json

# 运行权限诊断脚本
./diagnose_permissions.sh
```

## 解决方案

### 方案1：运行权限诊断脚本（推荐）

```bash
# 在项目目录中运行
cd claude-api-switch
./diagnose_permissions.sh
```

脚本将自动检测并提供针对性的解决方案。

### 方案2：手动修复权限

```bash
# 修复.claude目录权限
chmod 755 ~/.claude

# 修复settings.json权限
chmod 644 ~/.claude/settings.json 2>/dev/null || true

# 重新测试
./claude-switch en-ui
```

### 方案3：使用备用配置路径

```bash
# 设置备用配置目录环境变量
export CLAUDE_CONFIG_DIR="$HOME/.claude-config"

# 创建备用目录
mkdir -p "$CLAUDE_CONFIG_DIR"

# 测试配置切换
./claude-switch en-ui
```

### 方案4：完全环境变量方式（无文件写入）

```bash
# 直接设置环境变量
export ANTHROPIC_AUTH_TOKEN="your-api-key"
export ANTHROPIC_BASE_URL="https://your-endpoint.com/anthropic"
export ANTHROPIC_DEFAULT_SONNET_MODEL="your-model"

# 配置将自动应用到Claude CLI
```

## 增强功能

### 自动fallback机制
claude-switch现已内置智能fallback机制：

1. **主路径尝试** - 首先尝试写入~/.claude/settings.json
2. **备用路径尝试** - 失败时自动使用~/.claude-config/settings.json
3. **详细错误报告** - 提供具体的诊断信息和解决建议

### 错误诊断信息
当遇到权限问题时，脚本会显示：
```
⚠️  主配置路径写入失败，尝试备用路径
❌ 切换失败: 无法写入配置文件
   主路径: /home/ubuntu/.claude/settings.json
   备用路径: /home/ubuntu/.claude-config/settings.json

💡 可能的解决方案:
   1. 检查 ~/.claude/ 目录权限: chmod 755 ~/.claude
   2. 运行权限诊断脚本: ./diagnose_permissions.sh
   3. 尝试手动设置环境变量
```

## 环境变量配置

### 完整环境变量列表
```bash
# API认证
export ANTHROPIC_AUTH_TOKEN="your-api-key"

# API端点
export ANTHROPIC_BASE_URL="https://your-endpoint.com/anthropic"

# 模型配置
export ANTHROPIC_DEFAULT_SONNET_MODEL="your-sonnet-model"
export ANTHROPIC_DEFAULT_OPUS_MODEL="your-opus-model"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="your-haiku-model"

# 超时设置
export API_TIMEOUT_MS="3000000"
```

### 语言配置环境变量
```bash
# 英文界面
export UI_LANGUAGE="en-US"
export INTERFACE_LANGUAGE="english"
export DISPLAY_LANGUAGE="English"
export PROMPT_LANGUAGE="english"
export SYSTEM_MESSAGES_LANGUAGE="en-US"

# 中文界面
export UI_LANGUAGE="zh-CN"
export INTERFACE_LANGUAGE="chinese"
export DISPLAY_LANGUAGE="中文"
export PROMPT_LANGUAGE="chinese"
export SYSTEM_MESSAGES_LANGUAGE="zh-CN"
```

## 故障排除

### 常见错误及解决方案

#### 错误1: Permission denied
```bash
# 解决方案
sudo chown -R $USER:$USER ~/.claude
chmod 755 ~/.claude
```

#### 错误2: Read-only file system
```bash
# 检查文件系统状态
mount | grep $(dirname ~/.claude)

# 解决方案：使用备用路径
export CLAUDE_CONFIG_DIR="$HOME/claude-config"
mkdir -p "$CLAUDE_CONFIG_DIR"
```

#### 错误3: SELinux denial
```bash
# 检查SELinux状态
sestatus

# 临时禁用SELinux（需要管理员权限）
sudo setenforce 0

# 永久解决方案：设置SELinux策略
sudo semanage fcontext -a -t home_root_t "/home/[^/]+/.claude(/.*)?"
sudo restorecon -R ~/.claude
```

#### 错误4: AppArmor restriction
```bash
# 检查AppArmor状态
sudo apparmor_status

# 解决方案：修改AppArmor配置或使用备用路径
```

## 验证步骤

### 1. 基本功能验证
```bash
# 测试配置切换
./claude-switch en-ui
./claude-switch zh-ui
./claude-switch glm
```

### 2. 环境变量验证
```bash
# 检查环境变量
env | grep ANTHROPIC

# 检查当前配置
./claude-switch status
```

### 3. 文件权限验证
```bash
# 检查配置文件权限
ls -la ~/.claude/settings.json
ls -la ~/.claude-config/settings.json

# 测试写入权限
echo '{"test": "ok"}' > ~/.claude/test-write
rm -f ~/.claude/test-write
```

## 技术支持

如果以上解决方案都无法解决您的问题，请：

1. **收集诊断信息**：
   ```bash
   ./diagnose_permissions.sh > diagnose_output.txt 2>&1
   ```

2. **提供环境信息**：
   ```bash
   uname -a > system_info.txt
   ls -la ~/.claude/ >> system_info.txt
   mount >> system_info.txt
   ```

3. **联系技术支持**：
   将上述诊断文件提交到项目Issues页面。

## 预防措施

### 定期维护
```bash
# 定期检查权限
./diagnose_permissions.sh

# 备份配置
cp ~/.claude/settings.json ~/.claude/settings.json.backup
```

### 最佳实践
1. 定期运行权限诊断脚本
2. 保持配置文件备份
3. 使用环境变量进行临时配置
4. 监控系统权限变化

这个完整的解决方案应该能够处理大多数权限相关的问题，并提供多种fallback选项确保工具的正常使用。