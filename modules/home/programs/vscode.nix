{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # These should always be installed
      bbenoist.nix
      github.copilot
      github.copilot-chat
      arrterian.nix-env-selector

      # These should eventually be moved to individual environments.

      # Rosepoint environment.
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh

      # OPL Environment
      ms-python.python
    ];
  };
}
