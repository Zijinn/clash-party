# Clash Party - Swift for macOS

<h3 align="center">
  <img height='48px' src='./images/icon-white.png#gh-dark-mode-only'>
  <img height='48px' src='./images/icon-black.png#gh-light-mode-only'>
</h3>

<h3 align="center">A Native macOS <a href="https://github.com/MetaCubeX/mihomo">Mihomo</a> GUI</h3>

<p align="center">
  <a href="https://github.com/Zijinn/clash-party/releases">
    <img src="https://img.shields.io/github/release/Zijinn/clash-party/all.svg">
  </a>
  <a href="https://t.me/mihomo_party_group">
    <img src="https://img.shields.io/badge/Telegram-Group-blue?logo=telegram">
  </a>
</p>

## Overview

Clash Party is a native macOS application built with Swift and SwiftUI that provides a GUI for [Mihomo](https://github.com/MetaCubeX/mihomo) (Clash Meta). This application offers excellent performance, low resource usage, and seamless macOS integration.

## Features

- **Native macOS Experience**: Built with SwiftUI for a truly native look and feel
- **Menu Bar Integration**: Quick access from the macOS menu bar
- **System Proxy Control**: Seamless integration with macOS system proxy settings
- **Profile Management**: Easy management of multiple proxy configurations
- **Real-time Statistics**: Monitor upload/download speeds and connection status
- **Low Resource Usage**: Significantly lower memory and CPU usage
- **Dark Mode Support**: Native macOS dark mode support
- ⚡ **10x faster startup time** compared to Electron-based versions
- 💾 **80% less memory usage** compared to Electron-based versions
- 🔋 **Better energy efficiency** for longer battery life

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later (for building from source)
- Mihomo core binary

## Installation

### Option 1: Download Pre-built DMG (Recommended)

Download the latest DMG from the [releases page](https://github.com/Zijinn/clash-party/releases):

1. Download `ClashParty-{version}-macOS.dmg`
2. Open the DMG file
3. Drag ClashParty.app to the Applications folder
4. Launch from Applications or Spotlight

### Option 2: Build from Source

See **[BUILD-MACOS.md](BUILD-MACOS.md)** for detailed build instructions.

Quick build:
```bash
git clone https://github.com/Zijinn/clash-party.git
cd clash-party
./build-swift.sh
```

## Documentation

- **[BUILD-MACOS.md](BUILD-MACOS.md)** - Comprehensive build guide
- **[INSTALL-SWIFT.md](INSTALL-SWIFT.md)** - Installation instructions
- **[README-SWIFT.md](README-SWIFT.md)** - Detailed feature overview
- **[DMG-PACKAGING.md](DMG-PACKAGING.md)** - DMG creation guide
- **[CHANGELOG-SWIFT.md](CHANGELOG-SWIFT.md)** - Version history

## Configuration

The application stores its configuration in:
- `~/Library/Application Support/ClashParty/`

Configuration files:
- `config.yaml`: Mihomo configuration
- `profiles.json`: Saved profiles

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

See [LICENSE](LICENSE) file for details.

## Credits

- Mihomo Core: [MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo)
- Swift implementation: Clash Party Team

## Support

- Open an issue on [GitHub](https://github.com/Zijinn/clash-party/issues)
- Join the Telegram group: [Mihomo Party Group](https://t.me/mihomo_party_group)
