{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    virtualbox.enable = mkEnableOption "Enable virtualbox";
  };

  config = mkIf config.virtualbox.enable {
    virtualisation.virtualbox = {
      host.enable = true;
      guest = {
        enable = true;
        dragAndDrop = true;
      };
    };

    users.extraGroups.vboxusers.members = ["tiec"];
  };
}
