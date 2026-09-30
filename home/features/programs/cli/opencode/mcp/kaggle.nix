{
  programs =
    let
      envVar = "KAGGLE_API_KEY";
      apiKey.${envVar} = "api-keys/kaggle";
    in
    {
      opencode.env.apiKeys = apiKey;
      mcp.servers.kaggle = {
        # INFO: Configured but not started on boot. Enable it on demand from the
        # TUI MCP dialog (which calls `mcp.connect`), or flip this to `enabled`.
        enabled = false;
        url = "https://www.kaggle.com/mcp";
        headers.Authorization = "Bearer {env:${envVar}}";
      };
    };
}
