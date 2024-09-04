class TrunkRecorder < Formula
  desc "Trunked & Conventional Radio Recorder"
  homepage "https://github.com/robotastic/trunk-recorder"
  license "GPL-3.0-or-later"
  url "https://github.com/robotastic/trunk-recorder/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "a9c328e94f46be89525071a361753dcbf8b1309bf0f8ab186df8769082a9804f"
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
  depends_on "gr-osmosdr"
  depends_on "openssl@3"
  depends_on "sox"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"

  def install
    args = %W[
      -Bbuild
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]
      system "cmake", *std_cmake_args, *args
      system "make", "-C", "build", "install"
  end

  test do
	# Start Trunk Trecorder with an empty config and interrupt after a
	# short timeout if no fatal errors encountered running/ending the flowgraph
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
