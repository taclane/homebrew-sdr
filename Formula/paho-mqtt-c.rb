class PahoMqttC < Formula
  desc "Eclipse Paho C Client Library for the MQTT Protocol"
  homepage "https://github.com/eclipse/paho.mqtt.c"
  url "https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v1.3.12.tar.gz"
  sha256 "6a70a664ed3bbcc1eafdc45a5dc11f3ad70c9bac12a54c2f8cef15c0e7d0a93b"
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
