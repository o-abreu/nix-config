# INFO: Opens URLs, file paths and other references under the cursor in the
# browser, without relying on netrw

{
  programs.nixvim.plugins.gx = {
    enable = true;
    lazyLoad.settings.cmd = "Browse";
    settings.search_engine = "duckduckgo";
  };
}
