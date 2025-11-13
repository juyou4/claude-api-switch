# Claude API Switch

<p align="center">
  <a href="README.md">
    <img src="https://img.shields.io/badge/docs-chinese-red" alt="Chinese Docs">
  </a>
  &nbsp;
  <a href="README.en.md">
    <img src="https://img.shields.io/badge/docs-english-blue" alt="English Docs">
  </a>
</p>

A concise, efficient Claude CLI API configuration switching tool designed for remote environments and developers.

## ✨ Features

- 🚀 **Quick Switching** - One-click switching between multiple Claude API providers
- 💻 **CLI-Friendly** - Pure command-line interface, perfect for remote server environments
- 🎯 **Simple Configuration** - Standardized JSON configuration files
- 🔧 **Shell Integration** - Convenient aliases and auto-completion
- 📦 **Plug and Play** - Automated installation script
- 🛡️ **Security & Reliability** - Configuration validation and error handling
- 🌍 **Environment Variable Override** - Dynamic configuration adjustment via environment variables
- 🎨 **Interactive Creation** - Graphical configuration creation wizard
- 🔍 **Smart Validation** - API endpoint and configuration integrity checking
- 💾 **Auto Backup** - Automatic backup protection before configuration changes

## 🏗️ Project Structure

```
claude-api-switch/
├── claude-switch          # Main script file
├── install.sh            # Auto-installation script
├── README.md             # Chinese project documentation (main)
├── README.en.md          # English project documentation
├── LICENSE               # Open source license
└── configs/              # Preset configuration files
    ├── glm.json          # GLM (Zhipu AI) configuration
    ├── kimi2.json        # Kimi2 (Moonshot AI) configuration
    ├── minimax.json      # MiniMax configuration
    ├── deepseek.json     # DeepSeek configuration
    ├── qwen.json         # Qwen (Alibaba) configuration
    ├── hunyuan.json      # Tencent Hunyuan configuration
    ├── doubao.json       # Doubao (ByteDance) configuration
    ├── ernie.json        # Ernie (Baidu) configuration
    ├── sensenova.json    # SenseNova (SenseTime) configuration
    ├── anthropic-official.json  # Claude Official configuration
    ├── zh-ui.json        # Chinese UI configuration
    └── en-ui.json        # English UI configuration
```

## 🚀 Quick Start

### Installation

1. **Clone the project**
   ```bash
   git clone https://github.com/juyou4/claude-api-switch.git
   cd claude-api-switch
   ```

2. **Run the installation script**
   ```bash
   ./install.sh
   ```

3. **Reload Shell configuration**
   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

### Basic Usage

```bash
# Display interactive menu
claude-switch

# List all available configurations
claude-switch list

# Switch to specific configuration
claude-switch glm                # Switch to GLM
claude-switch kimi2              # Switch to Kimi2 (legacy)
claude-switch kimi-cn            # Switch to Kimi China version
claude-switch kimi-global        # Switch to Kimi International version
claude-switch minimax            # Switch to MiniMax M2.1
claude-switch deepseek           # Switch to DeepSeek V3.1
claude-switch qwen               # Switch to Qwen
claude-switch hunyuan            # Switch to Tencent Hunyuan
claude-switch doubao             # Switch to Doubao
claude-switch ernie              # Switch to Ernie
claude-switch sensenova          # Switch to SenseNova
claude-switch anthropic-official # Switch to Claude Official

# Language interface switching
claude-switch zh-ui            # Switch to Chinese interface
claude-switch en-ui            # Switch to English interface

# Display current configuration status
claude-switch status

# Advanced configuration management
claude-switch create            # Launch interactive configuration creation wizard
claude-switch save <name>        # Save current configuration as new configuration
claude-switch delete <name>      # Delete specified configuration
claude-switch backup            # Backup current configuration
```

## 🎨 Advanced Features

### Interactive Configuration Creation

Use the built-in wizard to quickly create new API configurations:

```bash
claude-switch create
```

The creation wizard supports three methods:
1. **Template-based** - Create from existing provider templates
2. **Current configuration-based** - Copy current Claude configuration
3. **Fully custom** - Manually input all configuration parameters

### Environment Variable Override

Support dynamic override of configuration parameters via environment variables, with priority higher than configuration files:

```bash
# Override API key
export ANTHROPIC_AUTH_TOKEN="your-api-key"

# Override API endpoint
export ANTHROPIC_BASE_URL="https://your-api-endpoint.com/anthropic"

# Override default model
export ANTHROPIC_DEFAULT_SONNET_MODEL="your-model"

# Set API timeout (milliseconds)
export API_TIMEOUT_MS="6000000"

# Apply environment variable overrides when switching configurations
claude-switch glm
```

