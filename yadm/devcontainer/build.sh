#!/bin/bash

docker build -t ghcr.io/pranavmishra90/dotfiles-devcontainer:latest -f ./Dockerfile .

docker push ghcr.io/pranavmishra90/dotfiles-devcontainer:latest
