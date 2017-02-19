{ stdenv, fetchgit, fetchFromGitHub, cmake, pkgconfig, git, python3,
  python3Packages, glslang, spirv-tools, x11, libxcb, libXrandr,
  libXext, wayland }:

let
  version = "1.0.39.1";
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-LoaderAndValidationLayers";
    rev = "sdk-${version}";
    sha256 = "0y9zzrnjjjza2kkf5jfsdqhn98md6rsq0hb7jg62z2dipzky7zdp";
  };
in

stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  inherit version src;

  buildInputs = [ cmake pkgconfig git python3 python3Packages.lxml
                  glslang spirv-tools x11 libxcb libXrandr libXext wayland
                ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBUILD_WSI_MIR_SUPPORT=OFF"
  ];

  patches = [ ./use-xdg-paths.patch ];

  outputs = [ "out" "dev" "demos" ];

  preConfigure = ''
    checkRev() {
      [ "$2" = $(cat "external_revisions/$1_revision") ] || (echo "ERROR: dependency $1 is revision $2 but should be revision" $(cat "external_revisions/$1_revision") && exit 1)
    }
    checkRev spirv-tools "${spirv-tools.src.rev}"
    checkRev spirv-headers "${spirv-tools.headers.rev}"
    checkRev glslang "${glslang.src.rev}"
  '';

  installPhase = ''
    mkdir -p $out/lib $out/bin
    cp -d loader/libvulkan.so* $out/lib
    cp demos/vulkaninfo $out/bin
    mkdir -p $out/lib $out/share/vulkan/explicit_layer.d
    cp -d layers/*.so $out/lib/
    cp -d layers/*.json $out/share/vulkan/explicit_layer.d/
    sed -i "s:\\./lib:$out/lib/lib:g" "$out/share/vulkan/"*/*.json
    mkdir -p $dev/include
    cp -rv ../include $dev/
    mkdir -p $demos/bin
    cp demos/*.spv demos/*.ppm $demos/bin
    find demos -type f -executable -not -name vulkaninfo -exec cp {} $demos/bin \;
   '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = "http://www.lunarg.com";
    platforms   = platforms.linux;
    license     = licenses.asl20;
  };
}
