{ fetchurl, stdenv, pkgconfig, intltool, perl, perlXMLParser, libxml2
, glib, gtk3, pango, atk, gdk_pixbuf, shared_mime_info, itstool, gnome3
, poppler, ghostscriptX, djvulibre, libspectre, libsecret , wrapGAppsHook
, librsvg, gobjectIntrospection
, recentListSize ? null # 5 is not enough, allow passing a different number
, supportXPS ? false    # Open XML Paper Specification via libgxps
, fetchpatch, autoreconfHook
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  patches = [
    (fetchpatch {
      name = "CVE-2017-1000083"; # https://bugzilla.gnome.org/show_bug.cgi?id=784630
      url = "https://git.gnome.org/browse/evince/patch/?id=fa072dbbfd96";
      sha256 = "12xg00jvbsh54dr2dyq2ha5a05x2bpzd1lh2k3sppq3h7a02lsjy";
    })
  ];
  # missing help for now; fixing the autogen phase seemed too difficult
  postPatch = "sed '/@YELP_HELP_RULES@/d' -i help/Makefile.am";

  nativeBuildInputs = [ pkgconfig wrapGAppsHook autoreconfHook/*for patches*/ ];

  buildInputs = [
    intltool perl perlXMLParser libxml2
    glib gtk3 pango atk gdk_pixbuf gobjectIntrospection
    itstool gnome3.adwaita-icon-theme
    gnome3.libgnome_keyring gnome3.gsettings_desktop_schemas
    poppler ghostscriptX djvulibre libspectre
    libsecret librsvg gnome3.adwaita-icon-theme gnome3.dconf
  ] ++ stdenv.lib.optional supportXPS gnome3.libgxps;

  configureFlags = [
    "--disable-nautilus" # Do not use nautilus
    "--enable-introspection"
    (if supportXPS then "--enable-xps" else "--disable-xps")
  ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  preConfigure = with stdenv.lib;
    optionalString doCheck ''
      for file in test/*.py; do
        echo "patching $file"
        sed '1s,/usr,${python},' -i "$file"
      done
    '' + optionalString (recentListSize != null) ''
      sed -i 's/\(gtk_recent_chooser_set_limit .*\)5)/\1${builtins.toString recentListSize})/' shell/ev-open-recent-action.c
      sed -i 's/\(if (++n_items == \)5\(.*\)/\1${builtins.toString recentListSize}\2/' shell/ev-window.c
    '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared_mime_info}/share")
  '';

  enableParallelBuilding = true;

  doCheck = false; # would need pythonPackages.dogTail, which is missing

  meta = with stdenv.lib; {
    homepage = http://www.gnome.org/projects/evince/;
    description = "GNOME's document viewer";

    longDescription = ''
      Evince is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, TIFF and DVI.  The goal
      of Evince is to replace the multiple document viewers that exist
      on the GNOME Desktop with a single simple application.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
  };
}
