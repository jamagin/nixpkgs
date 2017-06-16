{ stdenv, procps, coreutils, fetchurl, jdk, jre, ant, gettext, which }:

stdenv.mkDerivation rec {
  name = "i2p-0.9.30";
  src = fetchurl {
    url = "https://github.com/i2p/i2p.i2p/archive/${name}.tar.gz";
    sha256 = "03hrirmah3ba9ygql487jy233nsxkfjyz82mmyppazi0mcgiass1";
  };
  buildInputs = [ jdk ant gettext which ];
  patches = [ ./i2p.patch ];
  buildPhase = ''
    export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
    ant preppkg-linux-only
    '';
  installPhase = ''
    set -B
    mkdir -p $out/{bin,share}
    cp -r pkg-temp/* $out
    '' +

    # TODO: Compile wrapper ourselves, see https://geti2p.net/en/misc/manual-wrapper
    (if stdenv.system == "i686-linux"
    then ''
      cp installer/lib/wrapper/linux/* $out
    '' else ''
      cp installer/lib/wrapper/linux64/* $out
    '')

     # */ # comment end for vim

    + ''
    sed -i $out/i2prouter -i $out/runplain.sh \
      -e "s#uname#${coreutils}/bin/uname#" \
      -e "s#which#${which}/bin/which#" \
      -e "s#%gettext%#${gettext}/bin/gettext#" \
      -e "s#/usr/ucb/ps#${procps}/bin/ps#" \
      -e "s#/usr/bin/tr#${coreutils}/bin/tr#" \
      -e "s#%INSTALL_PATH#$out#" \
      -e 's#%USER_HOME#$HOME#' \
      -e "s#%SYSTEM_java_io_tmpdir#/tmp#" \
      -e "s#%JAVA%#${jre}/bin/java#"
    mv $out/runplain.sh $out/bin/i2prouter-plain
    mv $out/man $out/share/
    chmod +x $out/bin/* $out/i2psvc
    rm $out/{osid,postinstall.sh,INSTALL-headless.txt}
    '';

  meta = with stdenv.lib; {
    homepage = https://geti2p.net;
    description = "Applications and router for I2P, anonymity over the Internet";
    maintainers = [ maintainers.joelmo ];
    license = licenses.gpl2;
    # TODO: support other systems, just copy appropriate lib/wrapper.. to $out
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
