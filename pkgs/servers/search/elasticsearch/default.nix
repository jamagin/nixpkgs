{ stdenv, fetchurl, makeWrapper, jre, utillinux, getopt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "elasticsearch-1.4.3";

  src = fetchurl {
    url = "https://download.elasticsearch.org/elasticsearch/elasticsearch/${name}.tar.gz";
    sha256 = "0s1z814pwasiz9byglil6smgxfylqk7g9w9schfgv40wwi6zkh98";
  };

  patches = [ ./es-home.patch ];

  buildInputs = [ makeWrapper jre ] ++
    (if (!stdenv.isDarwin) then [utillinux] else [getopt]);

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib $out

    # don't want to have binary with name plugin
    mv $out/bin/plugin $out/bin/elasticsearch-plugin

    # set ES_CLASSPATH and JAVA_HOME
    wrapProgram $out/bin/elasticsearch \
      --prefix ES_CLASSPATH : "$out/lib/${name}.jar":"$out/lib/*":"$out/lib/sigar/*" \
      ${if (!stdenv.isDarwin)
        then ''--prefix PATH : "${utillinux}/bin/"''
        else ''--prefix PATH : "${getopt}/bin"''} \
      --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/elasticsearch-plugin \
      --prefix ES_CLASSPATH : "$out/lib/${name}.jar":"$out/lib/*":"$out/lib/sigar/*" \
      --set JAVA_HOME "${jre}"
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = stdenv.lib.licenses.asl20;
    platforms = platforms.unix;
  };
}
