# Every `.nix` file below this directory is a module and gets imported
# automatically — there is no per-category `default.nix` to keep in sync.
#
# The flake reads from the git index, so a new module file has to be
# `git add`-ed before it is visible here.
{lib, ...}: {
  imports =
    builtins.filter
    (path: lib.hasSuffix ".nix" (toString path) && baseNameOf path != "default.nix")
    (lib.filesystem.listFilesRecursive ./.);
}
