export_group_identifiers() {
  RENDER_GROUP_ID="$(getent group render | sed -E 's/render:x:([0-9]+)(:.*)?/\1/')"
  if [ -z "$RENDER_GROUP_ID" ]; then
    echo 'Error: cannot find the render group' >&2
    return 1
  fi

  VIDEO_GROUP_ID="$(getent group video | sed -E 's/video:x:([0-9]+)(:.*)?/\1/')"
  if [ -z "$VIDEO_GROUP_ID" ]; then
    echo 'Error: cannot find the video group' >&2
    return 1
  fi

  export RENDER_GROUP_ID
  export VIDEO_GROUP_ID
}

forward_to_ancestor() {
  make -C ancestor up
}

main() {
  export_group_identifiers &&
    forward_to_ancestor
}

main
