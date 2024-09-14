{
  username = "freddy";
  host = "work";
  system = "x86_64-linux";
  modules = {
    driver = {
      nvidia = false;
      amdgpu = true;
    };
    docker = true;
    display-link = true;
    git = true;
    jetbrains = true;
    lutris = false;
    steam = false;
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
      "google-chrome.desktop"
      "firefox.desktop"
      "postman.desktop"
      "idea-ultimate.desktop"
      "code.desktop"
      "chrome-faolnafnngnfdaknnbpnkhgohbobgegn-Default.desktop"
      "chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
      "com.yubico.authenticator.desktop"
      "org.keepassxc.KeePassXC.desktop"
      "org.gnome.Nautilus.desktop"
      "org.gnome.gitlab.somas.Apostrophe.desktop"
      "org.gnome.TextEditor.desktop"
    ];
  };
}
