{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.dev;
in
{
  options.userModules.dev = {
    python = {
      enable = mkEnableOption "Python";
      extraPackages = mkOption {
        type = with types; listOf package;
        default = [ ];
      };
    };
    rust.enable = mkEnableOption "Rust";
    nodejs.enable = mkEnableOption "Node.js";
    commonLisp.enable = mkEnableOption "Common Lisp";
    godot.enable = mkEnableOption "Godot";
    claude.code.enable = mkEnableOption "Claude Code";
    claude.desktop.enable = mkEnableOption "Claude Desktop";
  };
  config = mkMerge [
    (mkIf cfg.python.enable {
      home.packages = with pkgs; [
        poetry
        python3
        ruff
        uv
      ] ++ map lib.lowPrio cfg.python.extraPackages;
    })
    (mkIf cfg.rust.enable {
      home = {
        sessionPath = [ "$HOME/.cargo/bin" ];
        packages = with pkgs; [
          rustup
        ];
      };
    })
    (mkIf cfg.nodejs.enable {
      programs.npm.enable = true;
      home.sessionPath = [ "$HOME/.npm/bin" ];
    })
    (mkIf cfg.commonLisp.enable {
      home.packages = with pkgs; [
        sbcl
        sbclPackages.agnostic-lizard
      ];
    })
    (mkIf cfg.godot.enable {
      home.packages = with pkgs; [
        godot
      ];
    })
    (mkIf cfg.claude.code.enable {
      programs.claude-code.enable = true;
    })
    (mkIf cfg.claude.desktop.enable {
      home.packages = with pkgs; [
        claude-desktop
      ];
    })
  ];
}
