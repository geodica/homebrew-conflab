class Conflab < Formula
  desc "CLI and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"
  version "0.1.8"
  license :cannot_represent

  RELEASE_VERSION = "0.1.8"

  on_macos do
    on_arm do
      url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflab-aarch64-apple-darwin"
      sha256 "0c18b74fcd31f8b6939e2043e432b1b7a8e4a61f6aa61508a4ea9be97528db88"

      resource "conflabd" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/conflabd-aarch64-apple-darwin"
        sha256 "802c42dbd0f6ede236004d625fb8400911ea72f26a45587bcfb7e5e46db01c19"
      end

      resource "conflab-app" do
        url "https://github.com/geodica/conflab-dist/releases/download/v#{RELEASE_VERSION}/Conflab-aarch64-apple-darwin.tar.gz"
        sha256 "485da15852bb141e82a390748eb581f4ee1216c71f61677feebab0f86783c6c8"
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
