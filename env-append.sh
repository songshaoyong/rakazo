#!/usr/bin/env bash
set -Eeuo pipefail
cd /mnt/e/projecte/rakazo

append_once() {
  local line="$1" key="${1%%=*}"
  grep -qE "^${key}=" .env && { echo "already set: $key"; return 0; }
  printf '\n%s\n' "$line" >> .env
  echo "appended: $key"
}

# WSL 侧 docker.io 被墙，用可达的 Docker Hub 镜像站代替（摘要与官方一致）
append_once 'POSTGRES_IMAGE=docker.m.daocloud.io/library/postgres:16@sha256:e17e86066e5ef83e0952a9347f5c792b7ece00972e2aa787a6986f471b3dd3d5'
append_once 'BUSYBOX_IMAGE=docker.m.daocloud.io/library/busybox:1'
# 不让安装脚本改动宿主 iptables（会牵连 WSL 里正在工作的 Incus 桥）
append_once 'SANDBOX_COMPUTER_EGRESS=open'
