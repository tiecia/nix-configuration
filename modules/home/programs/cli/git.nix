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
        # git
        gitkraken
        # gh
      ];
    };

    programs.git = {
      enable = true;
      settings = {
        alias = {
          co = "checkout";
          cm = "commit";
          st = "status";
          pu = "push";
        };
        user = {
          email = "ty.cia@outlook.com";
          name = "tiecia";
        };
      };
    };

    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
