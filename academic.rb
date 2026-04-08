class Academic < Formula
  desc "Omnichannel payments CLI for Academic"
  homepage "https://academic.io"
  version "2026.04.08.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/homebrew-tap_darwin_arm64.tar.gz"
      sha256 "48142eb50b73349b9ab29ae28ea78c61554b930c6c03c29823005e68a4e9ee3b"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/homebrew-tap_darwin_amd64.tar.gz"
      sha256 "62b6f780255f754f8b759513159b5f12d358a533bc546a517b756baa3e840b97"
    else
      odie "Unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/homebrew-tap_linux_arm64.tar.gz"
      sha256 "0539670c0fce7b69a6966c91f8502de62fbe783ea096ea16c8b4bd867563d0ea"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/homebrew-tap_linux_amd64.tar.gz"
      sha256 "cfd059dae693e7c3523b1dd3bbc9e91a9d3e3ef45823d6bb686b8cb1785db8d7"
    else
      odie "Unsupported Linux architecture"
    end
  end

  def install
    suffix = if OS.mac?
      Hardware::CPU.arm? ? "_darwin_arm64" : "_darwin_amd64"
    else
      Hardware::CPU.arm? ? "_linux_arm64" : "_linux_amd64"
    end

    candidates = ["academic", "academic-cli", "academic-cli#{suffix}"]
    binary = candidates.find { |name| File.exist?(name) }

    odie "Unable to locate academic binary in archive" unless binary

    bin.install binary => "academic"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/academic --version")
  end
end