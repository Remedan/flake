{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption mkEnableOption types mkIf;
  cfg = config.userModules.emacs;
in
{
  options.userModules.emacs = {
    enable = mkEnableOption "Emacs";
    service = mkOption {
      type = types.bool;
      default = pkgs.stdenv.isLinux;
    };
  };
  config = mkIf cfg.enable {
    xdg.configFile = {
      "doom/init.el".source = ./doom/init.el;
      "doom/config.el".source = ./doom/config.el;
      "doom/packages.el".source = ./doom/packages.el;
    };
    home.sessionPath = [
      "$HOME/.config/emacs/bin"
    ];
    programs.emacs = {
      enable = true;
      package =
        let
          extraPkgs = with pkgs; [
            vips # For Dirvish image preview
            gcc # For Tree-sitter grammar installation
            claude-agent-acp # For agent-shell
          ];
        in
        pkgs.symlinkJoin {
          name = "emacs";
          paths = [ pkgs.emacs-pgtk ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/emacs --prefix PATH : ${lib.makeBinPath extraPkgs}
          '';
        };
    };
    services.emacs = {
      enable = cfg.service;
      startWithUserSession = "graphical"; # Fixes *ERROR*: Display :0 can’t be opened
    };
    # Emacs needs to have kitty's terminfo in env if it is started in terminal
    systemd.user.services.emacs.Service.Environment = mkIf
      (cfg.service && config.userModules.kitty.enable)
      [ "TERMINFO=${pkgs.kitty}/lib/kitty/terminfo" ];
  };
}
