# CHANGELOG

<!-- version list -->

## v1.1.0 (2025-12-05)

### Bug Fixes

- Add pyproject.toml back
  ([`5e8b012`](https://github.com/pranavmishra90/dotfiles/commit/5e8b01211197446635cf549c162f8313a323289b))

- Comment out line numbers in nano
  ([`d24c88d`](https://github.com/pranavmishra90/dotfiles/commit/d24c88dc91fb1b18f1bd81bac9160aee36af204b))

- Do not set sslCAInfo in gitconfig
  ([`9f616f7`](https://github.com/pranavmishra90/dotfiles/commit/9f616f7c9739e63fb2e2df42ae29d41d7e143029))

- Do not track nano search history
  ([`98ecfec`](https://github.com/pranavmishra90/dotfiles/commit/98ecfec380e0fa5f947640d60b1e4137ec6e3c43))

- Do not use the kill_keychain.sh on logout
  ([`8fd0c27`](https://github.com/pranavmishra90/dotfiles/commit/8fd0c27ad2408acfa972657b5398ea92727c3e94))

- Improve the loading of keychain to prevent duplicate ssh agents / sockets from being created
  ([`02448f1`](https://github.com/pranavmishra90/dotfiles/commit/02448f1ca26cda11b6cff0344b5a5ce59255b7e0))

- Indentation
  ([`e87eb7e`](https://github.com/pranavmishra90/dotfiles/commit/e87eb7e974619b930a917f12a5f2245ff6106a47))

- Remove datalad autocomplete
  ([`93dead3`](https://github.com/pranavmishra90/dotfiles/commit/93dead3f3a4fc6c547ab50d301d9536791596b86))

- Rename python env to a bak extension so that it does not cause `uv` to activate to the wrong env
  when logging in via ssh to ~/
  ([`ce87fdb`](https://github.com/pranavmishra90/dotfiles/commit/ce87fdb8cdbe830cd575df71831b78f01038c460))

- Stop using line numbers for nano. it makes it harder to copy text with the windows terminal
  ([`a9b84fe`](https://github.com/pranavmishra90/dotfiles/commit/a9b84fe81ed3efcf2db56476be7b3db786fb64b6))

- Use bash as the default shell
  ([`5127955`](https://github.com/pranavmishra90/dotfiles/commit/51279551e210ddbdd4207446d92e18dce7efb91a))

### Chores

- Commit pminformatics changes
  ([`e086a23`](https://github.com/pranavmishra90/dotfiles/commit/e086a2375a926643210d8d8f434c3ad676a5b751))

- Save current state
  ([`2e95768`](https://github.com/pranavmishra90/dotfiles/commit/2e95768285f7be839ce9680d2fd59cae0667215f))

- Save current state on mishracloud
  ([`3d76282`](https://github.com/pranavmishra90/dotfiles/commit/3d76282bd957f5887f88460a4c6947db458fdadb))

- Switch branch
  ([`67aa5bc`](https://github.com/pranavmishra90/dotfiles/commit/67aa5bcfef20a7582041bf0456ca78bc17d9ba2a))

### Documentation

- Document how to setup the wsl port proxy
  ([`93dc0e2`](https://github.com/pranavmishra90/dotfiles/commit/93dc0e2514ea4015404efd1e605e8d4e0419ec4a))

### Features

- Add rich print
  ([`95a6709`](https://github.com/pranavmishra90/dotfiles/commit/95a67096c0a8dca02a8b47bdde759223d6bc453f))

- Add wsl port forwarding scripts for powershell and bash
  ([`59f1422`](https://github.com/pranavmishra90/dotfiles/commit/59f142261f632160c27a488aa81d516670088963))

- Add yadm scripts and functions in a new directory format. zsh-autocomplete as a submodule
  ([`3407d27`](https://github.com/pranavmishra90/dotfiles/commit/3407d2775d29993f173eafaa45da8c9945c41587))

- Cleanup of the bashrc and bash_aliases files, remove ones that were duplicates
  ([`2c53fbd`](https://github.com/pranavmishra90/dotfiles/commit/2c53fbdcd0448fe875cd737687ed531f706d4ff1))

- Detect existing keychain sessions and connect to it if they exist
  ([`afbcd61`](https://github.com/pranavmishra90/dotfiles/commit/afbcd61f6b55e80621f589ace62b88cd8a62624f))

- Run active-python() via an alias pointing to an executable uv script
  ([`aa2b11c`](https://github.com/pranavmishra90/dotfiles/commit/aa2b11ccf66531f7149c889b24b44c8d699b1f5d))

- Script to determine the active python env and the uv/conda environment variables
  ([`f008267`](https://github.com/pranavmishra90/dotfiles/commit/f0082679c43e09a1b7d552c6ccb0e8f4e2b0fb10))

- Updates from pminformatics with the shell scripts and functions
  ([`814fc96`](https://github.com/pranavmishra90/dotfiles/commit/814fc96af1f3c5229611d01d3464b900a614a9b3))

- Yadm bootstrap script
  ([`91bd918`](https://github.com/pranavmishra90/dotfiles/commit/91bd918efed4242ceb3b06112cce00c04a21a589))

- Yadm bootstrap sets remote to gitea
  ([`92e98d8`](https://github.com/pranavmishra90/dotfiles/commit/92e98d80fdee96bb83e5c63e5ca171fc7cda5188))


## v1.0.0 (2025-09-14)

- Initial Release
