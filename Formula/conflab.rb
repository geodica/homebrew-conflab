class Conflab < Formula
  desc "CLI and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"
  version "0.1.6"
  license :cannot_represent

  RELEASE_VERSION = "0.1.6"

  on_macos do
    on_arm do
      url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflab-aarch64-apple-darwin"
      sha256 "265017ed45563b6f946cd88d1c2e621a8177a5efdb28d3661efd801516d787af"

      resource "conflabd" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflabd-aarch64-apple-darwin"
        sha256 "1fae6e8394c12c2d45ccb67e3954ed29031973405cc7b6706897b8b5c0b22880"
      end

      resource "conflab-app" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/Conflab-aarch64-apple-darwin.tar.gz"
        sha256 "6ade8888818d53c6125b9cee85602880b2bd91224d48d7e5c798d3fd80edab47"
      end
    end
  end

  def install
    bin.install Dir["conflab-*"].first => "conflab"
    resource("conflabd").stage do
      bin.install Dir["conflabd-*"].first => "conflabd"
    end
    resource("conflab-app").stage do
      # Homebrew strips the single top-level dir from tarballs,
      # so Contents/ is directly in the staging dir
      (prefix/"Conflab.app").install Dir["*"]
    end
  end

  def caveats
    <<~EOS
      Conflab.app has been installed to:
        #{prefix}/Conflab.app

      To add to your Applications folder:
        ln -sf #{prefix}/Conflab.app /Applications/Conflab.app

      Then start it with:
        conflab app start
    EOS
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
