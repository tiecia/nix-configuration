{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    printing.enable = lib.mkEnableOption "Enable printing";
  };

  config = mkIf config.printing.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
