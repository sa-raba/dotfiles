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
# Node 環境の起動、接続、停止
dcu node
dcb node
dcs node

# Go / Python 環境も同じ形式で操作できます
dcu go
dcb go
dcu python
dcb python

# コンテナを削除する場合
dcd node
```

`dcu` はコンテナを作成・起動し、`dcb` はコンテナの `app` サービスに接続します。
`dcs` はコンテナを保持したまま停止し、`dcd` はコンテナを削除します。
いずれも `node`、`go`、`python` のいずれかを指定してください。
compose ファイルは共通のものを使用し、指定した runtime に対応するイメージが選択されます。

ツール類は Dockerfile の build 時にインストールされます。起動時はリポジトリを
`/workspace` にマウントし、作業ツリーをそのまま利用します。compose はイメージを
build しないため、あらかじめイメージを作成しておく必要があります。別プロジェクトで
compose ファイルを使う場合は、そのプロジェクトのルートディレクトリで起動します。
