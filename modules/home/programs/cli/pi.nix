{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    pi.enable = mkEnableOption "Enable pi coding agent";
  };

  config = mkIf config.pi.enable {
    home.packages = with pkgs; [
      pi-coding-agent
    ];

    home.activation.configurePiSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
      settings="$HOME/.pi/agent/settings.json"
      mkdir -p "$(dirname "$settings")"

      if [ -e "$settings" ]; then
        tmp="$(${pkgs.coreutils}/bin/mktemp)"
        ${pkgs.jq}/bin/jq '. + {
          defaultProvider: "openai",
          defaultModel: "gpt-6-sol",
          defaultThinkingLevel: "high"
        }' "$settings" > "$tmp"
        ${pkgs.coreutils}/bin/mv "$tmp" "$settings"
      else
        cat > "$settings" <<'EOF'
      ${builtins.toJSON {
        defaultProvider = "openai";
        defaultModel = "gpt-6-sol";
        defaultThinkingLevel = "high";
      }}
      EOF
      fi
    '';
  };
}
