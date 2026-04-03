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
          charliermarsh.ruff
          davidlday.languagetool-linter
          gitlab.gitlab-workflow
          jdinhlife.gruvbox
          jnoortheen.nix-ide
          ms-azuretools.vscode-containers
          ms-kubernetes-tools.vscode-kubernetes-tools
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-python-envs
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow
          redhat.vscode-yaml
          tonybaloney.vscode-pets
          vscodevim.vim
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
