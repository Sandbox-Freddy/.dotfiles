{
  hostVariables,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Modules
  modules.gui.gnome = {
    favoriteApps = [
      "org.gnome.Console.desktop"
      "firefox.desktop"
      "dev.zed.Zed.desktop"
      "SourceGit.desktop"
      "org.gnome.Nautilus.desktop"
    ];
  };

  modules.printer.scanbutton = {
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
    # your Open GL, Vulkan and VAAPI drivers
    libva-vdpau-driver
  ];
}
