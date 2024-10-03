class PahoMqttCpp < Formula
  desc "Eclipse Paho C++ Client Library for the MQTT Protocol"
  homepage "https://github.com/eclipse/paho.mqtt.cpp"
  url "https://github.com/eclipse/paho.mqtt.cpp/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "48e7ba6e1032aa73e4d985a7387e02a77cc5807a8420d16790b84b941d86374e"
  license "EPL-2.0"
  head "https://github.com/eclipse/paho.mqtt.cpp.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    args = %W[
      -Bbuild
      -H.
      -DPAHO_ENABLE_TESTING=OFF
      -DPAHO_BUILD_STATIC=ON
      -DPAHO_WITH_SSL=ON
      -DPAHO_HIGH_PERFORMANCE=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DCMAKE_MACOSX_RPATH=ON
    ]

    system "cmake", *std_cmake_args, *args
    system "cmake", "--build", "build", "--target", "install"
  end
end
