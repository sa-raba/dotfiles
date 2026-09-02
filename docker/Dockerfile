ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG NODE_VERSION=24

ENV DEBIAN_FRONTEND=noninteractive
ENV VOLTA_HOME=/home/work/.volta
ENV PATH=/home/work/.local/bin:/home/work/.volta/bin:${PATH}

COPY config /home/work/dotfiles/config
COPY .config /home/work/dotfiles/.config
COPY --chmod=0755 docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        sudo \
        unzip \
        xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --user-group --shell /bin/bash work \
    && echo 'work ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/work \
    && chmod 0440 /etc/sudoers.d/work \
    && mkdir -p /workspace \
    && chown -R work:work /home/work /workspace

USER work

RUN cd "$HOME/dotfiles" \
    && ./config/install_docker.sh \
    && volta install node@${NODE_VERSION} \
    && npm install --global @openai/codex \
    && curl -fsSL https://antigravity.google/cli/install.sh | bash \
    && find /tmp -mindepth 1 -maxdepth 1 -user "$(id -un)" -exec rm -rf {} + \
    && { grep -qxF 'source ~/dotfiles/config/init.sh' "$HOME/.bashrc" \
         || echo 'source ~/dotfiles/config/init.sh' >> "$HOME/.bashrc"; }

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
