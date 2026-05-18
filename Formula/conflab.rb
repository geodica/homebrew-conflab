class Conflab < Formula
  desc "CLI and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"
  version "0.5.6"
  license :cannot_represent

  RELEASE_VERSION = "0.5.6"

  on_macos do
    on_arm do
      url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflab-aarch64-apple-darwin"
      sha256 "e0677cb3d721e453fbaae5971cd018cef28cca5886179ccf9f9f72fd19b9cb4b"

      resource "conflabd" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflabd-aarch64-apple-darwin"
        sha256 "c01bf0c79712b216408f07028f03d118a1119c1e99751d0abc992a0127bb4808"
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
    # conflabd is a long-running daemon (MCP + WebSocket endpoints); a crashed
    # daemon should restart automatically. Matches the pkg installer's
    # LaunchAgent (`KeepAlive=true`) so behaviour is the same regardless of
    # install path.
    keep_alive true
    log_path var/"log/conflabd.log"
    error_log_path var/"log/conflabd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conflab --version")
  end
end
