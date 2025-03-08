{
  config,
  lib,
  pkgs,
  ...
}: let
  netcoredbg = pkgs.netcoredbg;
in
  with lib; {
    environment = {
      systemPackages = [
        netcoredbg
      ];

      varables = {
        TEST = "test";
        NETCOREDBG = netcoredbg;
      };
    };
  }
