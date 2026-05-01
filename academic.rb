class Academic < Formula
  desc "Omnichannel payments CLI for Academic"
  homepage "https://academic.io"
  version "2026.05.01.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_darwin_arm64.tar.gz"
      sha256 "cd94cb46caacf318b37de744bb0a02484f1b48418f5f13c9553e4a449291287b"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_darwin_amd64.tar.gz"
      sha256 "79d62fc2bae55ab969627ede7db4aa1766637274c020996d542e9eefbbfa7856"
    else
      odie "Unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_linux_arm64.tar.gz"
      sha256 "2d6ac9a5fc052507a98da5ea43fc73d4c763763f3ae6f5edc2513fe3b0e60b44"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_linux_amd64.tar.gz"
      sha256 "47f289df5a0eb47a51b46168de6ec7de10a37341b10b899be3e06c0b22d4907a"
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