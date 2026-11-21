FROM ghcr.io/astral-sh/uv:python3.14-trixie@sha256:b7389fc779a8b057a5e8007ea676b2f99a5cb16e2d0f3d0d9b9888167671d4d5 AS base


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
