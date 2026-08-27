# Docker開発環境

## イメージの作成

`BASE_IMAGE` はデフォルト値を持たないため、build 時に必ず指定します。
以下のコマンドはリポジトリのルートディレクトリで実行してください。
どのイメージにも共通ツールと Node.js、Codex がインストールされ、`BASE_IMAGE` に応じて
追加の実行環境が変わります。

```bash
# Node
BASE_IMAGE=debian:bookworm-slim docker build --build-arg BASE_IMAGE -f docker/Dockerfile -t codex-docker-node:latest .
# Go
BASE_IMAGE=golang:bookworm docker build --build-arg BASE_IMAGE -f docker/Dockerfile -t codex-docker-go:latest .
# Python
BASE_IMAGE=python:3.13-bookworm docker build --build-arg BASE_IMAGE -f docker/Dockerfile -t codex-docker-python:latest .
```

## 関連コマンド

```bash
# 初回のみ、ネットワークを作成
docker network create work-shared
# 起動、接続、停止
docker compose -p "$(basename "$PWD")" -f "${HOME}/dotfiles/docker/docker-compose.yml" up -d
docker compose -p "$(basename "$PWD")" -f "${HOME}/dotfiles/docker/docker-compose.yml" exec app bash
docker compose -p "$(basename "$PWD")" -f "${HOME}/dotfiles/docker/docker-compose.yml" down
```

ツール類は Dockerfile の build 時にインストールされます。起動時はリポジトリを
`/workspace` にマウントし、作業ツリーをそのまま利用します。compose はイメージを
build しないため、あらかじめイメージを作成しておく必要があります。別プロジェクトで
compose ファイルを使う場合は、そのプロジェクトのルートディレクトリで起動します。