### Smart Configuration Validation

Automatically validate configuration completeness and correctness:

- ✅ API endpoint format checking
- ✅ Model name validation
- ✅ Configuration file structure validation
- ✅ Required field completeness checking

### Auto Backup Protection

Automatically create backups before important operations:

```bash
# Auto backup before each configuration switch
claude-switch backup
```

Backup location: `~/.claude/backups/settings.backup.TIMESTAMP.json`

## 📋 Quick Aliases

Automatically configured after installation:

```bash
cs                    # Display interactive menu
csglm                 # Switch to GLM
cskimi                # Switch to Kimi2
csminimax             # Switch to MiniMax
cslist                # List all configurations
csstatus              # Display current status

# Language switching aliases
cscn                  # Switch to Chinese interface
csen                  # Switch to English interface
cslang                # List language configurations
```

### Configuration Management Commands

```bash
cscreate              # Launch interactive configuration creation wizard
cssave <name>         # Save current configuration as new configuration
csdelete <name>       # Delete specified configuration (requires confirmation)
csbackup              # Backup current configuration
```

**Example Usage**:

```bash
# Create new configuration
cscreate

# Save current configuration to custom name
cssave my-custom-config

# Delete unwanted configuration
csdelete old-config

# Regular configuration backup
csbackup
```

## 🔧 Configuration Guide

### Supported API Providers

#### 1. GLM (Zhipu AI)
- **API Endpoint**: `https://open.bigmodel.cn/api/anthropic`
- **Models**: glm-4.6, glm-4.5-air, glm-4-flash
- **Configuration File**: `configs/glm.json`

#### 2. Kimi2 (Moonshot AI)
- **API Endpoint**: `https://api.kimi.com/coding/`
- **Models**: kimi-for-coding
- **Configuration File**: `configs/kimi2.json`

#### 3. MiniMax M2.1
- **API Endpoint**: `https://api.minimaxi.com/anthropic`
- **Models**: MiniMax-M2 (High-performance programming model)
- **Configuration File**: `configs/minimax.json`
- **Features**: Official limited-time free, extended timeout settings

#### 4. DeepSeek V3.1
- **API Endpoint**: `https://api.deepseek.com/anthropic`
- **Models**: deepseek-chat-v3.1, deepseek-coder, deepseek-reasoner
- **Configuration File**: `configs/deepseek.json`
- **Features**: V3.1 enhanced Claude API support, extremely cost-effective

#### 5. Qwen (Alibaba Cloud)
- **API Endpoint**: `https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy`
- **Models**: qwen3-coder-plus (Claude Code dedicated)
- **Configuration File**: `configs/qwen.json`
- **Features**: 2000 free requests daily, supports dedicated models only

#### 6. Tencent Hunyuan
- **API Endpoint**: `https://hunyuan.tencentcloudapi.com/anthropic`
- **Models**: hunyuan-standard, hunyuan-lite, hunyuan-pro
- **Configuration File**: `configs/hunyuan.json`
- **Features**: Requires Tencent Cloud API key and TC3 signature
- **⚠️ Note**: Tencent Hunyuan currently does not officially support Claude Code's Anthropic API interface. Requires Claude Code Router as intermediate layer or third-party API forwarding service

#### 7. Doubao (ByteDance)
- **API Endpoint**: `https://ark.cn-beijing.volces.com/api/v3/anthropic`
- **Models**: Doubao-Seed-Code (Programming dedicated)
- **Configuration File**: `configs/doubao.json`
- **Features**: ¥9.9/month, native Claude compatibility

#### 8. Kimi (Moonshot AI)
- **China Users**: `configs/kimi-cn.json` - `https://api.moonshot.cn/anthropic`
- **International Users**: `configs/kimi-global.json` - `https://api.moonshot.ai/anthropic`
- **Models**: kimi-for-coding, moonshot-v1-8k/32k/128k
- **Features**: API keys distinguish China/International sites, not compatible

#### 9. Ernie (Baidu)
- **API Endpoint**: `https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/anthropic`
- **Models**: ernie-4.0-8k/128k, ernie-3.5-8k/128k, ernie-speed-8k/128k
- **Configuration File**: `configs/ernie.json`
- **Features**: Requires OAuth2 authentication process
- **⚠️ Note**: Ernie currently does not officially support Claude Code's Anthropic API interface. Solution similar to Tencent Hunyuan, requires Claude Code Router as intermediate layer or third-party API forwarding service

