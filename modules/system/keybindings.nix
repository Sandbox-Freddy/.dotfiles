{...}: {
  services.keyd.enable = true;
  services.keyd.keyboards.default = {
    ids = ["*"];
    settings."control+alt" = {
      "7" = "G-7"; # C-A-7 => {
      "8" = "G-8"; # C-A-8 => [
      "9" = "G-9"; # C-A-9 => ]
      "0" = "G-0"; # C-A-0 => }
      "-" = "G--"; # C-A-ß => \
      "]" = "G-]"; # C-A-+ => ~
    };
  };
}
