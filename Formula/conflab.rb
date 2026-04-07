class Conflab < Formula
  desc "CLI and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"
  version "0.1.12"
  license :cannot_represent

  RELEASE_VERSION = "0.1.12"

  on_macos do
    on_arm do
      url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflab-aarch64-apple-darwin"
      sha256 "90a85bba5d6dde84b6c4b85924c9c812d231c3ed08d23629e426f029e37182e0"

      resource "conflabd" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflabd-aarch64-apple-darwin"
        sha256 "a83ac8a50bb12350bffd1cfaa948d77c40e30e82edbc37a74adcbcdcbd2daecb"
      end

      resource "conflab-app" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/Conflab-aarch64-apple-darwin.tar.gz"
        sha256 "4e75e26d0504bf763867d14be459987ad4cc9d4dbf0736bd1c96a731e5c6671a"
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
