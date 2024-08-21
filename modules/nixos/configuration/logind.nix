{
  config,
  lib,
  pkgs,
  ...
}: {
  services.logind = {
    lidSwitch = "suspend";
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
  };
}
