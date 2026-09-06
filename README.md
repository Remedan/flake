# Nix flake that builds my systems

<img src="assets/nix-snowflake.svg" alt="Nix snowflake" width="200">

## Structure

Reusable configuration is organized into custom modules under `modules`. They are further split between NixOS (`system`) and Home Manager (`user`).

Machine profiles live under `hosts`. Secrets are managed via git-crypt and live in `secrets`.

## Installation

1. Clone
2. Unlock secrets with git-crypt
3. Build a NixOS/HM configuration
4. Initialize Doom Emacs
