#!/usr/bin/env bash
set -euo pipefail

agents="${CODEX_AGENTS:-a}"
base="${CODEX_AGENT_BASE:-$HOME}"

for name in $agents; do
  home_dir="$base/codex-$name"
  codex_dir="$home_dir/.codex"

  mkdir -p "$codex_dir"

  [ -f "$HOME/.codex/auth.json" ] && ln -sfn "$HOME/.codex/auth.json" "$codex_dir/auth.json"
  [ -f "$HOME/.codex/config.toml" ] && ln -sfn "$HOME/.codex/config.toml" "$codex_dir/config.toml"
  [ -d "$HOME/.aws" ] && ln -sfn "$HOME/.aws" "$home_dir/.aws"
done

for name in $agents; do
  home_dir="$base/codex-$name"
  skills_link="$home_dir/.codex/skills"

  rm -rf "$skills_link"
  ln -s "$HOME/.codex/skills" "$skills_link"
done

exec "$@"
