#!/bin/bash
# config/install_docker.sh
set -e
source config/assets.env

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$(mktemp -d)"

UPDATE=0
if [ "$1" == "--update" ]; then
    UPDATE=1
fi

if [ ! -f "$HOME/.volta/bin/volta" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Volta ---"
    curl https://get.volta.sh | bash
fi
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

if [ ! -f "$BIN_DIR/hx" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Helix ---"
    curl -L -o hx.tar.xz "$HELIX_URL" && tar xf hx.tar.xz && install helix-*-x86_64-linux/hx "$BIN_DIR/"
    mkdir -p "$HOME/.config/helix" && cp -r helix-*-x86_64-linux/runtime "$HOME/.config/helix/"
fi

if [ ! -f "$BIN_DIR/yazi" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Yazi ---"
    curl -L -o yazi.zip "$YAZI_URL" && unzip -o yazi.zip && install yazi-*/yazi "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/zoxide" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Zoxide ---"
    curl -L -o zoxide.tar.gz "$ZOXIDE_URL" && tar xf zoxide.tar.gz && install zoxide "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/fzf" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Fzf ---"
    curl -L -o fzf.tar.gz "$FZF_URL" && tar xf fzf.tar.gz && install fzf "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/rg" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Ripgrep ---"
    curl -L -o rg.tar.gz "$RIPGREP_URL" && tar xf rg.tar.gz && install ripgrep-*/rg "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/starship" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Starship ---"
    curl -L -o starship.tar.gz "$STARSHIP_URL" && tar xf starship.tar.gz && install starship "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/bat" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing bat ---"
    curl -L -o bat.tar.gz "$BAT_URL" && tar xf bat.tar.gz && install bat-*/bat "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/difft" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Difftastic ---"
    curl -L -o difft.tar.gz "$DIFFT_URL" && tar xf difft.tar.gz && install difft "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/eza" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing eza ---"
    curl -L -o eza.tar.gz "$EZA_URL" && tar xf eza.tar.gz && install eza "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/fd" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing fd ---"
    curl -L -o fd.tar.gz "$FD_URL" && tar xf fd.tar.gz && install fd-*/fd "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/terraform" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Terraform ---"
    curl -L -o terraform.zip "$TERRAFORM_URL" && unzip -o terraform.zip && install terraform "$BIN_DIR/"
fi

if [ ! -f "$BIN_DIR/aws" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing AWS CLI ---"
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    ./aws/install --bin-dir "$BIN_DIR" --install-dir "$HOME/.local/aws-cli" --update
    rm -rf aws awscliv2.zip
fi

if ! command -v session-manager-plugin &> /dev/null || [ "$UPDATE" = "1" ]; then
    echo "--- Installing AWS Session Manager Plugin ---"
    curl -s "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
    sudo dpkg -i session-manager-plugin.deb
    rm session-manager-plugin.deb
fi

echo "--- Syncing configuration files ---"
mkdir -p "$HOME/.config"
cp -rv "$DOTFILES_DIR/.config/"* "$HOME/.config/"
