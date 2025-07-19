{hostVariables, ...}: {
  i18n.defaultLocale = hostVariables.location;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = hostVariables.location;
    LC_IDENTIFICATION = hostVariables.location;
    LC_MEASUREMENT = hostVariables.location;
    LC_MONETARY = hostVariables.location;
    LC_NAME = hostVariables.location;
    LC_NUMERIC = hostVariables.location;
    LC_PAPER = hostVariables.location;
    LC_TELEPHONE = hostVariables.location;
    LC_TIME = hostVariables.location;
  };
}
