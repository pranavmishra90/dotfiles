#!/bin/bash

uvx pre-commit install

uvx pre-commit run --all-files
if [ $? -ne 0 ]; then
    echo "Pre-commit checks failed. Please fix the issues and try again."
    exit 1
fi
exit 0