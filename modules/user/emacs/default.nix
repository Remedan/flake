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
      (cfg.service && config.userModules.kitty.enable)
      [ "TERMINFO=${pkgs.kitty}/lib/kitty/terminfo" ];
    # Integration between vterm and fish
    # https://github.com/akermu/emacs-libvterm/blob/master/README.md#shell-side-configuration
    programs.fish.shellInit = ''
      function vterm_printf;
          if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
              # tell tmux to pass the escape sequences through
              printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
          else if string match -q -- "screen*" "$TERM"
              # GNU screen (screen, screen-256color, screen-256color-bce)
              printf "\eP\e]%s\007\e\\" "$argv"
          else
              printf "\e]%s\e\\" "$argv"
          end
      end

      function vterm_prompt_end;
          vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
      end
      functions --copy fish_prompt vterm_old_fish_prompt
      function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
          # Remove the trailing newline from the original prompt. This is done
          # using the string builtin from fish, but to make sure any escape codes
          # are correctly interpreted, use %b for printf.
          printf "%b" (string join "\n" (vterm_old_fish_prompt))
          vterm_prompt_end
      end
    '';
  };
}
