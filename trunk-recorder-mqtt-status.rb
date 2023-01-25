class TrunkRecorderMqttStatus < Formula
  desc "MQTT Status Plugin for trunk-recorder"
  homepage "https://github.com/robotastic/trunk-recorder-mqtt-status"
  license "GPL-3.0-or-later"

  # Head only formula
  head "https://github.com/robotastic/trunk-recorder-mqtt-status.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "gnuradio"
  depends_on "gr-osmosdr"
  depends_on "openssl@1.1"
  depends_on "spdlog"
  depends_on "trunk-recorder"
  depends_on "uhd"
  depends_on "volk"

  # 25 JAN 2023 *** Patch to include gnuradio::gnuradio-network and homebrew dirs
  patch :DATA

  def install
    args = %W[
      -Bbuild
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DTRUNK_LIBRARY_DIR=#{Formula["trunk-recorder"].lib}/trunk-recorder
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]
    system "cmake", *args
    system "make", "-C", "build", "install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index ded581a..d5fa541 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -66,8 +66,8 @@ include(FindPkgConfig)
 find_package(Gnuradio REQUIRED)
 include(GrVersion)
 
-set(GR_REQUIRED_COMPONENTS RUNTIME ANALOG BLOCKS DIGITAL FILTER FFT PMT)
-find_package(Gnuradio REQUIRED COMPONENTS runtime analog blocks digital filter fft)
+set(GR_REQUIRED_COMPONENTS RUNTIME ANALOG BLOCKS DIGITAL FILTER FFT PMT NETWORK)
+find_package(Gnuradio REQUIRED COMPONENTS runtime analog blocks digital filter fft network)
 if(Gnuradio_VERSION VERSION_LESS "3.8")
     find_package(Volk)
 endif()
@@ -201,6 +201,7 @@ link_directories(
     ${Boost_LIBRARY_DIRS}
     ${OPENSSL_ROOT_DIR}/lib
     ${CMAKE_INSTALL_PREFIX}/lib/trunk-recorder
+    ${TRUNK_LIBRARY_DIR}
 )
 
 set(CMAKE_CXX_FLAGS_DEBUG "-Wall -Wno-unused-local-typedef -Wno-deprecated-declarations -Wno-error=deprecated-declarations -g3")
@@ -241,6 +242,7 @@ if(NOT Gnuradio_VERSION VERSION_LESS "3.8")
     gnuradio::gnuradio-digital
     gnuradio::gnuradio-filter
     gnuradio::gnuradio-pmt
+    gnuradio::gnuradio-network
     ) 
 
 endif()
 