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
    };
    claude.code.enable = true;
    claude.recall.enable = true;
  };
}
