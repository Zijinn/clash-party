# Building and Using Clash Party on macOS

This guide provides comprehensive instructions for building and using **Clash Party** on macOS from the [Zijinn/clash-party](https://github.com/Zijinn/clash-party) repository.

## Table of Contents

1. [Overview](#overview)
2. [System Requirements](#system-requirements)
3. [Installation Options](#installation-options)
4. [Building the Swift Version (Native macOS)](#building-the-swift-version-native-macos)
5. [Building the Electron Version (Cross-platform)](#building-the-electron-version-cross-platform)
6. [Using Clash Party](#using-clash-party)
7. [Troubleshooting](#troubleshooting)
8. [Contributing](#contributing)

## Overview

Clash Party is available in two versions for macOS:

1. **Swift Version (Recommended for macOS)**: Native macOS application with better performance
2. **Electron Version**: Cross-platform version that also works on macOS

This guide covers both versions, with a focus on the Swift version for optimal macOS experience.

## System Requirements

### For Swift Version
- **macOS**: 13.0 (Ventura) or later
- **Xcode**: 15.0 or later
- **Architecture**: Apple Silicon (M1/M2/M3/M4) or Intel x64
- **RAM**: 256 MB minimum (512 MB recommended)
- **Storage**: ~100 MB free space

### For Electron Version
- **macOS**: 10.15 (Catalina) or later
- **Node.js**: 18.x or later
- **pnpm**: 10.22.0 (specified in package.json)
- **RAM**: 512 MB minimum (1 GB recommended)
- **Storage**: ~500 MB free space

### Common Requirements
- **Mihomo Core**: Required for proxy functionality
- **Internet Connection**: For downloading dependencies and Mihomo core

## Installation Options

### Option 1: Pre-built Releases

Pre-built releases are available at:
https://github.com/Zijinn/clash-party/releases

For the Swift version, download the `.dmg` file:
1. Go to the latest release
2. Download `ClashParty-{version}-macOS.dmg`
3. Open the DMG file
4. Drag ClashParty.app to the Applications folder
5. Launch from Applications

### Option 2: Build from Source

Follow the instructions below to build from source.

## Building the Swift Version (Native macOS)

The Swift version offers 10x faster startup and 80% less memory usage compared to Electron.

### Prerequisites

1. **Install Xcode**
   ```bash
   # Download from Mac App Store, or install Command Line Tools:
   xcode-select --install
   ```

2. **Verify Installation**
   ```bash
   xcodebuild -version
   # Expected output: Xcode 15.0 or later
   ```

3. **Install Mihomo Core** (Required)
   
   Choose one of the following methods:

   **Method A: Using Homebrew (Recommended)**
   ```bash
   brew install mihomo
   ```

   **Method B: Download Binary**
   ```bash
   # For Apple Silicon (M1/M2/M3/M4)
   curl -Lo mihomo https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-darwin-arm64
   
   # For Intel Macs
   curl -Lo mihomo https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-darwin-amd64
   
   # Make executable and move to PATH
   chmod +x mihomo
   sudo mv mihomo /usr/local/bin/
   ```

### Build Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Zijinn/clash-party.git
   cd clash-party
   ```

2. **Build Using the Build Script (Recommended)**
   ```bash
   ./build-swift.sh
   ```
   
   The script will:
   - Clean previous builds
   - Compile the Swift application
   - Display build output
   - Offer to run the app automatically

3. **Alternative: Build Using Makefile**
   ```bash
   # Just build
   make build
   
   # Build and run
   make run
   
   # Build release version
   make release
   
   # Install to /Applications
   make install
   
   # Clean build artifacts
   make clean
   ```

4. **Alternative: Build Using Xcode**
   ```bash
   # Open project in Xcode
   open ClashParty.xcodeproj
   ```
   
   In Xcode:
   - Select "ClashParty" scheme
   - Choose "My Mac" as destination
   - Click Run (⌘R) or Product > Run

5. **Alternative: Build Using xcodebuild Directly**
   ```bash
   xcodebuild -project ClashParty.xcodeproj \
     -scheme ClashParty \
     -configuration Release \
     -derivedDataPath .build \
     build
   ```
   
   Built app location: `.build/Build/Products/Release/ClashParty.app`

### Creating a DMG Package

After building the application, you can create a distributable DMG file:

1. **Using Makefile (Recommended)**
   ```bash
   # Build and create DMG in one command
   make release-dmg
   
   # Or, if already built, just create DMG
   make dmg
   ```

2. **Using the DMG Script Directly**
   ```bash
   # Build first
   ./build-swift.sh
   
   # Create DMG
   ./create-dmg.sh .build/Build/Products/Release/ClashParty.app 1.0.0
   ```
   
   The script will:
   - Create a macOS disk image (.dmg)
   - Configure the DMG with a modern appearance
   - Add an Applications symlink for easy installation
   - Generate a SHA256 checksum file
   - Optionally code sign the DMG (if CODE_SIGN_IDENTITY is set)

3. **DMG Output Location**
   
   Created DMG location: `.build/ClashParty-{version}-macOS.dmg`
   
   Checksum file: `.build/ClashParty-{version}-macOS.dmg.sha256`

### Running the Swift Version

After building:

```bash
# Run from build directory
open .build/Build/Products/Release/ClashParty.app

# Or if installed to /Applications
open /Applications/ClashParty.app
```

## Building the Electron Version (Cross-platform)

### Prerequisites

1. **Install Node.js**
   ```bash
   # Using Homebrew
   brew install node
   
   # Verify installation
   node --version  # Should be v18.x or later
   ```

2. **Install pnpm**
   ```bash
   npm install -g pnpm@10.22.0
   
   # Verify installation
   pnpm --version
   ```

### Build Steps

1. **Clone the Repository** (if not already done)
   ```bash
   git clone https://github.com/Zijinn/clash-party.git
   cd clash-party
   ```

2. **Install Dependencies**
   ```bash
   pnpm install
   ```
   
   This will:
   - Install all Node.js dependencies
   - Install Electron
   - Set up the development environment

3. **Prepare the Application**
   ```bash
   pnpm run prepare
   ```

4. **Build for macOS**
   ```bash
   # Development build
   pnpm run build:mac:dev
   
   # Production build
   pnpm run build:mac
   ```
   
   Built app location: `dist/mac/Clash Party.app`

### Running the Electron Version

```bash
# Development mode with hot reload
pnpm run dev

# Run built application
open "dist/mac/Clash Party.app"
```

## Using Clash Party

### First Launch

1. **Launch the Application**
   - Swift version: Double-click `ClashParty.app`
   - Electron version: Double-click `Clash Party.app`

2. **Grant Permissions**
   
   On first launch, macOS may show security warnings:
   
   - Click "Open" when prompted
   - If blocked, go to System Settings > Privacy & Security > Open Anyway
   - Grant network access permissions when requested

3. **Verify Mihomo Core**
   
   The app will check for the Mihomo core. If not found, it will display an error.

### Configuration

#### Method 1: Add Subscription Profile

1. Open Clash Party
2. Go to **Profiles** tab
3. Click **"Add Profile"** or **"+"**
4. Enter a profile name
5. Paste your subscription URL
6. Click **"Add"** or **"Save"**
7. The app will download and update the profile

#### Method 2: Import Local Configuration

1. Prepare a YAML configuration file
2. In Clash Party, go to **Settings** > **Import**
3. Select your configuration file
4. The configuration will be imported

#### Method 3: Manual Configuration

Configuration files are stored in:
```bash
~/Library/Application Support/ClashParty/
```

You can manually edit:
- `config.yaml` - Main Mihomo configuration
- `profiles.json` - Profile management data

### Starting the Proxy

1. Go to the **Overview** tab
2. Select a profile (if you have multiple)
3. Click the **"Start"** button
4. Status should change to **"Running"**
5. Real-time traffic statistics will appear

### System Proxy Configuration

#### Automatic (Recommended)

1. Open **Settings** (⌘,)
2. Go to **Proxy** or **System** tab
3. Enable **"Set as System Proxy"**
4. The app will configure macOS system proxy automatically

#### Manual

1. Open **System Settings**
2. Go to **Network** > **Wi-Fi/Ethernet** > **Details**
3. Click **Proxies** tab
4. Configure:
   - **HTTP Proxy**: 127.0.0.1:7890
   - **HTTPS Proxy**: 127.0.0.1:7890
   - **SOCKS Proxy**: 127.0.0.1:7891
5. Click **OK** and **Apply**

### Using the Menu Bar

**Swift Version Only**: Clash Party appears in the macOS menu bar

- Click the menu bar icon for quick access
- View connection status
- Toggle proxy on/off
- Access settings
- Quit application

### Features Overview

- **Overview Tab**: Dashboard with status, traffic statistics, and quick controls
- **Proxies Tab**: View and select proxy nodes
- **Profiles Tab**: Manage subscription profiles
- **Rules Tab**: View and manage routing rules
- **Connections Tab**: Monitor active connections
- **Logs Tab**: View application and core logs
- **Settings Tab**: Configure application behavior

## Troubleshooting

### Build Issues

#### Problem: "xcodebuild: command not found"

**Solution**: Install Xcode Command Line Tools
```bash
xcode-select --install
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

#### Problem: "No such module" errors during Swift build

**Solution**: Clean build folder and rebuild
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf .build
make clean && make build
```

#### Problem: Code signing errors

**Solutions**:
1. In Xcode, select the project
2. Go to "Signing & Capabilities"
3. Check "Automatically manage signing"
4. Select your Apple Developer team
5. For local development, you can use a free Apple ID

#### Problem: pnpm install fails

**Solutions**:
```bash
# Clear pnpm cache
pnpm store prune

# Remove node_modules and lockfile
rm -rf node_modules pnpm-lock.yaml

# Reinstall
pnpm install
```

#### Problem: Electron build fails with native module errors

**Solutions**:
```bash
# Rebuild native modules
pnpm run postinstall

# Or rebuild manually
pnpm rebuild
```

### Runtime Issues

#### Problem: "Mihomo core not found"

**Solutions**:
1. Verify mihomo is installed:
   ```bash
   which mihomo
   ls -la /usr/local/bin/mihomo
   ls -la /opt/homebrew/bin/mihomo
   ```

2. Install if missing:
   ```bash
   brew install mihomo
   ```

3. Ensure executable permissions:
   ```bash
   chmod +x /usr/local/bin/mihomo
   ```

#### Problem: App crashes on launch

**Solutions**:
1. Check Console.app for crash logs:
   - Open Console.app
   - Search for "ClashParty" or "Clash Party"
   - Look for crash reports

2. Verify macOS version:
   ```bash
   sw_vers
   ```

3. Remove preferences:
   ```bash
   # Swift version
   defaults delete party.mihomo.app
   
   # Electron version
   rm -rf ~/Library/Application\ Support/mihomo-party/
   ```

4. Rebuild the application

#### Problem: System proxy not working

**Solutions**:
1. Grant necessary permissions:
   - System Settings > Privacy & Security
   - Allow Clash Party to modify network settings

2. Try manual proxy configuration

3. Check logs for permission errors:
   - In-app Logs tab
   - Console.app

4. Restart the application after granting permissions

#### Problem: Cannot start proxy - port already in use

**Solutions**:
1. Check what's using the port:
   ```bash
   lsof -i :7890
   lsof -i :7891
   ```

2. Stop the conflicting process or change port in Settings

3. Kill existing mihomo processes:
   ```bash
   pkill mihomo
   ```

#### Problem: Slow performance or high CPU usage

**Solutions**:
1. Check Activity Monitor for resource usage
2. Reduce connection limits in Settings
3. Lower log level (Error or Warning only)
4. Disable unnecessary features
5. Restart the core process
6. Consider using Swift version for better performance

#### Problem: Profile update fails

**Solutions**:
1. Check internet connection
2. Verify subscription URL is valid:
   ```bash
   curl -I "your-subscription-url"
   ```
3. Check logs for specific error messages
4. Try manual download and import
5. Check if subscription requires authentication

### Permission Issues

#### Problem: "Operation not permitted" errors

**Solutions**:
1. Grant Full Disk Access:
   - System Settings > Privacy & Security > Full Disk Access
   - Add Clash Party

2. Grant Network permissions:
   - System Settings > Privacy & Security > Network
   - Allow Clash Party

3. For system proxy control:
   - May require administrator password
   - Run with appropriate privileges

### Debugging

#### Enable Verbose Logging

**Swift Version**:
- Build in Debug configuration
- Logs appear in Xcode console and Console.app

**Electron Version**:
```bash
# Run in development mode
pnpm run dev

# Check logs in:
# - Terminal output
# - In-app Logs tab
# - Console.app
```

#### Check Configuration

```bash
# View configuration
cat ~/Library/Application\ Support/ClashParty/config.yaml

# Validate configuration
mihomo -t -d ~/Library/Application\ Support/ClashParty/

# Check mihomo API
curl http://127.0.0.1:9090/version
```

#### Test Network Connectivity

```bash
# Test proxy
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
curl -I https://www.google.com

# Test SOCKS proxy
curl --socks5 127.0.0.1:7891 -I https://www.google.com
```

## Configuration Details

### File Locations

**Swift Version**:
```
~/Library/Application Support/ClashParty/
├── config.yaml          # Mihomo configuration
├── profiles.json        # Profile data
└── logs/               # Log files (if enabled)
```

**Electron Version**:
```
~/Library/Application Support/mihomo-party/
├── config.yaml          # Mihomo configuration
├── profiles/           # Profile files
└── cache/             # Cache data
```

### Default Ports

- **HTTP/HTTPS Proxy**: 7890
- **SOCKS5 Proxy**: 7891
- **Mixed Proxy**: 7892
- **Controller API**: 9090
- **External Controller**: 9090

### Environment Variables

For development and debugging:

```bash
# Enable debug mode
export DEBUG=clash-party:*

# Custom core path
export MIHOMO_CORE_PATH=/custom/path/to/mihomo

# Custom config directory
export CLASH_PARTY_CONFIG_DIR=/custom/config/path
```

## Advanced Usage

### Using Different Profiles

1. Add multiple profiles via Profiles tab
2. Switch between profiles in Overview tab
3. Set automatic profile updates:
   - Edit profile
   - Set update interval (e.g., 24 hours)
   - Enable auto-update

### Custom Rules

1. Go to Settings > Rules
2. Add custom routing rules
3. Rules support:
   - Domain matching
   - IP-CIDR matching
   - Process matching
   - Port matching

### TUN Mode (Advanced)

TUN mode provides system-wide transparent proxying:

1. Enable in Settings > General > TUN Mode
2. May require administrator password
3. All traffic automatically routed through proxy
4. More powerful than system proxy

### Scripts and Automation

Run Clash Party from command line:

```bash
# Swift version (if installed)
open /Applications/ClashParty.app

# With specific profile
open /Applications/ClashParty.app --args --profile "MyProfile"

# Electron version
cd /path/to/clash-party
pnpm run dev
```

## Uninstallation

### Remove Application

```bash
# Swift version
rm -rf /Applications/ClashParty.app

# Electron version
rm -rf "/Applications/Clash Party.app"
```

### Remove Configuration and Data

```bash
# Swift version
rm -rf ~/Library/Application\ Support/ClashParty/
defaults delete party.mihomo.app

# Electron version
rm -rf ~/Library/Application\ Support/mihomo-party/

# Remove caches
rm -rf ~/Library/Caches/party.mihomo.app/
rm -rf ~/Library/Caches/mihomo-party/
```

### Remove Mihomo Core (Optional)

```bash
# If installed via Homebrew
brew uninstall mihomo

# If manually installed
sudo rm /usr/local/bin/mihomo
```

## Contributing

Contributions to the Zijinn/clash-party repository are welcome!

### Development Setup

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/clash-party.git
   cd clash-party
   ```

3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/Zijinn/clash-party.git
   ```

4. Create a feature branch:
   ```bash
   git checkout -b feature/my-feature
   ```

5. Make your changes

6. Test thoroughly on macOS

7. Commit and push:
   ```bash
   git add .
   git commit -m "Description of changes"
   git push origin feature/my-feature
   ```

8. Open a Pull Request on GitHub

### Code Guidelines

**Swift Version**:
- Follow Swift naming conventions
- Use SwiftUI for all UI components
- Use async/await for asynchronous operations
- Document public APIs with Swift documentation comments
- Test on multiple macOS versions

**Electron Version**:
- Follow existing code style
- Use TypeScript
- Follow React best practices
- Test on macOS

### Reporting Issues

When reporting issues, include:
1. macOS version: `sw_vers`
2. App version (from About dialog)
3. Build method used
4. Error messages from Console.app or terminal
5. Steps to reproduce
6. Relevant log excerpts

## Additional Resources

### Documentation
- **Main README**: [README.md](README.md)
- **Swift README**: [README-SWIFT.md](README-SWIFT.md)
- **Swift Installation**: [INSTALL-SWIFT.md](INSTALL-SWIFT.md)
- **Official Docs**: [clashparty.org](https://clashparty.org)

### Related Projects
- **Mihomo Core**: [MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo)
- **Upstream Project**: [mihomo-party-org/clash-party](https://github.com/mihomo-party-org/clash-party)

### Community
- **Telegram Group**: [Mihomo Party Group](https://t.me/mihomo_party_group)
- **GitHub Issues**: [Zijinn/clash-party/issues](https://github.com/Zijinn/clash-party/issues)

### Performance Comparison

| Metric | Swift Version | Electron Version |
|--------|--------------|------------------|
| Startup Time | ~0.5s | ~5s |
| Memory Usage | ~50 MB | ~250 MB |
| CPU (Idle) | <1% | 1-3% |
| Energy Impact | Low | Medium |
| Platform | macOS only | Cross-platform |

### Version Recommendations

- **For macOS users**: Use Swift version for best performance
- **For cross-platform**: Use Electron version
- **For development**: Either version works well

---

**Last Updated**: December 2025  
**Repository**: [Zijinn/clash-party](https://github.com/Zijinn/clash-party)  
**License**: GPL-3.0

For more help, please open an issue or join the Telegram group.
