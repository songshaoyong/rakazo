#!/usr/bin/env bash
set -u
host_ip=172.17.192.1

probe() {
  local label="$1" url="$2"
  local code
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 12 "$url" 2>/dev/null) || code=fail
  printf '%-42s %s\n' "$label" "$code"
}

echo "== 直连 =="
probe ghcr https://ghcr.io/v2/
probe dockerhub https://registry-1.docker.io/v2/
probe github-raw https://raw.githubusercontent.com/elie222/rakazo/main/README.md
probe jsdelivr-gh https://cdn.jsdelivr.net/gh/elie222/rakazo@main/README.md
probe daocloud https://docker.m.daocloud.io/v2/
probe dockerproxy https://dockerproxy.com/v2/
probe 1panel https://docker.1panel.live/v2/
probe rat https://hub.rat.dev/v2/

echo
echo "== 宿主机代理 $host_ip:7890 =="
if timeout 5 bash -c "cat < /dev/null > /dev/tcp/$host_ip/7890" 2>/dev/null; then
  echo "tcp 7890 可连通"
else
  echo "tcp 7890 拒绝/超时（Clash 只监听 127.0.0.1，未开 Allow LAN）"
fi
