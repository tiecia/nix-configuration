{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    git.enable = mkEnableOption "Enable Git";
  };

  config = lib.mkIf config.git.enable {
    home = {
      packages = with pkgs; [
        git
        gitkraken
        gh
      ];
    };

    programs.git = {
      enable = true;
      userName = "tiecia";
      userEmail = "ty.cia@outlook.com";
      aliases = {
        co = "checkout";
        cm = "commit";
        st = "status";
        pu = "push";
      };
    };
  };
}
