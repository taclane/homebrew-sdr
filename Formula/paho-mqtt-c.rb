class PahoMqttC < Formula
  desc "Eclipse Paho C Client Library for the MQTT Protocol"
  homepage "https://github.com/eclipse/paho.mqtt.c"
  url "https://github.com/eclipse-paho/paho.mqtt.c/archive/refs/tags/v1.3.16.tar.gz"
  sha256 "8b960f51edc7e03507637d987882bc486d8f4be6e79431bf99e2763344fd14c5"
  license "EPL-2.0"
  head "https://github.com/eclipse/paho.mqtt.c.git", branch: "master"

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
