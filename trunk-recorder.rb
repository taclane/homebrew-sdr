class TrunkRecorder < Formula
  desc "Trunked & Conventional Radio Recorder"
  homepage "https://github.com/robotastic/trunk-recorder"
  url "https://github.com/robotastic/trunk-recorder/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "7850cb9c0d91a153b6371c80124e081482e74ad4bd49b8e7b0ae2fc52ced5c6e"
  license "GPL-3.0-or-later"
  head url "https://github.com/robotastic/trunk-recorder.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkgconfig" => :build
  depends_on "pybind11" => :build
  depends_on "boost"
  depends_on "cppunit"
  depends_on "curl"
  depends_on "fdk-aac-encoder"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "gnuradio"
  depends_on "gr-osmosdr"
  depends_on "openssl"
  depends_on "sox"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"

  # 23 JAN 2023 *** Temporary patch to build on apple clang 14 / Xcode 14.2
  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-D OPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
      system "make", "install"
    end
  end
end

__END__
diff --git a/lib/op25_repeater/lib/frame_assembler_impl.h b/lib/op25_repeater/lib/frame_assembler_impl.h
index 1f508d2..ede8634 100644
--- a/lib/op25_repeater/lib/frame_assembler_impl.h
+++ b/lib/op25_repeater/lib/frame_assembler_impl.h
@@ -29,6 +29,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <deque>
+#include <array>
 
 #include "rx_base.h"
 