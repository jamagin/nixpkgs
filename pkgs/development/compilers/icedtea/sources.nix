# This file is autogenerated from update.py in the same directory.
{
  icedtea7 = rec {
    branch = "2.5";
    version = "${branch}.3";

    url = "http://icedtea.wildebeest.org/download/source/icedtea-${version}.tar.xz";
    sha256 = "1w7i6j4wmg2ixv7d24mad6gphspnkb9w30azjdp4jqn2zqn95wpl";

    hg_url = "http://icedtea.classpath.org/hg/release/icedtea7-forest-${branch}";

    bundles = {
      openjdk = rec {
        url = "http://icedtea.wildebeest.org/download/drops/icedtea7/2.5.3/openjdk.tar.bz2";
        sha256 = "3ba1a30762f5d5890e8ee6af11f52213ab9c574c01f07c75a081c42034f5d5c9";
      };

      corba = rec {
        url = "http://icedtea.wildebeest.org/download/drops/icedtea7/2.5.3/corba.tar.bz2";
        sha256 = "8ceb2cd60782b7fc14b88e3d366f273873fa5436cf0e36b86406c0905b7dc43c";
      };

      jaxp = rec {
        url = "http://icedtea.wildebeest.org/download/drops/icedtea7/2.5.3/jaxp.tar.bz2";
        sha256 = "2d13a82078f3f2b8831d1e670e5e75719336a56490df64f16ab7647674a272ef";
      };

      jaxws = rec {
        url = "http://icedtea.wildebeest.org/download/drops/icedtea7/2.5.3/jaxws.tar.bz2";
        sha256 = "5a63d85307203f1aed1e31459ad5e32687909e0640d424ff6f540d9b1cceeb1e";
      };

      jdk = rec {
        url = "http://icedtea.wildebeest.org/download/drops/icedtea7/2.5.3/jdk.tar.bz2";
        sha256 = "40c4dda969be0ecd213e79269184e19cfc32100b83777dc529b3cf4b6aa3e12f";
      };

      langtools = rec {
        url = "http://icedtea.wildebeest.org/download/drops/icedtea7/2.5.3/langtools.tar.bz2";
        sha256 = "516f6c21719f4b5a2092847c147cde7890c5a30d4aed9425ff667c0164ef1dd0";
      };

      hotspot = rec {
        url = "http://icedtea.wildebeest.org/download/drops/icedtea7/2.5.3/hotspot.tar.bz2";
        sha256 = "8c8e1f7e97f47fe4029e0b0ba42b3515474adabe64e1fbee15c0e2e22a13aa28";
      };
    };
  };
}
