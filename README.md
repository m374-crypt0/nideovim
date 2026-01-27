# 🚀 nideovim

> *"There is no spoon... only containers."* - Morpheus (probably)

**The ultimate development environment fabricator** that transforms your humble
terminal into a fully-loaded coding battlestation. Built on the holy trinity of
Docker 🐳, Debian 🌀, and Neovim ⚡ with LazyVim 💤 — because who has time for
configuration when there's code to write?

## 🎯 Mission Statement

Create, manage, and deploy **zero-friction development environments** that get
you from `git clone` to `git push` faster than you can say "it works on my
machine." Maximum productivity 📈, minimum existential dread 💢.

## ✨ What Makes This Special?

- **🏭 Environment Fabricator**: Like a replicator from Star Trek, but for dev environments
- **🐳 Docker-Powered**: Containerized goodness that runs anywhere containers run
- **🔧 Infinitely Extensible**: Customize without limits — your environment,
  your rules
- **📟 Terminal Native**: No GUI bloat, just pure command-line efficiency
- **⚡ LazyVim Integration**: All the Neovim awesomeness with community plugins
  baked in

## 🛠️ Prerequisites

### 🎮 Usage Requirements

- **Terminal-based workflow** (because real developers live in the shell)
- **No GUI dependency** — your terminal is your castle

### 🔧 Tooling Stack

- POSIX compliant shell (bash, zsh, fish — pick your poison, real bears prefer
  bash though...)
- `rev` and `cut` (the unsung heroes)
- **Docker** (native, Docker Desktop, or OrbStack)
  - buildx plugin
  - compose plugin
- `make` (the build system above all deities)
- `command` utility
- GNU `sed` (or `gsed` on macOS via Homebrew)
- `less` (optional, but recommended for your sanity)

### 💻 Hardware

- **Storage**: Several GB of free space (containers gotta container gotta build
  cache)
- **Power**: Decent CPU and RAM recommended (because waiting is for chumps)

*Most modern Linux distros and macOS should work out of the box. Windows users:
WSL2 is your friend.*

## 🚀 Quick Start

```bash
# Level 1: Gentle introduction
make help

# Level 2: For the curious
make help-help

# Level 3: ???
# Level 4: Profit!
```
