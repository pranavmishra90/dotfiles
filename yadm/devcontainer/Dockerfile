FROM node:trixie AS base

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/


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
