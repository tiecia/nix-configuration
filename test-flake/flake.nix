{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    nixosModules.default = {
      config = {
        environment.systemPackages = [
          nixpkgs.legacyPackages.x86_64-linux.hello
        ];
      };
    };
  };
}
