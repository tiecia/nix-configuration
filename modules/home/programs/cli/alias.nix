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
        work = "cd ~/Development/rosepoint/PlanZ/; code ~/Development/rosepoint/PlanZ/";
        unfree = "export NIXPKGS_ALLOW_UNFREE=1";
        home = "cd ~";
        open = "bash ~/nix-configuration/modules/home/programs/cli/scripts/open.sh";
        ".." = "cd ..";
        hypr = "vi ~/nix-configuration/modules/home/configuration/hyprland/hyprland-conf.nix";
        dup = "kitty $PWD";
      };
    };
  };
}
