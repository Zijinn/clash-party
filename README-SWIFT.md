# Clash Party - Swift for macOS

This is the native macOS version of Clash Party, rewritten entirely in Swift using SwiftUI.

## Overview

Clash Party is a native macOS application that provides a GUI for [Mihomo](https://github.com/MetaCubeX/mihomo) (Clash Meta). This Swift version offers better performance, lower memory usage, and deeper macOS integration compared to the Electron version.

## Features

- **Native macOS Experience**: Built with SwiftUI for a truly native look and feel
- **Menu Bar Integration**: Quick access from the macOS menu bar
- **System Proxy Control**: Seamless integration with macOS system proxy settings
- **Profile Management**: Easy management of multiple proxy configurations
- **Real-time Statistics**: Monitor upload/download speeds and connection status
- **Low Resource Usage**: Significantly lower memory and CPU usage than Electron
- **Dark Mode Support**: Native macOS dark mode support

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later (for building from source)
- Mihomo core binary

## Building from Source

### Prerequisites

1. Install Xcode from the Mac App Store
2. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```

### Build Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/mihomo-party-org/clash-party.git
   cd clash-party
   ```

2. Open the project in Xcode:
   ```bash
   open ClashParty.xcodeproj
   ```

3. Build and run:
   - Select the "ClashParty" scheme
   - Click the Run button (⌘R) or go to Product > Run

### Building for Release

To build a release version:

1. In Xcode, select Product > Archive
2. Once the archive is created, click "Distribute App"
3. Choose "Copy App" to export the .app bundle
4. The application will be saved to your chosen location

## Project Structure

```
ClashParty/
├── ClashParty.xcodeproj/     # Xcode project file
└── ClashParty/
    ├── Sources/
    │   ├── ClashPartyApp.swift       # Main app entry point
    │   ├── ContentView.swift         # Main UI
    │   ├── Core/
    │   │   └── CoreManager.swift     # Mihomo core management
    │   ├── Config/
    │   │   ├── ConfigManager.swift   # Configuration management
    │   │   └── ProfileManager.swift  # Profile data models
    │   ├── System/
    │   │   └── SystemProxy.swift     # System proxy control
    │   └── Utils/
    │       └── Logger.swift          # Logging utilities
    ├── Resources/
    │   └── Assets.xcassets/          # App icons and assets
    └── Supporting Files/
        ├── Info.plist                # App metadata
        └── ClashParty.entitlements   # App capabilities
```

## Architecture

### Core Components

1. **CoreManager**: Manages the Mihomo proxy core
   - Starts/stops the mihomo process
   - Monitors traffic statistics
   - Communicates with mihomo API

2. **ConfigManager**: Handles configuration and profiles
   - Loads/saves application settings
   - Manages proxy profiles
   - Handles profile subscriptions

3. **SystemProxy**: Controls macOS system proxy settings
   - Sets HTTP/HTTPS/SOCKS proxy
   - Clears proxy settings
   - Queries current proxy status

4. **Logger**: Application-wide logging
   - Structured logging with levels
   - In-memory log storage
   - Export functionality

### UI Components

- **ContentView**: Main application window with sidebar navigation
- **OverviewView**: Dashboard showing status and statistics
- **ProxiesView**: List of available proxy nodes
- **ProfilesView**: Profile management interface
- **SettingsView**: Application settings

## Configuration

The application stores its configuration in:
- `~/Library/Application Support/ClashParty/`

Configuration files:
- `config.yaml`: Mihomo configuration
- `profiles.json`: Saved profiles
- Application preferences are stored in UserDefaults

## Development

### Adding New Features

1. **New Views**: Add SwiftUI views in `Sources/ContentView.swift` or create new files
2. **Core Features**: Extend `CoreManager.swift` for mihomo-related features
3. **System Integration**: Add to `System/` directory for macOS-specific features
4. **Utilities**: Add helper functions to `Utils/` directory

### Debugging

Enable debug logging by building in Debug configuration. Logs are available:
- In Xcode console
- System Console.app (filter by "ClashParty")
- In-app Logs view

### Code Style

- Follow Swift naming conventions
- Use SwiftUI for all UI components
- Use async/await for asynchronous operations
- Document public APIs with Swift documentation comments

## Differences from Electron Version

### Advantages
- **Performance**: ~10x faster startup time
- **Memory**: ~80% less memory usage
- **Native**: True macOS look and feel
- **Integration**: Better system integration (menu bar, shortcuts, notifications)
- **Energy**: More energy efficient

### Limitations
- macOS only (no cross-platform support)
- Requires recompilation for updates
- Smaller ecosystem than web technologies

## Troubleshooting

### App Won't Start
- Check Console.app for error messages
- Ensure mihomo binary is present and executable
- Verify entitlements are properly set

### System Proxy Not Working
- The app requires elevated privileges for proxy settings
- Grant necessary permissions in System Settings > Privacy & Security

### Mihomo Core Not Found
- Ensure mihomo binary is in the expected location
- Check `CoreManager.getCoreExecutablePath()` for search paths

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

### Guidelines
- Write clean, documented code
- Follow Swift best practices
- Test on multiple macOS versions
- Update documentation as needed

## License

Same as the original Clash Party project.

## Credits

- Original Clash Party: [mihomo-party-org](https://github.com/mihomo-party-org/clash-party)
- Mihomo Core: [MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo)
- Swift rewrite: Clash Party Team

## Support

For issues specific to the Swift version:
- Open an issue on GitHub
- Join the Telegram group: [Mihomo Party Group](https://t.me/mihomo_party_group)

---

**Note**: This Swift version is a complete rewrite and may not have feature parity with the Electron version initially. Features are being added continuously.
