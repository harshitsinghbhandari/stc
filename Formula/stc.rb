# typed: false
# frozen_string_literal: true

# Homebrew formula for stc - Save Token Cost (a fork of rtk, Rust Token Killer)
# To install: brew tap harshitsinghbhandari/homebrew-tap && brew install stc
#
# This file is the in-repo template. The release pipeline
# (.github/workflows/release.yml) regenerates it with the real version and
# SHA-256 checksums and pushes it to harshitsinghbhandari/homebrew-tap.
class Stc < Formula
  desc "Save Token Cost - CLI proxy to minimize LLM token consumption (fork of rtk)"
  homepage "https://github.com/harshitsinghbhandari/stc"
  version "0.40.0"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/harshitsinghbhandari/stc/releases/download/v#{version}/stc-x86_64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER_SHA256_INTEL"
    end

    on_arm do
      url "https://github.com/harshitsinghbhandari/stc/releases/download/v#{version}/stc-aarch64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER_SHA256_ARM"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/harshitsinghbhandari/stc/releases/download/v#{version}/stc-x86_64-unknown-linux-musl.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_INTEL"
    end

    on_arm do
      url "https://github.com/harshitsinghbhandari/stc/releases/download/v#{version}/stc-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_ARM"
    end
  end

  def install
    bin.install "stc"
  end

  test do
    assert_match "stc #{version}", shell_output("#{bin}/stc --version")
  end
end
