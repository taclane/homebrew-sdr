class Acarsdec < Formula
  desc "Multi-channels ACARS decoder"
  # homepage "https://github.com/TLeconte/acarsdec"
  homepage "https://github.com/f00b4r0/acarsdec"
  url "https://github.com/f00b4r0/acarsdec/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "39a27ea9dd491fe23ca7dba66b69504e2e0251f6ebbb51c392b7a076f53f0250"
  license "GPL-2.0"

  # head "https://github.com/TLeconte/acarsdec.git", branch: "master"
  head "https://github.com/f00b4r0/acarsdec.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "cjson"
  depends_on "taclane/sdr/libacars"
  depends_on "librtlsdr"
  depends_on "libsndfile"
  depends_on "libusb"
  depends_on "taclane/sdr/paho-mqtt-c"
  depends_on "soapyrtlsdr"
  depends_on "soapysdr"

  def install
    args = %w[
      -B build
      -DCMAKE_C_FLAGS=-march=native
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", *std_cmake_args, *args
    system "cmake", "--build", "build", "--target", "install"
  end
end
