# Homebrew formula for ddvk/rmapi (the Go binary rmsync shells out to).
#
# Lives in this tap so we can pin a specific rmapi version that we've
# end-to-end tested against rmsync. The upstream io41/tap formula has
# repeatedly lagged behind cloud-side API changes — most recently the
# 2026-04 schema-v4 rollout that broke every put on rmapi <0.0.32 with
# HTTP 400 (see ddvk/rmapi#58, rmsync v0.2.23 release notes).
#
# This formula installs prebuilt binaries from ddvk's GitHub releases.
# We don't build from source because:
#   - the upstream Go module needs network at build time for some deps;
#   - prebuilt darwin/arm64 + darwin/x86_64 zips are published on every
#     ddvk release and have stable, predictable URLs;
#   - sha256-pinning the zips keeps supply-chain provenance honest.
#
# Bumping versions:
#   1. Update `version` below.
#   2. Update both `sha256` values from the new release's macOS zips.
#      Compute via:
#        curl -sL https://github.com/ddvk/rmapi/releases/download/vX.Y.Z/rmapi-macos-arm64.zip | shasum -a 256
#        curl -sL https://github.com/ddvk/rmapi/releases/download/vX.Y.Z/rmapi-macos-intel.zip | shasum -a 256
#   3. Commit to the tap repo.
#
# A scheduled workflow in the tap repo
# (`.github/workflows/rmapi-bump.yml`) automates steps 1–3 by polling
# ddvk/rmapi's latest tag once a day and opening a PR when a new
# release ships. Manual bumps remain valid for emergencies.

class Rmapi < Formula
  desc "Go CLI for the reMarkable cloud (used by rmsync)"
  homepage "https://github.com/ddvk/rmapi"
  version "0.0.33"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ddvk/rmapi/releases/download/v#{version}/rmapi-macos-arm64.zip"
      sha256 "ddde79c4247477a4490f76a000509ab50412e43fd46acb6f4d84a16766f49e66"
    end
    on_intel do
      url "https://github.com/ddvk/rmapi/releases/download/v#{version}/rmapi-macos-intel.zip"
      sha256 "69a6bf76f4845102d1af5089b2c58b94f6e1bafb141ac4d6bee57815769f24a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ddvk/rmapi/releases/download/v#{version}/rmapi-linux-arm64.tar.gz"
      sha256 "0267f55c8b3fb001a84cbe42059d8e9b3321cefee578f88d9deec763f1dde441"
    end
    on_intel do
      url "https://github.com/ddvk/rmapi/releases/download/v#{version}/rmapi-linux-amd64.tar.gz"
      sha256 "432e5f56c44af6dc557a3154e1e4122ec8126e159ae674bb2c4a4bd31f58a853"
    end
  end

  # Conflicts with the upstream io41/tap formula. Both ship the same
  # `rmapi` binary at the same path; brew refuses to install both.
  #
  # The conflict reason text below is the message users actually see
  # during ``brew upgrade rmsync`` when they have io41/tap/rmapi
  # installed from before rmsync v0.2.24 (which moved to this tap).
  # Make it actionable: point at the exact uninstall + untap commands
  # so the upgrade isn't a dead end. Without this, the failure mode
  # was a cryptic "Cannot install rmapi because conflicting formulae
  # are installed" message that left users guessing.
  conflicts_with "io41/tap/rmapi",
    because: "both install the same `rmapi` binary. To migrate: " \
             "`brew uninstall --ignore-dependencies io41/tap/rmapi && " \
             "brew untap io41/tap && brew upgrade rmsync`"

  def install
    # The zip extracts a single file named ``rmapi``. tar.gz on Linux
    # does the same. Either way the binary lands in the cwd; we just
    # move it to bin.
    bin.install "rmapi"
  end

  test do
    # ``rmapi version`` exits 0 even without auth, prints a version
    # string. Verifies the binary loads its dynamic libraries cleanly
    # and the ``version`` subcommand parses.
    out = shell_output("#{bin}/rmapi version")
    assert_match(/v?\d+\.\d+\.\d+/, out)
  end
end
