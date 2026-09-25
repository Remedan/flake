{ pkgs, lib, ... }:
let
  inherit (lib) mkForce;
in
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "claude-code"
    "vscode-extension-anthropic-claude-code"
  ];
  home.packages = with pkgs; [
    # Core
    bat
    htop
    ripgrep

    # Networking
    nmap
    wireguard-tools

    # Extra
    fastfetch
    fd
    fzf
    google-cloud-sdk
    gws
    magic-wormhole
    nix-tree
    pandoc
    pwgen
    qmk

    # Development
    bfg-repo-cleaner
    git-crypt
    glab
    just
    (lib.lowPrio minikube)
    mkcert
    pgcli
    tig
    websocat

    # Infrastructure
    awscli2
    kubernetes-helm
    k9s
    krew
    kubectl
  ];
  programs.fish.shellInit = ''
    source /home/vojta/.config/op/plugins.sh
  '';
  programs.git.settings.gpg.ssh.program = "/opt/1Password/op-ssh-sign";
  programs.ssh.settings."*".IdentityAgent = mkForce "~/.1password/agent.sock";
  home.sessionPath = [ "$HOME/.cargo/bin" ];
  # For some reason, Nix programs can't find the CA bundle on Fedora 44
  home.sessionVariables.NIX_SSL_CERT_FILE = "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem";
  # The two-axis variable Noto Sans files from nixpkgs noto-fonts (NotoSans[wdth,wght].ttf and the
  # Italic one) break Qt 6.11 font matching on Fedora 44: "Noto Sans" Regular/Italic silently fall
  # back to Noto Sans Arabic line metrics, which makes Breeze title bars and Qt line spacing ~50 %
  # too tall. Hide them so Fedora's static NotoSans-Regular.ttf is used (Fedora's own single-axis
  # NotoSans[wght].ttf is fine). Re-check after qt6-qtbase / fontconfig / noto-fonts updates.
  xdg.configFile."fontconfig/conf.d/60-reject-noto-vf.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <selectfont>
        <rejectfont>
          <glob>*/share/fonts/noto/NotoSans[*</glob>
          <glob>*/share/fonts/noto/NotoSans-Italic[*</glob>
        </rejectfont>
      </selectfont>
    </fontconfig>
  '';
  userModules = {
    genericLinux.enable = true;
    plasma.enable = true;

    packages.enable = false;
    flatpak.enable = false;

    dev = {
      python.enable = true;
      nodejs.enable = true;
    };
  };
}
