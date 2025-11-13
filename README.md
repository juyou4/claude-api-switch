# Claude API Switch

<p align="center">
  <a href="README.md">
    <img src="https://img.shields.io/badge/📖-文档-中文-red.svg" alt="中文文档">
  </a>
  &nbsp;
  <a href="README.en.md">
    <img src="https://img.shields.io/badge/📖-Documentation-English-blue.svg" alt="English Documentation">
  </a>
</p>

一个简洁、高效的 Claude CLI API 配置切换工具，专为远程环境和开发者设计。

## ✨ 特性

- 🚀 **快速切换** - 一键切换多个 Claude API 提供商
- 💻 **CLI友好** - 纯命令行界面，适合远程服务器环境
- 🎯 **简单配置** - 标准化的 JSON 配置文件
- 🔧 **Shell集成** - 提供便捷的别名和自动补全
- 📦 **即装即用** - 自动化安装脚本
- 🛡️ **安全可靠** - 配置验证和错误处理
- 🌍 **环境变量覆盖** - 支持通过环境变量动态调整配置
- 🎨 **交互式创建** - 图形化配置创建向导
- 🔍 **智能验证** - API端点和配置完整性检查
- 💾 **自动备份** - 配置修改前自动备份保护

## 🏗️ 项目结构

```
claude-api-switch/
├── claude-switch          # 主脚本文件
├── install.sh            # 自动安装脚本
├── README.md             # 项目文档
├── LICENSE               # 开源协议
└── configs/              # 预设配置文件
    ├── glm.json          # GLM (智谱AI) 配置
    ├── kimi2.json        # Kimi2 (月之暗面) 配置
    ├── minimax.json      # MiniMax 配置
    ├── deepseek.json     # DeepSeek 配置
    ├── qwen.json         # 通义千问 配置
    ├── hunyuan.json      # 腾讯混元 配置
    ├── doubao.json       # 豆包 配置
    ├── ernie.json        # 文心一言 配置
    ├── sensenova.json    # 商汤SenseNova 配置
    └── anthropic-official.json  # Claude官方 配置
```

## 🚀 快速开始

### 安装

1. **克隆项目**
   ```bash
   git clone https://github.com/your-username/claude-api-switch.git
   cd claude-api-switch
   ```

2. **运行安装脚本**
   ```bash
   ./install.sh
   ```

3. **重新加载Shell配置**
   ```bash
   source ~/.bashrc  # 或 source ~/.zshrc
   ```

### 基本使用

```bash
# 显示交互式菜单
claude-switch

# 列出所有可用配置
claude-switch list

# 切换到指定配置
claude-switch glm                # 切换到GLM
claude-switch kimi2              # 切换到Kimi2 (旧版)
claude-switch kimi-cn            # 切换到Kimi中国版
claude-switch kimi-global        # 切换到Kimi国际版
claude-switch minimax            # 切换到MiniMax M2.1
claude-switch deepseek           # 切换到DeepSeek V3.1
claude-switch qwen               # 切换到通义千问
claude-switch hunyuan            # 切换到腾讯混元
claude-switch doubao             # 切换到豆包
claude-switch ernie              # 切换到文心一言
claude-switch sensenova          # 切换到商汤SenseNova
claude-switch anthropic-official # 切换到Claude官方

# 语言界面切换
claude-switch zh-ui            # 切换到中文界面
claude-switch en-ui            # 切换到英文界面

# 显示当前配置状态
claude-switch status

# 高级配置管理
claude-switch create            # 启动交互式配置创建向导
claude-switch save <名称>        # 保存当前配置为新配置
claude-switch delete <名称>      # 删除指定配置
claude-switch backup            # 备份当前配置
```

## 🎨 高级功能

### 交互式配置创建

使用内置向导快速创建新的API配置：

```bash
claude-switch create
```

创建向导支持三种方式：
1. **基于模板** - 从现有提供商模板创建
2. **基于当前配置** - 复制当前Claude配置
3. **完全自定义** - 手动输入所有配置参数

### 环境变量覆盖

支持通过环境变量动态覆盖配置参数，优先级高于配置文件：

