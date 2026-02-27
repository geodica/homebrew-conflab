class Conflab < Formula
  desc "CLI and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"
  version "0.1.1"
  license :cannot_represent

  RELEASE_VERSION = "0.1.1"

  on_macos do
    on_arm do
      url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflab-aarch64-apple-darwin"
      sha256 "589d0fddacfb92f339323c6881bd1697d9d164ac354f7d76bc3121cc5c65d36c"

      resource "conflabd" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflabd-aarch64-apple-darwin"
        sha256 "716f8768090134526756f4875d9dc564408be4c290dff3887a9f0ccddc084197"
      end
    end
  end

  def install
    bin.install Dir["conflab-*"].first => "conflab"
    resource("conflabd").stage do
      bin.install Dir["conflabd-*"].first => "conflabd"
    end
  end

  service do
    run [opt_bin/"conflabd", "start"]
    keep_alive false
    log_path var/"log/conflabd.log"
    error_log_path var/"log/conflabd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conflab --version")
  end
end
