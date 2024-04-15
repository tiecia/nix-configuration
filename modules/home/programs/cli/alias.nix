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
    home = {
      programs.bash = {
        enable = true;
        aliases = {
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
        };
      };
    };
  };
}
