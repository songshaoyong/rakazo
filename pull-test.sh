#!/usr/bin/env bash
set -u
M=docker.m.daocloud.io
echo "== busybox pull via mirror =="
docker pull "$M/library/busybox:1" 2>&1 | tail -3
echo
echo "== postgres digest manifest via mirror =="
docker manifest inspect "$M/library/postgres@sha256:e17e86066e5ef83e0952a9347f5c792b7ece00972e2aa787a6986f471b3dd3d5" >/dev/null 2>&1 \
  && echo "digest OK" || echo "digest FAILED (将退回 :16 tag)"
echo
echo "== postgres tag manifest via mirror =="
docker manifest inspect "$M/library/postgres:16" >/dev/null 2>&1 && echo "tag OK" || echo "tag FAILED"
echo
echo "== ghcr app manifest =="
docker manifest inspect ghcr.io/elie222/rakazo/app:edge >/dev/null 2>&1 && echo "ghcr app OK" || echo "ghcr app FAILED"
echo "== ghcr computer manifest =="
docker manifest inspect ghcr.io/elie222/rakazo/computer:edge >/dev/null 2>&1 && echo "ghcr computer OK" || echo "ghcr computer FAILED"
