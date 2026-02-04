#!/bin/bash

# Hello OpenClaw 部署脚本
# 作者: bingoup886
# 日期: 2026-02-04

set -e

echo "🚀 开始部署 Hello OpenClaw 项目..."

# 检查必要工具
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ 未找到 $1，请先安装"
        exit 1
    fi
}

echo "🔧 检查必要工具..."
check_tool node
check_tool npm
check_tool git

# 安装依赖
echo "📦 安装依赖..."
npm install

# 配置 OpenClaw
echo "⚙️ 配置 OpenClaw..."
if [ ! -f "openclaw.json" ]; then
    echo "📝 创建 OpenClaw 配置文件..."
    cp openclaw.example.json openclaw.json
    echo "⚠️ 请编辑 openclaw.json 文件，配置你的 API 密钥和其他设置"
fi

# 检查 Cloudflare Wrangler
if command -v wrangler &> /dev/null; then
    echo "☁️ 检测到 Cloudflare Wrangler，准备部署..."
    
    # 登录 Cloudflare（如果需要）
    if [ ! -f "$HOME/.wrangler/config/default.toml" ]; then
        echo "🔐 需要登录 Cloudflare..."
        wrangler login
    fi
    
    # 部署到 Cloudflare Pages
    echo "🚀 部署到 Cloudflare Pages..."
    npm run deploy:pages
    
    # 部署 Workers（如果需要）
    echo "⚡ 部署 Cloudflare Workers..."
    npm run deploy:workers
    
    echo "✅ 部署完成！"
else
    echo "ℹ️ 未安装 Cloudflare Wrangler，跳过部署步骤"
    echo "📚 请参考 README.md 中的手动部署指南"
fi

echo "🎉 Hello OpenClaw 项目准备就绪！"
echo ""
echo "📋 下一步："
echo "1. 编辑 openclaw.json 配置文件"
echo "2. 配置你的 API 密钥和通道设置"
echo "3. 运行 'npm run dev' 启动开发服务器"
echo "4. 访问 http://localhost:3000 查看效果"