```bash
# 覆盖API密钥
export ANTHROPIC_AUTH_TOKEN="your-api-key"

# 覆盖API端点
export ANTHROPIC_BASE_URL="https://your-api-endpoint.com/anthropic"

# 覆盖默认模型
export ANTHROPIC_DEFAULT_SONNET_MODEL="your-model"

# 设置API超时（毫秒）
export API_TIMEOUT_MS="6000000"

# 切换配置时自动应用环境变量覆盖
claude-switch glm
```

### 智能配置验证

自动验证配置的完整性和正确性：

- ✅ API端点格式检查
- ✅ 模型名称验证
- ✅ 配置文件结构验证
- ✅ 必要字段完整性检查

### 自动备份保护

重要操作前自动创建备份：

```bash
# 每次切换配置前自动备份
claude-switch backup
```

备份位置：`~/.claude/backups/settings.backup.TIMESTAMP.json`

## 📋 快捷别名

安装后自动配置以下别名：

```bash
cs                    # 显示交互式菜单
csglm                 # 切换到GLM
cskimi                # 切换到Kimi2
csminimax             # 切换到MiniMax
cslist                # 列出所有配置
csstatus              # 显示当前状态

# 语言切换别名
cscn                  # 切换到中文界面
csen                  # 切换到英文界面
cslang                # 列出语言配置
```

### 配置管理命令

```bash
cscreate              # 启动交互式配置创建向导
cssave <名称>         # 保存当前配置为新配置
csdelete <名称>       # 删除指定配置（需要确认）
csbackup              # 备份当前配置
```

**示例用法**：

```bash
# 创建新配置
cscreate

# 保存当前配置到自定义名称
cssave my-custom-config

# 删除不需要的配置
csdelete old-config

# 定期备份配置
csbackup
```

## 🔧 配置说明

### 支持的API提供商

#### 1. GLM (智谱AI)
- **API端点**: `https://open.bigmodel.cn/api/anthropic`
- **模型**: glm-4.6, glm-4.5-air, glm-4-flash
- **配置文件**: `configs/glm.json`

#### 2. Kimi2 (月之暗面)
- **API端点**: `https://api.kimi.com/coding/`
- **模型**: kimi-for-coding
- **配置文件**: `configs/kimi2.json`

#### 3. MiniMax M2.1
- **API端点**: `https://api.minimaxi.com/anthropic`
- **模型**: MiniMax-M2 (高性能编程模型)
- **配置文件**: `configs/minimax.json`
- **特点**: 官方限时免费，超长超时设置

#### 4. DeepSeek V3.1
- **API端点**: `https://api.deepseek.com/anthropic`
- **模型**: deepseek-chat-v3.1, deepseek-coder, deepseek-reasoner
- **配置文件**: `configs/deepseek.json`
- **特点**: V3.1版本增强Claude API支持，性价比极高

#### 5. 通义千问 (阿里云)
- **API端点**: `https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy`
- **模型**: qwen3-coder-plus (Claude Code专用)
- **配置文件**: `configs/qwen.json`
- **特点**: 每天免费2000次，仅支持专用模型

#### 6. 腾讯混元
- **API端点**: `https://hunyuan.tencentcloudapi.com/anthropic`
- **模型**: hunyuan-standard, hunyuan-lite, hunyuan-pro
- **配置文件**: `configs/hunyuan.json`
- **特点**: 需要腾讯云API密钥和TC3签名

#### 7. 豆包 (字节跳动)
- **API端点**: `https://ark.cn-beijing.volces.com/api/v3/anthropic`
- **模型**: Doubao-Seed-Code (编程专用)
- **配置文件**: `configs/doubao.json`
- **特点**: 9.9元/月，原生Claude兼容

#### 8. Kimi (月之暗面)
- **中国用户**: `configs/kimi-cn.json` - `https://api.moonshot.cn/anthropic`
- **国际用户**: `configs/kimi-global.json` - `https://api.moonshot.ai/anthropic`
- **模型**: kimi-for-coding, moonshot-v1-8k/32k/128k
- **特点**: API Key区分中国/国际站点，不兼容

#### 8. 文心一言 (百度)
- **API端点**: `https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/anthropic`
- **模型**: ernie-4.0-8k/128k, ernie-3.5-8k/128k, ernie-speed-8k/128k
- **配置文件**: `configs/ernie.json`
- **特点**: 需要OAuth2认证流程

