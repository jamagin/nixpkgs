{ fetchMaven }:

rec {
  mavenPluginRegistry_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-plugin-registry";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1d9134rarw653dgn1q80dahjpkl82sfrznkhdb6s8zy6d31bbr4ry6w362r7a2p54ijx2vw3rl0jmh805p3imlf1cgra1m7pihh2b63"; }
    { type = "pom"; sha512 = "0b85gmdgwwxdw4czs7383ivssp5n8nxr5vxnj8agjlx6yclxpbbw7n192c4p1hba8as1md52c08cxilibjiiahlv83bmzyh2hb0vdm3"; }
  ];

  mavenPluginRegistry_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-plugin-registry";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "14mkwxvj0rbj28df9gjnkvr20paayqdmsg0vrzcb23d3xng3zc1fy5hvkifnp7xg73qxpdz0nij56lnnj7q2dqxcnmqvh0vslhc2xja"; }
    { type = "pom"; sha512 = "0c09imgd44b3pgnj1bjak7xn2z3mpwy9nhbchagfqkicras4djmn2dqwpm1z6p1d4khwx830x9grjrw45przan8lgc7wxzkalnnaqkf"; }
  ];

  mavenPluginRegistry_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-plugin-registry";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "31kbwqlcwpyvp69sp41hb86dskyr4jp9pb1b43wc23lnk0qlyc712bqrr3qbc6kbl2wfra5fhpr70nfilx6bxsz66zizgdca3pdc0z3"; }
    { type = "pom"; sha512 = "2i5zj8fmfjdnjl5y91b8m5n8gyiaih4n1i6rn85plibq4n8a42kmxgphvicnn36sgrgmy7la4vrzbaigm2zci857qws52j9p16hzv9c"; }
  ];
}
