{ ... }:
{
  home = {
    username = "remedan";
    homeDirectory = "/home/remedan";
  };
  user-modules = {
    music.libraryLocation = "~/Network/Media/Audio/Music";
    dev = {
      python.enable = true;
      nodejs.enable = true;
      godot.enable = true;
    };
  };
}
