pkgname="vkbasalt"
repology=("project: vkbasalt")
pkgver="0.3.2.10"
source=("https://github.com/DadSchoorse/vkBasalt/releases/download/v${pkgver}/vkBasalt-${pkgver}.tar.gz")
url="https://github.com/DadSchoorse/vkBasalt"
makedepends=(
  "gcc" "g++"
  "meson"                # High-productivity build system
  "pkg-config"           # Manage compile and link flags for libraries
  "glslang-tools"        # OpenGL and OpenGL ES shader front end and validator -- tools
  "libx11-dev"           # X11 client-side library (development headers)
  "libvulkan-dev"        # Vulkan loader library -- development files
  "spirv-headers"        # Machine-readable files for the SPIR-V Registry
)
pkgdesc="vkBasalt is a Vulkan post processing layer to enhance the visual graphics of games."
optdepends=("reshade-shaders: Required for advanced post-processing effects")
sha256sums=("eb196ff446fa36ec0ca99c4406d753c1fa210afddeec5e7a76e1c2e74ed605e3")
maintainer=("andy <tsa.andy@live.de>")
external_connection=false

prepare() {
  cd "vkBasalt-${pkgver}"

  # Modify the configuration file paths for ReShade shaders and textures
  sed -i 's|/path/to/reshade-shaders/Textures|/opt/reshade/textures|g' \
    "config/vkBasalt.conf"
  sed -i 's|/path/to/reshade-shaders/Shaders|/opt/reshade/shaders|g' \
    "config/vkBasalt.conf"
}

build() {
  cd "vkBasalt-${pkgver}"
  meson build --buildtype=release --prefix="/usr"
  ninja -C build -j"${NCPU}"
}

package() {
  cd "vkBasalt-${pkgver}"

  DESTDIR="${pkgdir}" ninja -C build install
  install -Dm 644 config/vkBasalt.conf "${pkgdir}/usr/share/vkBasalt/vkBasalt.conf.example"
  install -Dm 644 LICENSE -t "${pkgdir}/usr/share/licenses/${pkgname}"
}
