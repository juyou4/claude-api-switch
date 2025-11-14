# Claude API Switch 别名问题解决方案

## 问题描述
用户反馈csen和cscn命令显示"command not found"，无法正常使用。

## 问题原因
1. **Shell别名加载问题**：csen和cscn别名没有在当前Shell会话中正确加载
2. **.bashrc配置问题**：cs_generate_aliases函数在子shell中执行失败

## 解决方案

### 方法1：立即可用（推荐）
在当前终端中手动设置别名：

```bash
# 设置主要别名
alias csen='claude-switch en-ui'
alias cscn='claude-switch zh-ui'
alias cs='claude-switch'
alias cslist='claude-switch list'
alias csstatus='claude-switch status'

# 测试命令
csen  # 切换到英文界面
cscn  # 切换到中文界面
```

### 方法2：永久修复
运行项目提供的修复脚本：

```bash
./fix_aliases.sh
source ~/.bashrc
```

### 方法3：手动修复
编辑 `~/.bashrc` 文件，在末尾添加：

```bash
# Claude API Switch 别名
alias csen='claude-switch en-ui'
alias cscn='claude-switch zh-ui'
alias cs='claude-switch'
alias cslist='claude-switch list'
alias csstatus='claude-switch status'
```

然后执行：
```bash
source ~/.bashrc
```

## 功能验证

### 测试语言切换功能
```bash
# 测试英文界面切换
./claude-switch en-ui

# 测试中文界面切换
./claude-switch zh-ui

# 测试API配置切换
./claude-switch glm
```

### 预期输出
语言配置切换应该显示：
```
✅ 语言界面配置验证通过
ℹ️ 语言配置使用环境变量中的API密钥
✅ 已切换到配置: en-ui
```

## 技术细节

### 语言配置特点
- 使用 `provider: "language-ui"` 标识
- 自动跳过API密钥验证
- 继承当前环境的API配置
- 提供中英文界面语言设置

### 配置文件位置
- 英文界面：`~/.claude/configs/en-ui.json`
- 中文界面：`~/.claude/configs/zh-ui.json`

### 验证逻辑
claude-switch脚本中已修复语言配置验证逻辑，对language-ui类型配置跳过API密钥检查。

## 故障排除

如果问题仍然存在：

1. **检查claude-switch路径**：
   ```bash
   which claude-switch
   ls -la claude-switch
   ```

2. **检查配置文件**：
   ```bash
   ls -la ~/.claude/configs/en-ui.json
   ls -la ~/.claude/configs/zh-ui.json
   ```

3. **直接使用完整命令**：
   ```bash
   ./claude-switch en-ui
   ./claude-switch zh-ui
   ```

## 联系支持

如果以上方法都无法解决问题，请检查：
1. 确保在正确的项目目录中
2. 确保claude-switch脚本有执行权限
3. 检查系统环境变量设置