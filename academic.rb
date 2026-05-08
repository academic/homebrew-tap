class Academic < Formula
  desc "Omnichannel payments CLI for Academic"
  homepage "https://academic.io"
  version "2026.05.09.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_darwin_arm64.tar.gz"
      sha256 "42e46ca9c10cf1b559793aaf66cae1d9a8a1349e521def0ee24477dbea5a122c"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_darwin_amd64.tar.gz"
      sha256 "3ac3f7f74b66e1ccadf36d97d3e4123cc8e5f84722f7310df3bc468fa0afb76d"
    else
      odie "Unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_linux_arm64.tar.gz"
      sha256 "829000578dca498624230bebe3598dee1b4d6b378d6353c3423aceb1716ae0e6"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_linux_amd64.tar.gz"
      sha256 "1eec5c1a9c3851c558515028abd62fbe0064da4c323758a165cae6388fa0aa1b"
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