{ ... }:
{
  home = {
    username = "remedan";
    homeDirectory = "/home/remedan";
  };
  userModules = {
    dev = {
      python.enable = true;
      rust.enable = true;
      t3code.enable = true;
    };
    claude.desktop.enable = true;
  };
}
