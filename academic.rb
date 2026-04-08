class Academic < Formula
  desc "Omnichannel payments CLI for Academic"
  homepage "https://academic.io"
  version "2026.04.08.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/academic/academic-cli/releases/download/v#{version}/academic-cli_darwin_arm64.tar.gz"
      sha256 "9225d58f8e1ee7797e2f24c536d37e19aa4018966784cdb4920832595e892e1d"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/academic-cli/releases/download/v#{version}/academic-cli_darwin_amd64.tar.gz"
      sha256 "24037474df399e0b25c34886cf24c1c684d37bedb8cdd2b720e0f81534d2489a"
    else
      odie "Unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/academic/academic-cli/releases/download/v#{version}/academic-cli_linux_arm64.tar.gz"
      sha256 "c8be59f154ad192fc1db59e5ea1c6247a09b04cb31ade2ea9f883149ffee6113"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/academic-cli/releases/download/v#{version}/academic-cli_linux_amd64.tar.gz"
      sha256 "73970d69a6a182cae0a95f81fd497fd70ab2694914d7c77480bb3b31bf159374"
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