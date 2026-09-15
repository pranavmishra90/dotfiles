#!/bin/env bash

cd $(git rev-parse --show-toplevel)

IMG_VERSION=$(python-semantic-release version --print)

docker build -t ghcr.io/pranavmishra90/dotfiles-devcontainer:$IMG_VERSION -f ./yadm/devcontainer/Dockerfile yadm/devcontainer

docker tag ghcr.io/pranavmishra90/dotfiles-devcontainer:$IMG_VERSION ghcr.io/pranavmishra90/dotfiles-devcontainer:latest

docker push ghcr.io/pranavmishra90/dotfiles-devcontainer:$IMG_VERSION
