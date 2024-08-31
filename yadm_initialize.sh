#!/bin/bash

# Ensure the script is executed from the root of the repository
cd "$(dirname "$0")"

# Initialize and update all submodules
git submodule update --init --recursive