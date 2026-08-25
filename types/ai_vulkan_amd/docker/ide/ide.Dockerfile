# hadolint global ignore=DL3008
# NOTE: As there is an ancestor for this type, a base image is specified here.
#       Take a look in the build script attached to the build make target to
#       get more insights.
ARG BASE_IMAGE=nideovim_ai_vulkan_amd_ide_image

FROM ${BASE_IMAGE} AS install_go
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER root
# hadolint ignore=DL3008
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get install -y --no-install-recommends \
  golang
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
# hadolint  ignore=DL3062
RUN go install golang.org/dl/go1.24.13@latest
WORKDIR ${USER_HOME_DIR}/go/bin
RUN ./go1.24.13 download

FROM ${BASE_IMAGE} AS build_ollama
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER root
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get install -y --no-install-recommends \
  git cmake pkg-config libssl-dev \
  build-essential libvulkan-dev glslc glslang-tools spirv-headers
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
COPY \
  --from=install_go \
  --chown=${USER_NAME}:${USER_NAME} \
  ${USER_HOME_DIR}/sdk/go1.24.13/ ${USER_HOME_DIR}/sdk/go1.24.13/
ENV PATH=${USER_HOME_DIR}/sdk/go1.24.13/bin/:${PATH}
RUN git clone --depth 1 https://github.com/ollama/ollama.git ollama
WORKDIR ${USER_HOME_DIR}/ollama
RUN git submodule update --init --recursive
RUN cmake -S llama/server -B llama/server/build \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DGGML_VULKAN=ON \
  && cmake --build llama/server/build --config Release --parallel "$(nproc)" --target llama-server
RUN cmake -B build . -DOLLAMA_LLAMA_BACKENDS="vulkan" && \
  cmake --build build --parallel "$(nproc)"
RUN go build -tags full -o ${USER_HOME_DIR}/ollama/dist .

# NOTE: The last build stage must named 'end'. Take a look in the build script
#       attached to the build make target to get more insights
FROM ${BASE_IMAGE} AS end
ARG RENDER_GROUP_ID=0
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
ARG VIDEO_GROUP_ID=0
USER root
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  mesa-vulkan-drivers \
  libgl1-mesa-dri \
  libglx-mesa0 \
  libvulkan1 \
  vulkan-tools \
  && rm -rf /var/lib/apt/lists/* \
  && update-ca-certificates
RUN groupadd -fg ${RENDER_GROUP_ID} render \
  && groupadd -fg ${VIDEO_GROUP_ID} video
USER ${USER_NAME}
COPY \
  --from=build_ollama \
  --chown=${USER_NAME}:${USER_NAME} \
  ${USER_HOME_DIR}/ollama/dist ${USER_HOME_DIR}/.local/bin/ollama
COPY \
  --from=build_ollama \
  --chown=${USER_NAME}:${USER_NAME} \
  ${USER_HOME_DIR}/ollama/llama/server/build/bin/llama-server ${USER_HOME_DIR}/.local/bin/llama-server
ENV PATH=${USER_HOME_DIR}/.local/bin:${PATH}
WORKDIR ${USER_HOME_DIR}
