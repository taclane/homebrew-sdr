class Libacars < Formula
  desc "Library for decoding ACARS message contents"
  homepage "https://github.com/szpajder/libacars"
  url "https://github.com/szpajder/libacars/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "495e9836c8a1033a5d7814e68ebfc3b0d8f7db1747d13310e7df47c561aee9ce"
  license "MIT"

  head do
    url "https://github.com/szpajder/libacars.git", branch: "master"
  end

  depends_on "cmake" => :build
  depends_on "zlib"
  depends_on "libxml2"
  depends_on "jansson"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
