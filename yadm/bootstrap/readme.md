# `yadm` bootstrap


`yadm` can perform an automated bootstrap when the repo is first cloned. This is done by creating a `bootstrap` file in the `.config/yadm/` directory.

This directory, `~/yadm/bootstrap`, will contain files / functions that will be sourced and executed in the bootstrapping process. While these files could be present in the `~/.config/yadm` directory, I am placing them within `~/yadm` to retain organizational consistency with the remainder of this dotfiles repo's structure.