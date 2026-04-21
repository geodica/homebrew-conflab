class Conflab < Formula
  desc "CLI and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"
  version "0.3.0"
  license :cannot_represent

  RELEASE_VERSION = "0.3.0"

  on_macos do
    on_arm do
      url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflab-aarch64-apple-darwin"
      sha256 "576474b7d48f077dcafa0017135e9a3a9fd17a0089992233355c2312997d0577"

      resource "conflabd" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflabd-aarch64-apple-darwin"
        sha256 "17cbe98437035ebd718ab848077a7c9bbb190c651f046bc9ca67295b64b154bb"
      end
    end
  end

  def install
    bin.install Dir["conflab-*"].first => "conflab"
    resource("conflabd").stage do
      bin.install Dir["conflabd-*"].first => "conflabd"
    end
  end

  def caveats
    <<~EOS
      This formula installs the Conflab CLI and daemon only.

      For the menubar app (Conflab.app) install the cask:
        brew install --cask geodica/conflab/conflab

      Or download the signed installer directly:
        https://conflab.space/download/mac

      The cask and this formula coexist. The cask installs the app to
      /Applications and the binaries to /usr/local/bin; this formula installs
      into Homebrew's prefix. If you have both, /usr/local/bin takes precedence
      on PATH. Run `conflab doctor` to verify.
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
