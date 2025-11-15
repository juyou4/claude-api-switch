#!/bin/bash

# Claude API Switch 多语言加载器
# 负责检测语言设置、加载语言资源、提供文本获取功能

# 全局变量
declare -A I18N_TEXTS
CURRENT_LANGUAGE="zh-CN"
I18N_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检测命令行参数中的语言设置
detect_language_from_args() {
    for arg in "$@"; do
        case "$arg" in
            --lang=*)
                CURRENT_LANGUAGE="${arg#--lang=}"
                return 0
                ;;
            -l)
                # 获取下一个参数
                local next_arg=false
                for a in "$@"; do
                    if [ "$next_arg" = true ]; then
                        CURRENT_LANGUAGE="$a"
                        return 0
                    fi
                    if [ "$a" = "-l" ]; then
                        next_arg=true
                    fi
                done
                ;;
        esac
    done
    return 1
}

# 检测环境变量中的语言设置
detect_language_from_env() {
    # 检查 CLAUDE_LANG 环境变量
    if [ -n "${CLAUDE_LANG:-}" ]; then
        CURRENT_LANGUAGE="$CLAUDE_LANG"
        return 0
    fi

    # 检查标准语言环境变量
    if [ -n "${LANG:-}" ]; then
        case "$LANG" in
            zh_*|CN*)
                CURRENT_LANGUAGE="zh-CN"
                return 0
                ;;
            en_*|US*)
                CURRENT_LANGUAGE="en-US"
                return 0
                ;;
        esac
    fi

    if [ -n "${LC_ALL:-}" ]; then
        case "$LC_ALL" in
            zh_*|CN*)
                CURRENT_LANGUAGE="zh-CN"
                return 0
                ;;
            en_*|US*)
                CURRENT_LANGUAGE="en-US"
                return 0
                ;;
        esac
    fi

    return 1
}

# 从当前配置文件检测语言设置
detect_language_from_config() {
    local config_file="$HOME/.claude/settings.json"
    local alt_config_file="$HOME/.claude-config/settings.json"

    # 尝试主配置文件
    if [ -f "$config_file" ] && command -v jq >/dev/null 2>&1; then
        local provider=$(jq -r '.provider // ""' "$config_file" 2>/dev/null)
        case "$provider" in
            "language-ui")
                # 进一步检查具体语言
                local ui_lang=$(jq -r '.env.UI_LANGUAGE // ""' "$config_file" 2>/dev/null)
                case "$ui_lang" in
                    zh-CN|chinese)
                        CURRENT_LANGUAGE="zh-CN"
                        return 0
                        ;;
                    en-US|english)
                        CURRENT_LANGUAGE="en-US"
                        return 0
                        ;;
                esac
                ;;
        esac
    fi

    # 尝试备用配置文件
    if [ -f "$alt_config_file" ] && command -v jq >/dev/null 2>&1; then
        local provider=$(jq -r '.provider // ""' "$alt_config_file" 2>/dev/null)
        case "$provider" in
            "language-ui")
                local ui_lang=$(jq -r '.env.UI_LANGUAGE // ""' "$alt_config_file" 2>/dev/null)
                case "$ui_lang" in
                    zh-CN|chinese)
                        CURRENT_LANGUAGE="zh-CN"
                        return 0
                        ;;
                    en-US|english)
                        CURRENT_LANGUAGE="en-US"
                        return 0
                        ;;
                esac
                ;;
        esac
    fi

    return 1
}

# 初始化多语言系统
init_i18n() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local i18n_dir="$(dirname "$script_dir")/i18n"

    # 检测语言设置的优先级
    # 1. 命令行参数
    if ! detect_language_from_args "$@"; then
        # 2. 环境变量
        if ! detect_language_from_env; then
            # 3. 当前配置文件
            if ! detect_language_from_config; then
                # 4. 默认中文（向后兼容）
                CURRENT_LANGUAGE="zh-CN"
            fi
        fi
    fi

    # 加载语言资源
    load_language_resources "$CURRENT_LANGUAGE"
}

