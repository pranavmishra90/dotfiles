# CHANGELOG

<!-- version list -->

## Unreleased

### Documentation

- Update license year and remove root dir changelog
  ([`f747600`](https://github.com/pranavmishra90/dotfiles/commit/f7476009db4c5c7368318f706a4b4ea7f809c1ad))


## v1.2.0 (2026-06-14)

### Bug Fixes

- Add ssh-agent eval
  ([`cfb46b4`](https://github.com/pranavmishra90/dotfiles/commit/cfb46b4450be199ba4751f093e26f39e24094ed6))

- Bash_logout
  ([`9b44859`](https://github.com/pranavmishra90/dotfiles/commit/9b44859a9b3a4389019f7f35fb7e994d172a4b81))

- Chmod +x to the shell files
  ([`1ff0d33`](https://github.com/pranavmishra90/dotfiles/commit/1ff0d33f365e02aa7112b07e1f439f10f0e4a426))

- Chmod +x to the shell files
  ([`9f2d470`](https://github.com/pranavmishra90/dotfiles/commit/9f2d4701edf3888fa90109dd7fbafad02e4fab5c))

- Delete duplicate
  ([`b4c0491`](https://github.com/pranavmishra90/dotfiles/commit/b4c0491ddbbc8888d5e3b9d04d651c43626902df))

- Do not print signatures by default on git log, interferes with gitlens in vscode
  ([`d1cb944`](https://github.com/pranavmishra90/dotfiles/commit/d1cb9442ea9b0e33c3f78a7638cc7f4c9a4e9584))

- Do not show line numbers in nano
  ([`17c8d57`](https://github.com/pranavmishra90/dotfiles/commit/17c8d57d9c328dc783e76a3d03481d609fafc056))

- Gitea remote url to use ssh config
  ([`0a779ac`](https://github.com/pranavmishra90/dotfiles/commit/0a779ac7718ba7f3b78aae1480fba6fb48f423d9))

- Gitea remote url to use ssh config
  ([`9c6a5de`](https://github.com/pranavmishra90/dotfiles/commit/9c6a5de4959d315a227c407ee47204149687a470))

- Logger colors was being overwritten by old code
  ([`edff4ee`](https://github.com/pranavmishra90/dotfiles/commit/edff4eebb6c81759ff19d68c44c888ea164f50bb))

- Only attempt to move pyproject.toml if it exists
  ([`81b99b5`](https://github.com/pranavmishra90/dotfiles/commit/81b99b5bee650fef2551dabdb66dc3db25864325))

- Remove initializing an ssh-agent with bashrz and zshrc
  ([`13b77c4`](https://github.com/pranavmishra90/dotfiles/commit/13b77c49aa358d29cb1fe2ac1f826b5d3ccb32ce))

- Remove keychain init from common-profile
  ([`eb064a7`](https://github.com/pranavmishra90/dotfiles/commit/eb064a7e0eab7182a5c0410acfa073b4da33f977))

- Remove the modification of the current SSH_AGENT_SOCK
  ([`f591dc2`](https://github.com/pranavmishra90/dotfiles/commit/f591dc26068e7934ae7980e003e65e3acf4104cf))

- Use local path to pubkey for signining on other gitconfigs
  ([`7a00c8c`](https://github.com/pranavmishra90/dotfiles/commit/7a00c8c5d4ed60ceb4761ff6f4bbde4c5a206961))

- Use the path to the ssh pubkey rather than giving the value, so that it can always find it, if not
  in the agent
  ([`fb52176`](https://github.com/pranavmishra90/dotfiles/commit/fb521764190abc25f20bcebe221dfae2b8d81855))

### Chores

- Add a pipefail to precommit
  ([`889ca09`](https://github.com/pranavmishra90/dotfiles/commit/889ca096d6cb3b0aea76aa82e9b34dbcf96f9398))

- Cleanup unused lines
  ([`aed5bd8`](https://github.com/pranavmishra90/dotfiles/commit/aed5bd87ac634f45111f8483ec498743d62be9cf))

- Create a copy of pyproject.toml
  ([`b570147`](https://github.com/pranavmishra90/dotfiles/commit/b5701470810c88c885505fd644adb5f3bbba3b22))

- Do not track log files
  ([`233f3b0`](https://github.com/pranavmishra90/dotfiles/commit/233f3b0842aad8e107092cc27034aedec45fbbad))

- Do not track log files
  ([`f1e953f`](https://github.com/pranavmishra90/dotfiles/commit/f1e953f8f682925445ec41b835523d41f0bec860))

- Drpm
  ([`42b811a`](https://github.com/pranavmishra90/dotfiles/commit/42b811a52265df7e2d5fda6a11633af4f3b91502))

- Drpm
  ([`fdf997f`](https://github.com/pranavmishra90/dotfiles/commit/fdf997f4873f14d178428f21029fab03f548d807))

- Merge
  ([`28092b9`](https://github.com/pranavmishra90/dotfiles/commit/28092b980de22ae52fdccd092e94661a8d52d8da))

- Remove bashrc for drpm
  ([`44fdbc1`](https://github.com/pranavmishra90/dotfiles/commit/44fdbc1b7912d3d8794d2ecff3e5eabbf273a904))

- Rename keychain scripts to .bak so that they are not picked up
  ([`63e110b`](https://github.com/pranavmishra90/dotfiles/commit/63e110b3361de5ceca7ecf440fdb463b8b0b3899))

- Rename tmux main config file, removing the preceding dot
  ([`d5c9f9d`](https://github.com/pranavmishra90/dotfiles/commit/d5c9f9d3b2d9a01a1aabd9687f62f9c2b2c75d33))

- Rename tmux main config file, removing the preceding dot
  ([`5533a31`](https://github.com/pranavmishra90/dotfiles/commit/5533a313fc9357cb0f7588c67c3bb329197df2db))

- Save current state
  ([`0a46b98`](https://github.com/pranavmishra90/dotfiles/commit/0a46b98a3ab04586be0731b54460817f8838a613))

- Save current state
  ([`45a4219`](https://github.com/pranavmishra90/dotfiles/commit/45a421978df7a2cf333128cc12cba5f58eafbfaa))

### Code Style

- Add spacing to bootstrapping logger
  ([`5328168`](https://github.com/pranavmishra90/dotfiles/commit/532816854fda5cbccd6ab863e1c1c649c96d2312))

### Features

- Add a default GIT_COMMIT_AUTHOR
  ([`031a5d2`](https://github.com/pranavmishra90/dotfiles/commit/031a5d23961e6cc5047566aa80c4ff2e8c7eeebb))

- Add a script to configure tmux settings via the yadm bootstrap process
  ([`7bd39a8`](https://github.com/pranavmishra90/dotfiles/commit/7bd39a890c36cedcb6b1a28020ea036cb1b2e43e))

- Add a script to configure tmux settings via the yadm bootstrap process
  ([`34805da`](https://github.com/pranavmishra90/dotfiles/commit/34805da0e0e26cd674bf657c3f83f0cb59e29529))

- Add api snippet for reference
  ([`c7f6520`](https://github.com/pranavmishra90/dotfiles/commit/c7f6520826f887e3c6d198bdd6c6eb6cc1eddd93))

- Add bash-logger.sh
  ([`14705fd`](https://github.com/pranavmishra90/dotfiles/commit/14705fd7ef9727e8d1f09b06f0364043808b1487))

- Add ssh signer
  ([`59b7cd4`](https://github.com/pranavmishra90/dotfiles/commit/59b7cd40d0863e71f47d085783fe0e90d495d894))

- Add the bash logger function
  ([`c9a1c76`](https://github.com/pranavmishra90/dotfiles/commit/c9a1c761de69b6d1f0d686d3c8783ade60b3c912))

- Add the bash logger function
  ([`342e1be`](https://github.com/pranavmishra90/dotfiles/commit/342e1bef7b5cb748f52b8e13fe8dad6016fba50b))

- Alias for python--> python3
  ([`4ab8f14`](https://github.com/pranavmishra90/dotfiles/commit/4ab8f146d8eb5fa7b0de3ccc0cb1423c89d089ca))

- Bootstrap should update the local master branch
  ([`5f0f7e9`](https://github.com/pranavmishra90/dotfiles/commit/5f0f7e937b7192ead7b8eca47ce37f7a7f196b8a))

- Bootstrap to merge changes from origin/master
  ([`3b6057c`](https://github.com/pranavmishra90/dotfiles/commit/3b6057c024d1acbbe1f5e92695dd8c1e8aeb7524))

- Bootstrap to merge changes from origin/master
  ([`dda5ba4`](https://github.com/pranavmishra90/dotfiles/commit/dda5ba4e149b8a93fb0d41ab1946b73fb473013e))

- Check for a path for `go`
  ([`e40eb92`](https://github.com/pranavmishra90/dotfiles/commit/e40eb92e6713e3ac486a59ccb1231d279dc02045))

- Copy script to generate long certificates with Step CA
  ([`04adb5b`](https://github.com/pranavmishra90/dotfiles/commit/04adb5b8fcdcc28f153c6db3f57c76b29454ea0c))

- Gitconfig and bitwarden agent bridge
  ([`9c92635`](https://github.com/pranavmishra90/dotfiles/commit/9c92635e89b93464c554c05cbc85006242e549ee))

- Rename pyproject.toml to releaserc.toml so that uv does not detect it as a python project
  ([`5ffa2ca`](https://github.com/pranavmishra90/dotfiles/commit/5ffa2ca76f660651e9ced76bca248e13be6de4e9))

- Update bootstrap ssh url to new forgejo instance
  ([`cb31ac0`](https://github.com/pranavmishra90/dotfiles/commit/cb31ac0bf97529bf995922f084ec2f2e52df7109))

- Update btop config following update to package
  ([`bbeec2b`](https://github.com/pranavmishra90/dotfiles/commit/bbeec2b337c669533d5f24c2be66ae3a986571a5))

- Update releaserc.toml to new forgejo instance
  ([`8853e74`](https://github.com/pranavmishra90/dotfiles/commit/8853e748841a9c2c0b4e2ebefff77e0943f2d234))

- Use user systemd SSH_AUTH_SOCK instead of keychain
  ([`f2769cb`](https://github.com/pranavmishra90/dotfiles/commit/f2769cb50b36fe6a1b667f79a92a5a803e2d223e))


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

- Pminformatics
  ([`6bd4aba`](https://github.com/pranavmishra90/dotfiles/commit/6bd4abadd62168fd59c76c1322cf7f553f9bcf4c))

- Remove datalad autocomplete
  ([`93dead3`](https://github.com/pranavmishra90/dotfiles/commit/93dead3f3a4fc6c547ab50d301d9536791596b86))

- Remove http sslCAInfo from wsl config
  ([`025a77b`](https://github.com/pranavmishra90/dotfiles/commit/025a77b163d97a5ab4986fcb66f17f8de53286e7))

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

- Save current state on wsl
  ([`1b3f33a`](https://github.com/pranavmishra90/dotfiles/commit/1b3f33aece04c5b965d17c7b6409d9105296fa74))

- Switch branch
  ([`67aa5bc`](https://github.com/pranavmishra90/dotfiles/commit/67aa5bcfef20a7582041bf0456ca78bc17d9ba2a))

### Continuous Integration

- **semantic-release**: Automatic update - v1.1.0
  ([`e226f0b`](https://github.com/pranavmishra90/dotfiles/commit/e226f0b6ea59061f01c56205ec773c600b3b0fc1))

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
