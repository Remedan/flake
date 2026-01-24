{ ... }:
{
  home = {
    username = "remedan";
    homeDirectory = "/home/remedan";
  };
  user-modules = {
    gnome.enable = false;
    dev = {
      python.enable = true;
      claudeCode.enable = true;
    };
  };
}
