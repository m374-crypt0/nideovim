# NOTE: exposes useful functions for instance manipulation and info gathering
. "${ROOT_DIR}"/scripts/lib/instance.sh

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
output_type_toc_items() {
  echo '# AI VULKAN AMD SPECIFICS'
}

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
output_type_section_items() {
  cat <<EOF
################################################################################
# AI VULKAN AMD SPECIFICS
################################################################################

$(write_ollama_port_description | comment)
OLLAMA_PORT ?= ${OLLAMA_PORT}

EOF
}

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
interactive_init_type_sections() {
  prompt_ollama_port_description &&
    prompt_rocmpfx_port_description
}

write_ollama_port_description() {
  cat <<EOF
The port used by ollama.
default: $(get_default_value_for OLLAMA_PORT)
EOF
}

write_rocmpfx_port_description() {
  cat <<EOF
The port used by the ROCmPFX build of llama_server.
default: $(get_default_value_for ROCMPFX_SERVER_PORT)
EOF
}

prompt_ollama_port_description() {
  write_ollama_port_description
  echo

  read -e -r -p "[${OLLAMA_PORT}]: " ollama_port

  if [ -n "${ollama_port}" ]; then
    OLLAMA_PORT="${ollama_port}"
  fi

  echo
}

prompt_rocmpfx_port_description() {
  write_rocmpfx_port_description
  echo

  read -e -r -p "[${ROCMPFX_SERVER_PORT}]: " rocmpfx_server_port

  if [ -n "${rocmpfx_server_port}" ]; then
    ROCMPFX_SERVER_PORT="${rocmpfx_server_port}"
  fi

  echo
}
