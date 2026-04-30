# homebrew-rmsync

Homebrew tap for [rmsync](https://github.com/madhavsuresh/rmsync), a
bidirectional macOS ↔ reMarkable tablet Markdown sync daemon, plus a
pinned build of [rmapi](https://github.com/ddvk/rmapi) (the Go cloud
client rmsync shells out to).

## Install

```sh
brew install madhavsuresh/rmsync/rmsync
```

This pulls `rmapi` from this tap automatically. Then follow the
post-install caveats to authenticate rmapi and boot the launchd
agents.

## Why a pinned rmapi?

The reMarkable cloud's API moves; rmapi has historically had a
multi-month gap between an upstream API change and a packaged
release reaching end users via other taps. To keep `brew install`
working on the day a cloud-side rollout breaks the wire format, this
tap pins a specific rmapi version that we end-to-end tested against
rmsync. The version bump is automated via a daily workflow watching
[ddvk/rmapi](https://github.com/ddvk/rmapi) releases (see
`.github/workflows/rmapi-bump.yml`); each new release opens a PR for
review before merging.

If you already have `rmapi` installed from another tap (commonly
`io41/tap`), the formula declares a `conflicts_with` on it and brew
will surface the conflict at install time. To migrate:

```sh
brew uninstall io41/tap/rmapi
brew untap io41/tap
brew install madhavsuresh/rmsync/rmapi
```

You can also install rmapi standalone:

```sh
brew install madhavsuresh/rmsync/rmapi
rmapi version    # prints the pinned version
```

## Update

```sh
brew upgrade rmsync
brew upgrade rmapi  # picks up cloud-API-compatibility fixes
```

## Uninstall

```sh
rmsync-uninstall-agents     # stop + remove the two launchd agents
brew uninstall rmsync
```

Order matters — tear down the agents while the helper script still
exists.

## Development

This tap only hosts the formulae. The source, docs, and issues all
live on the main repo:

https://github.com/madhavsuresh/rmsync
