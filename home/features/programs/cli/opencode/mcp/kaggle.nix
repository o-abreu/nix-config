{
  programs = let
    envVar = "KAGGLE_API_KEY";
    apiKey.${envVar} = "api-keys/kaggle";
  in {
    opencode = {
      env.apiKeys = apiKey;
      # Reserved for the `research` agent (re-allowed there).
      settings.permission."kaggle_*" = "deny";
    };
    mcp.servers.kaggle = {
      url = "https://www.kaggle.com/mcp";
      headers.Authorization = "Bearer {env:${envVar}}";
    };
  };
}
