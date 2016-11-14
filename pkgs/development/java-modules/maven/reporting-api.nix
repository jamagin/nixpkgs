{ fetchMaven }:

rec {
  mavenReportingApi_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-reporting-api";
    package = "/org/apache/maven/reporting";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0x7j7k3xbxps80swyp4ff1sw4rwrhlxsx80kyh0sj0i9jz50x18p1rba10gx2fqd4l29zri77nlm4qza5yrf61s68xby2zr2bygyc9r"; }
    { type = "pom"; sha512 = "054v1p9h0141pahs52pg8wb0x4jghm5222yns6mf4dbc9gpy7x9j2b0z2lv9q3slx98378s4zakx4kbk5ca9ldlm8sz9y10fpqm35s6"; }
  ];
}
