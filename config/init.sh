# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Initialize tools
source <(fzf --bash)
eval "$(starship init bash)"

# Volta (Fast Node Manager)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Aliases
de() {
  local name
  name=$(docker ps --format "{{.Names}} {{.Image}}" | grep "$1" | awk '{print $1}' | head -1)
  docker exec -it "$name" bash || docker exec -it "$name" sh
}

dce() {
  docker compose exec "${1:-app}" bash
}

alias cat='bat'
alias ls='eza --icons --git'
alias ll='eza -al --icons --git'
alias tree='eza --tree --icons'
alias find='fd'
alias ld='lazydocker'
alias lg='lazygit'
alias zj='zellij'
alias zjm='zellij action override-layout ~/.config/zellij/layouts/main.kdl'
alias mount-g='~/dotfiles/config/mount_g.sh'

# Project helpers
dotfiles_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$dotfiles_root/poml/init.sh" ]; then
	source "$dotfiles_root/poml/init.sh"
fi

# Editor
export EDITOR=hx
export VISUAL=hx

# Yazi wrapper for directory change on quit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# AWS
export AWS_PAGER=""

# AI Agents
export TERM=xterm-256color

# zoxide should be initialized at the end of the shell configuration
eval "$(zoxide init bash)"
