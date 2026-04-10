{ ... }:
{
  home = {
    username = "remedan";
    homeDirectory = "/home/remedan";
  };
  userModules = {
    music.libraryLocation = "~/Network/Media/Audio/Music";
    dev = {
      python.enable = true;
      rust.enable = true;
      nodejs.enable = true;
      godot.enable = true;
      jetbrains.enable = true;
      claude.code.enable = true;
    };
  };
}
