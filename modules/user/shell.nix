{ config, lib, ... }:
let
  cfg = config.userModules.shell;
in
{
  options.userModules.shell = {
    enable = lib.mkEnableOption "shell";
  };
  config = lib.mkIf cfg.enable {
    home = {
      shell.enableFishIntegration = true;
      sessionPath = [
        "$HOME/.local/bin"
        "$HOME/.krew/bin"
      ];
      sessionVariables = {
        EDITOR = if config.userModules.emacs.service then "emacsclient -nw" else "emacs -nw";
        # Enable wayland for chromium-based apps
        NIXOS_OZONE_WL = 1;
      };
      shellAliases = {
        e = "eval \"$EDITOR\"";
        E = "sudoedit";
        ip = "ip --color=auto";
        c = "claude";
        oc = "openclaw tui";
        l = "ls -lah";

        # Inspired by omz git
        g = "git";
        ga = "git add";
        gb = "git branch";
        gco = "git checkout";
        gc = "git commit --verbose";
        gd = "git diff";
        gds = "git diff --staged";
        gf = "git fetch";
        gl = "git pull";
        gm = "git merge";
        gp = "git push";
        gpf = "git push --force-with-lease --force-if-includes";
        grb = "git rebase";
        grba = "git rebase --abort";
        grbc = "git rebase --continue";
        grbi = "git rebase --interactive";
        gst = "git status";

        # Insipred by omz kubectl
        k = "kubectl";
        kcuc = "kubectl config use-context";
        kcn = "kubectl config set-context --current --namespace";
        kaf = "kubectl apply -f";
        kak = "kubectl apply -k";
        kd = "kubectl describe";
        kg = "kubectl get";
        kdel = "kubectl delete";
        kdelf = "kubectl delete -f";
        kdelk = "kubectl delete -k";
        kdff = "kubectl diff -f";
        kdfk = "kubectl diff -k";
        kgp = "kubectl get po";
        kgpa = "kubectl get po --all-namespaces";
        kgpw = "kubectl get po --watch";
        kep = "kubectl edit po";
        kdp = "kubectl describe po";
        kdelp = "kubectl delete po";
        kgs = "kubectl get svc";
        kgsa = "kubectl get svc --all-namespaces";
        kgsw = "kubectl get svc --watch";
        kes = "kubectl edit svc";
        kds = "kubectl describe svc";
        kdels = "kubectl delete svc";
        kgns = "kubectl get ns";
        kens = "kubectl edit ns";
        kdns = "kubectl describe ns";
        kdelns = "kubectl delete ns";
        kgcm = "kubectl get cm";
        kgcma = "kubectl get cm --all-namespaces";
        kecm = "kubectl edit cm";
        kdcm = "kubectl describe cm";
        kdelcm = "kubectl delete cm";
        kgsec = "kubectl get secrets";
        kgseca = "kubectl get secrets --all-namespaces";
        kdsec = "kubectl describe secret";
        kdelsec = "kubectl delete secret";
        kgd = "kubectl get deploy";
        kgda = "kubectl get deploy --all-namespaces";
        kgdw = "kubectl get deploy --watch";
        ked = "kubectl edit deploy";
        kdd = "kubectl describe deploy";
        kdeld = "kubectl delete deploy";
        ksd = "kubectl scale deployment";
        krsd = "kubectl rollout status deployment";
        krrd = "kubectl rollout restart deployment";
        kgsts = "kubectl get sts";
        kgstsa = "kubectl get sts --all-namespaces";
        kgstsw = "kubectl get sts --watch";
        kests = "kubectl edit sts";
        kdsts = "kubectl describe sts";
        kdelsts = "kubectl delete sts";
        kssts = "kubectl scale sts";
        krssts = "kubectl rollout status sts";
        krrsts = "kubectl rollout restart sts";
        kpf = "kubectl port-forward";
        kl = "kubectl logs";
        klf = "kubectl logs -f";
        kgno = "kubectl get nodes";
        kgpvc = "kubectl get pvc";
        kgpvca = "kubectl get pvc --all-namespaces";
        kgpvcw = "kubectl get pvc --watch";
        kepvc = "kubectl edit pvc";
        kdpvc = "kubectl describe pvc";
        kdelpvc = "kubectl delete pvc";
        kgds = "kubectl get ds";
        kgdsa = "kubectl get ds --all-namespaces";
        kgdsw = "kubectl get ds --watch";
        keds = "kubectl edit ds";
        kdds = "kubectl describe ds";
        kdelds = "kubectl delete ds";
        kgcj = "kubectl get cj";
        kgcja = "kubectl get cj --all-namespaces";
        kecj = "kubectl edit cj";
        kdcj = "kubectl describe cj";
        kdelcj = "kubectl delete cj";
        kgj = "kubectl get job";
        kej = "kubectl edit job";
        kdj = "kubectl describe job";
        kdelj = "kubectl delete job";
      };
    };
    programs.fish = {
      enable = true;
      shellInit = ''
        set fish_greeting
      '';
      shellInitLast = ''
        complete -e e
        complete -c e -w emacs
      '';
    };
    programs.starship = {
      enable = true;
      settings = {
        directory.truncate_to_repo = false;
        kubernetes.disabled = false;
        gcloud.disabled = true;
      };
    };
    programs.kubecolor = {
      enable = true;
      enableAlias = true;
    };
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      flags = [ "--disable-up-arrow" ];
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
