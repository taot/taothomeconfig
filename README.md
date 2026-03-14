# taothomeconfig

This repo contains my home directory config files, managed by [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

Install `git` and `stow`:

```bash
sudo pacman -S git stow
```

Clone the repo

```bash
git clone git@github.com:taot/taothomeconfig.git
cd taothomeconfig
```

## Manage packages

A package is a related collection of files and directories that you wish to administer as a unit.

### `base` package

 The `base` packages contains bash related configs, e.g. environment variables, aliases, functions.

From the repo root, run:

```bash
stow base
```

This symlinks the files from `base/` into your home directory.

Then add this line to your `~/.bashrc`:

```bash
[[ -f ~/.bashrc.init ]] && source ~/.bashrc.init
```

### Other packages

This repo also contains other config folders for additional tools and applications. They can be stowed separately later if needed.

```bash
stow <package>
```

### Remove packages

To remove the symlinks created by `stow`:

```bash
stow -D <package>
```

## Other folders

This repo also contains other config folders for additional tools and applications. They can be stowed separately later if needed, but they are not required for the basic shell setup.
