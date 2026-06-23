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
    home = {
      sessionPath = [
        "$HOME/.config/emacs/bin"
      ];
      packages = with pkgs; [
        (pkgs.writeShellScriptBin "doom-update-config" ''
          home-manager switch
          $HOME/.config/emacs/bin/doom sync
          systemctl --user restart emacs
        '')
        vips # for Dirvish image preview
      ];
    };
    programs.emacs.enable = true;
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
