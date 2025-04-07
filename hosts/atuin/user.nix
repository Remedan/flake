{ pkgs, ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  user-modules = {
    dev.python = {
      enable = true;
      extraVersions = with pkgs; [
        python310
        python311
        python312
        python313
        python314
      ];
    };
    dev.nodejs.enable = true;
  };
}
