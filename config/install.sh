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

# Create and move to a temporary working directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# --- 2. Volta (Fast Node Manager) ---
echo "--- Installing Volta ---"
curl https://get.volta.sh | bash
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# --- 3. Helix ---
echo "--- Installing Helix ---"
gh release download --repo helix-editor/helix --pattern "helix-*-x86_64-linux.tar.xz" --clobber
tar xf helix-*.tar.xz
# Install binary
install helix-*-x86_64-linux/hx "$BIN_DIR/"
# Install runtime
mkdir -p "$HOME/.config/helix"
cp -r helix-*-x86_64-linux/runtime "$HOME/.config/helix/"
rm -rf helix-*

# --- 4. Zellij ---
echo "--- Installing Zellij ---"
gh release download --repo zellij-org/zellij --pattern "zellij-x86_64-unknown-linux-musl.tar.gz" --clobber
tar xf zellij*.tar.gz
install zellij "$BIN_DIR/"
rm zellij*

# --- 5. Lazygit ---
echo "--- Installing Lazygit ---"
gh release download --repo jesseduffield/lazygit --pattern "lazygit_*_linux_x86_64.tar.gz" --clobber
tar xf lazygit*.tar.gz
install lazygit "$BIN_DIR/"
rm -rf lazygit* LICENSE README.md

# --- 6. Yazi ---
echo "--- Installing Yazi ---"
gh release download --repo sxyazi/yazi --pattern "yazi-x86_64-unknown-linux-musl.zip" --clobber
unzip -o yazi*.zip
install yazi-*/yazi "$BIN_DIR/"
rm -rf yazi*

# --- 7. Zoxide ---
echo "--- Installing Zoxide ---"
gh release download --repo ajeetdsouza/zoxide --pattern "zoxide-*-x86_64-unknown-linux-musl.tar.gz" --clobber
tar xf zoxide*.tar.gz
install zoxide "$BIN_DIR/"
rm -rf zoxide* LICENSE README.md

# --- 8. Fzf ---
echo "--- Installing Fzf ---"
gh release download --repo junegunn/fzf --pattern "fzf-*-linux_amd64.tar.gz" --clobber
tar xf fzf*.tar.gz
install fzf "$BIN_DIR/"
rm -rf fzf* LICENSE

# --- 9. Ripgrep ---
echo "--- Installing Ripgrep ---"
gh release download --repo BurntSushi/ripgrep --pattern "ripgrep-*-x86_64-unknown-linux-musl.tar.gz" --clobber
tar xf ripgrep-*.tar.gz
install ripgrep-*/rg "$BIN_DIR/"
rm -rf ripgrep-*

# --- 10. Starship ---
echo "--- Installing Starship ---"
gh release download --repo starship/starship --pattern "starship-x86_64-unknown-linux-musl.tar.gz" --clobber
tar xf starship*.tar.gz
install starship "$BIN_DIR/"
rm starship*

# --- 11. bat ---
echo "--- Installing bat ---"
gh release download --repo sharkdp/bat --pattern "bat-*-x86_64-unknown-linux-musl.tar.gz" --clobber
tar xf bat-*.tar.gz
install bat-*/bat "$BIN_DIR/"
rm -rf bat-*

# --- 12. Difftastic ---
echo "--- Installing Difftastic ---"
gh release download --repo Wilfred/difftastic --pattern "difft-x86_64-unknown-linux-gnu.tar.gz" --clobber
tar xf difft-*.tar.gz
install difft "$BIN_DIR/"
rm difft

# --- 13. Delta ---
echo "--- Installing Delta ---"
gh release download --repo dandavison/delta --pattern "delta-*-x86_64-unknown-linux-musl.tar.gz" --clobber
tar xf delta-*.tar.gz
install delta-*/delta "$BIN_DIR/"
rm -rf delta-*

# --- 14. Lazydocker ---
echo "--- Installing Lazydocker ---"
gh release download --repo jesseduffield/lazydocker --pattern "lazydocker_*_Linux_x86_64.tar.gz" --clobber
tar xf lazydocker*.tar.gz
install lazydocker "$BIN_DIR/"
rm lazydocker*

# --- 15. btop ---
echo "--- Installing btop ---"
gh release download --repo aristocratos/btop --pattern "btop-x86_64*linux-musl.tbz" --clobber
tar xf btop-*.tbz
if [ -f btop/bin/btop ]; then
    install btop/bin/btop "$BIN_DIR/"
elif [ -f btop/btop ]; then
    install btop/btop "$BIN_DIR/"
fi
rm -rf btop*

# --- 16. eza ---
echo "--- Installing eza ---"
gh release download --repo eza-community/eza --pattern "eza_x86_64-unknown-linux-musl.tar.gz" --clobber
tar xf eza_*.tar.gz
install eza "$BIN_DIR/"
rm eza

# --- 17. fd ---
echo "--- Installing fd ---"
gh release download --repo sharkdp/fd --pattern "fd-*-x86_64-unknown-linux-musl.tar.gz" --clobber
tar xf fd-*.tar.gz
install fd-*/fd "$BIN_DIR/"
rm -rf fd-*

# --- 18. Configuration Files ---
echo "--- Syncing configuration files ---"
# Sync .config from repository to ~/.config
mkdir -p "$HOME/.config"
cp -rv "$DOTFILES_DIR/.config/"* "$HOME/.config/"

# --- 19. Cleanup ---
rm -rf "$TMP_DIR"

echo "--- All tools installed successfully! ---"
