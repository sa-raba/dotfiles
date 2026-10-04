#!/bin/bash
# config/install_docker.sh
set -e
source config/assets.env

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$(mktemp -d)"

CURL_OPTS="-fSL --connect-timeout 10 --max-time 120 --speed-limit 1000 --speed-time 10 --retry 3 --retry-delay 2"

UPDATE=0
if [ "$1" == "--update" ]; then
    UPDATE=1
fi

if [ ! -f "$HOME/.volta/bin/volta" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Volta ---"
    mkdir -p "$HOME/.volta/bin"
    curl $CURL_OPTS -o volta.tar.gz "$VOLTA_URL" && tar xf volta.tar.gz -C "$HOME/.volta/bin"
fi
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

if [ ! -f "$BIN_DIR/hx" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Helix ---"
    curl $CURL_OPTS -o hx.tar.xz "$HELIX_URL" && tar xf hx.tar.xz && install helix-*-x86_64-linux/hx "$BIN_DIR/"
    mkdir -p "$HOME/.config/helix" && cp -r helix-*-x86_64-linux/runtime "$HOME/.config/helix/"
fi

if [ ! -f "$BIN_DIR/yazi" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Yazi ---"
    curl $CURL_OPTS -o yazi.zip "$YAZI_URL" && unzip -o yazi.zip && install yazi-*/yazi "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/zoxide" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Zoxide ---"
    curl $CURL_OPTS -o zoxide.tar.gz "$ZOXIDE_URL" && tar xf zoxide.tar.gz && install zoxide "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/fzf" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Fzf ---"
    curl $CURL_OPTS -o fzf.tar.gz "$FZF_URL" && tar xf fzf.tar.gz && install fzf "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/rg" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Ripgrep ---"
    curl $CURL_OPTS -o rg.tar.gz "$RIPGREP_URL" && tar xf rg.tar.gz && install ripgrep-*/rg "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/starship" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Starship ---"
    curl $CURL_OPTS -o starship.tar.gz "$STARSHIP_URL" && tar xf starship.tar.gz && install starship "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/bat" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing bat ---"
    curl $CURL_OPTS -o bat.tar.gz "$BAT_URL" && tar xf bat.tar.gz && install bat-*/bat "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/difft" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Difftastic ---"
    curl $CURL_OPTS -o difft.tar.gz "$DIFFT_URL" && tar xf difft.tar.gz && install difft "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/eza" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing eza ---"
    curl $CURL_OPTS -o eza.tar.gz "$EZA_URL" && tar xf eza.tar.gz && install eza "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/fd" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing fd ---"
    curl $CURL_OPTS -o fd.tar.gz "$FD_URL" && tar xf fd.tar.gz && install fd-*/fd "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/terraform" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Terraform ---"
    curl $CURL_OPTS -o terraform.zip "$TERRAFORM_URL" && unzip -o terraform.zip && install terraform "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/aws" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing AWS CLI ---"
    curl $CURL_OPTS -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
    unzip -o awscliv2.zip
    ./aws/install --bin-dir "$BIN_DIR" --install-dir "$HOME/.local/aws-cli" --update
    rm -rf aws awscliv2.zip
fi

if ! command -v session-manager-plugin &> /dev/null || [ "$UPDATE" = "1" ]; then
    echo "--- Installing AWS Session Manager Plugin ---"
    curl $CURL_OPTS -o "session-manager-plugin.deb" "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"
    sudo dpkg -i session-manager-plugin.deb
    rm session-manager-plugin.deb
fi

echo "--- Syncing configuration files ---"
mkdir -p "$HOME/.config"
cp -rv "$DOTFILES_DIR/.config/"* "$HOME/.config/"
