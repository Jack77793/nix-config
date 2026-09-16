{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  nodejs,
  dsh,
}:

stdenvNoCC.mkDerivation rec {
  pname = "dsh-context";
  version = "0.52.2";

  src = fetchFromGitHub {
    owner = "bowenliang123";
    repo = "dsh-context";
    rev = "v${version}";
    hash = "sha256-iF+RIrUux0C+E00q+nzDak+OJxGfXe0oUfkwuHWvK9I=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-LxTgpsv1jH15CnfPtJRDzP8igIf4pAvLIIlBNpV6KTA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -rf node_modules
    pnpm install --prod --offline --frozen-lockfile --ignore-scripts

    mkdir -p $out
    cp -r . $out/pkg
    ln -s ${dsh}/apps/cli/node_modules $out/node_modules

    rm -f $out/pkg/node_modules/.modules.yaml \
      $out/pkg/node_modules/.pnpm-workspace-state-v1.json

    runHook postInstall
  '';

  meta = {
    description = "dsh-context as a dsh profile bundle";
    homepage = "https://github.com/bowenliang123/dsh-context";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
