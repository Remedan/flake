{ config, lib, pkgs, ... }:
let
  cfg = config.userModules.vscodium;
in
{
  options.userModules.vscodium = {
    enable = lib.mkEnableOption "VSCodium";
  };

  config = lib.mkIf cfg.enable {
    programs.vscodium = {
      enable = true;
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs.open-vsx-release; [
          anthropic.claude-code
          davidlday.languagetool-linter
          editorconfig.editorconfig
          gitlab.gitlab-workflow
          jeanp413.open-remote-ssh
          mkhl.direnv
          ms-azuretools.vscode-containers
          ms-kubernetes-tools.vscode-kubernetes-tools
          redhat.vscode-yaml
          tonybaloney.vscode-pets
          vscodevim.vim

          # Themes
          jdinhlife.gruvbox
          enkia.tokyo-night

          # Nix
          jnoortheen.nix-ide

          # Python
          charliermarsh.ruff
          meta.pyrefly
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

          # Databases
          mtxr.sqltools
          mtxr.sqltools-driver-pg
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
          "editor.fontFamily" = "'JetBrains Mono', monospace";
          "git.confirmSync" = false;
          "vs-kubernetes" = {
            "vs-kubernetes.crd-code-completion" = "enabled";
          };
          "redhat.telemetry.enabled" = true;
          "claudeCode.preferredLocation" = "panel";
          "python.languageServer" = "None"; # Use Pyrefly
          "workbench.experimental.modernUI" = true;
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
