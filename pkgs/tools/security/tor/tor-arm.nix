{ stdenv, fetchurl, python, setuptools, lsof, nettools, makeWrapper }:

stdenv.mkDerivation rec {
  name    = "tor-arm-${version}";
  version = "1.4.5.0";

  src = fetchurl {
    url    = "https://www.atagar.com/arm/resources/static/arm-${version}.tar.bz2";
    sha256 = "1yi87gdglkvi1a23hv5c3k7mc18g0rw7b05lfcw81qyxhlapf3pw";
  };

  buildInputs = [ python setuptools lsof nettools makeWrapper ];

  patchPhase = ''
    substituteInPlace ./setup.py --replace "/usr/bin" "$out/bin"
    substituteInPlace ./src/util/connections.py \
      --replace "lsof -wnPi"   "${lsof}/bin/lsof"
    substituteInPlace ./src/util/torTools.py \
      --replace "netstat -npl" "${nettools}/bin/netstat -npl" \
      --replace "lsof -wnPi"   "${lsof}/bin/lsof"

    substituteInPlace ./arm --replace '"$0" = /usr/bin/arm' 'true'

    for i in ./install ./arm ./src/gui/controller.py ./src/cli/wizard.py ./src/resources/torrcOverride/override.h ./src/resources/torrcOverride/override.py ./src/resources/arm.1 ./setup.py; do
      substituteInPlace $i --replace "/usr/share" "$out/share"
    done
  '';

  installPhase = ''
    mkdir -p $out/share/arm $out/bin $out/libexec
    python setup.py install --prefix=$out
    cp -R src/TorCtl $out/libexec

    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i \
        --prefix PYTHONPATH : "$(toPythonPath $out):$out/libexec:$PYTHONPATH"
    done
  '';

  meta = {
    description = "Anonymizing relay monitor for Tor";
    homepage    = "https://www.atagar.com/arm/";
    license     = stdenv.lib.licenses.gpl3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
