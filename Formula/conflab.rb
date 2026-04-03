class Conflab < Formula
  desc "CLI and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"
  version "0.1.9"
  license :cannot_represent

  RELEASE_VERSION = "0.1.9"

  on_macos do
    on_arm do
      url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflab-aarch64-apple-darwin"
      sha256 "b1b4c0d6f9a1ee0b40c935390de3a42662b652dcf9b64f393513623a1f65fb9a"

      resource "conflabd" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflabd-aarch64-apple-darwin"
        sha256 "5cd0b346b88975410fbd3b1bba6d88d56b4180cf0a956e6f1227ca056aeece76"
      end

      resource "conflab-app" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/Conflab-aarch64-apple-darwin.tar.gz"
        sha256 "181c3dcd38d9e6f3301c8bdc61b4761e00fb9e3e7ac8f4b08fb91a5456e7cadb"
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
