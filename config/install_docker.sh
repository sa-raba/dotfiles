#!/bin/bash
# config/install_docker.sh
set -e
source config/assets.env

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
cd "$(mktemp -d)"

echo "--- Installing fnm ---"
curl -L -o fnm.zip "$FNM_URL" && unzip -o fnm.zip && install fnm "$BIN_DIR/"

echo "--- Installing Helix ---"
curl -L -o hx.tar.xz "$HELIX_URL" && tar xf hx.tar.xz && install helix-*-x86_64-linux/hx "$BIN_DIR/"
mkdir -p "$HOME/.config/helix" && cp -r helix-*-x86_64-linux/runtime "$HOME/.config/helix/"

echo "--- Installing Yazi ---"
curl -L -o yazi.zip "$YAZI_URL" && unzip -o yazi.zip && install yazi-*/yazi "$BIN_DIR/"

echo "--- Installing Zoxide ---"
curl -L -o zoxide.tar.gz "$ZOXIDE_URL" && tar xf zoxide.tar.gz && install zoxide "$BIN_DIR/"

echo "--- Installing Fzf ---"
curl -L -o fzf.tar.gz "$FZF_URL" && tar xf fzf.tar.gz && install fzf "$BIN_DIR/"

echo "--- Installing Ripgrep ---"
curl -L -o rg.tar.gz "$RIPGREP_URL" && tar xf rg.tar.gz && install ripgrep-*/rg "$BIN_DIR/"

echo "--- Installing Starship ---"
curl -L -o starship.tar.gz "$STARSHIP_URL" && tar xf starship.tar.gz && install starship "$BIN_DIR/"

echo "--- Installing bat ---"
curl -L -o bat.tar.gz "$BAT_URL" && tar xf bat.tar.gz && install bat-*/bat "$BIN_DIR/"

echo "--- Installing eza ---"
curl -L -o eza.tar.gz "$EZA_URL" && tar xf eza.tar.gz && install eza "$BIN_DIR/"

echo "--- Installing fd ---"
curl -L -o fd.tar.gz "$FD_URL" && tar xf fd.tar.gz && install fd-*/fd "$BIN_DIR/"
