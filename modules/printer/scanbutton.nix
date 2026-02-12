{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: let
  cfg = config.modules.printer.scanbutton;
  scannerUser = hostVariables.username;
  scanOutputDir = cfg.outputDir;

  saneBin = "${pkgs.sane-backends}/bin";
  libtiffBin = "${pkgs.libtiff}/bin";
  coreutilsBin = "${pkgs.coreutils}/bin";
  utilLinuxBin = "${pkgs.util-linux}/bin";

  duplexSources = [
    "ADF Duplex"
    "ADF Front and Back"
  ];

  scanScript = pkgs.writeShellScript "scanbutton-scan.sh" ''
    #!/usr/bin/env bash
    set -euo pipefail

    SCANIMAGE_BIN="${saneBin}/scanimage"
    TIFFCP_BIN="${libtiffBin}/tiffcp"
    TIFF2PDF_BIN="${libtiffBin}/tiff2pdf"
    DATE_BIN="${coreutilsBin}/date"
    LOGGER_BIN="${utilLinuxBin}/logger"
    MKDIR_BIN="${coreutilsBin}/mkdir"
    MKTEMP_BIN="${coreutilsBin}/mktemp"
    MV_BIN="${coreutilsBin}/mv"
    RM_BIN="${coreutilsBin}/rm"

    OUT_DIR="${scanOutputDir}"
    TIMESTAMP="$("$DATE_BIN" +%Y%m%d-%H%M%S)"
    UUID="$(cat /proc/sys/kernel/random/uuid)"

    TMP_DIR="$("$MKTEMP_BIN" -d)"
    MERGED_TIFF="$TMP_DIR/scan-merged.tiff"
    OUT_FILE="$OUT_DIR/scan-$TIMESTAMP-$UUID.pdf"
    PAGE_PATTERN="$TMP_DIR/page-%03d.tiff"
    readonly DUPLEX_SOURCES=(${lib.concatMapStringsSep " " (source: "\"${source}\"") duplexSources})

    log() {
      "$LOGGER_BIN" -t scanbutton-scan "$1"
    }

    cleanup() {
      "$RM_BIN" -rf "$TMP_DIR"
    }
    trap cleanup EXIT

    device_args=()
    if [ -n "''${SCANBD_DEVICE:-}" ]; then
      device_args=(--device-name "$SCANBD_DEVICE")
    fi

    scan_pages() {
      local source
      for source in "''${DUPLEX_SOURCES[@]}"; do
        if "$SCANIMAGE_BIN" "''${device_args[@]}" \
          --source "$source" \
          --resolution 300 \
          --mode "Lineart" \
          --format=tiff \
          --batch="$PAGE_PATTERN"; then
          return 0
        fi
      done
      return 1
    }

    merge_to_pdf() {
      local -a pages
      shopt -s nullglob
      pages=("$TMP_DIR"/page-*.tiff)
      shopt -u nullglob

      if [ "''${#pages[@]}" -eq 0 ]; then
        return 1
      fi

      if [ "''${#pages[@]}" -eq 1 ]; then
        "$MV_BIN" "''${pages[0]}" "$MERGED_TIFF"
      else
        "$TIFFCP_BIN" "''${pages[@]}" "$MERGED_TIFF"
      fi

      "$TIFF2PDF_BIN" -o "$OUT_FILE" "$MERGED_TIFF"
    }

    "$MKDIR_BIN" -p "$OUT_DIR"

    if ! scan_pages; then
      log "scanimage failed for device ''${SCANBD_DEVICE:-unknown} (no matching duplex source)"
      exit 1
    fi

    if ! merge_to_pdf; then
      log "No pages scanned for device ''${SCANBD_DEVICE:-unknown}"
      exit 1
    fi

    log "Saved $OUT_FILE"
  '';

  scanbdConf = pkgs.writeText "scanbd.conf" ''
    global {
      debug = false
      debug-level = 3
      user = root
      group = lp
      saned = "${pkgs.sane-backends}/bin/saned"
      saned_env = { "SANE_CONFIG_DIR=/etc/scanbd" }
      scriptdir = /etc/scanbd
      timeout = 500
      pidfile = "/run/scanbd.pid"

      environment {
        device = "SCANBD_DEVICE"
        action = "SCANBD_ACTION"
      }

      multiple_actions = true
    }

    device fujitsu-fi-6130 {
      filter = "${cfg.scannerFilter}"
      desc = "Fujitsu fi-6130"

      action scan {
        filter = "${cfg.buttonFilter}"
        numerical-trigger {
          from-value = 1
          to-value = 0
        }
        desc = "Scan to file"
        script = "scanbutton-scan.sh"
      }
    }
  '';
in {
  options.modules.printer.scanbutton = {
    enable = lib.mkEnableOption "scan button trigger for Fujitsu fi-6130";

    outputDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/${hostVariables.username}/Scans";
      description = "Directory where scanned files are written.";
    };

    scannerFilter = lib.mkOption {
      type = lib.types.str;
      default = "^fujitsu.*";
      description = "Regex matching the scanner backend device name.";
    };

    buttonFilter = lib.mkOption {
      type = lib.types.str;
      default = "^scan.*";
      description = "Regex matching scanner button options.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${scannerUser} = {
      extraGroups = ["scanner" "lp"];
    };

    environment.systemPackages = with pkgs; [
      scanbd
    ];

    systemd.tmpfiles.rules = [
      "d ${scanOutputDir} 0770 ${scannerUser} users -"
    ];

    environment.etc."scanbd/scanbd.conf".source = scanbdConf;
    environment.etc."scanbd/scanbutton-scan.sh" = {
      source = scanScript;
      mode = "0755";
    };

    systemd.services.scanbd = {
      description = "Scanner button daemon";
      wantedBy = ["multi-user.target"];
      after = ["local-fs.target"];
      path = with pkgs; [
        sane-backends
        libtiff
        coreutils
        util-linux
      ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.scanbd}/bin/scanbd -f -c /etc/scanbd/scanbd.conf";
        Restart = "on-failure";
        RestartSec = "2s";
      };
    };
  };
}
