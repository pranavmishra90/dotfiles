FROM ghcr.io/astral-sh/uv:python3.14-trixie@sha256:65557d27bba9d043ce89a7f1ef82bfdaffb1ce45f5e81fce1efd085050673154 AS base


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
