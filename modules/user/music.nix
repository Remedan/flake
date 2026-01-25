{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.music;
in
{
  options.userModules.music = {
    enable = mkEnableOption "Music";
    libraryLocation = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    enableMpris = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
            type    "pipewire"
            name    "PipeWire Sound Server"
        }

        audio_output {
            type    "fifo"
            name    "my_fifo"
            path    "/tmp/mpd.fifo"
            format  "44100:16:2"
        }
      '';
    } // optionalAttrs (cfg.libraryLocation != null) {
      musicDirectory = cfg.libraryLocation;
    };
    services.mpd-mpris.enable = cfg.enableMpris;
    services.mpdscribble = {
      enable = true;
      endpoints."last.fm" = {
        username = "Remedan";
        passwordFile = config.home.homeDirectory + "/.config/mpd/lastfm";
      };
    };
    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    };
    home.packages = with pkgs; [
      mpc
      plattenalbum
      picard
    ];
  };
}
