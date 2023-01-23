class GrOsmosdr < Formula
   include Language::Python::Virtualenv

   desc "Osmocom GNU Radio Blocks"
   homepage "https://osmocom.org/projects/sdr/wiki/GrOsmoSDR"
   url "https://github.com/osmocom/gr-osmosdr/archive/v0.2.4.tar.gz"
   sha256 "28b6f2768aee7b397b227e9e70822e28de3b4c5362a5d14646a0948a48094a63"
   license "GPL-3.0-or-later"

   #bottle do
   #  sha256 big_sur:  "54c41d6a6ad6ff508d1a9fb3fcebf1d245ecd50eded905b9ca51f26fb6f4d01a"
   #  sha256 catalina: "781bf31b9c0ef7764dad1509148fadade96b1c8c43042951bf3e0b3ade05ae3e"
   #  sha256 mojave:   "1316ec1150647972436f96a9d957b5c5b7889f6f962217b181e6185a939aa2e2"
   #end

   head do
     url "https://github.com/osmocom/gr-osmosdr.git"
     depends_on "pybind11" => :build
   end
   
   # gr-osmosdr does not build with gnuradio 3.9+
   # disable! date: "2021-01-17", because: :does_not_build

   depends_on "cmake" => :build
   depends_on "airspy"
   depends_on "boost"
   depends_on "gnuradio"
   depends_on "librtlsdr"
   depends_on "uhd"
   depends_on "hackrf"
   depends_on "pybind11"

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

   patch :DATA

   def install
     venv_root = libexec/"venv"
     xy = Language::Python.major_minor_version "python3"
     ENV.prepend_create_path "PYTHONPATH", "#{venv_root}/lib/python#{xy}/site-packages"
     venv = virtualenv_create(venv_root, "python3")

     venv.pip_install resources


# 	 patch :p0, :DATA
	
     system "cmake", ".", *std_cmake_args, "-DPYTHON_EXECUTABLE=#{venv_root}/bin/python"
     system "make", "install"

     # Leave a pointer to our Python module directory where GNU Radio can find it
     site_packages = "#{venv_root}/lib/python#{xy}/site-packages"
     plugin_path = etc/"gnuradio/plugins.d/gr-osmosdr.pth"
     
     plugin_path.delete if plugin_path.exist? || plugin_path.symlink? 
   
     (plugin_path).write "#{site_packages}\n"
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
 