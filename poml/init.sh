poml() {
  local target_dir="$PWD"
  (
    cd ~/poml-project &&
    POML_FILE="$target_dir/main.poml" npm run --silent dev > "$target_dir/prompt.md"
  )
}
