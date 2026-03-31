class Tqs < Formula
  desc "Terminal task queue CLI with Markdown/YAML-backed tasks"
  homepage "https://github.com/andreabergia/tqs"
  version "0.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/andreabergia/tqs/releases/download/v0.2.3/tqs-aarch64-apple-darwin.tar.xz"
    sha256 "cbb42d07a6eb3f7169f8f406134d466a5c7db7ce69fe8ecfd7a5cf213ba62fb8"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/andreabergia/tqs/releases/download/v0.2.3/tqs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8113ac85229adc520a0319f9b09a1b99c025f392b1e0765333161cc9877673e8"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tqs" if OS.mac? && Hardware::CPU.arm?
    bin.install "tqs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
