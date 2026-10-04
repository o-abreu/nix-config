{
  config,
  lib,
  ...
}: let
  cfg = config.programs.nixvim.plugins.dap;
in {
  programs.nixvim.plugins.dap.signs = lib.mkIf cfg.enable {
    dapBreakpoint = {
      text = "󰧞";
      texthl = "DiagnosticInfo";
    };
    dapBreakpointCondition = {
      text = "󰪣";
      texthl = "DiagnosticInfo";
    };
    dapBreakpointRejected = {
      text = "󰅙";
      texthl = "DiagnosticError";
    };
    dapLogPoint = {
      text = "󰛿";
      texthl = "DiagnosticInfo";
    };
    dapStopped = {
      text = "󰁕";
      texthl = "DiagnosticWarn";
      linehl = "DapStoppedLine";
      numhl = "DapStoppedLine";
    };
  };
}
