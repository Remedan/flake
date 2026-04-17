{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.userModules.vscodium;
in
{
  options.userModules.vscodium = {
    enable = mkEnableOption "VSCodium";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs.open-vsx-release; [
          anthropic.claude-code
          davidlday.languagetool-linter
          editorconfig.editorconfig
          gitlab.gitlab-workflow
          jdinhlife.gruvbox
          mkhl.direnv
          ms-azuretools.vscode-containers
          ms-kubernetes-tools.vscode-kubernetes-tools
          redhat.vscode-yaml
          tonybaloney.vscode-pets
          vscodevim.vim

          # Nix
          jnoortheen.nix-ide

          # Python
          charliermarsh.ruff
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-python-envs
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow

          # Rust
          rust-lang.rust-analyzer
          vadimcn.vscode-lldb

          # Haskell
          haskell.haskell
          justusadam.language-haskell
        ];
        userSettings = {
          "containers.containerClient" = "com.microsoft.visualstudio.containers.docker";
          "containers.orchestratorClient" = "com.microsoft.visualstudio.orchestrators.dockercompose";
          "gitlab.duoAgentPlatform.enabled" = false;
          "gitlab.duoChat.enabled" = false;
          "gitlab.duoCodeSuggestions.enabled" = false;
          "claudeCode.allowDangerouslySkipPermissions" = true;
          "editor.minimap.enabled" = false;
          "vim.handleKeys" = {
            "<C-p>" = false;
            "<C-d>" = true;
            "<C-s>" = false;
            "<C-z>" = false;
          };
          "workbench.colorTheme" = "Gruvbox Dark Hard";
          "editor.fontFamily" = "'JetBrains Mono', monospace";
          "git.confirmSync" = false;
          "vs-kubernetes" = {
            "vs-kubernetes.crd-code-completion" = "enabled";
          };
          "redhat.telemetry.enabled" = true;
          "claudeCode.preferredLocation" = "panel";
        };
        keybindings = [
          {
            "key" = "ctrl+w";
            "command" = "-workbench.action.terminal.killEditor";
            "when" = "terminalEditorFocus && terminalFocus && terminalHasBeenCreated || terminalEditorFocus && terminalFocus && terminalProcessSupported";
          }
        ];
      };
    };
  };
}
