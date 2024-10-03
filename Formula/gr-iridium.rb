class GrIridium < Formula
  desc "GNU Radio Iridium Out Of Tree Module"
  homepage "https://github.com/muccc/gr-iridium"
  url "https://github.com/muccc/gr-iridium/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "933f5fd18705ddd452547304b404cc36abe4acc1ad7d5c016ad16c0dd2254d86"
  license "GPL-3.0-or-later"
  head "https://github.com/muccc/gr-iridium.git", branch: "master"

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
