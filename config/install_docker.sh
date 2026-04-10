#!/bin/bash
# config/install_docker.sh
set -e
source config/assets.env

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$(mktemp -d)"

echo "--- Installing Volta ---"
curl https://get.volta.sh | bash
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

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

echo "--- Installing Terraform ---"
curl -L -o terraform.zip "$TERRAFORM_URL" && unzip -o terraform.zip && install terraform "$BIN_DIR/"

echo "--- Installing AWS CLI ---"
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
./aws/install --bin-dir "$BIN_DIR" --install-dir "$HOME/.local/aws-cli" --update
rm -rf aws awscliv2.zip

echo "--- Installing AWS Session Manager Plugin ---"
curl -s "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
rm session-manager-plugin.deb

echo "--- Syncing configuration files ---"
mkdir -p "$HOME/.config"
cp -rv "$DOTFILES_DIR/.config/"* "$HOME/.config/"
