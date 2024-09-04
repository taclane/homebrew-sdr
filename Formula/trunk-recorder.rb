class TrunkRecorder < Formula
  desc "Trunked & Conventional Radio Recorder"
  homepage "https://github.com/robotastic/trunk-recorder"
  license "GPL-3.0-or-later"

  stable do
    url "https://github.com/robotastic/trunk-recorder/archive/refs/tags/v5.0.0.tar.gz"
    sha256 "a9c328e94f46be89525071a361753dcbf8b1309bf0f8ab186df8769082a9804f"
  end
  
  head do
    url "https://github.com/robotastic/trunk-recorder.git", branch: "master"
  end

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
    (testpath/"test.json").write <<~EOS
      {
        "ver": 1,
        "logFile": true,
        "logdir": "."
      }
    EOS

    system "trunk-recorder", "--config", "test.json"
    assert_equal "456", shell_output("find ./logs -name '*.log' -type f -exec awk 1 {} + | wc -m")
  end

end
