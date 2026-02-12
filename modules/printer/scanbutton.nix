{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: let
  cfg = config.modules.printer.scanbutton;

  scanScript = pkgs.writeShellScript "scanbutton-scan.sh" ''
    #!/usr/bin/env bash
    set -euo pipefail

    SCANIMAGE_BIN="${pkgs.sane-backends}/bin/scanimage"
    TIFFCP_BIN="${pkgs.libtiff}/bin/tiffcp"
    TIFF2PDF_BIN="${pkgs.libtiff}/bin/tiff2pdf"
    DATE_BIN="${pkgs.coreutils}/bin/date"
    LOGGER_BIN="${pkgs.util-linux}/bin/logger"
    MKDIR_BIN="${pkgs.coreutils}/bin/mkdir"
    MKTEMP_BIN="${pkgs.coreutils}/bin/mktemp"
    MV_BIN="${pkgs.coreutils}/bin/mv"
    RM_BIN="${pkgs.coreutils}/bin/rm"

    OUT_DIR="${cfg.outputDir}"
    UUID="$(cat /proc/sys/kernel/random/uuid)"
    TIMESTAMP="$("$DATE_BIN" +%Y%m%d-%H%M%S)"
    OUT_FILE="$OUT_DIR/scan-$TIMESTAMP-$UUID.pdf"
    TMP_DIR="$("$MKTEMP_BIN" -d)"
    MERGED_TIFF="$TMP_DIR/scan-merged.tiff"

    cleanup() {
      "$RM_BIN" -rf "$TMP_DIR"
    }
    trap cleanup EXIT

    "$MKDIR_BIN" -p "$OUT_DIR"

    device_args=()
    if [ -n "''${SCANBD_DEVICE:-}" ]; then
      device_args=(--device-name "$SCANBD_DEVICE")
    fi

    scan_ok=0
    for source in "ADF Duplex" "ADF Front and Back"; do
      if "$SCANIMAGE_BIN" "''${device_args[@]}" \
        --source "$source" \
        --resolution 300 \
        --mode "Lineart" \
        --format=tiff \
        --batch="$TMP_DIR/page-%03d.tiff"; then
        scan_ok=1
        break
      fi
    done

    if [ "$scan_ok" -ne 1 ]; then
      "$LOGGER_BIN" -t scanbutton-scan "scanimage failed for device ''${SCANBD_DEVICE:-unknown} (no matching duplex source)"
      exit 1
    fi

    shopt -s nullglob
    pages=("$TMP_DIR"/page-*.tiff)
    shopt -u nullglob

    if [ "''${#pages[@]}" -eq 0 ]; then
      "$LOGGER_BIN" -t scanbutton-scan "No pages scanned for device ''${SCANBD_DEVICE:-unknown}"
      exit 1
    fi

    if [ "''${#pages[@]}" -eq 1 ]; then
      "$MV_BIN" "''${pages[0]}" "$MERGED_TIFF"
    else
      "$TIFFCP_BIN" "''${pages[@]}" "$MERGED_TIFF"
    fi

    "$TIFF2PDF_BIN" -o "$OUT_FILE" "$MERGED_TIFF"

    "$LOGGER_BIN" -t scanbutton-scan "Saved $OUT_FILE"
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
    users.users.${hostVariables.username} = {
      extraGroups = ["scanner" "lp"];
    };

    environment.systemPackages = with pkgs; [
      scanbd
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.outputDir} 0770 ${hostVariables.username} users -"
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
