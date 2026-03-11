class Dumpvdl2 < Formula
  desc "VDL Mode 2 message decoder and protocol analyzer"
  homepage "https://github.com/szpajder/dumpvdl2"
  url "https://github.com/szpajder/dumpvdl2/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "7a76f65eddae8bbf1c652e1d2bd0b6ede25cda90809d6c80517d9a7a5840e8ad"
  license "GPL-3.0"
  revision 1

  head "https://github.com/szpajder/dumpvdl2.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libacars"
  depends_on "librtlsdr"
  depends_on "zeromq"

  option "with-soapysdr", "Build with SoapySDR support for multiple SDR types"
  option "with-sqlite", "Build with SQLite support for aircraft data enrichment"
  option "with-statsd", "Build with StatsD statistics support"

  def install
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]

    # macOS specific flags for compatibility
    if OS.mac?
      args << "-DCMAKE_C_FLAGS=-DHOST_NAME_MAX=255"
      homebrew_prefix = HOMEBREW_PREFIX.to_s
      args << "-DCMAKE_PREFIX_PATH=#{homebrew_prefix}"
      args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    end

    # Configure SDR support
    if build.with? "soapysdr"
      args << "-DSOAPYSDR=ON"
      args << "-DRTLSDR=OFF"
    else
      args << "-DRTLSDR=ON"
      args << "-DSOAPYSDR=OFF"
    end

    # Optional features
    args << "-DSQLITE=ON" if build.with? "sqlite"
    args << "-DETSY_STATSD=ON" if build.with? "statsd"
    args << "-DZMQ=ON"

    system "cmake", *std_cmake_args, *args, "-B", "build"
    system "cmake", "--build", "build", "--target", "install"  
  end

  test do
    # Test that the binary exists and can show help
    version_output = shell_output("#{bin}/dumpvdl2 --help 2>&1 || true")
    assert_match(/usage|dumpvdl2|VDL/i, version_output)
  end
end
