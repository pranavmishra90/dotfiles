#!/bin/bash

function gitpush() {
	git push $1 $2
	git log --decorate --all --show-pulls --show-signature --max-count 1
}

function gitcleantags() {
    local TAGS
    TAGS=$(git tag -l "*-main*" "*-rc*" "*-beta*")

    if [ -z "$TAGS" ]; then
        echo 'No tags matching "*-main*" "*-rc*" "*-beta*" found.'
        return
    fi

    echo 'The following tags match "*-main*" "*-rc*" "*-beta*":'
    echo "$TAGS"
    echo -n "Delete these tags locally? [y/N]: "
    read -r CONFIRM_LOCAL

    if [[ "$CONFIRM_LOCAL" =~ ^[Yy]$ ]]; then
        echo "$TAGS" | xargs -n 1 git tag -d
    else
        echo "Skipped local deletion."
    fi

    echo -n "Also delete these tags from 'origin'? [y/N]: "
    read -r CONFIRM_ORIGIN

    if [[ "$CONFIRM_ORIGIN" =~ ^[Yy]$ ]]; then
        echo "$TAGS" | xargs -n 1 -I {} git push origin :refs/tags/{}
        if git remote | grep -q "^warehouse$"; then
            echo "Deleting tags from 'warehouse' as well..."
            echo "$TAGS" | xargs -n 1 -I {} git push warehouse :refs/tags/{}
        fi
    else
        echo "Skipped remote deletion."
    fi
}

function reporoot {
  # Copyright 2009 Daniel Jackoway
  # MIT License
  while [ ! -d .git -a ! -f 'README.md' -a `pwd` != "/" ]
  do
      cd "..";
  done
}