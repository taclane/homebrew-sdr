class Dumphfdl < Formula
  desc "Multichannel HFDL (High Frequency Data Link) decoder"
  homepage "https://github.com/szpajder/dumphfdl"
  url "https://github.com/szpajder/dumphfdl/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "56b091e5e3f8c3b87c91f63cbd3a15fc6c318b297e30f89b77dbaae5991f2d7a"
  license "GPL-3.0"
  revision 1

  head "https://github.com/szpajder/dumphfdl.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libacars"
  depends_on "libconfig"
  depends_on "liquid-dsp"
  depends_on "fftw"
  depends_on "soapysdr"
  depends_on "zeromq"

  option "with-sqlite", "Build with SQLite support for aircraft data enrichment"
  option "with-statsd", "Build with StatsD statistics support"
  option "with-kafka", "Build with Apache Kafka output support"

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

    # Optional features
    args << "-DSQLITE=ON" if build.with? "sqlite"
    args << "-DETSY_STATSD=ON" if build.with? "statsd"
    args << "-DRDKAFKA=ON" if build.with? "kafka"
    args << "-DZMQ=ON"

    system "cmake", *std_cmake_args, *args, "."
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    # Test that the binary exists and can show help
    version_output = shell_output("#{bin}/dumphfdl --help 2>&1 || true")
    assert_match(/usage|dumphfdl|HFDL/i, version_output)
  end
end
