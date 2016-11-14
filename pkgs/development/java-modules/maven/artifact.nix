{ fetchMaven }:

rec {
  mavenArtifact_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-artifact";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3kkv5kf3k5in69aplawkr0cr2cviyjgf8k6r6qvgxk53i3jmh7qylzrwkrd9bxclkjkgyg77cffxm48qhxm9pyqncdbwjldsmmdfb4f"; }
    { type = "pom"; sha512 = "37kvfxcpfajjn9lmvh5kay4y61ri1190hxxgiil8fqfvmvcm02jcqzfi4ry0nzc80g5fsarsd3s2ns2d8l0lnqjp28nn51dixm9a55w"; }
  ];

  mavenArtifact_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-artifact";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "17g913m1zbrvarkwvmz5xx9nv7mrk2984rc9pkbc2laid7n1nb226g0262xyhcnc2s57av96337ag6jg2bq9p1kgx7gbd2z6gnvkkia"; }
    { type = "pom"; sha512 = "0g0cbqihzxyaa1b0z9a7qb8lkhcm8bzxi7qnqaab2n2zaaql6jyy7cf4z4yzqw3yfj7ylqvydiwp32j2c7nqacyx0hmcydqkqg46kxv"; }
  ];

  mavenArtifact_3_0_3 = map (obj: fetchMaven {
    version = "3.0.3";
    baseName = "maven-artifact";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0f842m7wi9ajvphgshnmsn8dppiwr326yp663gic45xzkpfvka118npl8xxqnr683dipvbnbrddim974qcpz4mgpypir0922803i3qv"; }
    { type = "pom"; sha512 = "3wpambpgm68rap906gdvwlbywgjs57nkc8k05r8rx701800zbpwlrzc9b3ipxgjb7y6f2z1vi14yj9ia12wv7k8jn2aspf31pzp5plq"; }
  ];
}
