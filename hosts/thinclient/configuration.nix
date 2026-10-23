{
  hostVariables,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  fileSystems."/".options = ["noatime"];

  powerManagement.cpuFreqGovernor = "performance";

  services.gnome = {
    localsearch.enable = false;
    tinysparql.enable = false;
  };

  nix.gc = {
    options = lib.mkForce "--delete-older-than 7d";
    persistent = lib.mkForce false;
  };

  modules.gui.gnome = {
    disabledExtensions = [
      "system-monitor@gnome-shell-extensions.gcampax.github.com"
    ];
    favoriteApps = [
      "org.gnome.Console.desktop"
      "firefox.desktop"
      "dev.zed.Zed.desktop"
      "SourceGit.desktop"
      "org.gnome.Nautilus.desktop"
    ];
  };

  modules.hardware.scanbutton = {
    outputDir = "/mnt/paperless";
    blankPageThreshold = 0.985;
    blackBorderTrimFuzz = "32%";
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  home-manager.users.${hostVariables.username} = {lib, ...}: {
    home.packages = with pkgs; [
      github-cli
    ];

    dconf.settings."org/gnome/nautilus/preferences" = {
      show-image-thumbnails = "local-only";
      thumbnail-limit = lib.hm.gvariant.mkUint64 200;
    };
  };

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
  ];
}
