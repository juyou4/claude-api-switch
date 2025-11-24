# GLM-4.6 思考模式使用指南

## 概述

GLM-4.6 原生支持思考模式（Extended Thinking），能够在回答问题前进行深度推理和反思。本指南将详细说明如何启用和使用这一功能。

## 思考模式的工作原理

GLM-4.6 的思考模式类似于 Claude 3.5 Sonnet 的扩展思维功能：
- 模型会在给出最终回答前进行内部推理
- 推理过程可以被记录和显示
- 适用于复杂的编程任务、数学问题、逻辑推理等

## 配置方法

### 1. 基础配置（已完成）

`glm-router.json` 配置已启用思考模式：

```json
{
  "name": "glm-router",
  "thinking_enabled": true,
  "alwaysThinkingEnabled": true,
  "env": {
    "ANTHROPIC_BASE_URL": "http://127.0.0.1:3456",
    "API_TIMEOUT_MS": "6000000",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.6",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.6"
  }
}
```

**配置说明**：
- `thinking_enabled: true` - 启用思考能力
- `alwaysThinkingEnabled: true` - 始终启用思考模式
- `API_TIMEOUT_MS: 6000000` - 长超时时间（6000秒），因为思考需要更多时间

### 2. 路由器配置

路由器配置中的 `think` 字段指定了用于推理任务的模型：

```json
{
  "Router": {
    "default": "zhipu,glm-4.6",
    "think": "zhipu,glm-4.6",
    "background": "zhipu,glm-4.5-air"
  }
}
```

**路由说明**：
- `think` - 用于需要深度思考的任务（Plan 模式）
- `default` - 默认对话使用 GLM-4.6
- `background` - 后台任务使用轻量级的 GLM-4.5-air

## 使用方法

### 方法1：自动触发（推荐）

使用当前配置，GLM-4.6 会在以下情况自动启用思考：

1. **复杂编程任务**
   ```bash
   # 示例：要求实现复杂算法
   "帮我实现一个高效的红黑树数据结构"
   ```

2. **Plan 模式**
   ```bash
   # Claude Code 的 Plan 模式会自动使用 think 路由
   /plan 如何重构这个项目的架构
   ```

3. **需要推理的问题**
   ```bash
   "分析这段代码的时间复杂度并优化"
   ```

### 方法2：显式请求思考

在提示词中明确要求模型思考：

```bash
# 使用特殊指令触发思考
"请仔细思考这个问题，逐步推理..."

# 或使用 ultrathink 指令（强制思考）
"ultrathink: 分析这个算法的所有边界情况"
```

### 方法3：通过 API 参数控制

如果直接调用 API，可以使用 `thinking` 参数：

```bash
curl -X POST "https://open.bigmodel.cn/api/anthropic/v1/messages" \
  -H "Content-Type: application/json" \
  -H "x-api-key: your-api-key" \
  -d '{
    "model": "glm-4.6",
    "messages": [{
      "role": "user",
      "content": "解决这个复杂的数学问题..."
    }],
    "thinking": {
      "type": "enabled",
      "budget_tokens": 10000
    },
    "max_tokens": 8192
  }'
```

**参数说明**：
- `thinking.type` - 设置为 `"enabled"` 启用思考
- `thinking.budget_tokens` - 思考过程的 token 预算（可选）
- 更大的 budget 可以提升复杂问题的回答质量

## 思考模式的优势

### 1. 编程任务
- ✅ 更好的代码架构设计
- ✅ 更全面的边界情况考虑
- ✅ 更优化的算法选择
- ✅ 更详细的错误分析

### 2. 复杂问题
- ✅ 多步骤推理
- ✅ 问题分解
- ✅ 假设验证
- ✅ 自我纠错

### 3. 代码审查
- ✅ 深入的安全分析
- ✅ 性能瓶颈识别
- ✅ 潜在 bug 发现
- ✅ 最佳实践建议

## 注意事项

### 1. 响应时间
- 思考模式会增加响应时间（通常 5-30 秒）
- 对于简单查询，GLM 可能自动跳过思考
- 复杂任务的思考时间更长，但结果更准确

### 2. Token 消耗
- 思考过程会消耗额外的 token
- 建议设置合理的 `API_TIMEOUT_MS`
- 监控 API 使用量，避免超出限额

### 3. 最佳实践
- 对于简单任务，可以使用 `glm-4.5-air` 节省成本
- 对于复杂任务，明确要求"仔细思考"
- 使用 Plan 模式处理多步骤任务
- 定期查看路由器日志，了解模型选择情况

