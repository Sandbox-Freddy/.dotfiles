{
  hostVariables,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  modules.gui.gnome = {
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

  home-manager.users.${hostVariables.username} = {
    home.packages = with pkgs; [
      github-cli
      opencode
    ];
  };

  hardware.graphics.extraPackages = with pkgs; [
    libva-vdpau-driver
  ];
}
