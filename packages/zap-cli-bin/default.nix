{
  fetchzip,
  lib,
  makeWrapper,
  asar,
  nodejs_24,
  stdenvNoCC,
}:
let
  inherit (stdenvNoCC.hostPlatform) isDarwin isLinux;

  sources = {
    x86_64-linux = {
      url = "https://github.com/project-chip/zap/releases/download/v2026.05.21/zap-linux-x64.zip";
      hash = "sha256-QbOLOHpl/0WUY8HsAhfzdqdTT+0HSn3TG9j6uuAKQpM=";
    };
    aarch64-linux = {
      url = "https://github.com/project-chip/zap/releases/download/v2026.05.21/zap-linux-arm64.zip";
      hash = "sha256-A13MtQXaSLgc3WLXJKS9RDVRkHnm4FZydDcLsZE1JH4=";
    };
    x86_64-darwin = {
      url = "https://github.com/project-chip/zap/releases/download/v2026.05.21/zap-mac-x64.zip";
      hash = "sha256-LYY5peXBMxCRLwKsjDDn4An54Jrb6ZKmkyKWGBZt1po=";
    };
    aarch64-darwin = {
      url = "https://github.com/project-chip/zap/releases/download/v2026.05.21/zap-mac-arm64.zip";
      hash = "sha256-h3ehPggZ0KaHoXYCw1+g4zahwLlQef0Z6kaKNu7X91I=";
    };
  };

  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "zap-cli-bin is unsupported on ${stdenvNoCC.hostPlatform.system}");

  linuxMainProcess = "${placeholder "out"}/libexec/zap-cli-app/dist/src-electron/main-process/main.js";
in
stdenvNoCC.mkDerivation {
  pname = "zap-cli-bin";
  version = "2026.05.21";

  src = fetchzip {
    inherit (source) url hash;
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals isLinux [
    makeWrapper
    asar
  ];

  doInstallCheck = stdenvNoCC.hostPlatform.system == stdenvNoCC.buildPlatform.system;

  installPhase = ''
    runHook preInstall

    ${lib.optionalString isLinux ''
      install -d "$out/bin"

      asar extract ./resources/app.asar "$out/libexec/zap-cli-app"

      makeWrapper ${lib.getExe nodejs_24} "$out/bin/zap-cli" \
        --argv0 zap-cli \
        --add-flags ${lib.escapeShellArg linuxMainProcess}
    ''}

    ${lib.optionalString isDarwin ''
      install -Dm755 ./zap-cli "$out/bin/zap-cli"
    ''}

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"

    if ! "$out/bin/zap-cli" --version; then
      "$out/bin/zap-cli" -v
    fi

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Prebuilt ZAP release assets packaged for Project CHIP";
    homepage = "https://github.com/project-chip/zap";
    license = licenses.asl20;
    mainProgram = "zap-cli";
    platforms = platforms.unix;
  };
}
