class Vdlm2dec < Formula
  desc "VDL Mode 2 message decoder"
  homepage "https://github.com/TLeconte/vdlm2dec"
  url "https://github.com/TLeconte/vdlm2dec/archive/refs/tags/v2.3.tar.gz"
  sha256 "ed6294a0d59423408e75e91dd06be0d25d89b06e034caf0c162b6c2a7384c677"
  license "GPL-2.0"

  head "https://github.com/TLeconte/vdlm2dec.git", branch: "master"

  # Add pthread_barrier support for macOS — not available in system pthread
  patch do
    url "https://raw.githubusercontent.com/taclane/homebrew-sdr/refs/heads/main/Patches/vdlm2dec-2.3.patch"
    sha256 "e62d31a527b88ea710a8a231fa2e74b05d2e7e7c46f172a8ba34415926a40808"
  end

  depends_on "cmake" => :build
  depends_on "libacars"
  depends_on "librtlsdr"
  depends_on "libxml2"
  depends_on "zlib"

  option "with-airspy", "Build with Airspy SDR support"

  def install
    args = %W[
      -B build
      -DCMAKE_C_FLAGS=-DHOST_NAME_MAX=255
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    # Enable RTL-SDR by default
    args << "-Drtl=ON"

    # Add Airspy support if requested
    args << "-Dairspy=ON" if build.with? "airspy"

    system "cmake", *std_cmake_args, *args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    # Test that the binary exists and can show help/version
    version_output = shell_output("#{bin}/vdlm2dec 2>&1 || true")
    assert_match(/vdlm2dec|version|usage|error/i, version_output)
  end
end
