class Libacars < Formula
  desc "Library for decoding ACARS message contents"
  homepage "https://github.com/szpajder/libacars"
  url "https://github.com/szpajder/libacars/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"
  head "https://github.com/szpajder/libacars.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libxml2"
  depends_on "zlib"

  def install
    args = %W[
      -B build
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", *std_cmake_args, *args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    # Test decode a sample ACARS message
    adsc_test = "d B6 /BOMASAI.ADS.VT-ANB072501A070A988CA73248F0E5DC10200000F5EE1ABC000102B885E0A19F5"
    adsc_result = "Temperature: -62.75 C"
    system "#{bin}/decode_acars_apps #{adsc_test} | grep -q \"#{adsc_result}\""
  end
end
