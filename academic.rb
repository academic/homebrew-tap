class Academic < Formula
  desc "Omnichannel payments CLI for Academic"
  homepage "https://academic.io"
  version "2026.04.08.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/academic/academic-cli/releases/download/v#{version}/academic-cli_darwin_arm64.tar.gz"
      sha256 "33ab0bf540f84fffbe173e0a8c14a15e6fb01d71d1053806c64a73d4e6f6e504"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/academic-cli/releases/download/v#{version}/academic-cli_darwin_amd64.tar.gz"
      sha256 "f78ef7b9e510ddd6ff0bcef89579ef22e9b3d1681f1ecb36efd663ae03e7c8b1"
    else
      odie "Unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/academic/academic-cli/releases/download/v#{version}/academic-cli_linux_arm64.tar.gz"
      sha256 "43176c2abc9240fa53ed223a237761b9d4ba25a4030ea153cd7f74a95406546e"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/academic-cli/releases/download/v#{version}/academic-cli_linux_amd64.tar.gz"
      sha256 "2887c6805d7f1eee057dd5a16b3c90ef7443f95dc1985daecf1049cc8436460e"
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