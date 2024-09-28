{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    direnv.enable = mkEnableOption "Enable direnv";
  };

  config = mkIf config.direnv.enable {
    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        nix-direnv.enable = true;
      };
      bash = {
        enable = true;

        # https://github.com/nix-community/nix-direnv/wiki/Shell-integration
        bashrcExtra = ''
          eval "$(direnv hook bash)"

          nixify() {
            if [ ! -e ./.envrc ]; then
              echo "use nix" > .envrc
              direnv allow
            fi
            if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
              cat > default.nix <<'EOF'
          with import <nixpkgs> {};
          mkShell {
            nativeBuildInputs = [
              bashInteractive
            ];
          }
          EOF
              ''${EDITOR:-vim} default.nix
            fi
          }

          flakify() {
            if [ ! -e flake.nix ]; then
              nix flake new -t github:nix-community/nix-direnv .
            elif [ ! -e .envrc ]; then
              echo "use flake" > .envrc
              direnv allow
            fi
            ''${EDITOR:-vim} flake.nix
          }
        '';
      };
    };
  };
}
