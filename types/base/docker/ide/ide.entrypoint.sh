#!/bin/env sh

setup_ssh_authentication() {
  cd "${USER_HOME_DIR}" || return $?

  mkdir -p .ssh
  chmod 0755 .ssh

  cat /run/secrets/ssh_public_key_file >.ssh/id.pub
  sudo chmod 0444 .ssh/id.pub

  sudo sh -c 'cat /run/secrets/ssh_secret_key_file >.ssh/id'
  sudo chown ${USER_NAME}:${USER_NAME} .ssh/id
  sudo chmod 0400 .ssh/id
}

run_live_loop() {
  while true; do
    sleep 1
  done
}

fix_docker_group_id() {
  sudo chown root:docker /var/run/docker.sock
}

main() {
  setup_ssh_authentication &&
    fix_docker_group_id &&
    run_live_loop
}

main
