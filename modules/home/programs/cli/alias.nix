{
  config,
  lib,
  pkgs,
  globalConfig,
  ...
}:
with lib; {
  options = {
    alias.enable = mkEnableOption "Enable aliases";
  };

  config = lib.mkIf config.alias.enable {
    programs.bash = {
      enable = true;
      shellAliases = {
        ls = "eza";
        la = "eza -la";
        l = "eza";
        c = "clear";
        h = "history";
        gcm = "git commit -m";
        gs = "git status";
        ga = "git add";
        gaa = "git add -A";
        g = "git";
        gp = "git push";
        work = "cd ~/development/rosepoint/PlanZ/; code ~/Development/rosepoint/PlanZ/";
        unfree = "export NIXPKGS_ALLOW_UNFREE=1";
        open = "bash ~/nix-configuration/modules/home/programs/cli/scripts/open.sh";
        ".." = "cd ..";
        dup = "nohup ${globalConfig.terminal} --working-directory $PWD > /dev/null 2>&1 &";
        # dup = "(nohup ${globalConfig.terminal} $PWD &) &> /dev/null";
      };
    };
  };
}
