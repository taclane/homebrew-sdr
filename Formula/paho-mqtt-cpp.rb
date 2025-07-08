class PahoMqttCpp < Formula
  desc "Eclipse Paho C++ Client Library for the MQTT Protocol"
  homepage "https://github.com/eclipse/paho.mqtt.cpp"
  url "https://github.com/eclipse-paho/paho.mqtt.cpp/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "3d8d9bfee614d74fa2e28dc244733c79e4868fa32a2d49af303ec176ccc55bfb"
  license "EPL-2.0"
  head "https://github.com/eclipse/paho.mqtt.cpp.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    args = %W[
      -B build
      -H.
      -DPAHO_ENABLE_TESTING=OFF
      -DPAHO_BUILD_STATIC=ON
      -DPAHO_WITH_SSL=ON
      -DPAHO_HIGH_PERFORMANCE=ON
      -DCMAKE_MACOSX_RPATH=ON
    ]

    system "cmake", *std_cmake_args, *args
    system "cmake", "--build", "build", "--target", "install"
  end
end
