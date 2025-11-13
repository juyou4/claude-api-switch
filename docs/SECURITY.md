# 🔒 安全配置指南

## ⚠️ 重要安全提醒

本工具需要配置API密钥才能正常工作。请务必保护您的API密钥安全，遵循以下最佳实践：

## 🔐 API密钥安全

### 1. 密钥保护原则
- **永远不要**将API密钥提交到版本控制系统
- **定期轮换**API密钥，建议每30-90天更换一次
- **使用最小权限**原则，仅为必要的服务生成密钥
- **监控API使用情况**，及时发现异常活动

### 2. 配置文件安全
- 用户配置文件位于 `~/.claude/configs/` 目录
- 这些文件包含您的API密钥，应该保密
- 建议定期备份配置文件到安全位置

### 3. 环境变量选项（推荐）
对于额外安全，您可以使用环境变量覆盖配置：

```bash
export ANTHROPIC_AUTH_TOKEN="your-api-key"
export ANTHROPIC_BASE_URL="your-endpoint"
claude-switch your-config
```

## 🛡️ 配置模板

### GLM (智谱AI) 配置示例
```json
{
  "name": "glm",
  "display_name": "智谱GLM",
  "provider": "zhipu",
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "在此处输入您的GLM API密钥",
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic"
  }
}
```

### Kimi 配置示例
```json
{
  "name": "kimi2",
  "display_name": "Kimi2",
  "provider": "moonshot",
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "在此处输入您的Kimi API密钥",
    "ANTHROPIC_BASE_URL": "https://api.kimi.com/coding/"
  }
}
```

## 🔄 密钥轮换流程

1. **备份当前配置**
   ```bash
   claude-switch backup
   ```

2. **生成新密钥**
   - 在相应的API提供商控制台生成新密钥

3. **更新配置文件**
   ```bash
   # 编辑配置文件
   nano ~/.claude/configs/your-config.json

   # 或使用save命令创建新配置
   claude-switch save new-config-name
   ```

4. **测试新配置**
   ```bash
   claude-switch new-config-name
   claude-switch status
   ```

5. **撤销旧密钥**
   - 在API提供商控制台撤销旧密钥

## 🚨 安全事件响应

如果怀疑API密钥泄露：

1. **立即撤销**：在API提供商控制台撤销相关密钥
2. **检查使用记录**：查看API调用日志，确认是否有异常使用
3. **更换密钥**：立即生成新的API密钥
4. **审查访问权限**：检查谁有权限访问您的配置文件
5. **加强监控**：临时增加API使用监控频率

## 📞 联系支持

如果您发现安全漏洞或有安全问题需要报告：

- 📧 安全邮件：security@example.com
- 🐛 问题报告：[GitHub Issues](https://github.com/your-username/claude-api-switch/issues)

## 📚 相关资源

- [API密钥最佳实践](https://owasp.org/www-project-cheat-sheets/cheatsheets/API_Security_Cheat_Sheet.html)
- [Claude CLI官方文档](https://docs.anthropic.com/claude/docs/claude-for-developers)
- [版本控制安全](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks.html)

---

**记住：您的API密钥就像是您在线服务的密码。请像保护密码一样保护它们！** 🛡️