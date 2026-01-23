{ ... }:
{
  home = {
    username = "remedan";
    homeDirectory = "/home/remedan";
  };
  user-modules = {
    music.libraryLocation = "~/Network/Media/Audio/Music";
    gnome.enable = false;
    dev = {
      python.enable = true;
      rust.enable = true;
      nodejs.enable = true;
      godot.enable = true;
      claudeCode.enable = true;
    };
  };
}
