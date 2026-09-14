FROM ghcr.io/astral-sh/uv:python3.14-trixie@sha256:6643a433b1c6ad1121cda332d56be075105d4291c6fd712da5b91b1bb0698fef AS base


RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    yadm \
    openssh-client \
    sudo \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -U -m -s /bin/bash pranav && \
    echo "pranav ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN useradd -U -m -s /bin/bash coder

USER pranav

WORKDIR /home/pranav
