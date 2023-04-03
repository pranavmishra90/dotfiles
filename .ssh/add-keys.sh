#!/bin/bash

find ~/.ssh/ -type f -exec grep -l "PRIVATE" {} \; | xargs ssh-add
