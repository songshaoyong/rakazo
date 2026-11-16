#!/usr/bin/env bash
set -u
M=docker.m.daocloud.io
get() {
  local path="$1"
  local code
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 \
    -H 'Accept: application/vnd.docker.distribution.manifest.list.v2+json, application/vnd.oci.image.index.v1+json, application/vnd.docker.distribution.manifest.v2+json' \
    "https://$M/v2/$path")
  printf '%-90s %s\n' "$path" "$code"
}
get 'library/postgres/manifests/16'
get 'library/postgres/manifests/sha256:e17e86066e5ef83e0952a9347f5c792b7ece00972e2aa787a6986f471b3dd3d5'
get 'library/busybox/manifests/1'
