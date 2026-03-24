de() {
  local target="$1"

  case "$target" in
    t) target="test" ;;
    d) target=$(docker ps --format "{{.Image}} {{.Names}}" | grep "^<your-image-name>" | awk '{print $2}' | head -1) ;;
  esac

  # Connect to the container
  docker exec -it "$target" /bin/bash || \
  docker exec -it "$target" /bin/sh
}
