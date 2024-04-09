{
  config,
  pkgs,
  ...
}: {
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.numlockx}/bin/numlockx on
  '';
}
