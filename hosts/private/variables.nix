{
  username = "freddy";
  host = "private";
  system = "x86_64-linux";
  modules = {
    driver = {
      nvidia = true;
      amdgpu = false;
    };
    docker = true;
    display-link = false;
    git = true;
    jetbrains = false;
    steam = true;
    ubuntu-theme = true;
    vscode = true;
  };
  git = {
    lfs = true;
    extraConfig = {
      defaultBranch = "main";
      credential-helper = "store";
    };
    credentials = {
      email = "31123359+Sandbox-Freddy@users.noreply.github.com";
      name = "Sandbox-Freddy";
    };
  };
  ubuntu-theme = {
    fav-icon = [
      "org.gnome.Console.desktop"
      "bitwarden.desktop"
      "google-chrome.desktop"
      "firefox.desktop"
      "thunderbird.desktop"
      "code.desktop"
      "org.gnome.Nautilus.desktop"
    ];
  };
}
