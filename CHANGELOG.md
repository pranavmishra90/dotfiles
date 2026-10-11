# CHANGELOG

<!-- version list -->

## v1.6.0 (2026-10-11)

### Bug Fixes

- /etc/ssh/ssh_known_hosts not /etc/ssh/known_hosts
  ([`9a16384`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/9a1638470bc375e750dad3beda106e56d2975549))

- Add "--force" command so that it automatically overwrites the old ssh certificate
  ([`63d5cf7`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/63d5cf7eda5b5dc4c40e48f3892b46d85d0ea225))

- Add missing sudo
  ([`55db465`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/55db465a2261ee4a0f8ab0802aa705ad365a30f8))

- Alias
  ([`2590634`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/2590634eb56348e922bbf74d383d370c6ed9d239))

- Bash_logout
  ([`ad084a7`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/ad084a774e53ea6de7bd3d23ec41a8cea94e1b5c))

- Call bootstrap_ssh_agent
  ([`2b71f98`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/2b71f98d4a95b6f71464bf048329da16184edfc4))

- Call bootstrap_ssh_agent
  ([`808bc3a`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/808bc3a447673d7ea9f7b2b425878d81735f1811))

- Container yaml
  ([`22574c9`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/22574c963d275e259850942b2385bc705a1311e8))

- Copy destination nesting
  ([`ba59970`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/ba59970dd95bfff35c1db47ded463d3bb33d42ad))

- Create a keyrings directory if it doesn't exist already
  ([`4496c59`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/4496c595d816cbc714383b4017f635af28353c75))

- Dynamic CA_URL if running in github actions
  ([`02cb481`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/02cb48177a9e5eef06f139de1ce09cbc4f10321e))

- Dynamically set CURRENT_HOME using the script's directory, not the user HOME
  ([`137ab33`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/137ab3387c3cce82fc936982cf4391c38680e03e))

- For checkout on the develop branch if all others fail
  ([`6b72c50`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/6b72c50a5ceb85f74e6ec0e9b5f356d77cf14213))

- FORGEJO_ACTION
  ([`5e39156`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/5e391565d7ecd2edd9c61b97de1789a2d87a22ff))

- Hostid
  ([`2443b7c`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/2443b7ca6fa93c8c01bf3ffae57a58cd41ad5fd2))

- Image tag
  ([`cbdfc74`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/cbdfc7407fc3698a33aa05d0912609c6d45fa9bc))

- Logger should emit its text to stderr rather than stdout. otherwise its output is captured
  ([`6149d2f`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/6149d2f3eda2da4506f0dee1912409289ac76b75))

- Logic of checking if forgejo can be reached. otherwise stick with github
  ([`0469282`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/046928222f50b02584dffa18429e48a598a609dd))

- Only source zoxide if it is installed already
  ([`61d70ba`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/61d70ba001dbc333dec9074efefb0b97993253fa))

- Order of variables
  ([`be4b3be`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/be4b3be2020e112f3d7815c0c004965034ec840c))

- Place the script git-signing-key in ~/.local/bin so that it can be picked up on PATH and does run
  into the ~ expansion issue in ~/.gitconfig
  ([`ab043f1`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/ab043f13fabbdafeebd9f3a6f225be9dfbb10845))

- Provide GHCR_PAT as a secret
  ([`4e99fad`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/4e99fada5d2a5b635478da02e7547cb0f4f82d47))

- Remove additional zoxide references
  ([`68e904b`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/68e904b429f24aa5e8f2fdd0e9e0561e8f504eed))

- Remove Automated_ed25519. fix order of Step CA cert authority line
  ([`a02bcc3`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/a02bcc3f8e089498f60064416418e427e07ba5c2))

- Remove root user requirement, uses sudo
  ([`edb4f0e`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/edb4f0e68c462fa01292aea7ad18268a6edbf04b))

- Renamed file
  ([`1a883a2`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/1a883a2ab8de7ecb9f737c4b09c25e07962b4c14))

- Set origin and upstream url in separate lines without a rename
  ([`4edc41b`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/4edc41b29064ae4c00ecb7f242b9cc41a286b503))

- Source the system bash settings
  ([`68c7ff5`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/68c7ff550acc6741c38fa15e0696a7a717e8990e))

