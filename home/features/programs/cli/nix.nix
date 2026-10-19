{
  config,
  ...
}:
{
  nix = {
    # INFO: Nix's flake fetchers query api.github.com unauthenticated and are
    # subject to GitHub's anonymous rate limit (60 req/h, shared per IP), which
    # `nix flake update` frequently hits. Include a runtime-rendered access
    # token so the user's nix client authenticates (5000 req/h). The token is a
    # sops secret: only its rendered path enters the store, never its value.
    extraOptions = ''
      !include ${config.sops.templates."nix-access-tokens".path}
    '';
  };

  sops.templates."nix-access-tokens" = {
    content = ''
      access-tokens = github.com=${config.sops.placeholder."api-keys/github"}
    '';
    mode = "0400";
  };
}
