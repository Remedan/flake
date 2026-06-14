{ config, lib, pkgs, ... }:
let
  cfg = config.userModules.claude;
in
{
  options.userModules.claude = {
    code.enable = lib.mkEnableOption "Claude Code";
    desktop.enable = lib.mkEnableOption "Claude Desktop";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.code.enable {
      programs.claude-code = {
        enable = true;
      };
    })
    (lib.mkIf cfg.desktop.enable {
      home.packages = with pkgs; [
        # TODO Broken upstream
        # claude-desktop-fhs
      ];
    })
  ];
}
