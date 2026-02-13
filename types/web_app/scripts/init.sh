# NOTE: exposes useful functions for instance manipulation and info gathering
. "${ROOT_DIR}"/scripts/lib/instance.sh

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
output_type_toc_items() {
  echo '# WEB APP SPECIFICS'
}

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
output_type_section_items() {
  cat <<EOF
################################################################################
# WEB SPECIFICS
################################################################################

$(write_backend_exposed_port_description | comment)
BACKEND_EXPOSED_PORT ?= ${BACKEND_EXPOSED_PORT}

$(write_frontend_exposed_port_description | comment)
FRONTEND_EXPOSED_PORT ?= ${FRONTEND_EXPOSED_PORT}

EOF
}

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
interactive_init_type_sections() {
  prompt_web_app_ports_description
}

write_create_next_app_major_version_description() {
  cat <<EOF
The major version of the npm package 'create-next-app' to use. The package
that will be isntalled in this docker image will be the last of this major
version.
default: $(get_default_value_for CREATE_NEXT_APP_MAJOR_VERSION)
EOF
}

write_backend_exposed_port_description() {
  cat <<EOF
The port to use for local development endeavors for the backend of your web
app. This port will be published and reachable from your docker host.
default: $(get_default_value_for BACKEND_EXPOSED_PORT)
EOF
}

write_frontend_exposed_port_description() {
  cat <<EOF
The port to use for local development endeavors for the frontend of your web
app. This port will be published and reachable from your docker host.
default: $(get_default_value_for FRONTEND_EXPOSED_PORT)
EOF
}

prompt_backend_port_description() {
  write_backend_exposed_port_description
  echo

  read -e -r -p "[${BACKEND_EXPOSED_PORT}]: " backend_exposed_port

  if [ -n "${backend_exposed_port}" ]; then
    BACKEND_EXPOSED_PORT="${backend_exposed_port}"
  fi

  echo
}

prompt_frontend_port_description() {
  write_frontend_exposed_port_description
  echo

  read -e -r -p "[${FRONTEND_EXPOSED_PORT}]: " frontend_exposed_port

  if [ -n "${frontend_exposed_port}" ]; then
    FRONTEND_EXPOSED_PORT="${frontend_exposed_port}"
  fi

  echo
}

prompt_web_app_ports_description() {
  prompt_backend_port_description &&
    prompt_frontend_port_description

}
