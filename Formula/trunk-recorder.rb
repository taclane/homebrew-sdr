class TrunkRecorder < Formula
  desc "Trunked & Conventional Radio Recorder"
  homepage "https://github.com/robotastic/trunk-recorder"
  url "https://github.com/trunkrecorder/trunk-recorder/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "1c9a8a625506c5b5cc14948404e70b86333ea9cd08c0cfef117f611497d5b2be"
  license "GPL-3.0-or-later"
  head "https://github.com/robotastic/trunk-recorder.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "cppunit" => :build
  depends_on "pkgconfig" => :build
  depends_on "pybind11" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "fdk-aac-encoder"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "gnuradio"
  depends_on "taclane/sdr/gr-osmosdr"
  depends_on "openssl@3"
  depends_on "sox"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"

  def install
    system "cmake", *std_cmake_args, "-B", "build"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    # Start trunk recorder with a test configuration file, and gracefully exit after a few seconds.
    # Doing so should not generate any errors.
    (testpath/"test.json").write <<~EOS
      {
        "ver": 2,
        "logLevel": "error",
        "instanceId": "**** TR TEST ****",
        "callTimeout": 11,
        "controlWarnRate": 22,
        "controlRetuneLimit": 33,
        "frequencyFormat": "hz"
      }
    EOS

    system "timeout", "-sINT", "--preserve-status", "2s",
      "trunk-recorder", "-c", testpath/"test.json"
  end
end
