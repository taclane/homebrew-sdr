class Acarsdec < Formula
  desc "Multi-channels ACARS decoder"
  # homepage "https://github.com/TLeconte/acarsdec"
  homepage "https://github.com/fredclausen/acarsdec"
  url "https://github.com/f00b4r0/acarsdec/archive/refs/tags/v4.1.tar.gz"
  sha256 "79c4c739461c0443372a6c651f49f4b3a9306e4a364cd633ba9e733dcc409460"
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
      -B build
      -DCMAKE_C_FLAGS=-march=native
    ]
    system "cmake", *std_cmake_args, *args
    system "cmake", "--build", "build", "--target", "install"
  end
end
