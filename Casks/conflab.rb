cask "conflab" do
  version "0.3.2"
  sha256 "e179c2b0f627d05e870e122f221745497c68ef283533562e70f04ed216f9de37"

  url "https://github.com/geodica/conflab-dist/releases/download/v#{version}/Conflab-#{version}-arm64.pkg"
  name "Conflab"
  desc "Menubar app, CLI, and daemon for Conflab agentic collaboration"
  homepage "https://conflab.space"

  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  pkg "Conflab-#{version}-arm64.pkg"

  uninstall launchctl: "space.conflab.daemon",
            quit:      "space.conflab.macos",
            pkgutil:   "space.conflab.macos",
            delete:    [
              "/Applications/Conflab.app",
              "/usr/local/bin/conflab",
              "/usr/local/bin/conflabd",
              "/Library/Application Support/Conflab",
            ]

  zap trash: [
    "~/.conflab",
    "~/Library/LaunchAgents/space.conflab.daemon.plist",
    "~/Library/Application Support/Conflab",
    "~/Library/Caches/space.conflab.macos",
    "~/Library/Preferences/space.conflab.macos.plist",
  ]

  caveats <<~EOS
    Conflab.app has been installed to /Applications.
    The #{token} CLI and conflabd daemon are in /usr/local/bin.

    On first launch the menubar app runs a setup wizard that creates your
    local config and installs the Conflab Local CA for HTTPS to the daemon.

    This cask and the `conflab` formula coexist: the cask owns the app and
    /usr/local/bin; the formula installs into Homebrew's prefix. If you have
    both, /usr/local/bin takes precedence.
  EOS
end
