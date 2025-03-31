{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    homeManagerModules.default = {
      config = {
        home.packages = [
          nixpkgs.legacyPackages.x86_64-linux.hello
        ];
      };
    };
  };
}
