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
        (pkgs.writeShellScriptBin "doom-update-config" ''
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
    # Integration between vterm and zsh
    # https://github.com/akermu/emacs-libvterm/blob/master/README.md#shell-side-configuration
    programs.zsh.initContent = mkOrder 1200 ''
      vterm_printf() {
          if [ -n "$TMUX" ] \
              && { [ "''${TERM%%-*}" = "tmux" ] \
                  || [ "''${TERM%%-*}" = "screen" ]; }; then
              # Tell tmux to pass the escape sequences through
              printf "\ePtmux;\e\e]%s\007\e\\" "$1"
          elif [ "''${TERM%%-*}" = "screen" ]; then
              # GNU screen (screen, screen-256color, screen-256color-bce)
              printf "\eP\e]%s\007\e\\" "$1"
          else
              printf "\e]%s\e\\" "$1"
          fi
      }

      vterm_prompt_end() {
          vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
      }
      setopt PROMPT_SUBST
      PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
    '';
  };
}
