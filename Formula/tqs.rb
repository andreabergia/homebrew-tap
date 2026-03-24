class Tqs < Formula
  desc "Terminal task queue CLI with Markdown/YAML-backed tasks"
  homepage "https://github.com/andreabergia/tqs"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/andreabergia/tqs/releases/download/v0.2.2/tqs-aarch64-apple-darwin.tar.xz"
    sha256 "581a0d1faac467253fc33516d512578a136597491c4c4aef5a9c055631e41891"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/andreabergia/tqs/releases/download/v0.2.2/tqs-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "325078ba94e9a74468eed1b6ebced62a53c9a5737fa68d6ba6aa287d5ff45d18"
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
