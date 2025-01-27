{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  rofi,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "rofi-file-browser-extended";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "marvinkreis";
    repo = pname;
    rev = version;
    hash = "sha256-UEFv0skFzWhgFkmz1h8uV1ygW977zNq1Dw8VAawqUgw=";
    fetchSubmodules = true;
  };

  prePatch = ''
    substituteInPlace ./CMakeLists.txt \
      --replace ' ''${ROFI_PLUGINS_DIR}' " $out/lib/rofi" \
      --replace "/usr/share/" "$out/share/"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    rofi
    gtk3
  ];

  ROFI_PLUGINS_DIR = "$out/lib/rofi";

  dontUseCmakeBuildDir = true;

  # fix compile issue, fixed here:
  # https://github.com/marvinkreis/rofi-file-browser-extended/issues/52
  patches = [
    ./fix-pointer-issue.patch
  ];

  meta = with lib; {
    description = "Use rofi to quickly open files";
    homepage = "https://github.com/marvinkreis/rofi-file-browser-extended";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
