class PahoMqttCpp < Formula
  desc "Eclipse Paho C++ Client Library for the MQTT Protocol"
  homepage "https://github.com/eclipse/paho.mqtt.cpp"
  url "https://github.com/eclipse/paho.mqtt.cpp/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "435e97e4d5b1da13daa26cadd3e83fe9d154930abaa78b8ff1b8c854b5345d8b"
  license "EPL-2.0"

  head do
    url "https://github.com/eclipse/paho.mqtt.cpp", branch: "master"
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
