#!/bin/bash
set -e

GITHUB_REPO="https://github.com/your-org/frontend-app.git"
TMP_DIR="./tmp-frontend"
IMAGE_NAME="your-registry.com/frontend-app:latest"

echo "🌐 克隆 GitHub 仓库：$GITHUB_REPO"
rm -rf $TMP_DIR
git clone $GITHUB_REPO $TMP_DIR

echo "📦 在 $TMP_DIR 构建 Docker 镜像..."
docker build -t $IMAGE_NAME $TMP_DIR

echo "🚀 推送镜像到远程仓库..."
docker push $IMAGE_NAME

echo "🧹 清理临时目录..."
rm -rf $TMP_DIR

echo "✅ 镜像构建并推送完成：$IMAGE_NAME"