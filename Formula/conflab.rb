class Conflab < Formula
  desc "CLI and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"
  version "0.1.4"
  license :cannot_represent

  RELEASE_VERSION = "0.1.4"

  on_macos do
    on_arm do
      url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflab-aarch64-apple-darwin"
      sha256 "0feaec6588438d88a41f355dd61948577adaea92f3a33f110c87489a559a11cc"

      resource "conflabd" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflabd-aarch64-apple-darwin"
        sha256 "5bc5a2e92b448fe1d63cc7c6fe9028479f6f14be7f884a955d3340c4ef4c5589"
      end

      resource "conflab-app" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/Conflab-aarch64-apple-darwin.tar.gz"
        sha256 "TO_BE_FILLED_BY_RELEASE_SCRIPT"
      end
    end
  end

  def install
    bin.install Dir["conflab-*"].first => "conflab"
    resource("conflabd").stage do
      bin.install Dir["conflabd-*"].first => "conflabd"
    end
    resource("conflab-app").stage do
      prefix.install "Conflab.app"
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
