# dotfiles

## .bashrc

```bash
mkdir -p ~/.local/bin
echo "source ~/dotfiles/config/init.sh" >> ~/.bashrc
```

## github cli

```bash
# https://github.com/cli/cli/releases
GITHUB_CLI_VERSION=2.88.1
curl -LO https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz
tar xvf gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz
install gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh ~/.local/bin/

gh auth login
```

## tools

```bash
./config/install.sh
source config/init.sh
```

## セットアップ後の仕上げ

インストール完了後、以下のコマンドを実行して `git` と `delta` を連携させることを推奨します：

```bash
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global merge.conflictstyle zdiff3
```

### Lazygit で side-by-side diff を有効にする

`lazygit` 内でも `delta` の左右分割表示を使うには、設定ファイル (`~/.config/lazygit/config.yml`) に以下を追記します：

```yaml
git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never --side-by-side
```

## 便利なショートカット一覧

| コマンド | ツール | 特徴 |
| :--- | :--- | :--- |
| `y` | **Yazi** | `q` で終了時にそのディレクトリへ `cd` する |
| `ls` / `ll` | **eza** | アイコン・Gitステータス付きのモダンな `ls` |
| `tree` | **eza** | モダンなツリー表示 |
| `find` | **fd** | 高速で直感的なファイル検索 |
| `cat` | **bat** | シンタックスハイライト付き `cat` |
| `lg` | **lazygit** | Git 管理 TUI |
| `ld` | **lazydocker** | Docker 管理 TUI |
| `zj` | **Zellij** | ターミナルマルチプレクサ（画面分割など） |
| `btop` | **btop** | 豪華なシステムモニター |
| `z [dir]` | **zoxide** | 過去の履歴からディレクトリへ爆速ジャンプ |

## フォント

- [PlemolJP](https://github.com/yuru7/PlemolJP/releases)
