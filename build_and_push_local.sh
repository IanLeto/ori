#!/bin/bash
set -e

IMAGE_NAME="ianleto/goori-feontend:latest"

echo "📁 创建 deploy 目录"
mkdir -p deploy

echo "📦 打包本地前端项目"
npm install
npm run build

echo "🐳 构建 Docker 镜像：$IMAGE_NAME"
docker build -t $IMAGE_NAME .

echo "🚀 推送镜像到远程仓库"
docker push $IMAGE_NAME

echo "✅ 本地代码构建并推送完成"