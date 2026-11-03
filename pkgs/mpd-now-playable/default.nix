{
  lib,
  fetchPypi,
  python313Packages,
}:

python313Packages.buildPythonApplication rec {
  pname = "mpd-now-playable";
  version = "1.6.2";
  pyproject = true;

  src = fetchPypi {
    pname = "mpd_now_playable";
    inherit version;
    hash = "sha256-bbkRiJJieZToBCdeV4fuhNGrFl5PfyIWJhglaZ42to0=";
  };

  build-system = [ python313Packages.pdm-backend ];

  dependencies = with python313Packages; [
    aiocache
    boltons
    ormsgpack
    pydantic
    pyobjc-framework-Cocoa
    pyobjc-framework-MediaPlayer
    python-mpd2
    pytomlpp
    rich
    xdg-base-dirs
    yarl
  ];

  nativeCheckInputs = [ python313Packages.pytestCheckHook ];

  pythonImportsCheck = [
    "mpd_now_playable.cli"
    "corefoundationasyncio"
  ];

  postInstall = ''
    test -f "$out/${python313Packages.python.sitePackages}/mpd_now_playable/mpd/logo.svg"
  '';

  meta = {
    description = "Expose MPD as a Now Playing app on macOS";
    homepage = "https://github.com/00dani/mpd-now-playable";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "mpd-now-playable";
  };
}
