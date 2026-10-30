FROM ghcr.io/astral-sh/uv:python3.14-trixie@sha256:69acf868b6e856281be85e6088b6e3bde4e46cd83cfd578dbe159076a2920322 AS base


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
