class TrunkRecorder < Formula

   desc "Trunk-Recorder"
   homepage "https://github.com/robotastic/trunk-recorder"
   url "https://github.com/robotastic/trunk-recorder/archive/refs/tags/v4.5.0.zip"
   sha256 "eaf305895e4b58349ab809f9b8827ea37256bfd08dc5fe7447e9b5f6b3e777d0"
   license "GPL-3.0"

   head do
     url "https://github.com/robotastic/trunk-recorder.git"
   end

   depends_on "cmake" => :build
   depends_on "gnuradio"
   depends_on "gr-osmosdr"
   depends_on "uhd"
   depends_on "pkgconfig"
   depends_on "cppunit"
   depends_on "openssl"
   depends_on "fdk-aac-encoder"
   depends_on "sox"
   depends_on "pybind11"
   
   
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
 