## 切换到思考模式

```bash
# 1. 切换到 GLM 路由器配置
cd ~/claude-api-switch
./claude-switch glm-router

# 2. 确认路由器正在运行
ccr status

# 3. 如果未运行，启动路由器
ccr start

# 4. 验证配置
cat ~/.claude-code-router/config.json | jq '.Router.think'
# 应该显示: "zhipu,glm-4.6"
```

## 查看思考过程

### 在 Claude Code CLI 中
思考过程会以特殊格式显示（如果模型返回了思考内容）：

```
<thinking>
让我分析这个问题...
1. 首先考虑边界情况
2. 然后设计算法结构
3. 最后优化性能
</thinking>

基于以上思考，这是我的方案...
```

### 在路由器日志中
```bash
# 查看路由器日志
tail -f ~/.claude-router/logs/router.log

# 查看详细的请求/响应
ccr logs --verbose
```

## 故障排除

### 问题1：思考模式不工作
**症状**：模型不显示思考过程

**解决方案**：
1. 检查配置：`cat ~/.claude/settings.json | grep alwaysThinkingEnabled`
2. 确认 API 端点：应该是 `https://open.bigmodel.cn/api/anthropic`
3. 明确要求思考：在提示词中添加"请仔细思考"

### 问题2：响应超时
**症状**：请求因超时失败

**解决方案**：
```bash
# 增加超时时间
export API_TIMEOUT_MS=10000000  # 10000秒

# 或在配置文件中设置
{
  "env": {
    "API_TIMEOUT_MS": "10000000"
  }
}
```

### 问题3：思考过程太长
**症状**：等待时间过长

**解决方案**：
- 使用 `glm-4.5-air` 处理简单任务
- 调整 `thinking.budget_tokens` 限制思考长度
- 对于简单查询，不使用思考模式

## 性能对比

| 模式 | 响应时间 | 准确度 | Token 消耗 | 适用场景 |
|------|---------|--------|-----------|----------|
| 标准模式 | 快（2-5s） | 中 | 低 | 简单查询、代码补全 |
| 思考模式 | 慢（5-30s） | 高 | 高 | 复杂算法、架构设计 |
| Plan 模式 | 很慢（30s+） | 很高 | 很高 | 多步骤项目、重构 |

## 参考资源

- [GLM-4.6 思考模式博客](https://github.com/musistudio/claude-code-router/blob/main/blog/zh/GLM-4.6支持思考及思维链回传.md)
- [Anthropic 扩展思维文档](https://docs.anthropic.com/zh-CN/docs/build-with-claude/extended-thinking)
- [智谱 AI Claude Code 接入文档](https://docs.bigmodel.cn/cn/guide/develop/claude)
- [Claude Code Router GitHub](https://github.com/musistudio/claude-code-router)
- [Claude Code + GLM 4.6 配置教程](https://zhuanlan.zhihu.com/p/1957370685748938170)

## 示例场景

### 场景1：复杂算法实现
```
用户：帮我实现一个支持并发的 LRU 缓存，要考虑线程安全和性能优化

GLM-4.6（思考模式）：
<thinking>
这个任务需要考虑：
1. 基础 LRU 结构：哈希表 + 双向链表
2. 并发控制：读写锁 vs 分段锁
3. 性能优化：减少锁竞争，考虑 lock-free 方案
4. 边界情况：容量为0、单线程、高并发等
</thinking>

基于以上分析，我建议使用以下设计...
[详细实现代码]
```

### 场景2：架构重构
```
用户：这个项目的架构有什么问题？如何重构？

GLM-4.6（Plan 模式自动使用 think 路由）：
<thinking>
让我分析当前架构：
1. 代码结构：单体 vs 模块化
2. 依赖关系：是否有循环依赖
3. 测试覆盖：测试策略是否合理
4. 性能瓶颈：数据库、网络、计算
5. 可维护性：代码复杂度、文档完整性
</thinking>

发现以下问题：
1. [问题列表]

建议的重构方案：
1. [详细步骤]
```

## 总结

GLM-4.6 的思考模式是一个强大的功能，适用于需要深度推理的编程任务。通过正确的配置和使用，可以显著提升代码质量和问题解决能力。

**关键要点**：
- ✅ 配置已启用：`thinking_enabled` + `alwaysThinkingEnabled`
- ✅ 使用 Anthropic 原生 API 端点
- ✅ Plan 模式自动使用 think 路由
- ✅ 可通过提示词显式触发
- ✅ 注意响应时间和 token 消耗
