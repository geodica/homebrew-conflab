class Conflab < Formula
  desc "CLI and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"
  version "0.1.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/geodica/conflab-dist/releases/download/v#{version}/conflab-aarch64-apple-darwin"
      sha256 "e2b996eee33db5cd33508ea0f2b94b14d42ddfc4558af9bb0c00a08574097588"

      resource "conflabd" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{version}/conflabd-aarch64-apple-darwin"
        sha256 "853ac7f44007b7e24857244818317265e49534dd65ff7ea71b5f72b0ef49d0d1"
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
