{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  nodejs,
  node-gyp,
  python3,
  musl,
  bashInteractive,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "dsh";
  version = "0.1.1-rc.2";

  env = {
    pnpm_config_offline = "true";
    pnpm_config_update_notifier = "false";
    pnpm_config_side_effects_cache = "false";
  };

  landlockPackageDir = "native/landlock-run/packages/${stdenv.hostPlatform.node.platform}-${stdenv.hostPlatform.node.arch}";

  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "deepseek-harness";
    rev = "dsh-v${version}";
    hash = "sha256-bgZnSElEbiilAx2R6rCnov54ORBnLcgOe+PItKQbMAg=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD | head -c 7 > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-+PsdK9u3ZKv4XtSc8tBKKP48J/95/CGTMIUf8Q8dbok=";
  };

  nativeBuildInputs = [
    nodejs
    node-gyp
    pnpmConfigHook
    pnpm
    python3
    makeWrapper
  ];

  preBuild = ''
    export DSH_CLIENT_COMMIT_HASH="$(cat COMMIT)"
    rm -f COMMIT
  '';

  buildPhase = ''
    runHook preBuild

    nodePty="$(echo node_modules/.pnpm/node-pty@*/node_modules/node-pty)"
    (cd "$nodePty" && node-gyp rebuild --nodedir="${nodejs}")

    mkdir -p "${landlockPackageDir}/bin"
    ${musl.dev}/bin/musl-gcc -std=c11 -Os -Wall -Wextra -Werror -static -s \
      -o "${landlockPackageDir}/bin/landlock-run" \
      native/landlock-run/packages/entry/src/main.c
    chmod 755 "${landlockPackageDir}/bin/landlock-run"

    substituteInPlace packages/terminal/terminal-bash/src/config.ts \
      --replace-fail "/bin/bash" "${bashInteractive}/bin/bash"

    pnpm run build:official

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r . "$out"
    chmod -R u+w "$out"

    rm -rf "$out/website" "$out/docs" "$out/examples" "$out/python" \
      "$out/.github" "$out/.agents" "$out/.claude" "$out/packages/examples"

    find "$out/apps" "$out/packages" "$out/vendor" "$out/native" \
      -type d \( -name tests -o -name test \) -prune -exec rm -rf {} +
    find "$out/apps" "$out/packages" "$out/vendor" "$out/native" \
      -type f -path '*/lib/types/*.d.ts' -delete
    find "$out" -xtype l -delete

    rm -rf "$out"/node_modules/.pnpm/node-pty@*/node_modules/node-pty/prebuilds
    rm -rf "$out"/node_modules/.pnpm/node-pty@*/node_modules/node-pty/build/Release/obj.target
    rm -rf "$out"/node_modules/.modules.yaml
    rm -rf "$out"/node_modules/.pnpm-workspace-state-v1.json

    mkdir -p "$out/bin"
    makeWrapper ${nodejs}/bin/node "$out/bin/dsh" \
      --add-flags "--expose-internals $out/apps/cli/lib/bin.js" \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
          pnpm
        ]
      } \
      --suffix PATH : ${bashInteractive}/bin

    runHook postInstall
  '';

  meta = {
    description = "DeepSeek Harness CLI";
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    license = lib.licenses.mit;
    mainProgram = "dsh";
    platforms = [ "x86_64-linux" ];
  };
}
