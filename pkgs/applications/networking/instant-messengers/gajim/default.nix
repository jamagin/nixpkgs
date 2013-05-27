{ stdenv, fetchurl, python, intltool, pkgconfig, libX11, gtk
, ldns, pyopenssl, pythonDBus, pythonPackages

, enableJingle ? true, farstream ? null, gst_plugins_bad ? null
,                      libnice ? null
, enableE2E ? true
, enableRST ? true
, enableSpelling ? true, gtkspell ? null
}:

assert enableJingle -> farstream != null && gst_plugins_bad != null
                    && libnice != null;
assert enableE2E -> pythonPackages.pycrypto != null;
assert enableRST -> pythonPackages.docutils != null;
assert enableSpelling -> gtkspell != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gajim-${version}";
  version = "0.15.4";

  src = fetchurl {
    url = "http://www.gajim.org/downloads/0.15/gajim-${version}.tar.gz";
    sha256 = "1g4m5j777vqqdwqvr2m6l09ljjx65ilag45d5kfc78z7frm0cz7g";
  };

  patches = [
    (fetchurl {
      name = "gajim-drill-srv.patch";
      url = "https://projects.archlinux.org/svntogit/packages.git/"
          + "plain/trunk/gajim-drill.patch?h=packages/gajim";
      sha256 = "1k8zz3ns0l0kriffq41jgkv5ym6jvyd24171l7s98v9d81prdw1w";
    })
    (fetchurl {
      name = "gajim-icon-index.patch";
      url = "http://hg.gajim.org/gajim/raw-rev/b9ec78663dfb";
      sha256 = "0w54hr5dq9y36val55kmh8d6cid7h4fs2nghx09714jylz2nyxxv";
    })
  ];

  postPatch = ''
    sed -i -e '0,/^[^#]/ {
      /^[^#]/i export \\\
        PYTHONPATH="'"$PYTHONPATH\''${PYTHONPATH:+:}\$PYTHONPATH"'" \\\
        GST_PLUGIN_PATH="'"\$GST_PLUGIN_PATH''${GST_PLUGIN_PATH:+:}${""
        }$GST_PLUGIN_PATH"'"
    }' scripts/gajim.in

    sed -i -e 's/return helpers.is_in_path('"'"'drill.*/return True/' \
      src/features_window.py
    sed -i -e "s|'drill'|'${ldns}/bin/drill'|" src/common/resolver.py
  '' + optionalString enableSpelling ''
    sed -i -e 's|=.*find_lib.*|= "${gtkspell}/lib/libgtkspell.so"|'   \
      src/gtkspell.py
  '';

  buildInputs = [
    python intltool pkgconfig libX11
    pythonPackages.pygobject pythonPackages.pyGtkGlade
    pythonPackages.sqlite3 pythonPackages.pyasn1
    pythonPackages.pyxdg
    pyopenssl pythonDBus
  ] ++ optionals enableJingle [ farstream gst_plugins_bad libnice ]
    ++ optional enableE2E pythonPackages.pycrypto
    ++ optional enableRST pythonPackages.docutils;

  postInstall = ''
    install -m 644 -t "$out/share/gajim/icons/hicolor" \
                      "icons/hicolor/index.theme"
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://gajim.org/";
    description = "Jabber client written in PyGTK";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raskin maintainers.aszlig ];
  };
}
