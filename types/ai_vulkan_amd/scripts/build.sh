. "$ROOT_DIR"/scripts/lib/build.sh

export_group_identifiers() {
  RENDER_GROUP_ID=$(getent group render | sed -E 's/render:x:([0-9]+)(:.*)?/\1/')
  VIDEO_GROUP_ID=$(getent group video | sed -E 's/video:x:([0-9]+)(:.*)?/\1/')

  if [ -z "$RENDER_GROUP_ID" ]; then
    echo 'Error: cannot find the render group' >&2
    exit 1
  fi

  if [ -z "$VIDEO_GROUP_ID" ]; then
    echo 'Error: cannot find the video group' >&2
    exit 1
  fi
}

build() {
  docker build \
    --build-arg BASE_IMAGE="${INSTANCE_ID}_${PROJECT_NAME}_ide_image" \
    --build-arg USER_HOME_DIR="$(get_user_home_dir)" \
    --build-arg USER_NAME="$(get_user_name)" \
    --build-arg RENDER_GROUP_ID="$RENDER_GROUP_ID" \
    --build-arg VIDEO_GROUP_ID="$VIDEO_GROUP_ID" \
    --target="${TARGET_STAGE?}" \
    -t "${INSTANCE_ID}_${PROJECT_NAME}"_ide_image \
    -f docker/ide/ide.Dockerfile \
    docker/ide
}

# NOTE: As there are new variables defined in default.sh, a specific build is
#       needed because those variables are used as build arguments.
main() {
  export_group_identifiers &&
    build
}

main
