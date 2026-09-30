{
  programs.thunderbird = {
    enable = true;

    # INFO: Thunderbird-supported Firefox-style enterprise policies.
    # DisableTelemetry is supported since TB 78; DisableFeedbackCommands and
    # DisableFirefoxScreenshots are NOT supported by Thunderbird.
    policies = {
      DisableTelemetry = true;
      PasswordManagerEnabled = true;
    };
  };
}
