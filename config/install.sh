#!/bin/bash
set -e

# --- 0. Prerequisite Check ---
if ! command -v gh &> /dev/null; then
    echo "Error: github-cli (gh) not found. Please install it first."
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: Please login using 'gh auth login'."
    exit 1
fi

# --- 1. Common Settings ---
# Capture the project root directory relative to the script location
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

UPDATE=0
if [ "$1" == "--update" ]; then
    UPDATE=1
fi

# Create and move to a temporary working directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# --- 2. Volta (Fast Node Manager) ---
if [ ! -f "$HOME/.volta/bin/volta" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Volta ---"
    curl https://get.volta.sh | bash
fi
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# --- 3. Helix ---
if [ ! -f "$BIN_DIR/hx" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Helix ---"
    gh release download --repo helix-editor/helix --pattern "helix-*-x86_64-linux.tar.xz" --clobber
    tar xf helix-*.tar.xz
    # Install binary
    install helix-*-x86_64-linux/hx "$BIN_DIR/"
    # Install runtime
    mkdir -p "$HOME/.config/helix"
    cp -r helix-*-x86_64-linux/runtime "$HOME/.config/helix/"
    rm -rf helix-*
fi

# --- 4. Zellij ---
if [ ! -f "$BIN_DIR/zellij" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Zellij ---"
    gh release download --repo zellij-org/zellij --pattern "zellij-x86_64-unknown-linux-musl.tar.gz" --clobber
    tar xf zellij*.tar.gz
    install zellij "$BIN_DIR/"
    rm zellij*
fi

# --- 5. Lazygit ---
if [ ! -f "$BIN_DIR/lazygit" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Lazygit ---"
    gh release download --repo jesseduffield/lazygit --pattern "lazygit_*_linux_x86_64.tar.gz" --clobber
    tar xf lazygit*.tar.gz
    install lazygit "$BIN_DIR/"
    rm -rf lazygit* LICENSE README.md
fi

# --- 6. Yazi ---
if [ ! -f "$BIN_DIR/yazi" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Yazi ---"
    gh release download --repo sxyazi/yazi --pattern "yazi-x86_64-unknown-linux-musl.zip" --clobber
    unzip -o yazi*.zip
    install yazi-*/yazi "$BIN_DIR/"
    rm -rf yazi*
fi

# --- 7. Zoxide ---
if [ ! -f "$BIN_DIR/zoxide" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Zoxide ---"
    gh release download --repo ajeetdsouza/zoxide --pattern "zoxide-*-x86_64-unknown-linux-musl.tar.gz" --clobber
    tar xf zoxide*.tar.gz
    install zoxide "$BIN_DIR/"
    rm -rf zoxide* LICENSE README.md
fi

# --- 8. Fzf ---
if [ ! -f "$BIN_DIR/fzf" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Fzf ---"
    gh release download --repo junegunn/fzf --pattern "fzf-*-linux_amd64.tar.gz" --clobber
    tar xf fzf*.tar.gz
    install fzf "$BIN_DIR/"
    rm -rf fzf* LICENSE
fi

# --- 9. Ripgrep ---
if [ ! -f "$BIN_DIR/rg" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Ripgrep ---"
    gh release download --repo BurntSushi/ripgrep --pattern "ripgrep-*-x86_64-unknown-linux-musl.tar.gz" --clobber
    tar xf ripgrep-*.tar.gz
    install ripgrep-*/rg "$BIN_DIR/"
    rm -rf ripgrep-*
fi

# --- 10. Starship ---
if [ ! -f "$BIN_DIR/starship" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Starship ---"
    gh release download --repo starship/starship --pattern "starship-x86_64-unknown-linux-musl.tar.gz" --clobber
    tar xf starship*.tar.gz
    install starship "$BIN_DIR/"
    rm starship*
fi

# --- 11. bat ---
if [ ! -f "$BIN_DIR/bat" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing bat ---"
    gh release download --repo sharkdp/bat --pattern "bat-*-x86_64-unknown-linux-musl.tar.gz" --clobber
    tar xf bat-*.tar.gz
    install bat-*/bat "$BIN_DIR/"
    rm -rf bat-*
fi

# --- 12. Difftastic ---
if [ ! -f "$BIN_DIR/difft" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Difftastic ---"
    gh release download --repo Wilfred/difftastic --pattern "difft-x86_64-unknown-linux-gnu.tar.gz" --clobber
    tar xf difft-*.tar.gz
    install difft "$BIN_DIR/"
    rm difft
fi

# --- 13. Delta ---
if [ ! -f "$BIN_DIR/delta" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Delta ---"
    gh release download --repo dandavison/delta --pattern "delta-*-x86_64-unknown-linux-musl.tar.gz" --clobber
    tar xf delta-*.tar.gz
    install delta-*/delta "$BIN_DIR/"
    rm -rf delta-*
fi

# --- 14. Lazydocker ---
if [ ! -f "$BIN_DIR/lazydocker" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Lazydocker ---"
    gh release download --repo jesseduffield/lazydocker --pattern "lazydocker_*_Linux_x86_64.tar.gz" --clobber
    tar xf lazydocker*.tar.gz
    install lazydocker "$BIN_DIR/"
    rm lazydocker*
fi

# --- 15. btop ---
if [ ! -f "$BIN_DIR/btop" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing btop ---"
    gh release download --repo aristocratos/btop --pattern "btop-x86_64*linux-musl.tbz" --clobber
    tar xf btop-*.tbz
    if [ -f btop/bin/btop ]; then
        install btop/bin/btop "$BIN_DIR/"
    elif [ -f btop/btop ]; then
        install btop/btop "$BIN_DIR/"
    fi
    rm -rf btop*
fi

# --- 16. eza ---
if [ ! -f "$BIN_DIR/eza" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing eza ---"
    gh release download --repo eza-community/eza --pattern "eza_x86_64-unknown-linux-musl.tar.gz" --clobber
    tar xf eza_*.tar.gz
    install eza "$BIN_DIR/"
    rm eza
fi

# --- 17. fd ---
if [ ! -f "$BIN_DIR/fd" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing fd ---"
    gh release download --repo sharkdp/fd --pattern "fd-*-x86_64-unknown-linux-musl.tar.gz" --clobber
    tar xf fd-*.tar.gz
    install fd-*/fd "$BIN_DIR/"
    rm -rf fd-*
fi

# --- 18. Terraform ---
if [ ! -f "$BIN_DIR/terraform" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing Terraform ---"
    TERRAFORM_VERSION=$(gh release view --repo hashicorp/terraform --json tagName -q '.tagName' | sed 's/v//')
    curl -L -o terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    unzip -o terraform.zip
    install terraform "$BIN_DIR/"
    rm -f terraform terraform.zip
fi

# --- 19. AWS CLI ---
if [ ! -f "$BIN_DIR/aws" ] || [ "$UPDATE" = "1" ]; then
    echo "--- Installing AWS CLI ---"
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    ./aws/install --bin-dir "$BIN_DIR" --install-dir "$HOME/.local/aws-cli" --update
    rm -rf aws awscliv2.zip
fi

# --- 20. AWS Session Manager Plugin ---
if ! command -v session-manager-plugin &> /dev/null || [ "$UPDATE" = "1" ]; then
    echo "--- Installing AWS Session Manager Plugin ---"
    curl -s "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
    sudo dpkg -i session-manager-plugin.deb
    rm session-manager-plugin.deb
fi

# --- 21. Configuration Files ---
echo "--- Syncing configuration files ---"
# Sync .config from repository to ~/.config
mkdir -p "$HOME/.config"
cp -rv "$DOTFILES_DIR/.config/"* "$HOME/.config/"

# --- 22. Cleanup ---
rm -rf "$TMP_DIR"

echo "--- All tools installed successfully! ---"