- Sudo cat
  ([`6514da4`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/6514da494fa400d7d24e4afecd16e5129caa7238))

- Testing additional outputs of user and id
  ([`f271b72`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/f271b725c736abea07fcfa5b6f712d8bf11deda9))

- Use full path for sshd_config
  ([`3527ed5`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/3527ed51dd2c984c93cf15fd25eb7b93c385c0ed))

- Use intermediate copy directory
  ([`f0d1a00`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/f0d1a00d9cb95b350d8177d6a01501a70fae9431))

- Was missing a check for the SSH host cert, not the public key (which will almost always be
  present)
  ([`e08c67f`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/e08c67f7eb286cdcfe1e28ddc7cf23f1c11024ab))

### Build System

- Add pre-commit
  ([`3cc9030`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/3cc903036d8490fa8b8b5a598ac623d2d898f125))

### Chores

- Add vscode settings to the repo
  ([`8b05ceb`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/8b05ceb6fbcf1f215b09e9274bf4ce1ab24e37d9))

- Add vscode settings to the repo
  ([`3f05399`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/3f05399a81cd6d69e49ea1e043a45128543f9846))

- Chmod +x
  ([`4abaf72`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/4abaf7253e831fe991f98c915d9f589efc651840))

- Create worktree dir for use by github / forgejo actions
  ([`4694eed`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/4694eed9a0816fcbacea85dba46a9d46e9ed90ff))

- Ignore
  ([`54c9cfb`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/54c9cfb0f4d3e228577ffa131885172f703de60c))

- Move the primary bootstrap lower in the order
  ([`9703019`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/9703019759b805a81a19c3ac7c813e92d4172c5e))

- Remove deprecated ssh-function.bash file
  ([`e6d2035`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/e6d2035c0ec5fb41e4b4c3f74a7954dadd355f6f))

- Rename file to 'dynamic-git-remotes' as it better fits what's being done
  ([`da8bd7d`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/da8bd7dcb1e4299988302dc479648e436ce043a7))

- Temp remove the logic for setting the git remotes
  ([`5bd75f7`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/5bd75f7fafaa36e48b60f62531f4c909737a53ee))

- Unify changes to .gitconfig
  ([`f494749`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/f49474918d010e22a1601161e11854e16ff76517))

- **deps**: Add .renovaterc.json
  ([`3d7f2f0`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/3d7f2f0284cd74bc12ce4588e348c875f998c99e))

