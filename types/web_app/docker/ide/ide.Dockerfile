# NOTE: As there is an ancestor for this type, a base image is specified here.
#       Take a look in the build script attached to the build make target to
#       get more insights.
ARG BASE_IMAGE=nideovim_next_react_ide_image

# NOTE: The last build stage must named 'end'. Take a look in the build script
#       attached to the build make target to get more insights
FROM ${BASE_IMAGE} AS end
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://bun.com/install | bash
