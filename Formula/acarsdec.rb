class Acarsdec < Formula
  desc "Multi-channels ACARS decoder"
  # homepage "https://github.com/TLeconte/acarsdec"
  homepage "https://github.com/fredclausen/acarsdec"
  url "https://github.com/TLeconte/acarsdec/archive/refs/tags/acarsdec-3.7.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "GPL-2.0"

  # head "https://github.com/TLeconte/acarsdec.git", branch: "master"
  head "https://github.com/fredclausen/acarsdec.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "cjson"
  depends_on "libacars"
  depends_on "librtlsdr"
  depends_on "libsndfile"
  depends_on "libusb"
  depends_on "paho-mqtt-c"
  depends_on "soapyrtlsdr"
  depends_on "soapysdr"

  def install
    args = %w[
      -Bbuild
      -DCMAKE_C_FLAGS=-march=native
    ]
    system "cmake", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
