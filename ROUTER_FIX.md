# 路由器配置修复报告

## 🔍 问题概述

在使用路由器配置时，发现所有路由器配置文件中的 `ANTHROPIC_BASE_URL` 设置错误，导致API调用404错误。

### 错误的配置
```json
"ANTHROPIC_BASE_URL": "http://localhost:3456/v1"
```

### 正确的配置
```json
"ANTHROPIC_BASE_URL": "http://127.0.0.1:3456"
```

## 🔧 问题原因

### 1. **路径冲突错误**
- 路由器监听在端口 3456 (`http://127.0.0.1:3456`)
- Claude Code 自动添加路径 `/v1/messages`
- 错误配置导致最终URL变成：`http://127.0.0.1:3456/v1/v1/messages` → **404错误**
- 正确配置最终URL：`http://127.0.0.1:3456/v1/messages` → **成功**

### 2. **环境变量覆盖**
- `apply_config_with_env_overrides()` 函数优先使用环境变量
- 即使配置文件修复，如果环境变量未清除，仍会使用旧值
- 需要清除环境变量：`unset ANTHROPIC_BASE_URL ANTHROPIC_DEFAULT_OPUS_MODEL`

## ✅ 修复内容

### 修复的配置文件

#### 源码目录 (6个文件)
1. `/home/ubuntu/project/TanSH/claude-api-switch/configs/glm-router.json`
2. `/home/ubuntu/project/TanSH/claude-api-switch/configs/deepseek-router.json`
3. `/home/ubuntu/project/TanSH/claude-api-switch/configs/minimax-router.json`
4. `/home/ubuntu/project/TanSH/claude-api-switch-PUE/configs/glm-router.json`
5. `/home/ubuntu/project/TanSH/claude-api-switch-PUE/configs/deepseek-router.json`
6. `/home/ubuntu/project/TanSH/claude-api-switch-PUE/configs/minimax-router.json`

#### 用户配置目录 (3个文件)
1. `~/.claude/configs/glm-router.json`
2. `~/.claude/configs/deepseek-router.json`
3. `~/.claude/configs/minimax-router.json`

#### 脚本文件 (1个文件)
- `/home/ubuntu/project/TanSH/claude-api-switch/claude-switch:484`
  - 修改endpoint显示从 `http://localhost:3456/v1` 到 `http://127.0.0.1:3456`

### 修复命令
```bash
# 修复源码目录
sed -i 's|http://localhost:3456/v1|http://127.0.0.1:3456|g' \
  /home/ubuntu/project/TanSH/claude-api-switch/configs/*router*.json \
  /home/ubuntu/project/TanSH/claude-api-switch-PUE/configs/*router*.json

# 修复用户配置目录
sed -i 's|http://localhost:3456/v1|http://127.0.0.1:3456|g' \
  ~/.claude/configs/*router*.json

# 修复脚本显示
sed -i 's|http://localhost:3456/v1|http://127.0.0.1:3456|g' \
  /home/ubuntu/project/TanSH/claude-api-switch/claude-switch
```

## 🚀 使用方法

### 1. 确保路由器已安装和启动
```bash
# 安装路由器
claude-switch setup-router

# 启动路由器
claude-switch start-router

# 检查状态
claude-switch router-status
```

### 2. 切换到路由器配置
```bash
# 清除可能冲突的环境变量
unset ANTHROPIC_BASE_URL ANTHROPIC_DEFAULT_OPUS_MODEL ANTHROPIC_DEFAULT_SONNET_MODEL ANTHROPIC_DEFAULT_HAIKU_MODEL

# 切换到路由器配置
claude-switch glm-router      # GLM路由器
claude-switch deepseek-router # DeepSeek路由器
claude-switch minimax-router  # MiniMax路由器
```

### 3. 验证配置
```bash
# 检查当前配置
claude-switch status

# 应该看到：
# ANTHROPIC_BASE_URL: http://127.0.0.1:3456
```

## 📝 验证结果

### 测试命令
```bash
claude-switch router-status
```

### 预期输出
```
✅ Router is installed
✅ Running

Router Configurations:
  deepseek-router  - DeepSeek (路由器-思考模式)
  glm-router       - 智谱GLM (路由器-思考模式)
  minimax-router   - MiniMax (路由器-思考模式)

✅ Router is ready!
```

### 配置切换测试
```bash
# 切换到GLM路由器
claude-switch glm-router

# 预期输出
✅ 已切换到配置: glm-router
  BASE_URL: http://127.0.0.1:3456
  MODEL: glm-4.6-thinking
```

## 🔄 常见问题

### Q: 切换配置后 BASE_URL 还是显示错误？
A: 环境变量覆盖了配置文件。需要清除环境变量：
```bash
unset ANTHROPIC_BASE_URL ANTHROPIC_DEFAULT_OPUS_MODEL ANTHROPIC_DEFAULT_SONNET_MODEL ANTHROPIC_DEFAULT_HAIKU_MODEL
```

### Q: 如何验证路由器配置是否正确？
A: 检查配置状态：
```bash
claude-switch status | grep ANTHROPIC_BASE_URL
# 应该显示：http://127.0.0.1:3456
```

### Q: 如果路由器服务未启动会怎样？
A: 配置切换会成功，但API调用会失败。确保先启动路由器：
```bash
claude-switch start-router
```

## 📚 参考资源

- **路由器项目**: https://github.com/musistudio/claude-code-router
- **默认端口**: 3456
- **官方文档**: 路由器默认端点为 `http://127.0.0.1:3456`

## 📅 修复时间
**日期**: 2025-11-17
**版本**: v2.3.0 路由器管理功能
**状态**: ✅ 已完成并测试通过

---
**注意**: 此修复确保所有用户都能正确使用路由器功能，不再遇到 `/v1/v1` 路径冲突错误。