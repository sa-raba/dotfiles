# Docker開発環境

## イメージの作成

`BASE_IMAGE` はデフォルト値を持たないため、build 時に必ず指定します。
以下のコマンドはリポジトリのルートディレクトリで実行してください。
どのイメージにも共通ツールと Node.js、Codex がインストールされ、`BASE_IMAGE` に応じて
追加の実行環境が変わります。

```bash
# Node.js 24
docker build --network=host --build-arg BASE_IMAGE=debian:bookworm-slim --build-arg NODE_VERSION=24 -f docker/Dockerfile -t devbox-node:24 .
# Go 1.24
docker build --network=host --build-arg BASE_IMAGE=golang:1.24-bookworm -f docker/Dockerfile -t devbox-go:1.24 .
# Python 3.13
docker build --network=host --build-arg BASE_IMAGE=python:3.13-bookworm -f docker/Dockerfile -t devbox-python:3.13 .
```

`install_docker.sh` はビルド中に外部サイトから複数のツールをダウンロードするため、Docker bridge経由の通信で転送が停止する環境では `--network=host` を指定する。

## 関連コマンド

```bash
# 初回のみ、ネットワークを作成
docker network create work-shared
# Node / Go / Python 環境の起動、接続、停止
# 引数なしなら、ローカルにビルド済みのイメージから選択
dcu
dcb
dcs
dcd

# 明示指定も可能
dcu node:24
dcb python:3.13

# コンテナを削除する場合
dcd node:24
```

`dcu` はコンテナを作成・起動し、`dcb` はコンテナの `app` サービスに接続します。
`dcs` はコンテナを保持したまま停止し、`dcd` はコンテナを削除します。
引数を指定する場合は `node:VERSION`、`go:VERSION`、`python:VERSION` の形式で指定してください。
引数なしの場合は、ローカルに存在する `devbox-*` イメージから選択します。選択結果は
現在のシェルセッション中だけ保持されるため、続けて `dcu`、`dcb`、`dcs`、`dcd` を
実行できます。別のイメージへ切り替える場合は、引数を明示してください。
compose ファイルは共通のものを使用し、指定した runtime に対応するイメージが選択されます。

ツール類は Dockerfile の build 時にインストールされます。起動時はリポジトリを
`/workspace` にマウントし、作業ツリーをそのまま利用します。compose はイメージを
build しないため、あらかじめイメージを作成しておく必要があります。別プロジェクトで
compose ファイルを使う場合は、そのプロジェクトのルートディレクトリで起動します。
