#!/bin/bash
set -e

echo "📁 创建 deploy 目录"
mkdir -p deploy

echo "📄 部署前端资源到 Kubernetes"
kubectl apply -f ./k8s-frontend.yaml

echo "✅ 前端部署已完成"

echo "🌐 访问地址："
echo "http://frontend.example.com"