# 加载指定语言的资源文件
load_language_resources() {
    local lang="$1"
    local resource_file="$I18N_DIR/$lang.json"

    # 清空现有文本资源
    I18N_TEXTS=()

    # 检查资源文件是否存在
    if [ ! -f "$resource_file" ]; then
        echo "Warning: Language resource file not found: $resource_file" >&2
        echo "Falling back to zh-CN" >&2
        resource_file="$I18N_DIR/zh-CN.json"

        if [ ! -f "$resource_file" ]; then
            echo "Error: Default language resource file not found" >&2
            return 1
        fi
    fi

    # 检查jq是否可用
    if command -v jq >/dev/null 2>&1; then
        # 使用jq解析JSON
        local json_content=$(cat "$resource_file")

        # 递归提取所有文本
        extract_texts_from_json "$json_content" ""
    else
        echo "Warning: jq not available, using simplified text loading" >&2
        # 简化的文本加载方式（作为fallback）
        load_texts_simplified "$resource_file"
    fi

    return 0
}

# 从JSON中递归提取文本
extract_texts_from_json() {
    local json_content="$1"
    local prefix="$2"

    # 提取当前级别的键值对
    local keys=$(echo "$json_content" | jq -r 'keys[]' 2>/dev/null)

    while IFS= read -r key; do
        if [ -n "$key" ]; then
            local full_key="${prefix:+${prefix}.}$key"
            local value=$(echo "$json_content" | jq -r ".\"$key\"" 2>/dev/null)

            # 检查是否为对象（需要递归）
            if echo "$value" | jq -e 'type == "object"' >/dev/null 2>&1; then
                extract_texts_from_json "$value" "$full_key"
            else
                # 存储文本，支持参数化
                I18N_TEXTS["$full_key"]="$value"
            fi
        fi
    done <<< "$keys"
}

# 简化的文本加载方式（当jq不可用时）
load_texts_simplified() {
    local resource_file="$1"

    # 这里可以实现一个简化的JSON解析器
    # 为了简化，我们只加载一些基本的文本
    I18N_TEXTS["app.title"]="Claude API Quick Switch Tool"
    I18N_TEXTS["menu.title"]="Claude API Quick Switch Tool"
    I18N_TEXTS["messages.success.config_switched"]="✅ Switched to configuration: {name}"
    I18N_TEXTS["messages.errors.config_not_found"]="❌ Configuration file not found: {path}"
    # ... 可以添加更多基本文本
}

# 获取多语言文本
get_text() {
    local key="$1"
    local default_value="${2:-}"

    # 尝试获取指定语言的文本
    local text="${I18N_TEXTS[$key]:-}"

    # 如果找不到，尝试返回默认值
    if [ -z "$text" ]; then
        echo "$default_value"
    else
        echo "$text"
    fi
}

# 格式化文本（支持参数替换）
format_text() {
    local key="$1"
    shift
    local text="${I18N_TEXTS[$key]:-}"

    if [ -z "$text" ]; then
        echo "$key"
        return
    fi

    # 替换参数
    while [ $# -gt 0 ]; do
        local param_name="$1"
        local param_value="$2"
        shift 2

        # 支持多种参数格式
        text="${text//\{$param_name\}/$param_value}"
        text="${text//\$$param_name/$param_value}"
    done

    echo "$text"
}

# 获取当前语言
get_current_language() {
    echo "$CURRENT_LANGUAGE"
}

# 设置语言（运行时切换）
set_language() {
    local new_lang="$1"

    # 验证语言资源是否存在
    local resource_file="$I18N_DIR/$new_lang.json"
    if [ ! -f "$resource_file" ]; then
        echo "Error: Language resource file not found: $resource_file" >&2
        return 1
    fi

    # 加载新的语言资源
    if load_language_resources "$new_lang"; then
        CURRENT_LANGUAGE="$new_lang"
        echo "Language switched to: $new_lang"
        return 0
    else
        echo "Error: Failed to load language resources for: $new_lang" >&2
        return 1
    fi
}

# 列出支持的语言
list_supported_languages() {
    echo "Supported languages:"
    for file in "$I18N_DIR"/*.json; do
        if [ -f "$file" ]; then
            local lang=$(basename "$file" .json)
            local name=$(get_text_from_file "$file" "app.title" "$lang")
            echo "  $lang - $name"
        fi
    done
}

# 从指定文件获取文本（辅助函数）
get_text_from_file() {
    local file="$1"
    local key="$2"
    local default="$3"

    if [ ! -f "$file" ] || ! command -v jq >/dev/null 2>&1; then
        echo "$default"
        return
    fi

    local value=$(jq -r ".\"$key\" // \"$default\"" "$file" 2>/dev/null)
    echo "$value"
}

# 导出函数供其他脚本使用
export -f init_i18n
export -f load_language_resources
export -f get_text
export -f format_text
export -f get_current_language
export -f set_language
export -f list_supported_languages