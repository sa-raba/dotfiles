# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Use UTF-8 locale for Japanese input/output in the container
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

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

dc_help() {
  echo "Usage:"
  echo "  dcu [RUNTIME]  Start containers"
  echo "  dcb [RUNTIME]  Open bash"
  echo "  dcs [RUNTIME]  Stop containers"
  echo "  dcd [RUNTIME]  Stop and remove containers"
  echo "  RUNTIME: node:VERSION, go:VERSION, or python:VERSION"
  echo "  Without RUNTIME, select a locally built devbox image"
}

dc_select() {
  local selected
  selected="$({ docker image ls --format '{{.Repository}}:{{.Tag}}' \
    | awk '$0 ~ /^devbox-(node|go|python):[^:]+$/ { sub(/^devbox-/, ""); print }' \
    | sort -V; } | fzf --height 40% --reverse --prompt='Runtime > ')" || return 1

  [[ -n "$selected" ]] || return 1
  DC_RUNTIME="$selected"
}

dc_use() {
  if [[ $# -eq 1 ]]; then
    DC_RUNTIME="$1"
  elif [[ -z "${DC_RUNTIME:-}" ]]; then
    dc_select || return 1
  fi
}

dc() {
  [[ $# -ge 2 ]] || { dc_help; return 1; }

  local runtime="$1"
  shift

  local project_name
  project_name="$(basename "$PWD" | tr '[:upper:]' '[:lower:]')"

  case "$runtime" in
    node:?*|go:?*|python:?*)
      ;;
    *)
      echo "Runtime must include a version: node:24, go:1.24, or python:3.13" >&2
      return 1
      ;;
  esac

  CODEX_IMAGE="devbox-${runtime}" \
    docker compose \
      -p "$project_name" \
      -f "${HOME}/dotfiles/docker/docker-compose.yml" \
      "$@"
}

dcu() {
  [[ $# -le 1 ]] || { dc_help; return 1; }
  dc_use "$@" || return 1
  dc "$DC_RUNTIME" up -d
}

dcb() {
  [[ $# -le 1 ]] || { dc_help; return 1; }
  dc_use "$@" || return 1
  dc "$DC_RUNTIME" exec app bash
}

dcs() {
  [[ $# -le 1 ]] || { dc_help; return 1; }
  dc_use "$@" || return 1
  dc "$DC_RUNTIME" stop
}

dcd() {
  [[ $# -le 1 ]] || { dc_help; return 1; }
  dc_use "$@" || return 1
  dc "$DC_RUNTIME" down
}

alias cat='bat'
alias ls='eza --icons --git'
alias ll='eza -al --icons --git'
alias tree='eza --tree --icons'
alias find='fd'
alias ld='lazydocker'
alias lg='lazygit'
alias zj='zellij'
alias zjm='zellij action override-layout --retain-existing-terminal-panes ~/.config/zellij/layouts/main.kdl'
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
