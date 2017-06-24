{ stdenv, fetchMavenArtifact, fetchFromGitHub, bash, jre }:

let
  version = "0.9.1";
  nailgun-server = fetchMavenArtifact {
    groupId = "com.martiansoftware";
    artifactId = "nailgun-server";
    inherit version;
    sha256 = "09ggkkd1s58jmpc74s6m10d3hyf6bmif31advk66zljbpykgl625";
  };
in
stdenv.mkDerivation rec {
  name = "nailgun-${version}";

  src = fetchFromGitHub {
    owner = "martylamb";
    repo = "nailgun";
    rev = "1ad9ad9d2d17c895144a9ee0e7acb1d3d90fb66f";
    sha256 = "1f8ac5kg7imhix9kqdzwiav1bxh8vljv2hb1mq8yz4rqsrx2r4w3";
  };

  makeFlags = "PREFIX=$(out)";

  installPhase = ''
    install -D ng $out/bin/ng
    install -D ${nailgun-server.jar} $out/share/java/nailgun-server-${version}.jar

    cat > $out/bin/ng-server << EOF
    #!${bash}/bin/bash

    ${jre}/bin/java -cp $out/share/java/nailgun-server-${version}.jar:\$CLASSPATH com.martiansoftware.nailgun.NGServer "\$@"
    EOF
    chmod +x $out/bin/ng-server
  '';

  meta = with stdenv.lib; {
    description = "Client, protocol, and server for running Java programs from the command line without incurring the JVM startup overhead";
    homepage = http://martiansoftware.com/nailgun/;
    license = licenses.apsl20;
    platforms = platforms.linux;
    maintainer = with maintainers; [ volth ];
  };
}
