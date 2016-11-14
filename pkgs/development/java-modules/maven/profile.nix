{ fetchMaven }:

rec {
  mavenProfile_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-profile";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3wng0csnn4v3y2gndazg46hqriz27kkb977xzw5wr8anyharlz2ancl38zyfjf5vm18irqn8cxqklhzd3x1h0h6rlvz5z1wrrivr5kl"; }
    { type = "pom"; sha512 = "063vbh2miyfvrp90hs5cff5r8cj573zysjvd79lnz7zsah3ddbg6sbv09nb0pjy76pbqgrh913dziqk12l13kwngcgpq8v38v92vh63"; }
  ];

  mavenProfile_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-profile";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2v315cv62k3lmi23msk5rj9bijsafcajw7053jdzzk4zv03vdpdndm5cr995azrpdcvkcdq2m8zh5pdf44nzcdf2rvpm4nxdc2wr5rl"; }
    { type = "pom"; sha512 = "05iif04frjgbmg7zb3jygn9av2ja48vs2z35b2zrlmgf3s1fxqlr4wxylrrmmk8r0hvg4qmg5j0inm414n0v4ipn08hrpzik5nhdfgy"; }
  ];

  mavenProfile_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-profile";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2v315cv62k3lmi23msk5rj9bijsafcajw7053jdzzk4zv03vdpdndm5cr995azrpdcvkcdq2m8zh5pdf44nzcdf2rvpm4nxdc2wr5rl"; }
    { type = "pom"; sha512 = "05iif04frjgbmg7zb3jygn9av2ja48vs2z35b2zrlmgf3s1fxqlr4wxylrrmmk8r0hvg4qmg5j0inm414n0v4ipn08hrpzik5nhdfgy"; }
  ];
}
