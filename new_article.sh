#!/bin/bash

# Hexo 博客文章创建脚本 (V2 - 健壮版)
# 功能: 在指定的分类子目录下安全地创建一篇新文章及其资源文件夹。
# 包含了执行前检查、执行后校验和原子化操作逻辑。
#
# 用法: ./new_article.sh "分类目录" "文章标题"
# 示例: ./new_article.sh "DevOps-and-Tools" "深入理解MCP：模型上下文协议"

# --- 参数与路径定义 ---

# 检查参数数量是否正确
if [ "$#" -ne 2 ]; then
    echo "❌ 错误: 参数数量不正确。"
    echo "用法: $0 \"分类目录\" \"文章标题\""
    exit 1
fi

CATEGORY=$1
TITLE=$2

# 将标题中的下划线转换为空格，以便 `hexo new` 正确处理
# Hexo 会自动将标题中的空格转换为-
HEXO_FRIENDLY_TITLE=$(echo "${TITLE}" | tr '_' ' ')
HEXO_GENERATED_SLUG=$(echo "${TITLE}" | tr '_' '-')

# 定义所有相关路径变量
SOURCE_MD_FILE="source/_posts/${HEXO_GENERATED_SLUG}.md"
SOURCE_ASSET_FOLDER="source/_posts/${HEXO_GENERATED_SLUG}"
TARGET_CATEGORY_DIR="source/_posts/${CATEGORY}"
TARGET_MD_FILE="${TARGET_CATEGORY_DIR}/${TITLE}.md"
TARGET_ASSET_FOLDER="${TARGET_CATEGORY_DIR}/${TITLE}/"

# --- 第 1 步: 执行前安全检查 (来自您的建议) ---
echo "▶️ [1/5] 执行前安全检查..."
if [ -f "${TARGET_MD_FILE}" ] || [ -d "${TARGET_ASSET_FOLDER}" ]; then
    echo "❌ 错误: 操作中止！目标位置已存在文件或文件夹。"
    if [ -f "${TARGET_MD_FILE}" ]; then
        echo "   - 已存在文件: ${TARGET_MD_FILE}"
    fi
    if [ -d "${TARGET_ASSET_FOLDER}" ]; then
        echo "   - 已存在目录: ${TARGET_ASSET_FOLDER}"
    fi
    exit 1
fi
echo "✅ 目标路径干净，可以继续。"

# --- 第 2 步: 调用 hexo new 生成原材料 ---
echo "▶️ [2/5] 正在调用 'hexo new' 创建文章: ${TITLE}"
hexo new post "${HEXO_FRIENDLY_TITLE}"

# --- 第 3 步: 执行后完整性校验 (来自您的建议) ---
echo "▶️ [3/5] 正在校验 'hexo new' 的输出结果..."
if [ -f "${SOURCE_MD_FILE}" ] && [ -d "${SOURCE_ASSET_FOLDER}" ]; then
    echo "✅ .md 文件和资源文件夹都已成功创建。"
else
    echo "❌ 错误: 'hexo new' 执行后状态不一致！"
    echo "   - 期望得到 '${SOURCE_MD_FILE}' 和 '${SOURCE_ASSET_FOLDER}'"
    echo "   - 正在清理产生的孤立文件/文件夹..."
    if [ -f "${SOURCE_MD_FILE}" ]; then
        rm "${SOURCE_MD_FILE}"
        echo "   - 已删除孤立文件: ${SOURCE_MD_FILE}"
    fi
    if [ -d "${SOURCE_ASSET_FOLDER}" ]; then
        rm -rf "${SOURCE_ASSET_FOLDER}"
        echo "   - 已删除孤立目录: ${SOURCE_ASSET_FOLDER}"
    fi
    exit 1
fi

# --- 第 4 步: 创建目标分类目录 (来自您的建议) ---
echo "▶️ [4/5] 正在确保目标分类目录存在..."
mkdir -p "${TARGET_CATEGORY_DIR}"
echo "✅ 目标目录 '${TARGET_CATEGORY_DIR}' 已就绪。"

# --- 第 5 步: 移动到目标位置 ---
echo "▶️ [5/5] 正在移动文件和文件夹到目标位置..."
mv "${SOURCE_MD_FILE}" "${TARGET_MD_FILE}"
mv "${SOURCE_ASSET_FOLDER}" "${TARGET_ASSET_FOLDER}"

# --- 完成 ---
echo ""
echo "🎉 操作成功！"
echo "新文章已创建在: ${TARGET_MD_FILE}"