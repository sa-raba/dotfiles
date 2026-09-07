#!/usr/bin/env bash
set -euo pipefail

base="${CODEX_AGENT_BASE:-$HOME}"

setup_agent() {
  local home_dir="$1"
  local codex_dir="$home_dir/.codex"
  local skills_link="$home_dir/.codex/skills"

  mkdir -p "$codex_dir"

  [ -f "$HOME/.codex/auth.json" ] && ln -sfn "$HOME/.codex/auth.json" "$codex_dir/auth.json"
  [ -f "$HOME/.codex/config.toml" ] && ln -sfn "$HOME/.codex/config.toml" "$codex_dir/config.toml"
  [ -d "$HOME/.aws" ] && ln -sfn "$HOME/.aws" "$home_dir/.aws"
  [ -d "$HOME/.gemini" ] && ln -sfn "$HOME/.gemini" "$home_dir/.gemini"
  rm -rf "$skills_link"
  ln -s "$HOME/.codex/skills" "$skills_link"
}

if [ -n "${CODEX_AGENTS:-}" ]; then
  for name in $CODEX_AGENTS; do
    setup_agent "$base/codex-$name"
  done
else
  setup_agent "$base"
fi

exec "$@"
