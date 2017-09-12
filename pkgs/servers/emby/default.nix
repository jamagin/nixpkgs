{ stdenv, fetchurl, pkgs, unzip, sqlite, makeWrapper, mono46, ffmpeg, ... }:

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "3.2.30.0";

  src = fetchurl {
    url = "https://github.com/MediaBrowser/Emby/releases/download/${version}/Emby.Mono.zip";
    sha256 = "1aqal7n4a9dvy97zw4aah9a8jm4l2v1qgjgs5kvskrvir2dbid27";
  };

  buildInputs = with pkgs; [
    unzip
    makeWrapper
  ];
  propagatedBuildInputs = with pkgs; [
    mono46
    sqlite
  ];

  # Need to set sourceRoot as unpacker will complain about multiple directory output
  sourceRoot = ".";

  buildPhase = ''
    substituteInPlace SQLitePCLRaw.provider.sqlite3.dll.config --replace libsqlite3.so ${sqlite.out}/lib/libsqlite3.so
    substituteInPlace MediaBrowser.Server.Mono.exe.config --replace ProgramData-Server "/var/lib/emby/ProgramData-Server"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin

    makeWrapper "${mono46}/bin/mono" $out/bin/MediaBrowser.Server.Mono \
      --add-flags "$out/bin/MediaBrowser.Server.Mono.exe -ffmpeg ${ffmpeg}/bin/ffmpeg -ffprobe ${ffmpeg}/bin/ffprobe"
  '';

  meta = {
    description = "MediaBrowser - Bring together your videos, music, photos, and live television";
    homepage = https://emby.media/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