#### 10. SenseNova (SenseTime)
- **API Endpoint**: `https://api.sensenova.cn/v1/anthropic`
- **Models**: SenseChat-5, SenseChat-3, SenseChat-Turbo, SenseChat-Lite
- **Configuration File**: `configs/sensenova.json`
- **Features**: SenseTime Daily New Model Platform
- **⚠️ Note**: SenseNova primarily provides API migration services rather than direct configuration. Specific API configuration requires consultation with SenseTime official support for detailed BASE_URL and configuration information

#### 11. Claude Official (Anthropic)
- **API Endpoint**: `https://api.anthropic.com`
- **Models**: claude-3-5-sonnet-20241022, claude-3-opus, claude-3-haiku
- **Configuration File**: `configs/anthropic-official.json`
- **Features**: Official API, highest quality guarantee

### 12. UI Language Configurations

#### Chinese Interface (zh-ui)
- **Configuration File**: `configs/zh-ui.json`
- **UI Language**: Chinese (zh-CN)
- **Purpose**: Provide familiar interface environment for Chinese users
- **Quick Command**: `cscn` or `claude-switch zh-ui`
- **Features**:
  - Complete Chinese environment variable settings
  - Suitable for users needing Chinese interface
  - Includes system messages and prompt language configuration

#### English Interface (en-ui)
- **Configuration File**: `configs/en-ui.json`
- **UI Language**: English (en-US)
- **Purpose**: Provide standard interface environment for English users
- **Quick Command**: `csen` or `claude-switch en-ui`
- **Features**:
  - Standard English environment variable settings
  - Suitable for users preferring English interface
  - Complies with internationalization standards

### Configuring API Keys

Before using, ensure correct API key configuration:

```bash
# Method 1: Edit configuration file directly
nano ~/.claude/configs/glm.json

# Method 2: Use environment variables (temporary)
export ANTHROPIC_AUTH_TOKEN="your-api-key-here"

# Method 3: Create new configuration to save current settings
cscreate my-config
```

### Configuration File Format

```json
{
  "name": "provider-name",
  "display_name": "Display Name",
  "provider": "provider-type",
  "description": "Provider description",
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-api-key",
    "ANTHROPIC_BASE_URL": "https://api.example.com/anthropic",
    "API_TIMEOUT_MS": "3000000",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "model-name"
  },
  "models": {
    "model-name": "Model description"
  },
  "default_model": "default-model-name",
  "metadata": {
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z",
    "version": "1.0"
  }
}
```

## 🎯 Use Cases

### 1. Development Environment Switching
```bash
# Quick switching between API providers for different projects
csglm      # Use GLM for Chinese processing
cskimi     # Use Kimi for programming tasks
csminimax  # Use MiniMax for general conversation
```

### 2. Cost Optimization
```bash
# Select different models based on task complexity
claude-switch glm        # Use main model for complex tasks
claude-switch minimax    # Use lightweight model for simple tasks
```

### 3. Backup and Recovery
```bash
# Backup current configuration
csbackup

# Create custom configuration
cscreate work-project

# Switch between different configurations
claude-switch work-project
```

## 🛠️ Advanced Features

### Interactive Menu

Running `claude-switch` without parameters displays an interactive menu:

```
Claude CLI Configuration Management
==================

Current Configuration Status:
==================
Current configuration: glm

Configuration Details:
  ANTHROPIC_AUTH_TOKEN: 532e892690664ce2a02cda274776bd81.5ZGvUOh8DqbEcyJX
  ANTHROPIC_BASE_URL: https://open.bigmodel.cn/api/anthropic
  API_TIMEOUT_MS: 3000000
  ANTHROPIC_DEFAULT_OPUS_MODEL: glm-4.6
  ANTHROPIC_DEFAULT_SONNET_MODEL: glm-4.6
  ANTHROPIC_DEFAULT_HAIKU_MODEL: glm-4.5-air

Available Operations:
  1. Switch configuration
  2. Save current configuration
  3. List all configurations
  4. Delete configuration
  5. Backup current configuration
  6. Exit
```

### Configuration Validation

The tool automatically validates JSON format and environment variable settings of configuration files:

```bash
$ claude-switch invalid-config
Error: Invalid configuration file format
```

### Error Handling

