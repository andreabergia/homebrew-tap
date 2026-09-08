class Mahgit < Formula
  desc "Terminal Git interface inspired by Magit"
  homepage "https://github.com/andreabergia/mahgit"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/andreabergia/mahgit/releases/download/v0.1.0/mahgit-aarch64-apple-darwin.tar.xz"
    sha256 "1908f7aa23eab0b2c2bdc9ccab51351d577c5bc2b1c2603b94b3c841f9a3733b"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/andreabergia/mahgit/releases/download/v0.1.0/mahgit-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "cd51d0ff2e632096f8cac011a0d7e70a41c41219facc5278b27b878288a7cd5a"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "mahgit"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mahgit"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
