class IridiumSniffer < Formula
  desc "Standalone Iridium satellite burst detector and demodulator"
  homepage "https://github.com/alphafox02/iridium-sniffer"
  license "GPL-3.0-or-later"
  head "https://github.com/alphafox02/iridium-sniffer.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "hackrf"
  depends_on "libbladerf"
  depends_on "uhd"
  depends_on "soapysdr"
  depends_on "zmq"
  depends_on "taclane/sdr/libacars"

  patch :DATA

  def install
    args = %w[
      -B build
      -DUSE_OPENCL=OFF
      -DUSE_VULKAN=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", *std_cmake_args, *args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/iridium-sniffer --help 2>&1", 1)
  end
end

__END__
diff --git a/burst_detect.c b/burst_detect.c
--- a/burst_detect.c
+++ b/burst_detect.c
@@ -1,3 +1,4 @@
+#include <unistd.h>
 #include <stdlib.h>