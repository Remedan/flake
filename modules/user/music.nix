{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.music;
in
{
  options.user-modules.music = {
    enable = mkEnableOption "Music";
    libraryLocation = mkOption {
      type = with types; nullOr path;
      default = null;
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
    services.mpd-mpris.enable = true;
    programs.ncmpcpp.enable = true;
  };
}
