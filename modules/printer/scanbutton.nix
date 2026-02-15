{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: let
  cfg = config.modules.printer.scanbutton;
  scannerUser = hostVariables.username;
  hostOutputDir = lib.attrByPath ["modules" "printer" "scanbuttonOutDir"] null hostVariables;
  hostBlankPageThreshold = lib.attrByPath ["modules" "printer" "scanbuttonBlankPageThreshold"] null hostVariables;
  hostBlackBorderTrimFuzz = lib.attrByPath ["modules" "printer" "scanbuttonBlackBorderTrimFuzz"] null hostVariables;
  scanOutputDir = cfg.outputDir;

  saneBin = "${pkgs.sane-backends}/bin";
  libtiffBin = "${pkgs.libtiff}/bin";
  imagemagickBin = "${pkgs.imagemagick}/bin";
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
    MAGICK_BIN="${imagemagickBin}/magick"
    DATE_BIN="${coreutilsBin}/date"
    LOGGER_BIN="${utilLinuxBin}/logger"
    MKDIR_BIN="${coreutilsBin}/mkdir"
    MKTEMP_BIN="${coreutilsBin}/mktemp"
    MV_BIN="${coreutilsBin}/mv"
    RM_BIN="${coreutilsBin}/rm"

    OUT_DIR="${scanOutputDir}"
    TIMESTAMP="$("$DATE_BIN" +%Y%m%d-%H%M%S)"
    UUID="$("${utilLinuxBin}/uuidgen")"

    TMP_DIR="$("$MKTEMP_BIN" -d)"
    MERGED_TIFF="$TMP_DIR/scan-merged.tiff"
    OUT_FILE="$OUT_DIR/scan-$TIMESTAMP-$UUID.pdf"
    PAGE_PATTERN="$TMP_DIR/page-%03d.tiff"
    readonly DUPLEX_SOURCES=(${lib.concatMapStringsSep " " (source: "\"${source}\"") duplexSources})
    readonly BLANK_PAGE_THRESHOLD="${toString cfg.blankPageThreshold}"
    readonly BLANK_PAGE_MAX_DARK_RATIO="0.004"
    readonly BLACK_BORDER_TRIM_FUZZ="${cfg.blackBorderTrimFuzz}"
    readonly BLACK_BORDER_SHAVE="12x12"

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

    remove_blank_pages() {
      local -a pages
      local page
      local is_blank
      local is_low_ink
      local removed_blank_count=0

      shopt -s nullglob
      pages=("$TMP_DIR"/page-*.tiff)
      shopt -u nullglob

      for page in "''${pages[@]}"; do
        if ! is_blank="$("$MAGICK_BIN" "$page" -colorspace Gray -format "%[fx:mean>=$BLANK_PAGE_THRESHOLD]" info:)"; then
          log "Skipping blank-page check for $page (ImageMagick failed)"
          continue
        fi
        if ! is_low_ink="$("$MAGICK_BIN" "$page" -colorspace Gray -threshold 80% -negate -format "%[fx:mean<=$BLANK_PAGE_MAX_DARK_RATIO]" info:)"; then
          log "Skipping low-ink blank check for $page (ImageMagick failed)"
          continue
        fi

        if [ "$is_blank" = "1" ] || [ "$is_low_ink" = "1" ]; then
          "$RM_BIN" -f "$page"
          removed_blank_count=$((removed_blank_count + 1))
        fi
      done

      log "Blank-page cleanup removed $removed_blank_count page(s)"
    }

    remove_black_borders() {
      local -a pages
      local page
      local trim_tmp
      local trimmed_count=0

      shopt -s nullglob
      pages=("$TMP_DIR"/page-*.tiff)
      shopt -u nullglob

      for page in "''${pages[@]}"; do
        trim_tmp="$page.trimmed"
        if "$MAGICK_BIN" "$page" -fuzz "$BLACK_BORDER_TRIM_FUZZ" -trim +repage "$trim_tmp"; then
          if "$MAGICK_BIN" "$trim_tmp" -shave "$BLACK_BORDER_SHAVE" "$page"; then
            "$RM_BIN" -f "$trim_tmp"
            trimmed_count=$((trimmed_count + 1))
          else
            "$MV_BIN" "$trim_tmp" "$page"
            log "Border trim applied without shave for $page"
            trimmed_count=$((trimmed_count + 1))
          fi
        else
          "$RM_BIN" -f "$trim_tmp"
          log "Skipping border-trim output rewrite for $page (ImageMagick trim failed)"
        fi
      done

      log "Border cleanup processed $trimmed_count page(s)"
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

    remove_black_borders
    remove_blank_pages

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
      default =
        if hostOutputDir != null
        then hostOutputDir
        else "/home/${hostVariables.username}/Scans";
      description = "Directory where scanned files are written.";
    };

    blankPageThreshold = lib.mkOption {
      type = lib.types.float;
      default =
        if hostBlankPageThreshold != null
        then hostBlankPageThreshold
        else 0.998;
      description = "Grayscale mean threshold (0-1) above which a scanned page is considered empty and removed.";
    };

    blackBorderTrimFuzz = lib.mkOption {
      type = lib.types.str;
      default =
        if hostBlackBorderTrimFuzz != null
        then hostBlackBorderTrimFuzz
        else "12%";
      description = "ImageMagick fuzz value used when trimming black page borders.";
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
        imagemagick
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
