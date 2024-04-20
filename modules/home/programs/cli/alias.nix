{
  config,
  lib,
  pkgs,
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
        la = "ls -la";
        l = "ls";
        c = "clear";
        h = "history";
        gcm = "git commit -m";
        gs = "git status";
        ga = "git add";
        gaa = "git add -A";
        g = "git";
        gp = "git push";
        work = "cd ~/Development/rosepoent/PlanZ/; code ~/Development/rosepoint/PlanZ/";
      };
    };
  };
}
