{ stdenv, fetchFromGitHub }:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.android-udev-rules ];

stdenv.mkDerivation rec {
  name = "android-udev-rules-${version}";
  version = "20170202";

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "android-udev-rules";
    rev = version;
    sha256 = "0apl22i27kgwld670wrlf5lv6iknx57grjbw0x0h4q0il2k4nmn7";
  };

  installPhase = ''
    install -D 51-android.rules $out/lib/udev/rules.d/51-android.rules
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/M0Rf30/android-udev-rules";
    description = "Android udev rules list aimed to be the most comprehensive on the net";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
