{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, sway, wlroots
, libpulseaudio, libinput, libnl, gtkmm3
, fmt, jsoncpp, libdbusmenu-gtk3
, glib
, git
, spdlog
, mpd_clientlib
}:

let
  metadata = import ./metadata.nix;

  mpd_clientlibWithDebug = mpd_clientlib.overrideAttrs (oldAttrs: rec {
    separateDebugInfo = true;
    # dontStrip = true;
    NIX_CFLAGS_COMPILE = "-O0";
  });

in
stdenv.mkDerivation rec {
  name = "waybar-${version}";
  version = metadata.rev;

  separateDebugInfo = true;
  # dontStrip = true;
  NIX_CFLAGS_COMPILE = "-O0";

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [
    wayland wayland-protocols sway wlroots
    libpulseaudio libinput libnl gtkmm3
    git fmt jsoncpp libdbusmenu-gtk3
    glib
    spdlog
    mpd_clientlibWithDebug
  ];
  mesonFlags = [
    "-Dauto_features=enabled"
    "-Dout=${placeholder "out"}"
    "-Dsystemd=disabled"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Highly customizable Wayland Polybar like bar for Sway and Wlroots based compositors.";
    homepage    = https://github.com/Alexays/Waybar;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}

