{ ... }:
{
  home = {
    username = "remedan";
    homeDirectory = "/home/remedan";
  };
  userModules = {
    dev = {
      python.enable = true;
      claude.code.enable = true;
    };
  };
}
