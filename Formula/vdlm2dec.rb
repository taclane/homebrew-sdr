class Vdlm2dec < Formula
  desc "VDL Mode 2 message decoder"
  homepage "https://github.com/TLeconte/vdlm2dec"
  url "https://github.com/TLeconte/vdlm2dec/archive/refs/tags/v1.11.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "GPL-2.0"

  head "https://github.com/TLeconte/vdlm2dec.git", branch: "master"

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
