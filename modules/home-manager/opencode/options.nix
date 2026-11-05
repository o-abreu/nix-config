{
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.programs.opencode = with types; {
    env = {
      apiKeys = mkOption {
        type = attrsOf str;
        default = { };
        description = "API keys to inject into the opencode environment. Maps env var name to sops secret path.";
        example = {
          OPENCODE_API_KEY = "api-keys/opencode";
          DEEPSEEK_API_KEY = "api-keys/deepseek";
        };
      };

      vars = mkOption {
        type =
          oneOf [
            str
            bool
            int
          ]
          |> attrsOf;
        default = { };
        description = "Environemnt variables to inject into the opencode environment.";
        example = {
          OPENCODE_EXPERIMENTAL = true;
          OPENCODE_ENABLE_EXA = "true";
        };
      };
    };

    python = {
      enable = mkEnableOption "a shared python interpreter for opencode tool calls";

      package = mkOption {
        type = package;
        default = pkgs.python3;
        description = ''
          Interpreter to wrap. Entries in `withPackages` must come from this
          same interpreter's package set (`package.pkgs`), or they will be built
          against a different interpreter and fail at import time.
        '';
      };

      withPackages = mkOption {
        type = listOf package;
        default = [ ];
        description = ''
          Python packages installed into `package`. A non-empty list implies
          `enable`; set `enable` alone for a bare interpreter with no packages.
          Modules may contribute here freely -- the type merges by
          concatenation, so the whole tree shares a single interpreter.
        '';
        example = literalExpression "with pkgs.python3Packages; [ sympy ]";
      };
    };
  };
}