- **Configuration file not found**: Provide clear error messages and usage suggestions
- **JSON format error**: Validate configuration file format and give specific errors
- **Permission issues**: Check file and directory permissions
- **API connection failure**: Provide network and authentication related debugging information

## 🔧 Custom Configuration

### Adding New API Providers

1. **Create configuration file**
   ```bash
   nano ~/.claude/configs/new-provider.json
   ```

2. **Use standard format**
   ```json
   {
     "name": "new-provider",
     "display_name": "New Provider",
     "provider": "custom",
     "description": "Custom API provider",
     "env": {
       "ANTHROPIC_AUTH_TOKEN": "your-token",
       "ANTHROPIC_BASE_URL": "https://api.new-provider.com/anthropic",
       "ANTHROPIC_DEFAULT_SONNET_MODEL": "model-name"
     },
     "models": {
       "model-name": "Model description"
     },
     "default_model": "model-name"
   }
   ```

3. **Switch to new configuration**
   ```bash
   claude-switch new-provider
   ```

### Environment Variable Override

Can be temporarily overridden via environment variables:

```bash
export ANTHROPIC_AUTH_TOKEN="temporary-token"
export ANTHROPIC_BASE_URL="https://custom-endpoint.com"
claude-switch status
```

## 📁 File Locations

- **Main Script**: `~/.local/bin/claude-switch`
- **Configuration File**: `~/.claude/settings.json`
- **Preset Configurations**: `~/.claude/configs/`
- **Backup Files**: `~/.claude/backups/`
- **Shell Configuration**: `~/.bashrc` or `~/.zshrc`

## 🔄 Uninstallation

```bash
# Run uninstallation script
./install.sh --uninstall

# Or manually delete
rm ~/.local/bin/claude-switch
rm -rf ~/.claude/configs/
# Manually delete related aliases from Shell configuration file
```

## 🐛 Troubleshooting

### Common Issues

1. **Command not found**
   ```bash
   # Check PATH
   echo $PATH | grep ~/.local/bin

   # Reload Shell configuration
   source ~/.bashrc
   ```

2. **Permission Error**
   ```bash
   # Ensure script is executable
   chmod +x ~/.local/bin/claude-switch

   # Check configuration directory permissions
   ls -la ~/.claude/
   ```

3. **Configuration Format Error**
   ```bash
   # Validate JSON format
   jq empty ~/.claude/configs/glm.json

   # View detailed errors
   claude-switch status
   ```

4. **API Connection Failed**
   ```bash
   # Check network connection
   curl -I https://api.example.com/anthropic

   # Test authentication token
   export ANTHROPIC_AUTH_TOKEN="your-token"
   claude-switch status
   ```

5. **Environment Variable Override Not Working**
   ```bash
   # Check environment variable settings
   env | grep ANTHROPIC_

   # Reset environment variables
   export ANTHROPIC_AUTH_TOKEN="new-token"
   export ANTHROPIC_BASE_URL="new-endpoint"
   claude-switch your-config
   ```

6. **Configuration Creation Wizard Issues**
   ```bash
   # Ensure running in interactive terminal
   claude-switch create

   # Check input timeout settings
   # If using in script, please provide input pipe
   echo -e "config-name\n1\n1\n" | claude-switch create
   ```

### Debugging Tips

- **View detailed output**: Use `claude-switch status` to see complete configuration information
- **Configuration validation**: Automatically validates when switching configurations, pay attention to warning messages
- **Backup recovery**: Recover previous configurations from `~/.claude/backups/` directory
- **Environment variable priority**: Environment variables have higher priority than configuration files, can be used for temporary testing

## 📝 Changelog

### v2.0.0 (Latest)
- ✨ **New Interactive Configuration Creation Wizard** - Supports template, current configuration, and custom creation methods
- 🌍 **Environment Variable Override Mechanism** - Supports dynamic override of configuration parameters with priority higher than configuration files
- 🔍 **Smart Configuration Validation** - Automatically validates API endpoint format, model names, and configuration integrity
- 💾 **Auto Backup Protection** - Automatically creates configuration backups before important operations
- 🛡️ **Enhanced Error Handling** - Timeout protection, input validation, friendly error messages
- 🎨 **Improved User Experience** - Clearer output format and status indicators

### v1.0.0
- 🚀 Initial version release
- 📦 Support for multiple mainstream API providers
- 🔧 Shell integration and auto-completion
- 🛡️ Basic configuration validation and error handling

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Issues and Pull Requests are welcome!

---

**🎉 Enjoy your efficient Claude API configuration management experience!**