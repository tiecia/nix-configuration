{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    bash.enable = mkEnableOption "Enable bash";
  };

  config = mkIf config.bash.enable {
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        . ~/.profile
      '';
    };
  };
}
