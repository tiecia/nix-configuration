{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    ssh.enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf config.ssh.enable {
    services.openssh.enable = true;
  };
}
