{
  config,
  pkgs,
  ...
}: {
  # Enables flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
