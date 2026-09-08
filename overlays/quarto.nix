# Patch quarto 1.9.37 for compatibility with pandoc <3.8
#
# Quarto 1.9.37 uses `--syntax-highlighting` (pandoc 3.8+) but nixpkgs
# ships pandoc 3.7.0.2 which only supports `--highlight-style`.
# Also adds missing TableBody traversal in jog.lua.
#
# Upstream tracking: https://github.com/NixOS/nixpkgs/issues/519484
# PR: https://github.com/NixOS/nixpkgs/pull/557907
final: prev:
let
  pandocVersion = final.pandoc.version or "0";
  needsPatch = builtins.compareVersions pandocVersion "3.8" < 0;
in
{
  quarto = prev.quarto.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      ${
        if needsPatch then
          # bash
          ''
            substituteInPlace $out/bin/quarto.js \
              --replace-fail 'kSyntaxHighlighting = "syntax-highlighting"' 'kSyntaxHighlighting = "highlight-style"' \
              --replace-fail '"--syntax-highlighting"' '"--highlight-style"'

            substituteInPlace $out/share/filters/modules/jog.lua \
              --replace-fail "elseif tp == 'pandoc TableHead' or tp == 'pandoc TableFoot' or" \
              "elseif tp == 'pandoc TableBody' or tp == 'TableBody' then
                element.head = jogger(element.head)
                element.body = jogger(element.body)
              elseif tp == 'pandoc TableHead' or tp == 'pandoc TableFoot' or"
          ''
        else
          # bash
          ''
            echo "NOTE: pandoc ${pandocVersion} >= 3.8 detected. The quarto overlay patch is no longer needed and can be safely removed from overlays/quarto.nix."
          ''
      }
    '';
  });
}
