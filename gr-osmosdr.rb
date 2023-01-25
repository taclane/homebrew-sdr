class GrOsmosdr < Formula
  include Language::Python::Virtualenv

  desc "Osmocom GNU Radio Blocks"
  homepage "https://osmocom.org/projects/sdr/wiki/GrOsmoSDR"
  url "https://github.com/osmocom/gr-osmosdr/archive/v0.2.4.tar.gz"
  sha256 "28b6f2768aee7b397b227e9e70822e28de3b4c5362a5d14646a0948a48094a63"
  license "GPL-3.0-or-later"
  head url "https://github.com/osmocom/gr-osmosdr.git", branch: "master"

  # brew audit --strict --online gr-osmosdr
  # * Libraries were compiled with a flat namespace.

  # Does not pass audit due to SoapySDR:
  # /usr/local/share/cmake/SoapySDR/SoapySDRExport.cmake(61):
  #   set_target_properties( ... INTERFACE_LINK_LIBRARIES -pthread;-pthread;-flat_namespace )

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "airspy"
  depends_on "boost"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "gnuradio"
  depends_on "hackrf"
  depends_on "librtlsdr"
  depends_on "soapyrtlsdr"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/50/d5/34b30f650e889d0d48e6ea9337f7dcd6045c828b9abaac71da26b6bdc543/Cheetah3-3.2.5.tar.gz"
    sha256 "ececc9ca7c58b9a86ce71eb95594c4619949e2a058d2a1af74c7ae8222515eb1"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/72/89/402d2b4589e120ca76a6aed8fee906a0f5ae204b50e455edd36eda6e778d/Mako-1.1.3.tar.gz"
    sha256 "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  # Remove the remaining "register" to allow hackrf support in Apple clang 14 / Xcode 14.2
  # hackrf_sink_c.cc:302:9: error: ISO C++17 does not allow 'register' storage class specifier [-Wregister]
  patch :DATA

  def install
    venv_root = libexec/"venv"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{venv_root}/lib/python#{xy}/site-packages"
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resources

    system "cmake", ".", *std_cmake_args, "-DPYTHON_EXECUTABLE=#{venv_root}/bin/python"
    system "make", "install"

    # Leave a pointer to our Python module directory where GNU Radio can find it
    plugin_path = etc/"gnuradio/plugins.d/gr-osmosdr.pth"
    plugin_path.delete if plugin_path.exist? || plugin_path.symlink?
    plugin_path.write "#{venv_root}/lib/python#{xy}/site-packages\n"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <osmosdr/device.h>
      int main() {
        osmosdr::device_t device;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgnuradio-osmosdr", "-o", "test"
    system "./test"

    # Make sure GNU Radio's Python can find our module
    (testpath/"testimport.py").write "import osmosdr\n"
    system Formula["gnuradio"].libexec/"venv/bin/python", testpath/"testimport.py"
  end
end

__END__
diff --git a/lib/hackrf/hackrf_sink_c.cc b/lib/hackrf/hackrf_sink_c.cc
index 1762934..54ff3ef 100644
--- a/lib/hackrf/hackrf_sink_c.cc
+++ b/lib/hackrf/hackrf_sink_c.cc
@@ -299,7 +299,7 @@ void convert_avx(const float* inbuf, int8_t* outbuf,const unsigned int count)
 #elif USE_SSE2
 void convert_sse2(const float* inbuf, int8_t* outbuf,const unsigned int count)
 {
-  const register __m128 mulme = _mm_set_ps( 127.0f, 127.0f, 127.0f, 127.0f );
+  const __m128 mulme = _mm_set_ps( 127.0f, 127.0f, 127.0f, 127.0f );
   __m128 itmp1,itmp2,itmp3,itmp4;
   __m128i otmp1,otmp2,otmp3,otmp4;
 