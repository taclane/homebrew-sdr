class PahoMqttC < Formula
  desc "Eclipse Paho C Client Library for the MQTT Protocol"
  homepage "https://github.com/eclipse/paho.mqtt.c"
  url "https://github.com/eclipse-paho/paho.mqtt.c/archive/refs/tags/v1.3.14.tar.gz"
  sha256 "7af7d906e60a696a80f1b7c2bd7d6eb164aaad908ff4c40c3332ac2006d07346"
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
