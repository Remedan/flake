# Home Manager and NixOS

<img src="assets/nix-snowflake.svg" alt="Nix snowflake" width="200">

[Home Manager Manual](https://nix-community.github.io/home-manager/)

## Installation

Clone this repo to `~/.config/home-manager` and then build a new configuration.

[Install Doom Emacs](https://github.com/doomemacs/doomemacs?tab=readme-ov-file#install):

```bash
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
```

## Building a new NixOS configuration

```bash
sudo nixos-rebuild switch --flake "$HOME/.config/home-manager#$(hostname)"
```

## Building a new stand-alone Home Manager configuration

### First time setup

```bash
mkdir ~/.config/nix
echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf
nix run home-manager/master -- switch
```

### After first time setup

```bash
home-manager switch
```
