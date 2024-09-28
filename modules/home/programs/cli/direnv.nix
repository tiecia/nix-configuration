{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    direnv.enable = mkEnableOption "Enable direnv";
  };

  config = mkIf config.direnv.enable {
    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        nix-direnv.enable = true;
      };
      bash = {
        enable = true;
        bashrcExtra = "eval \"$(direnv hook bash)\"";
      };
    };
  };
}