- **deps**: Update ghcr.io/astral-sh/uv:python3.14-trixie docker digest to 432482a
  ([#55](https://git.mishracloud.com/pranavmishra90/dotfiles/pulls/55),
  [`910de74`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/910de749afb4a04528fb52d72eed911d62205341))

- **deps**: Update ghcr.io/astral-sh/uv:python3.14-trixie docker digest to 432482a
  ([#55](https://git.mishracloud.com/pranavmishra90/dotfiles/pulls/55),
  [`2f853c9`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/2f853c96c3b88639db19e5d66dbce6b56de4aa47))

### Code Style

- Formatting
  ([`f1608e2`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/f1608e2e6ad8a1c61ea8cb3d3eb42070114b7d62))

### Continuous Integration

- Add pre-commit
  ([`e317acb`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/e317acba3b1c8f4d29e7d9103f5d8e3dd98ee636))

- Add workflow file back, with restriction on forgejo only
  ([`84388d4`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/84388d40ca654b66b2997243c98b8551323f5573))

- Case for main or master
  ([`ffb03a0`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/ffb03a0d667b66f41c1688c2f35a6ac667c5053f))

- Case for main or master
  ([`f18cc90`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/f18cc9021756ddecfe0814ed4cbe32db038098f4))

- Case for main or master
  ([`eed499a`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/eed499a9c0724eba9100cafd2644c22f87a68412))

- Case for main or master
  ([`407265e`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/407265ec2e7dcb6c28de75bd95bc1a013441e2c5))

- Create seperate log branch and use worktree
  ([`992064c`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/992064cf892871e457b1d392762fabf06c45c01c))

- Install rsync outside the image
  ([`2137933`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/213793364d94c45406c118271434703ef8d38b97))

- Test using the devcontainer in forgejo
  ([`69182a8`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/69182a8df0ec03051e7750f87de9080c624680de))

- Update develop branch when a commit to main/master is done
  ([`f96f19f`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/f96f19f9ff8c02f368db8087083fc6cbfa77e2cc))

- Update develop branch when a commit to main/master is done
  ([`0a3d674`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/0a3d674aba36b07e12a59dca1271121e3974c2d4))

- Update develop branch when a commit to main/master is done
  ([`4bdcb44`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/4bdcb447c22250e883e8454fd8d6acdeec3ee3d1))

### Features

- Add a logger executable in ~/.local/bin so that it takes priority on interactive shells
  ([`4272bfb`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/4272bfbaeeae4fd66fe9deb264cb19173324fdac))

- Add additional mappings for wakatime
  ([`19ba80b`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/19ba80ba5de8f88487ac779d56482fa131b21834))

- Add additional PATH variables, from drpm config
  ([`5ec4f55`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/5ec4f556946b9e1ea70a7024b3164487918d8276))

- Add alias for a step ssh login with manual principles
  ([`9cf1fac`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/9cf1fac0b9f4019645fd08eaaae20a5a4e25a0ea))

- Add back sshd config file
  ([`2c6c2e5`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/2c6c2e5996c0165cf66b8c0f3361d7c63de2a4f8))

- Add bash functions to check if ssh certificates are present
  ([`c4c6186`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/c4c6186c8252f7479b9b0dede59522858634feef))

- Add checks if the host needs a new key, a renewal, or nothing
  ([`86c34bb`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/86c34bb6ee17d90f6a79e866c75e0acc339599ac))

- Add docs and script for selective git merge based on PRs on forgejo
  ([`fcdc4c5`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/fcdc4c5335bba362a53980ffaa1e807d39b76d53))

- Add file from https://files.smallstep.com/ssh-host.sh
  ([`02b055d`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/02b055db3992f4508b6238c3be570666e33dff1b))

- Add file from https://files.smallstep.com/ssh-host.sh
  ([`2de55b0`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/2de55b093042652fa1831d7acb497d8c929c7a5c))

- Add script for default git ssh signing operation. no more hardcodes!
  ([`fcff325`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/fcff3252339111f88b321afa1e72e44590ae6357))

- Add ssh config files to yadm
  ([`3c8fab5`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/3c8fab555a70ec510c1ef984425b4331536e2bc6))

- Add Step CA systemd files
  ([`880b4de`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/880b4dec6a03c55de513925aba25cf95bdc32b50))

- Add tirith security checks
  ([`ca657fb`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/ca657fb85e4904106d340e7807d663ed0e92d059))

- Add tirith security checks
  ([`e385df7`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/e385df78b2417d49157a74680ab7015d69473d57))

- Bring over changes from drpm, add some notes; delete the unique bashrc for drpm
  ([`122cca0`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/122cca06d0581a1a3ea93d33df1a42e523554578))

- Ca-url
  ([`6ad1de0`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/6ad1de05cbd3586c185ead179c1b76166ec3acb4))

- Check github_actions
  ([`e38ce9e`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/e38ce9eee1a709c3d62aced9355e52b548dfe82b))

- Copy in the SSH host provisioning from step-bootstrap
  ([`041defc`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/041defc834f3147ca736430fdf9008f7b0139ca8))

- Create a function for step-login, rather than an alias. keeping in .common-profile for now to test
  ([`49cc4f4`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/49cc4f4bb713184486964f1e277835fb91e2b551))

- Create a function for step-login, rather than an alias. keeping in .common-profile for now to test
  ([`cac673b`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/cac673b1e8ecd9782ef744b492904d0cb1737e7e))

- Create a script that dynamically sets a repos remotes between forgejo and github on SSH and HTTPS
  ([`92036fd`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/92036fddde490e4852481e1fa56579358f135c00))

- Create a separate script for the step-cli initialization
  ([`ffef43e`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/ffef43eb657eadd1a09e6f435dfb762c98d719fd))

- Create a ssh.d/ config file
  ([`5b76828`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/5b76828b21cfe172680eeaca6fab97279761ad4b))

- Create logic for non-systemd environments
  ([`dbbc493`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/dbbc4934915512f6a8ee424a79e20f7f1872ede8))

- Detect and correct/update if STEPPATH went to the local user rather than the system
  ([`17e265c`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/17e265c71edc630b85d37c44472984474846bd64))

- Devcontainer Dockerfile for testing (ghcr.io/pranavmishra90/dotfiles-devcontainer:latest)
  ([`299cc9d`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/299cc9daf181e01bb3ae0564d63a59ba9b56a711))

- Ensure existing bootstrap script runs first
  ([`74bb0a9`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/74bb0a9ef9c4d296d3071116510a5e4d6ab75927))

- Further dynamic setup of log files when changing users and writing to the same file
  ([`4911fbf`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/4911fbf5fbcfcb9af650ccbb887010dac0a9cf57))

- Ignore git worktrees
  ([`fd8ce74`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/fd8ce746182376d003f593e95cec4c73714c2171))

- Ignore git worktrees
  ([`c330599`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/c330599c7545af82fd9d9a53b89a3718af757917))

- Install rsync as part of the pipeline
  ([`0d253e3`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/0d253e34df892218cba099f857c51b95f42a4a2e))

- Make non-interactive
  ([`5e38db8`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/5e38db822a9ffb9f5c4d88b0d3c15e11c70b2b6c))

- Output the certficate details when showing a single commit. add certificate to json "ssh_key"
  ([`47d8492`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/47d8492560fbaa3fd701c50fe40dc072767cd88f))

- Pass in env
  ([`b58846e`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/b58846e083729d1523e56918162f5614fd091b15))

- Perform the yadm branch change at the end of the bootstrap process
  ([`f852e47`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/f852e477738e2cddcdc46f0af7adb1b789f157e4))

- Print out more info about current keys
  ([`ae013ca`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/ae013ca718e67e585dd617505292f6d991036cc8))

- Remove the autoamted signature. clean separation between human and bots
  ([`7e8d30d`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/7e8d30dc427ff50e2a9e9dbe2be9275355ebea31))

- Rsync
  ([`d30258c`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/d30258c967e2466d9371fb364d7c0a7ac906de29))

- Script to validate git signed commits with or without ssh certs
  ([`37fb5ec`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/37fb5ec58397ea9a76f7053cf39d9bbfa46efdc0))

- Scripts to get the user env and nearest user home
  ([`a10fcf6`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/a10fcf6df2c49b1337633686bb6ccff2f5220e87))

- Ssh token
  ([`8629ab5`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/8629ab51bee9fb3faedd9e986d6d321400f4ea4f))

- Step debug
  ([`48fa197`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/48fa197cbeb6c96006f7b91f89ecd2f36e4927d0))

- Update logger to constant url
  ([`e2f4a01`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/e2f4a0149e5e3e79454aab3905e6f7c93d3f6784))

- Use a case matrix to test the various endpoints where Forgejo > GitHub, SSH > HTTPS, and set the
  upstream if origin is not github
  ([`b856963`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/b8569638adb6ebbf2efc0d5b0f810eaae1c0b7f6))

- Use token
  ([`e4453c2`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/e4453c246a57668322b299b9086004f62346afa4))

- WIP logging for git remote test
  ([`71f0c8f`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/71f0c8f472fea3dcc10bc6fdcbb623f33a876cb9))

### Refactoring

- Gitconfig yadm switchout now occurs with included files in ~/git. keeps home directory cleaner
  ([`2738e89`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/2738e89942fc27766465d13b5918f9734afb8d1e))

### Testing

- Add rsync to devcontainer image
  ([`eddaa13`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/eddaa13065f2c6262783aaf6080bf89090d817c4))

- Bootstrap
  ([`869ff38`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/869ff380ed81f33fe5b3d3a931401ad802feda61))

- Try to clone yadm inside docker container
  ([`b18fad9`](https://git.mishracloud.com/pranavmishra90/dotfiles/commit/b18fad91968466845d8ec14bc54161667898911c))


## v1.5.1 (2026-08-26)

### Bug Fixes

- Remote name token
  ([`25503cb`](https://github.com/pranavmishra90/dotfiles/commit/25503cb5b9df6c37dd63b1c5ff4758f3995423e9))


## v1.5.0 (2026-08-26)

### Bug Fixes

- Spelling issue for psr alias
  ([`5c4b1c9`](https://github.com/pranavmishra90/dotfiles/commit/5c4b1c97ed6bd5efdd4b835f30095becab5b8483))

### Chores

- Create a bootstrap.d directory and run all of the files in there
  ([`7766f36`](https://github.com/pranavmishra90/dotfiles/commit/7766f3633734a550d767ce0dfeb5637c7ccc1845))

- Move step script into a dedicated dir
  ([`191ae1b`](https://github.com/pranavmishra90/dotfiles/commit/191ae1be6bd4eb453bba365bb14b1af299e8ccff))

- Rename back (preserves the git history on the previous commit)
  ([`cff89b0`](https://github.com/pranavmishra90/dotfiles/commit/cff89b0524e0374e037884d155a81dafeee2bfdd))

### Features

- Add a tailscale override to, by default, deny tailscale DNS and not use subnet routing
  ([`d7211a6`](https://github.com/pranavmishra90/dotfiles/commit/d7211a6892c1af0bffac9c9ff53f018e1823c14b))

- Add step-bootstrap.sh to setup Step CA with SSH Certs
  ([`081603e`](https://github.com/pranavmishra90/dotfiles/commit/081603e59323cfdeeaca3230cde33cb4ecb505ad))

- Dynamically set aliases for `ls` and `ll` depending on whether eza is installed
  ([`54ef237`](https://github.com/pranavmishra90/dotfiles/commit/54ef23754c25215acd01422224b34db9dfb0b1cb))

- WIP finding / resetting the yadm symlinks to the default option
  ([`4c029ce`](https://github.com/pranavmishra90/dotfiles/commit/4c029ce67dcaaa1cb5c01b2eb107d939c7574681))

### Refactoring

- Consolidate bash_aliases into one file, use yadm/shell/computer_sepecific to handle nuances.
  ([`ccd87c0`](https://github.com/pranavmishra90/dotfiles/commit/ccd87c08c9ac731ff2b9cae952b28cb0b066dc1d))

- Use ~/yadm rather than YADM_ROOT
  ([`96a0050`](https://github.com/pranavmishra90/dotfiles/commit/96a00505758079f086b1d790f28af2383abe1e05))


## v1.4.0 (2026-08-18)

### Bug Fixes

- .local/bin/ to use dynamic $HOME
  ([`630d85e`](https://github.com/pranavmishra90/dotfiles/commit/630d85ec45a06f9972ed06ac7d44ffcd0761ea90))

- Add back in newer config parameters for btop
  ([`40bbf3a`](https://github.com/pranavmishra90/dotfiles/commit/40bbf3ae5768bf751a0c4f70859628200ba22f47))

- Bash-logger from sh to bash extension
  ([`2ada0ea`](https://github.com/pranavmishra90/dotfiles/commit/2ada0ea4d8e5d84888202c726360251c569408e2))

- Have parameters for YADM_CUSTOM_DEBUG either 0 or 1 based on YADM_TEST
  ([`02c8405`](https://github.com/pranavmishra90/dotfiles/commit/02c84051bfab233ba53a40a895da1dc1617f4539))

- Make the conda init script dynamic for $HOME
  ([`d6df26e`](https://github.com/pranavmishra90/dotfiles/commit/d6df26eb6eabb9fb1ee9f595f785e27b111a15e2))

- Set default eth NIC for pminformatics, remove ssh-agent init in bashrc from mishracloud
  ([`f124696`](https://github.com/pranavmishra90/dotfiles/commit/f124696da5241ebf63997035739fd9622531e37b))

- Setup-tmux from sh to bash extension
  ([`8320fa7`](https://github.com/pranavmishra90/dotfiles/commit/8320fa7a4800f2f13a5b12fa33dd1d651cc0a8f7))

- Setup-tmux from sh to bash extension
  ([`7a7e4ee`](https://github.com/pranavmishra90/dotfiles/commit/7a7e4eeb8e5159089170e5d122ab3afe4d364662))

- Source a bash logger script from github directly if the local one is not working
  ([`c5b78d7`](https://github.com/pranavmishra90/dotfiles/commit/c5b78d7fa92543697c64404fb320b70e2f915ff3))

- Switch to HOME variable rather than ~/ expansion
  ([`4f7ee23`](https://github.com/pranavmishra90/dotfiles/commit/4f7ee23e926bfec1d5394b78d6ab74dac47cb8a7))

### Chores

- Add on proxmox
  ([`1830516`](https://github.com/pranavmishra90/dotfiles/commit/1830516624841cb2a21d3051755358dd33b1edc8))

- Change machine
  ([`e3ab51b`](https://github.com/pranavmishra90/dotfiles/commit/e3ab51b103e2f3a81c8f1a34bd28e66fd4c886a1))

- Cleanup changelog
  ([`10de83f`](https://github.com/pranavmishra90/dotfiles/commit/10de83fa07f9a6642747f8bfa2c90eb92693254c))

- Create docs dir
  ([`bb9d30c`](https://github.com/pranavmishra90/dotfiles/commit/bb9d30cd2f1eb7c8aa152ef3e7164694253c42c1))

- Pranav-surface
  ([`172be41`](https://github.com/pranavmishra90/dotfiles/commit/172be41231c43ce289da95bbfe1b9ea82430e751))

- Pranav-surface
  ([`85c84d4`](https://github.com/pranavmishra90/dotfiles/commit/85c84d44cdef0b7df962789180f8be0cf99e73bc))

- Remove mamba init from bashrc
  ([`54e5241`](https://github.com/pranavmishra90/dotfiles/commit/54e52410a0a73e8b9c26d0a0b1d66496d8b85428))

- Switch to default
  ([`966bb33`](https://github.com/pranavmishra90/dotfiles/commit/966bb33b37a0f21bd99a2d4f689b8dbd5c011b31))

### Features

- Add script to verify the dotfiles script [WIP]
  ([`5deb873`](https://github.com/pranavmishra90/dotfiles/commit/5deb873129b47cf77204e6e1088b1a4dedb98bf5))

- Add validation when starting the ssh agent
  ([`22b4e8f`](https://github.com/pranavmishra90/dotfiles/commit/22b4e8f9a267f10715e50894fa160f0886cf27dd))

- Add verbosity functionality
  ([`e96be8f`](https://github.com/pranavmishra90/dotfiles/commit/e96be8f6509dbc5750640b2fffb299abd1b828d8))

- Create "start-ssh-agent.bash" script which is copied from and updating the wsl script's behavior
  ([`61b9351`](https://github.com/pranavmishra90/dotfiles/commit/61b9351b6688bf28e92914330393a6e27c5d791a))

- Make scripts safe for sh/POSIX
  ([`85e2873`](https://github.com/pranavmishra90/dotfiles/commit/85e2873064ba888e530e9f45d48f98bf6fc03d3a))

- Prefer inherited socket and validate
  ([`628ae9f`](https://github.com/pranavmishra90/dotfiles/commit/628ae9fab422c50378b1a809ae346a5003861540))

- Split the functions into a separate library file
  ([`f211672`](https://github.com/pranavmishra90/dotfiles/commit/f211672aa2565d4499edb3e4622dfb8aa813ece0))

- Update btop config for v1.4.6
  ([`22fec49`](https://github.com/pranavmishra90/dotfiles/commit/22fec49be4475d50e3f6d448a0395774d7a19701))

### Testing

- Create a script to init a test environment which allows for a custom YADM_ROOT,
  YADM_TEST_HOME/HOME, YADM_CUSTOM_DEBUG
  ([`53732fd`](https://github.com/pranavmishra90/dotfiles/commit/53732fd55c6cb5567ae3427b50c5fdadc1602ccf))

- Create a test suite using pytest which checks multiple shells (sh, bash, zsh)
  ([`8292483`](https://github.com/pranavmishra90/dotfiles/commit/8292483ddbb214b27b70a1c7c3a692387910a306))


## v1.3.1 (2026-06-14)

### Bug Fixes

- Synatx of PSR release section since it's not a pyproject.toml file
  ([`5d33dd5`](https://github.com/pranavmishra90/dotfiles/commit/5d33dd5d39bcf811303d84ff123a890c6aba62d6))


## v1.3.0 (2026-06-14)

### Bug Fixes

- Use root directory changelog for generation, then move into yadm directory
  ([`61b03c1`](https://github.com/pranavmishra90/dotfiles/commit/61b03c1bf0461cb287bda7d2cc8520ee23ca1e90))

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
