{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    postman.enable = lib.mkEnableOption "Enable postman";
  };

  config = mkIf config.postman.enable {
    home.packages = with pkgs; [
      postman
    ];
  };
}
