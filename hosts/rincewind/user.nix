{ ... }:
{
  home = {
    username = "remedan";
    homeDirectory = "/home/remedan";
  };
  userModules = {
    gnome.enable = false;
    dev = {
      python.enable = true;
      claudeCode.enable = true;
    };
  };
}
