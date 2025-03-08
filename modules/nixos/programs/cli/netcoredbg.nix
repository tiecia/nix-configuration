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
      systemPackages = [netcoredbg];

      sessionVariables = {
        NETCOREDBG_PATH = "${netcoredbg}/bin/netcoredbg";
      };

      variables = {
        TEST = "test";
      };
    };
  }
