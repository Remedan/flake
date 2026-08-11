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
        settings = {
          model = "opus[1m]";
          effortLevel = "high";
          permissions.defaultMode = "auto";
          statusLine = {
            type = "command";
            command = "~/.claude/statusline.sh";
          };
          tui = "fullscreen";
          editorMode = "vim";
        };
      };
      home.shellAliases.c = "claude";
      home.shellAliases.cs = "cd ~/sandbox && claude";
      # Adapted from https://code.claude.com/docs/en/statusline#context-window-usage
      home.file.".claude/statusline.sh".source = ./statusline.sh;
      home.file.".claude/skills/emacs".source = ./skills/emacs;

      home.packages = with pkgs; [
        recall
      ];
    })
    (lib.mkIf cfg.desktop.enable {
      home.packages = with pkgs; [
        claude-desktop-fhs
      ];
    })
  ];
}
