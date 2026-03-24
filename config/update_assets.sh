#!/bin/bash
# config/update_assets.sh
# Fetch the latest release URLs using gh and save them to assets.env

OUT="config/assets.env"
echo "# Generated URLs" > "$OUT"

get_url() {
    local repo=$1
    local pattern=$2
    local var=$3
    # Extract URL list from JSON and filter with grep
    local url=$(gh release view --repo "$repo" --json assets --jq ".assets[].url" | grep -P "$pattern" | head -n 1)
    echo "$var=\"$url\"" >> "$OUT"
    echo "Fetched $var"
}

get_url "Schniz/fnm" "fnm-linux.zip" "FNM_URL"
get_url "helix-editor/helix" "helix-.*-x86_64-linux.tar.xz" "HELIX_URL"
get_url "sxyazi/yazi" "yazi-x86_64-unknown-linux-musl.zip" "YAZI_URL"
get_url "ajeetdsouza/zoxide" "zoxide-.*-x86_64-unknown-linux-musl.tar.gz" "ZOXIDE_URL"
get_url "junegunn/fzf" "fzf-.*-linux_amd64.tar.gz" "FZF_URL"
get_url "BurntSushi/ripgrep" "ripgrep-.*-x86_64-unknown-linux-musl.tar.gz" "RIPGREP_URL"
get_url "starship/starship" "starship-x86_64-unknown-linux-musl.tar.gz" "STARSHIP_URL"
get_url "sharkdp/bat" "bat-.*-x86_64-unknown-linux-musl.tar.gz" "BAT_URL"
get_url "eza-community/eza" "eza_x86_64-unknown-linux-musl.tar.gz" "EZA_URL"
get_url "sharkdp/fd" "fd-.*-x86_64-unknown-linux-musl.tar.gz" "FD_URL"
