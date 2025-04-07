{ ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  user-modules = {
    python = {
      enable = true;
      extraVersions = with pkgs; [
        python310
        python311
        python312
        python313
        python314
      ];
    };
    nodejs.enable = true;
  };
}
