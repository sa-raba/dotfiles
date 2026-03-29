# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Initialize tools
source <(fzf --bash)
eval "$(starship init bash)"

# Volta (Fast Node Manager)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Aliases
source "$(dirname "${BASH_SOURCE[0]}")/docker.sh"
alias cat='bat'
alias ls='eza --icons --git'
alias ll='eza -al --icons --git'
alias tree='eza --tree --icons'
alias find='fd'
alias ld='lazydocker'
alias lg='lazygit'
alias zj='zellij'
alias mount-g='~/dotfiles/config/mount_g.sh'

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

# AI Agents
export TERM=xterm-256color

# zoxide should be initialized at the end of the shell configuration
eval "$(zoxide init bash)"
