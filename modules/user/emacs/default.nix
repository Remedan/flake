{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.emacs;
in
{
  options.user-modules.emacs = {
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
        (pkgs.writeShellScriptBin "doom-sync" ''
          home-manager switch
          $HOME/.config/emacs/bin/doom sync
          systemctl --user restart emacs
        '')
        vips # for Dirvish image preview
      ];
    };
    programs.emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; [
        vterm # This way we don't have to build vterm's compiled component
      ];
    };
    services.emacs = {
      enable = cfg.service;
      startWithUserSession = "graphical"; # Fixes *ERROR*: Display :0 can’t be opened
    };
    # Emacs needs to have kitty's terminfo in env if it is started in terminal
    systemd.user.services.emacs.Service.Environment = mkIf
      (cfg.service && config.user-modules.kitty.enable)
      [ "TERMINFO=${pkgs.kitty}/lib/kitty/terminfo" ];
  };
}
