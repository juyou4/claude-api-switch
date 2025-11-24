# 故障排除指南

## 常见问题

### 问题1：路由器配置后Claude回答答非所问

**症状**：
- 切换到路由器配置后，Claude的回答完全不对
- 提问中文，回答英文
- 回答内容与问题无关

**原因**：
生成的 `~/.claude-code-router/config.json` 文件中的API端点配置错误。

**快速诊断**：
```bash
# 查看生成的配置文件
cat ~/.claude-code-router/config.json | grep api_base_url

# GLM - 错误示例（需要修复）：
# "api_base_url": "https://open.bigmodel.cn/api/paas/v4"  ❌ (缺少/chat/completions)

# GLM - 正确示例：
# "api_base_url": "https://open.bigmodel.cn/api/paas/v4/chat/completions"  ✅
```

**解决方案**：

#### 方法1：使用自动修复脚本（推荐）
```bash
cd ~/project/claude-api-switch
chmod +x fix-router-config.sh
./fix-router-config.sh
```

#### 方法2：手动修复
```bash
# 1. 停止路由器
ccr stop

# 2. 删除旧配置
rm ~/.claude-code-router/config.json

# 3. 重新切换配置（会自动生成新配置）
claude-switch glm-router

# 4. 启动路由器
ccr start

# 5. 验证配置
cat ~/.claude-code-router/config.json | grep api_base_url
```

#### 方法3：直接编辑配置文件
```bash
# 1. 停止路由器
ccr stop

# 2. 编辑配置文件
nano ~/.claude-code-router/config.json

# 3. 检查并修改API端点（如果需要）：

# GLM配置（必须包含/chat/completions后缀）：
# 正确: "api_base_url": "https://open.bigmodel.cn/api/paas/v4/chat/completions"

# DeepSeek配置（完整路径，无/v1前缀）：
# 正确: "api_base_url": "https://api.deepseek.com/chat/completions"

# MiniMax配置（Anthropic原生支持）：
# 正确: "api_base_url": "https://api.minimaxi.com/anthropic"

# 4. 保存并重启路由器
ccr start
```

---

### 问题2：切换配置后提示"路由器未安装"

**症状**：
```
❌ claude-code-router 未安装
💡 请先安装路由器:
   claude-switch setup-router
```

**解决方案**：
```bash
# 检查是否已安装
command -v ccr

# 如果未安装，自动安装
claude-switch setup-router

# 或手动安装
git clone https://github.com/musistudio/claude-code-router.git ~/.claude-router
cd ~/.claude-router
npm install
npm install -g .

# 验证安装
ccr --version
```

---

### 问题3：路由器启动失败

**症状**：
```
❌ 路由器配置文件不存在
💡 请先切换到路由器配置以生成配置文件
```

**解决方案**：
```bash
# 1. 确认API密钥已配置
grep "ANTHROPIC_AUTH_TOKEN" ~/.claude/configs/glm-router.json

# 如果是占位符，设置真实密钥
claude-switch set-key glm-router "你的API密钥"

# 2. 切换到路由器配置
claude-switch glm-router

# 3. 启动路由器
claude-switch start-router
```

---

### 问题4：端口3456被占用

**症状**：
```
Error: listen EADDRINUSE: address already in use :::3456
```

**解决方案**：
```bash
# 检查占用端口的进程
lsof -i :3456

# 如果是旧的ccr进程，停止它
ccr stop

# 或强制杀死进程
kill -9 $(lsof -t -i:3456)

# 重新启动
ccr start
```

---

### 问题5：API密钥未配置

**症状**：
```
❌ API密钥未配置，无法生成路由器配置
```

**解决方案**：
```bash
# 快速设置单个密钥
claude-switch set-key glm-router "你的GLM-API密钥"
claude-switch set-key deepseek-router "你的DeepSeek-API密钥"

# 或使用交互式批量设置
claude-switch setup-keys
```

---

## 诊断工具

### 完整诊断脚本
```bash
cat > /tmp/diagnose-router.sh << 'EOF'
#!/bin/bash
echo "=== Claude Router 完整诊断 ==="
echo ""

echo "1. 路由器安装检查:"
command -v ccr && echo "✅ 已安装: $(ccr --version)" || echo "❌ 未安装"
echo ""

echo "2. 配置文件检查:"
for config in glm-router deepseek-router minimax-router; do
    if [ -f ~/.claude/configs/$config.json ]; then
        echo "  ✅ $config.json 存在"
    else
        echo "  ❌ $config.json 不存在"
    fi
done
echo ""

echo "3. 路由器配置文件:"
if [ -f ~/.claude-code-router/config.json ]; then
    echo "  ✅ 存在"
    echo "  API端点:"
    cat ~/.claude-code-router/config.json | grep -A 1 "api_base_url" | head -2
else
    echo "  ❌ 不存在"
fi
echo ""

echo "4. 路由器运行状态:"
if nc -z localhost 3456 2>/dev/null; then
    echo "  ✅ 运行中 (端口3456)"
else
    echo "  ❌ 未运行"
fi
echo ""

echo "5. API密钥检查:"
for config in glm-router deepseek-router minimax-router; do
    if [ -f ~/.claude/configs/$config.json ]; then
        KEY=$(grep "ANTHROPIC_AUTH_TOKEN" ~/.claude/configs/$config.json | head -1 | cut -d'"' -f4)
        if [[ "$KEY" == "在此处输入"* || -z "$KEY" ]]; then
            echo "  ❌ $config: 未配置"
        else
            echo "  ✅ $config: 已配置 (${KEY:0:20}...)"
        fi
    fi
done
echo ""

echo "6. 当前Claude配置:"
claude-switch status 2>/dev/null | grep -A 10 "当前配置"
echo ""

echo "=== 诊断完成 ==="
EOF

chmod +x /tmp/diagnose-router.sh
/tmp/diagnose-router.sh
```