#### 9. 商汤SenseNova
- **API端点**: `https://api.sensenova.cn/v1/anthropic`
- **模型**: SenseChat-5, SenseChat-3, SenseChat-Turbo, SenseChat-Lite
- **配置文件**: `configs/sensenova.json`
- **特点**: 商汤日日新大模型平台

#### 10. Claude Official (Anthropic)
- **API端点**: `https://api.anthropic.com`
- **模型**: claude-3-5-sonnet-20241022, claude-3-opus, claude-3-haiku
- **配置文件**: `configs/anthropic-official.json`
- **特点**: 官方API，最高质量保证

### 11. UI语言配置

#### 中文界面 (zh-ui)
- **配置文件**: `configs/zh-ui.json`
- **UI语言**: 中文 (zh-CN)
- **用途**: 为中文用户提供熟悉的界面环境
- **快捷命令**: `cscn` 或 `claude-switch zh-ui`
- **特点**:
  - 完整的中文环境变量设置
  - 适用于需要中文界面的用户
  - 包含系统消息和提示语言配置

#### 英文界面 (en-ui)
- **配置文件**: `configs/en-ui.json`
- **UI语言**: 英文 (en-US)
- **用途**: 为英文用户提供标准的界面环境
- **快捷命令**: `csen` 或 `claude-switch en-ui`
- **特点**:
  - 标准的英文环境变量设置
  - 适用于偏好英文界面的用户
  - 符合国际化标准

### 配置API密钥

在使用前，请确保配置了正确的API密钥：

```bash
# 方法1: 直接编辑配置文件
nano ~/.claude/configs/glm.json

# 方法2: 使用环境变量（临时）
export ANTHROPIC_AUTH_TOKEN="your-api-key-here"

# 方法3: 创建新配置保存当前设置
cscreate my-config
```

### 配置文件格式

```json
{
  "name": "provider-name",
  "display_name": "显示名称",
  "provider": "provider-type",
  "description": "提供商描述",
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-api-key",
    "ANTHROPIC_BASE_URL": "https://api.example.com/anthropic",
    "API_TIMEOUT_MS": "3000000",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "model-name"
  },
  "models": {
    "model-name": "模型描述"
  },
  "default_model": "default-model-name",
  "metadata": {
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z",
    "version": "1.0"
  }
}
```

## 🎯 使用场景

### 1. 开发环境切换
```bash
# 在不同项目间快速切换API提供商
csglm      # 使用GLM进行中文处理
cskimi     # 使用Kimi进行编程任务
csminimax  # 使用MiniMax进行通用对话
```

### 2. 成本优化
```bash
# 根据任务复杂度选择不同模型
claude-switch glm        # 使用主力模型处理复杂任务
claude-switch minimax    # 使用轻量模型处理简单任务
```

### 3. 备份和恢复
```bash
# 备份当前配置
csbackup

# 创建自定义配置
cscreate work-project

# 在不同配置间切换
claude-switch work-project
```

## 🛠️ 高级功能

### 交互式菜单

运行 `claude-switch` 不带参数时，会显示交互式菜单：

```
Claude CLI 配置管理
==================

当前配置状态:
==================
当前配置: glm

配置详情:
  ANTHROPIC_AUTH_TOKEN: 532e892690664ce2a02cda274776bd81.5ZGvUOh8DqbEcyJX
  ANTHROPIC_BASE_URL: https://open.bigmodel.cn/api/anthropic
  API_TIMEOUT_MS: 3000000
  ANTHROPIC_DEFAULT_OPUS_MODEL: glm-4.6
  ANTHROPIC_DEFAULT_SONNET_MODEL: glm-4.6
  ANTHROPIC_DEFAULT_HAIKU_MODEL: glm-4.5-air

可用操作:
  1. 切换配置
  2. 保存当前配置
  3. 列出所有配置
  4. 删除配置
  5. 备份当前配置
  6. 退出
```

### 配置验证

工具会自动验证配置文件的JSON格式和环境变量设置：

```bash
$ claude-switch invalid-config
错误: 配置文件格式无效
```

### 错误处理

- **配置文件不存在**: 提供清晰的错误信息和使用建议
- **JSON格式错误**: 验证配置文件格式并给出具体错误
- **权限问题**: 检查文件和目录权限
- **API连接失败**: 提供网络和认证相关的调试信息

