class Academic < Formula
  desc "Omnichannel payments CLI for Academic"
  homepage "https://academic.io"
  version "2026.04.12.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_darwin_arm64.tar.gz"
      sha256 "1833201572961c24eb063420ce02720e39d6fcd88df18a3114ce417bc8693097"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_darwin_amd64.tar.gz"
      sha256 "0db726b3509a13909ced0c05d655ebdce92b63c5c1c9d3d24fd8efab7196b12e"
    else
      odie "Unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_linux_arm64.tar.gz"
      sha256 "c7079f3884467a59d55c523265ae7915722cbb995031c61909dc7e4c124d7154"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_linux_amd64.tar.gz"
      sha256 "420a3d40d0d31a4712a2c551d1bdbbb52d13c265f8bc15f09b1d64dfaaa4f202"
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