### 快速测试路由器
```bash
# 测试路由器是否正常响应
curl -X POST http://127.0.0.1:3456/v1/messages \
  -H "x-api-key: 你的API密钥" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{
    "model": "glm-4-plus",
    "messages": [{"role": "user", "content": "你好，请用中文回答"}],
    "max_tokens": 100
  }'

# 应该返回类似：
# {"id":"...","type":"message","role":"assistant","content":[{"type":"text","text":"你好！..."}],...}
```

---

## API端点正确配置参考

### GLM (智谱AI)

**推荐配置：Anthropic原生API（支持思考模式）**
```json
{
  "name": "zhipu",
  "api_base_url": "https://open.bigmodel.cn/api/anthropic",
  "api_key": "your-api-key",
  "models": ["glm-4.6", "glm-4.5-air"],
  "transformer": {
    "use": []
  }
}
```
**优势**:
- ✅ 原生支持 Anthropic API 格式
- ✅ 支持 GLM-4.6 思考模式和推理能力
- ✅ 无需 transformer（端点已是 Anthropic 格式）
- ✅ 模型名称直接使用版本号（glm-4.6）

**替代配置：OpenAI兼容API（基础模式）**
```json
{
  "name": "zhipu",
  "api_base_url": "https://open.bigmodel.cn/api/paas/v4/chat/completions",
  "api_key": "your-api-key",
  "models": ["glm-4-plus", "glm-4-air-250414", "glm-4-airx", "glm-4-flashx"],
  "transformer": {
    "use": []
  }
}
```
**注意**:
- 使用此端点时，模型名称为 `glm-4-plus`（GLM-4.6的API调用名）
- 不支持思考模式（除非自定义 transformer）

**参考**:
- [智谱AI Claude Code接入文档](https://docs.bigmodel.cn/cn/guide/develop/claude)
- [GLM-4.6思考模式配置](https://github.com/musistudio/claude-code-router/blob/main/blog/zh/GLM-4.6%E6%94%AF%E6%8C%81%E6%80%9D%E8%80%83%E5%8F%8A%E6%80%9D%E7%BB%B4%E9%93%BE%E5%9B%9E%E4%BC%A0.md)
- [Issue #398](https://github.com/musistudio/claude-code-router/issues/398)

### DeepSeek
```json
{
  "name": "deepseek",
  "api_base_url": "https://api.deepseek.com/chat/completions",
  "api_key": "your-api-key",
  "models": ["deepseek-reasoner", "deepseek-chat"],
  "transformer": {
    "use": ["deepseek"],
    "deepseek-chat": {
      "use": ["tooluse"]
    }
  }
}
```

**参考**: [DeepSeek Anthropic API文档](https://api-docs.deepseek.com/guides/anthropic_api)

### MiniMax
```json
{
  "name": "minimax",
  "api_base_url": "https://api.minimaxi.com/anthropic",
  "api_key": "your-api-key",
  "models": ["MiniMax-M2"],
  "transformer": {
    "use": []
  }
}
```

**参考**: [MiniMax官方文档](https://platform.minimax.io/docs/guides/text-ai-coding-tools)

---

## 获取帮助

如果以上方法都无法解决问题，请：

1. **查看路由器日志**：
   ```bash
   ccr logs --follow
   ```

2. **运行完整诊断**：
   ```bash
   ./fix-router-config.sh
   ```

3. **查看健康检查**：
   ```bash
   claude-switch health glm-router --verbose
   ```

4. **提交Issue**：
   - 项目地址：https://github.com/juyou4/claude-api-switch
   - 包含诊断脚本输出
   - 包含路由器日志

---

## 相关链接

- [claude-code-router官方文档](https://github.com/musistudio/claude-code-router)
- [GLM API文档](https://open.bigmodel.cn/dev/api)
- [DeepSeek API文档](https://api-docs.deepseek.com/)
- [MiniMax API文档](https://platform.minimax.io/docs)
