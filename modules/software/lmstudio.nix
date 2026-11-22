{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: let
  cfg = config.modules.software.lmstudio;
in {
  options.modules.software.lmstudio = {
    enable = lib.mkEnableOption "LM Studio";
    webSearch.enable = lib.mkEnableOption "Exa web search in LM Studio (manages ~/.lmstudio/mcp.json and sends tool queries to Exa)";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${hostVariables.username} = {
      home.packages = [pkgs.lmstudio];
      home.file.".lmstudio/mcp.json" = lib.mkIf cfg.webSearch.enable {
        text = builtins.toJSON {
          mcpServers.exa.url = "https://mcp.exa.ai/mcp?tools=web_search_exa,web_fetch_exa";
        };
      };
    };
  };
}
