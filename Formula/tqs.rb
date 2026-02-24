class Tqs < Formula
  desc "Terminal task queue CLI with Markdown/YAML-backed tasks"
  homepage "https://github.com/andreabergia/tqs"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/andreabergia/tqs/releases/download/v0.1.1/tqs-aarch64-apple-darwin.tar.xz"
      sha256 "6873eb4a58a7286c5de3930f0cd80fd0b6936d9027071ad44b4392cd247c7759"
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/andreabergia/tqs/releases/download/v0.1.1/tqs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07f736f7880057fb8568bc7da3388560dec8295880a3aea82669b81cca176424"
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
