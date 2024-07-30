class PahoMqttC < Formula
  desc "Eclipse Paho C Client Library for the MQTT Protocol"
  homepage "https://github.com/eclipse/paho.mqtt.c"
  url "https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v1.3.13.tar.gz"
  sha256 "47c77e95609812da82feee30db435c3b7c720d4fd3147d466ead126e657b6d9c"
  license "EPL-2.0"

  head do
    url "https://github.com/eclipse/paho.mqtt.c.git", branch: "master"
  end

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
