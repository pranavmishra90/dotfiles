FROM ghcr.io/astral-sh/uv:python3.14-trixie@sha256:b60feb07c9c2a9b41d8a6dd97fa76ecf2107ee31be002cc76c8a1814d0dba3dc AS base


RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    yadm \
    openssh-client \
    openssh-server \
    sudo \
    wget \
    python3 \
    rsync \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -U -m -s /bin/bash pranav && \
    echo "pranav ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN useradd -U -m -s /bin/bash coder

USER pranav

WORKDIR /home/pranav

ENV NPM_CONFIG_PREFIX=/home/pranav/.npm-global

ENV PATH=$PATH:/home/pranav/.npm-global/bin
