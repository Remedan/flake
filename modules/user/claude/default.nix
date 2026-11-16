{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userModules.claude;
  # Adapted from https://code.claude.com/docs/en/statusline#context-window-usage
  statusline = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs = [
      pkgs.jq
      pkgs.coreutils
    ];
    text = builtins.readFile ./statusline.sh;
  };
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
          model = "claude-opus-5-5";
          permissions.defaultMode = "auto";
          statusLine = {
            type = "command";
            command = lib.getExe statusline;
          };
          tui = "fullscreen";
          editorMode = "vim";
        };
      };
      home.shellAliases.c = "claude";
      home.shellAliases.cs = "cd ~/sandbox && claude";
      home.file.".claude/skills/emacs".source = ./skills/emacs;
    })
    (lib.mkIf cfg.desktop.enable {
      home.packages = with pkgs; [
        claude-desktop-fhs
      ];
    })
  ];
}
