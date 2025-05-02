{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.dev;
in
{
  options.user-modules.dev = {
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
      home.packages = with pkgs; [
        rustup
      ];
    })
    (mkIf cfg.nodejs.enable {
      home.packages = with pkgs; [
        nodejs
      ];
    })
    (mkIf cfg.commonLisp.enable {
      home.packages = with pkgs; [
        sbcl
        sbclPackages.agnostic-lizard
      ];
    })
  ];
}
