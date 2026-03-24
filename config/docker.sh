de() {
  local target="$1"

  # Convert shorthand 't' to the actual container name
  if [ "$target" = "t" ]; then
    target="task"
  fi

  # Connect to the container
  docker exec -it "$target" /bin/bash || \
  docker exec -it "$target" /bin/sh
}
