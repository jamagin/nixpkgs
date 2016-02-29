# This file was generated by go2nix.
{ stdenv, lib, makeWrapper, go, goPackages, git, fetchgit, sqliteSupport ? true }:

with goPackages;

buildGoPackage rec {
  name = "gogs-${version}";
  version = "20160227-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "d320915ad2a7b4bbab075b98890aa50f91f0ced5";

  buildInputs = [ makeWrapper go ];
  buildFlags = lib.optional (sqliteSupport) "-tags sqlite";
  goPackagePath = "github.com/gogits/gogs";

  postInstall = ''
    wrapProgram $bin/bin/gogs \
      --prefix PATH : ${git}/bin \
      --run 'export GOGS_WORK_DIR=''${GOGS_WORK_DIR:-$PWD}' \
      --run 'cd "$GOGS_WORK_DIR"' \
      --run "ln -fs $out/share/go/src/${goPackagePath}/{public,templates} ."
  '';

  src = fetchgit {
    inherit rev;
    url = "https://github.com/gogits/gogs.git";
    sha256 = "0wpyn3linpb9jgqrpzbmmgn2s54rdhnqv286x2vj4lrngjc8xbc7";
  };

  extraSrcs = [
    {
      goPackagePath = "github.com/Unknwon/cae";

      src = fetchgit {
        url = "https://github.com/Unknwon/cae";
        rev = "7f5e046bc8a6c3cde743c233b96ee4fd84ee6ecd";
          sha256 = "1sp9mlm42r50ydsk1dyyhshrryy364pjdj8m275b5av8yg374dq2";
      };
    }
    {
      goPackagePath = "github.com/Unknwon/com";

      src = fetchgit {
        url = "https://github.com/Unknwon/com";
        rev = "28b053d5a2923b87ce8c5a08f3af779894a72758";
          sha256 = "1nq7pdjczgllm0yb2dlgr6zclwpwabl9a86dyw4bz0zd6qginfxy";
      };
    }
    {
      goPackagePath = "github.com/Unknwon/i18n";

      src = fetchgit {
        url = "https://github.com/Unknwon/i18n";
        rev = "3b48b6662051bed72d36efa3c1e897bdf96b2e37";
          sha256 = "1h18024641z473gx1ghwxd741c5sbhww4zsc0f3wwig6dghsfy0f";
      };
    }
    {
      goPackagePath = "github.com/Unknwon/paginater";

      src = fetchgit {
        url = "https://github.com/Unknwon/paginater";
        rev = "7748a72e01415173a27d79866b984328e7b0c12b";
          sha256 = "11lf3grqdr7ynhm39xp7siihf7b7v5p7r1vf9f3lbnyy99092v9p";
      };
    }
    {
      goPackagePath = "github.com/bradfitz/gomemcache";

      src = fetchgit {
        url = "https://github.com/bradfitz/gomemcache";
        rev = "fb1f79c6b65acda83063cbc69f6bba1522558bfc";
          sha256 = "0s4azbz3q681psi31r6z1697rkhqpaap8lif9yg85v6fc0zm7wvc";
      };
    }
    {
      goPackagePath = "github.com/codegangsta/cli";

      src = fetchgit {
        url = "https://github.com/codegangsta/cli";
        rev = "a2943485b110df8842045ae0600047f88a3a56a1";
          sha256 = "1hdbr6riv7j4all09w2a5zdc27fq11rf005v7v3wdccq07zmsmaa";
      };
    }
    {
      goPackagePath = "github.com/go-macaron/binding";

      src = fetchgit {
        url = "https://github.com/go-macaron/binding";
        rev = "a68f34212fe257219981e43adfe4c96ab48f42cd";
          sha256 = "00ny0khwbcv9n7kbnc2mfl07sp6dyp4xc5y4wiqvsgj66gb90yf7";
      };
    }
    {
      goPackagePath = "github.com/go-macaron/cache";

      src = fetchgit {
        url = "https://github.com/go-macaron/cache";
        rev = "56173531277692bc2925924d51fda1cd0a6b8178";
          sha256 = "05b2bbndkdr5z63f2xz4z1k8ls3zz7xi17vkhqnz0g0dvsx34l38";
      };
    }
    {
      goPackagePath = "github.com/go-macaron/captcha";

      src = fetchgit {
        url = "https://github.com/go-macaron/captcha";
        rev = "8aa5919789ab301e865595eb4b1114d6b9847deb";
          sha256 = "0wdihxbl7yw4wg2x0wb09kv9swfpr5j06wsj4hxn3xcbpqi9viwm";
      };
    }
    {
      goPackagePath = "github.com/go-macaron/csrf";

      src = fetchgit {
        url = "https://github.com/go-macaron/csrf";
        rev = "715bca06a911dbd91c4f1d9ec65fd329664b5211";
          sha256 = "1jljqv96ib5iih0jx7smsykbsfc0wy33salf19djad5xb64clpmi";
      };
    }
    {
      goPackagePath = "github.com/go-macaron/gzip";

      src = fetchgit {
        url = "https://github.com/go-macaron/gzip";
        rev = "cad1c6580a07c56f5f6bc52d66002a05985c5854";
          sha256 = "12mq3dd1vd0jbi80fxab4ysmipbz9zhbm9nw6y6a6bw3byc8w4jf";
      };
    }
    {
      goPackagePath = "github.com/go-macaron/i18n";

      src = fetchgit {
        url = "https://github.com/go-macaron/i18n";
        rev = "d2d3329f13b52314f3292c4cecb601fad13f02c8";
          sha256 = "18f59fkw3wy5b80x8jcqnywqscs7qvj7cnfi85d23m9kq353pifs";
      };
    }
    {
      goPackagePath = "github.com/go-macaron/inject";

      src = fetchgit {
        url = "https://github.com/go-macaron/inject";
        rev = "c5ab7bf3a307593cd44cb272d1a5beea473dd072";
          sha256 = "0v7plrgwx9qn9iknm7p5fr5c53zzx5aaqvdcgyh6hnfwjjf5zny4";
      };
    }
    {
      goPackagePath = "github.com/go-macaron/session";

      src = fetchgit {
        url = "https://github.com/go-macaron/session";
        rev = "66031fcb37a0fff002a1f028eb0b3a815c78306b";
          sha256 = "0h6l1af93cipcmy3p6asw79cbmhkl34rmf0nyzywpm2pmn7pqznc";
      };
    }
    {
      goPackagePath = "github.com/go-macaron/toolbox";

      src = fetchgit {
        url = "https://github.com/go-macaron/toolbox";
        rev = "82b511550b0aefc36b3a28062ad3a52e812bee38";
          sha256 = "1s2psf7sw3asag3hnw0n3ah6ywwghf2p4yn4m0pf5d9883sf4pgm";
      };
    }
    {
      goPackagePath = "github.com/go-sql-driver/mysql";

      src = fetchgit {
        url = "https://github.com/go-sql-driver/mysql";
        rev = "71f003c6e927d2550713e7637affb769977ece78";
          sha256 = "197x3hlmgaw736hyvyxla1m2c6bcwif68zjvk3qd7mxxbfi5ic6s";
      };
    }
    {
      goPackagePath = "github.com/go-xorm/core";

      src = fetchgit {
        url = "https://github.com/go-xorm/core";
        rev = "9ddf4ee12e7a370dacf0092d9896979ae6e3fb16";
          sha256 = "1qn7kgfyc7yv78ggwc8w2f75jklbm68a4wirglysf8kf70l3m773";
      };
    }
    {
      goPackagePath = "github.com/go-xorm/xorm";

      src = fetchgit {
        url = "https://github.com/go-xorm/xorm";
        rev = "67d038a63f23ce98f7fbc5ef3a87075d82d50f93";
          sha256 = "0qk1h3ihdl0mqmi28gljxx46lnngjh4l80zrxvlsqlwrlj95yw7k";
      };
    }
    {
      goPackagePath = "github.com/gogits/chardet";

      src = fetchgit {
        url = "https://github.com/gogits/chardet";
        rev = "2404f777256163ea3eadb273dada5dcb037993c0";
          sha256 = "1dki2pqhnzcmzlqrq4d4jwknnjxm82xqnmizjjdblb6h98ans1cd";
      };
    }
    {
      goPackagePath = "github.com/gogits/cron";

      src = fetchgit {
        url = "https://github.com/gogits/cron";
        rev = "3abc0f88f2062336bcc41b43a4febbd847a390ce";
          sha256 = "0y3z048wym595w8rgngz2mpd1bg8gc282li1l0bmg5q8a4hyb0x5";
      };
    }
    {
      goPackagePath = "github.com/gogits/git-module";

      src = fetchgit {
        url = "https://github.com/gogits/git-module";
        rev = "a1c50966a193fa4cfc9a9142c59189348c97387c";
          sha256 = "1xaffyzgbif84n73s79g8yynpp89d61lajn0y0vf4pnkh1j500v0";
      };
    }
    {
      goPackagePath = "github.com/gogits/go-gogs-client";

      src = fetchgit {
        url = "https://github.com/gogits/go-gogs-client";
        rev = "d584b1e0fb4d8ad0e8cf2fae2368838f2526b408";
          sha256 = "1g9kb0bj50dnwh261r3sq00jy1d8pyywh3ybav83lnmn95sbzsns";
      };
    }
    {
      goPackagePath = "github.com/gogits/gogs";

      src = fetchgit {
        url = "https://github.com/gogits/gogs.git";
        rev = "d320915ad2a7b4bbab075b98890aa50f91f0ced5";
          sha256 = "0wpyn3linpb9jgqrpzbmmgn2s54rdhnqv286x2vj4lrngjc8xbc7";
      };
    }
    {
      goPackagePath = "github.com/issue9/identicon";

      src = fetchgit {
        url = "https://github.com/issue9/identicon";
        rev = "f8c0d2ce04db79c663b1da33d3a9f62be753ee88";
          sha256 = "0zilbp4dqmbslhs9p10gb04xggf3z0xlr0vw2g7c5gyc2w02q27f";
      };
    }
    {
      goPackagePath = "github.com/klauspost/compress";

      src = fetchgit {
        url = "https://github.com/klauspost/compress";
        rev = "f9625351863b5e94c1da72862187b8fe9a91af90";
          sha256 = "0yjl58zk2dlb1jvgc3frnhgbsrc680ajkpb8bbyd9m5d21hmkq56";
      };
    }
    {
      goPackagePath = "github.com/klauspost/cpuid";

      src = fetchgit {
        url = "https://github.com/klauspost/cpuid";
        rev = "2c698c6aef5976c7860074cc7040e8af7866aa21";
          sha256 = "1gyxikc62ivs0yf6d4kpbj2038pwyziz47v1vn4qxg4phr2rd5h7";
      };
    }
    {
      goPackagePath = "github.com/klauspost/crc32";

      src = fetchgit {
        url = "https://github.com/klauspost/crc32";
        rev = "19b0b332c9e4516a6370a0456e6182c3b5036720";
          sha256 = "0r11v6vaqg49sa8zvxh2y6md4pp0sfh4ia43gsw1arwwlsah39vz";
      };
    }
    {
      goPackagePath = "github.com/lib/pq";

      src = fetchgit {
        url = "https://github.com/lib/pq";
        rev = "69552e54d2a9d4c6a2438926a774930f7bc398ec";
          sha256 = "1y9923j9yl1qqizsy80mzaylg4ysyqp6gyrf85x91x17p2adq2ll";
      };
    }
    ] ++ (lib.optional (sqliteSupport) {
      goPackagePath = "github.com/mattn/go-sqlite3";

      src = fetchgit {
        url = "https://github.com/mattn/go-sqlite3";
        rev = "09d5c451710ef887470709463f4f04ff83e1e039";
          sha256 = "16c8vl9j693gb0q2cqv5ijnxdvfgnpm1sgaicbpd25lbqningcfc";
      };
    }) ++ [
    {
      goPackagePath = "github.com/mcuadros/go-version";

      src = fetchgit {
        url = "https://github.com/mcuadros/go-version";
        rev = "d52711f8d6bea8dc01efafdb68ad95a4e2606630";
          sha256 = "1b4h6557y5aar74bi1xqmpm4zr1kla95x9q49k48w99n3sis3h7m";
      };
    }
    {
      goPackagePath = "github.com/microcosm-cc/bluemonday";

      src = fetchgit {
        url = "https://github.com/microcosm-cc/bluemonday";
        rev = "4ac6f27528d0a3f2a59e0b0a6f6b3ff0bb89fe20";
          sha256 = "0xacnj369mhpff6zykm9rykh7r2i4c6mjfmg5cd1ra4irpskx5sb";
      };
    }
    {
      goPackagePath = "github.com/nfnt/resize";

      src = fetchgit {
        url = "https://github.com/nfnt/resize";
        rev = "4d93a29130b1b6aba503e2aa8b50f516213ea80e";
          sha256 = "1s6z241726nd1xd5rwlnj6l4p0na4v20ibfg5sh9cp7pl98mn5gv";
      };
    }
    {
      goPackagePath = "github.com/russross/blackfriday";

      src = fetchgit {
        url = "https://github.com/russross/blackfriday";
        rev = "006144af03eeeff1037240a71865a9fd61f1c25f";
          sha256 = "1z9zdkxgyk10xngyk55f0433ix6q9kwfrcyljj6xaqjb19wldz7j";
      };
    }
    {
      goPackagePath = "github.com/satori/go.uuid";

      src = fetchgit {
        url = "https://github.com/satori/go.uuid";
        rev = "e673fdd4dea8a7334adbbe7f57b7e4b00bdc5502";
          sha256 = "0nm2dqj87vvv1bmcfl3x9k6kal655yfamxnb7xkfzqkvldigy0qf";
      };
    }
    {
      goPackagePath = "github.com/sergi/go-diff";

      src = fetchgit {
        url = "https://github.com/sergi/go-diff";
        rev = "ec7fdbb58eb3e300c8595ad5ac74a5aa50019cc7";
          sha256 = "049xnl182h5q8fs5z70wb9yh9jvi98h4v3z13xps2rys9xl9rh5x";
      };
    }
    {
      goPackagePath = "github.com/shurcooL/sanitized_anchor_name";

      src = fetchgit {
        url = "https://github.com/shurcooL/sanitized_anchor_name";
        rev = "10ef21a441db47d8b13ebcc5fd2310f636973c77";
          sha256 = "1cnbzcf47cn796rcjpph1s64qrabhkv5dn9sbynsy7m9zdwr5f01";
      };
    }
    {
      goPackagePath = "golang.org/x/crypto";

      src = fetchgit {
        url = "https://go.googlesource.com/crypto";
        rev = "5dc8cb4b8a8eb076cbb5a06bc3b8682c15bdbbd3";
          sha256 = "0b2s9gidpy2r85z0n9w2knh3dkfhjg89z3lyi620vcf1li6qhdl3";
      };
    }
    {
      goPackagePath = "golang.org/x/net";

      src = fetchgit {
        url = "https://go.googlesource.com/net";
        rev = "6acef71eb69611914f7a30939ea9f6e194c78172";
          sha256 = "0vy75lfl2viiikp3k9626g3ncxq6vpnwmhkgyaxdnq14hb4xgw2k";
      };
    }
    {
      goPackagePath = "golang.org/x/text";

      src = fetchgit {
        url = "https://go.googlesource.com/text";
        rev = "a71fd10341b064c10f4a81ceac72bcf70f26ea34";
          sha256 = "1wm63llpn1ix85f47ac3c9jx92i9cfbdw2ih7p8gdq964k7px53c";
      };
    }
    {
      goPackagePath = "gopkg.in/asn1-ber.v1";

      src = fetchgit {
        url = "https://gopkg.in/asn1-ber.v1";
        rev = "4e86f4367175e39f69d9358a5f17b4dda270378d";
          sha256 = "13p8s74kzklb5lklfpxwxb78rknihawv1civ4s9bfqx565010fwk";
      };
    }
    {
      goPackagePath = "gopkg.in/bufio.v1";

      src = fetchgit {
        url = "https://gopkg.in/bufio.v1";
        rev = "567b2bfa514e796916c4747494d6ff5132a1dfce";
          sha256 = "1z5pj778hdianlfj14p0d67g69v4gc2kvn6jg27z5jf75a88l19b";
      };
    }
    {
      goPackagePath = "gopkg.in/gomail.v2";

      src = fetchgit {
        url = "https://gopkg.in/gomail.v2";
        rev = "fbb71ddc63acd07dd0ed49ababdf02c551e2539a";
          sha256 = "1q8xa51bxcmbwsww8s2x42152w1xn553xmmpyq5jz66a2vf1wlvl";
      };
    }
    {
      goPackagePath = "gopkg.in/ini.v1";

      src = fetchgit {
        url = "https://gopkg.in/ini.v1";
        rev = "776aa739ce9373377cd16f526cdf06cb4c89b40f";
          sha256 = "04pmr4mdvpzawpxinwqpas4ksjzq54q5a0qapw0kkb651p06vqhn";
      };
    }
    {
      goPackagePath = "gopkg.in/ldap.v2";

      src = fetchgit {
        url = "https://gopkg.in/ldap.v2";
        rev = "07a7330929b9ee80495c88a4439657d89c7dbd87";
          sha256 = "0qsy0ldvkd0rhh6wfdrm51145ps9sd8nc8qx3fw1f90irb3a71sh";
      };
    }
    {
      goPackagePath = "gopkg.in/macaron.v1";

      src = fetchgit {
        url = "https://gopkg.in/macaron.v1";
        rev = "b9eee382bef2f2f678fadbcf368fc1e52306bed1";
          sha256 = "1rbj1l8742vgar4zchf4r203qvids9vv0iz9a20l5585xz21cmsj";
      };
    }
    {
      goPackagePath = "gopkg.in/redis.v2";

      src = fetchgit {
        url = "https://gopkg.in/redis.v2";
        rev = "e6179049628164864e6e84e973cfb56335748dea";
          sha256 = "02hifpgak39y39lbn7v2ybbpk3rmb8nvmb3h3490frr8s4pfkb8h";
      };
    }
  ];
}
