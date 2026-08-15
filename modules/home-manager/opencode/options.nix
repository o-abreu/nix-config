{
  lib,
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
  };
}
