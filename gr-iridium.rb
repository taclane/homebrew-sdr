class GrIridium < Formula
  desc "GNU Radio Iridium Out Of Tree Module"
  homepage "https://github.com/muccc/gr-iridium"
  url "https://github.com/muccc/gr-iridium/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "28b6f2768aee7b397b227e9e70822e28de3b4c5362a5d14646a0948a48094a63"
  license "GPL-3.0-or-later"

  head do
    url "https://github.com/muccc/gr-iridium.git", branch: "master"
  end

  # brew audit --strict --online gr-osmosdr
  # * Libraries were compiled with a flat namespace.

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "gnuradio"
  depends_on "gr-osmosdr"
  depends_on "hackrf"
  depends_on "librtlsdr"
  depends_on "scipy"
  depends_on "volk"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
