class Academic < Formula
  desc "Omnichannel payments CLI for Academic"
  homepage "https://academic.io"
  version "2026.04.08.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_darwin_arm64.tar.gz"
      sha256 "3e266bf6ad72ff4a06e9ac59a01ba6087d3acfeb3f5efc60a1437516780d75e8"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_darwin_amd64.tar.gz"
      sha256 "fd5339921bec16e5bf6ab20949acefb2a75ae0b20964698348af24507f40ed2b"
    else
      odie "Unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_linux_arm64.tar.gz"
      sha256 "c51ceb6638aafc79592192628a7a3733cd14754966a303d164e45d469f38f047"
    elsif Hardware::CPU.intel?
      url "https://github.com/academic/homebrew-tap/releases/download/v#{version}/academic-cli_linux_amd64.tar.gz"
      sha256 "66defc034becffebf871f5da8b111aa3b20945ea4ed3ba1cc62a818982a6ffb0"
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