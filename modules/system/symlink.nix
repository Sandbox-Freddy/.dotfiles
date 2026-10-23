{
  pkgs,
  lib,
  self,
  hostVariables,
  ...
}: let
  flakeRoot = toString self;

  mkOutOfStorePath = path: let
    p = toString path;
  in
    if lib.hasPrefix "${flakeRoot}/" p
    then "${hostVariables.dotfilesDir}/${lib.removePrefix "${flakeRoot}/" p}"
    else throw "mkOutOfStorePath: ${p} is not inside the flake (${flakeRoot})";

  mkSymlink = path: let
    target = mkOutOfStorePath path;
  in {
    recursive = true;
    source =
      pkgs.runCommandLocal
      (lib.strings.sanitizeDerivationName (baseNameOf target))
      {}
      ''ln -s ${lib.escapeShellArg target} $out'';
  };
in {
  _module.args = {inherit mkOutOfStorePath mkSymlink;};
}
