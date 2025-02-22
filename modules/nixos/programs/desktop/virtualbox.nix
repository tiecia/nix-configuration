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
      host = {
        enable = true;
      };
      guest = {
        enable = true;
        dragAndDrop = true;
      };
    };

    # https://github.com/NixOS/nixpkgs/issues/363887#issuecomment-2536693220
    boot.kernelParams = ["kvm.enable_virt_at_load=0"];

    users.extraGroups.vboxusers.members = ["tiec"];
  };
}
