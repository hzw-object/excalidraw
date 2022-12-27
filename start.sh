#!/bin/sh -l
time=$(date "+%Y%m%d%H%M%S")
yarn
TAG=latest
SERVER_NAME=hzw-excalidraw
SERVER_PORT=5000
#容器id
CID=$(docker ps | grep "$SERVER_NAME" | awk '{print $1}')

#镜像id
IID=$(docker images | grep "$SERVER_NAME:$TAG" | awk '{print $3}')

if [ -n "$IID" ]; then
  echo "存在镜像$SERVER_NAME, IID-$IID"
  docker rmi $IID
fi

if [ -n "$CID" ]; then
  echo "存在容器$SERVER_NAME, CID-$CID"
  docker stop $CID
  docker rm $CID
fi
# 构建docker镜像
if [ -n "$IID" ]; then
  echo "存在$SERVER_NAME:$TAG镜像，IID=$IID"
  docker rmi $IID
else
  echo "不存在$SERVER_NAME:$TAG镜像，开始构建镜像"
  docker build -t $SERVER_NAME:$TAG .
fi
# 运行docker容器
docker run --rm -dit --name $SERVER_NAME -d -p $SERVER_PORT:80 $SERVER_NAME:$TAG
echo "$SERVER_NAME容器创建完成"




