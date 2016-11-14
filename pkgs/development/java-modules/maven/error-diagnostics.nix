{ fetchMaven }:

rec {
  mavenErrorDiagnostics_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-error-diagnostics";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2rpzlgi1hyiq1qmfn9fdr3317mq990y67zb0jvyah7sgr5x969l984cfigwdcw0m7i4kpg5157myq4cps3d9pz81h4wx4plwwpkyp2v"; }
    { type = "pom"; sha512 = "3r8r5sw3zbyms1yk1811cxh2a6p86lhg8aa9b6whn97mx3gmy9zy2nhsadgnxw1hbc2y6l1pk3xs2q73hmvag1bapks5bm7higmgdpg"; }
  ];

  mavenErrorDiagnostics_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-error-diagnostics";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3czdrv2s1gafclm57m5qxw3aaxrm3r3z9yggscxg60fk0hn6jlpygclghkrl2g7c8ggdqdd01y6zcj1wgzq32yp1cd4s3kakf2y25dm"; }
    { type = "pom"; sha512 = "3l0cpg0ssivfnadffc68cnac65vpfpl0qa9a4ik82jxcwhfa00337jxz37vyqaqs1vjrvd2cqhmjayddwkpwc8aqnz3nr0rlqnqzm7g"; }
  ];

  mavenErrorDiagnostics_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-error-diagnostics";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3czdrv2s1gafclm57m5qxw3aaxrm3r3z9yggscxg60fk0hn6jlpygclghkrl2g7c8ggdqdd01y6zcj1wgzq32yp1cd4s3kakf2y25dm"; }
    { type = "pom"; sha512 = "3l0cpg0ssivfnadffc68cnac65vpfpl0qa9a4ik82jxcwhfa00337jxz37vyqaqs1vjrvd2cqhmjayddwkpwc8aqnz3nr0rlqnqzm7g"; }
  ];
}
