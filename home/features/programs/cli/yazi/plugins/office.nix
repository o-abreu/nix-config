{ pkgs, ... }:
{
  programs.yazi = {
    plugins.office = pkgs.yaziPlugins.office;

    extraPackages = with pkgs; [
      libreoffice
      poppler-utils
    ];

    settings.plugin = {
      prepend_previewers = [
        {
          mime = "application/{vnd.openxmlformats-officedocument.*,vnd.oasis.opendocument.*,vnd.ms-*,msword}";
          run = "office";
        }
        {
          url = "*.{docx,xlsx,pptx,odt,ods,odp,doc,xls,ppt,rtf}";
          run = "office";
        }
      ];
      # INFO: Use the final free preloader slot (15 -> 16) to pre-warm the
      # cache for instant office previews. Keep this consolidated to one rule.
      prepend_preloaders = [
        {
          mime = "application/{vnd.openxmlformats-officedocument.*,vnd.oasis.opendocument.*,vnd.ms-*,msword}";
          run = "office";
        }
      ];
    };
  };
}
