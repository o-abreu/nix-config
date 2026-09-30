{
  programs.nixvim = {
    plugins.dap.settings.signs = {
      dapBreakpoint = {
        text = "";
        texthl = "DiagnosticInfo";
      };
      dapBreakpointCondition = {
        text = "";
        texthl = "DiagnosticInfo";
      };
      dapBreakpointRejected = {
        text = "";
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
  };
}