## 🔧 自定义配置

### 添加新的API提供商

1. **创建配置文件**
   ```bash
   nano ~/.claude/configs/new-provider.json
   ```

2. **使用标准格式**
   ```json
   {
     "name": "new-provider",
     "display_name": "New Provider",
     "provider": "custom",
     "description": "自定义API提供商",
     "env": {
       "ANTHROPIC_AUTH_TOKEN": "your-token",
       "ANTHROPIC_BASE_URL": "https://api.new-provider.com/anthropic",
       "ANTHROPIC_DEFAULT_SONNET_MODEL": "model-name"
     },
     "models": {
       "model-name": "模型描述"
     },
     "default_model": "model-name"
   }
   ```

3. **切换到新配置**
   ```bash
   claude-switch new-provider
   ```

### 环境变量覆盖

可以通过环境变量临时覆盖配置：

```bash
export ANTHROPIC_AUTH_TOKEN="temporary-token"
export ANTHROPIC_BASE_URL="https://custom-endpoint.com"
claude-switch status
```

## 📁 文件位置

- **主脚本**: `~/.local/bin/claude-switch`
- **配置文件**: `~/.claude/settings.json`
- **预设配置**: `~/.claude/configs/`
- **备份文件**: `~/.claude/backups/`
- **Shell配置**: `~/.bashrc` 或 `~/.zshrc`

## 🔄 卸载

```bash
# 运行卸载脚本
./install.sh --uninstall

# 或手动删除
rm ~/.local/bin/claude-switch
rm -rf ~/.claude/configs/
# 手动从Shell配置文件中删除相关别名
```

## 🐛 故障排除

### 常见问题

1. **命令未找到**
   ```bash
   # 检查PATH
   echo $PATH | grep ~/.local/bin

   # 重新加载Shell配置
   source ~/.bashrc
   ```

2. **权限错误**
   ```bash
   # 确保脚本可执行
   chmod +x ~/.local/bin/claude-switch

   # 检查配置目录权限
   ls -la ~/.claude/
   ```

3. **配置格式错误**
   ```bash
   # 验证JSON格式
   jq empty ~/.claude/configs/glm.json

   # 查看详细错误
   claude-switch status
   ```

4. **API连接失败**
   ```bash
   # 检查网络连接
   curl -I https://api.example.com/anthropic

   # 测试认证令牌
   export ANTHROPIC_AUTH_TOKEN="your-token"
   claude-switch status
   ```

5. **环境变量覆盖不生效**
   ```bash
   # 检查环境变量设置
   env | grep ANTHROPIC_

   # 重新设置环境变量
   export ANTHROPIC_AUTH_TOKEN="new-token"
   export ANTHROPIC_BASE_URL="new-endpoint"
   claude-switch your-config
   ```

6. **配置创建向导问题**
   ```bash
   # 确保在交互式终端中运行
   claude-switch create

   # 检查输入超时设置
   # 如在脚本中使用，请提供输入管道
   echo -e "config-name\n1\n1\n" | claude-switch create
   ```

### 调试技巧

- **查看详细输出**: 使用 `claude-switch status` 查看完整配置信息
- **配置验证**: 切换配置时会自动验证，注意查看警告信息
- **备份恢复**: 从 `~/.claude/backups/` 目录恢复之前的配置
- **环境变量优先**: 环境变量优先级高于配置文件，可用于临时测试

## 📝 更新日志

### v2.0.0 (最新)
- ✨ **新增交互式配置创建向导** - 支持模板、当前配置和自定义三种创建方式
- 🌍 **环境变量覆盖机制** - 支持动态覆盖配置参数，优先级高于配置文件
- 🔍 **智能配置验证** - 自动验证API端点格式、模型名称和配置完整性
- 💾 **自动备份保护** - 重要操作前自动创建配置备份
- 🛡️ **增强错误处理** - 超时保护、输入验证、友好的错误信息
- 🎨 **改进用户体验** - 更清晰的输出格式和状态指示

### v1.0.0
- 🚀 初始版本发布
- 📦 支持多个主流API提供商
- 🔧 Shell集成和自动补全
- 🛡️ 基础配置验证和错误处理

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**🎉 享受高效的 Claude API 配置管理体验！**
