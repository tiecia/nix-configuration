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

    # programs.bash = {
    #   enable = true;
    #   shellAliases = {
    #     co = "checkout";
    #     cm = "commit";
    #     st = "status";
    #     pu = "push";
    #   };
    # };

    programs.git = {
      enable = true;
      userEmail = "ty.cia@outlook.com";
      userName = "tiecia";
      aliases = {
        co = "checkout";
        cm = "commit";
        st = "status";
        pu = "push";
      };
    };

    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
