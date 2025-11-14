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
      package = pkgs.emacs-pgtk; # The pgtk version has native Wayland support
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

    # Since the Emacs pgtk packages sets the wmclass to "emacs" (with lower-case e) we need to create
    # a new .desktop file that has a matching StartupWMCLass for Gnome to recognize the window.
    # This also enables us to add the Calculator action.
    # Mostly taken from: https://github.com/nix-community/home-manager/blob/master/modules/services/emacs.nix#L19
    xdg.desktopEntries = {
      emacsclient = {
        name = "Emacs Client";
        exec = "${config.programs.emacs.package}/bin/emacsclient -c %F";
        icon = "emacs";
        comment = "Edit text";
        genericName = "Text Editor";
        mimeType = [ "text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
        categories = [ "Development" "TextEditor" ];
        actions = {
          "Calculator" = {
            exec = "${config.programs.emacs.package}/bin/emacsclient -ce \"(full-calc)\"";
          };
        };
        settings = {
          Keywords = "Text;Editor";
          StartupWMClass = "emacs";
        };
      };
    };
  };
}
