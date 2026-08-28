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

$(write_inference_server_port_description | comment)
INFERENCE_SERVER_PORT ?= ${INFERENCE_SERVER_PORT}

$(write_rag_server_port_description | comment)
RAG_SERVER_PORT ?= ${RAG_SERVER_PORT}

EOF
}

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
interactive_init_type_sections() {
  prompt_inference_server_port_description &&
    prompt_rag_server_port_description
}

write_inference_server_port_description() {
  cat <<EOF
The port used by the ROCmPFX build of llama_server.
default: $(get_default_value_for INFERENCE_SERVER_PORT)
EOF
}

write_rag_server_port_description() {
  cat <<EOF
The port used by the ROCmPFX build of llama_server for the RAG.
default: $(get_default_value_for RAG_SERVER_PORT)
EOF
}

prompt_inference_server_port_description() {
  write_inference_server_port_description
  echo

  read -e -r -p "[${INFERENCE_SERVER_PORT}]: " inference_server_port

  if [ -n "${inference_server_port}" ]; then
    INFERENCE_SERVER_PORT="${inference_server_port}"
  fi

  echo
}

prompt_rag_server_port_description() {
  write_rag_server_port_description
  echo

  read -e -r -p "[${RAG_SERVER_PORT}]: " rag_server_port

  if [ -n "${rag_server_port}" ]; then
    RAG_SERVER_PORT="${rag_server_port}"
  fi

  echo
}
