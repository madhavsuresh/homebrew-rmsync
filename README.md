# homebrew-rmsync

Homebrew tap for [rmsync](https://github.com/madhavsuresh/rmsync), a
bidirectional macOS ↔ reMarkable tablet Markdown sync daemon.

## Install

```sh
brew install madhavsuresh/rmsync/rmsync
```

Then follow the post-install caveats to authenticate rmapi and boot
the launchd agents.

## Update

```sh
brew upgrade rmsync
```

## Uninstall

```sh
rmsync-uninstall-agents     # stop + remove the two launchd agents
brew uninstall rmsync
```

Order matters — tear down the agents while the helper script still
exists.

## Development

This tap only hosts the formula. The source, docs, and issues all
live on the main repo:

https://github.com/madhavsuresh/rmsync
