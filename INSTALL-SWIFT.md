# Installation Guide - Clash Party Swift for macOS

This guide covers all the ways to install and use the native Swift version of Clash Party.

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Quick Start](#quick-start)
3. [Building from Source](#building-from-source)
4. [Installing Mihomo Core](#installing-mihomo-core)
5. [First-Time Setup](#first-time-setup)
6. [Troubleshooting](#troubleshooting)

## System Requirements

### Minimum Requirements
- **Operating System**: macOS 13.0 (Ventura) or later
- **Architecture**: Apple Silicon (M1/M2/M3) or Intel x64
- **RAM**: 256 MB available
- **Storage**: 50 MB for application + space for mihomo core

### Recommended
- macOS 14.0 (Sonoma) or later
- Apple Silicon for best performance
- 512 MB RAM available

### For Building from Source
- Xcode 15.0 or later
- Xcode Command Line Tools
- macOS SDK 13.0+

## Quick Start

### Option 1: Download Pre-built Release (Coming Soon)

Once releases are available:

1. Download the `.dmg` or `.app.zip` from [Releases](https://github.com/mihomo-party-org/clash-party/releases)
2. Open the downloaded file
3. Drag Clash Party to Applications folder
4. Right-click and select "Open" (first time only)
5. Grant necessary permissions when prompted

### Option 2: Build from Source (Current Method)

See [Building from Source](#building-from-source) section below.

## Building from Source

### Step 1: Install Prerequisites

1. **Install Xcode**:
   ```bash
   # From Mac App Store or:
   xcode-select --install
   ```

2. **Verify Installation**:
   ```bash
   xcodebuild -version
   # Should show: Xcode 15.0 or later
   ```

### Step 2: Clone Repository

```bash
git clone https://github.com/mihomo-party-org/clash-party.git
cd clash-party
```

### Step 3: Build the Application

**Option A: Using Xcode (Recommended for development)**

1. Open project:
   ```bash
   open ClashParty.xcodeproj
   ```

2. In Xcode:
   - Select "ClashParty" scheme
   - Choose "My Mac" as destination
   - Click Run (⌘R) or Product > Run

**Option B: Using build script**

```bash
./build-swift.sh
```

The script will:
- Clean previous builds
- Compile the application
- Show build output
- Offer to run the app

**Option C: Using Makefile**

```bash
# Build
make build

# Build and run
make run

# Build release version
make release

# Install to /Applications
make install
```

**Option D: Using xcodebuild directly**

```bash
xcodebuild -project ClashParty.xcodeproj \
  -scheme ClashParty \
  -configuration Release \
  -derivedDataPath .build \
  build
```

Built app will be at: `.build/Build/Products/Release/ClashParty.app`

### Step 4: Code Signing (Optional)

For distribution, you'll need to sign the app:

1. In Xcode, select project
2. Go to "Signing & Capabilities"
3. Select your team
4. Xcode will automatically sign the app

## Installing Mihomo Core

Clash Party requires the Mihomo (Clash Meta) core binary.

### Option 1: Homebrew (Recommended)

```bash
brew install mihomo
```

### Option 2: Download Binary

1. Download from [Mihomo Releases](https://github.com/MetaCubeX/mihomo/releases)
2. Choose the correct version:
   - Apple Silicon: `mihomo-darwin-arm64`
   - Intel Mac: `mihomo-darwin-amd64`
3. Rename to `mihomo` and make executable:
   ```bash
   mv mihomo-darwin-arm64 mihomo
   chmod +x mihomo
   ```
4. Place in one of these locations:
   - `/usr/local/bin/mihomo`
   - `/opt/homebrew/bin/mihomo`
   - `~/mihomo`

### Option 3: Bundle with App

For distribution, include mihomo in app bundle:

```bash
# Copy to Resources folder before building
cp /path/to/mihomo ClashParty/Resources/
```

## First-Time Setup

### 1. Launch the Application

```bash
open /Applications/ClashParty.app
# or from build directory:
open .build/Build/Products/Release/ClashParty.app
```

### 2. Grant Permissions

The app may request:
- **Network Access**: Required for proxy functionality
- **System Preferences**: For system proxy configuration

Click "Allow" when prompted.

### 3. Configure Profiles

**Method A: Add Subscription URL**
1. Go to Profiles tab
2. Click "Add Profile"
3. Enter profile name
4. Paste subscription URL
5. Click "Add"

**Method B: Import Local File**
1. Prepare a YAML config file
2. In Settings > Import Config
3. Select your config file

**Method C: Start with Default**
- App creates a default profile automatically
- Edit as needed in `~/Library/Application Support/ClashParty/config.yaml`

### 4. Start the Proxy

1. Go to Overview tab
2. Click "Start" button
3. Check status shows "Running"
4. Verify upload/download speeds appear

### 5. Configure System Proxy (Optional)

**Option A: In App**
1. Open Settings (⌘,)
2. Go to Proxy tab
3. Enable "Set as System Proxy"

**Option B: Manual**
1. Open System Settings
2. Network > Advanced > Proxies
3. Configure:
   - HTTP Proxy: 127.0.0.1:7890
   - HTTPS Proxy: 127.0.0.1:7890
   - SOCKS Proxy: 127.0.0.1:7891

## Configuration

### File Locations

- **Config Directory**: `~/Library/Application Support/ClashParty/`
- **Config File**: `~/Library/Application Support/ClashParty/config.yaml`
- **Profiles**: `~/Library/Application Support/ClashParty/profiles.json`
- **Logs**: Available in app Logs tab
- **Preferences**: Stored in UserDefaults

### Default Ports

- HTTP/HTTPS: 7890
- SOCKS: 7891
- Mixed: 7892
- Controller API: 9090

### Customization

Edit ports in Settings > Proxy tab or directly in config file.

## Troubleshooting

### App Won't Start

**Problem**: Application crashes on launch

**Solutions**:
1. Check Console.app for errors:
   - Open Console.app
   - Filter by "ClashParty"
   - Look for crash logs
2. Verify macOS version: `sw_vers`
3. Rebuild app: `make clean && make build`
4. Try removing preferences:
   ```bash
   defaults delete party.mihomo.app
   ```

### Mihomo Core Not Found

**Problem**: "Core executable not found" error

**Solutions**:
1. Verify mihomo is installed:
   ```bash
   which mihomo
   ls -la /usr/local/bin/mihomo
   ls -la /opt/homebrew/bin/mihomo
   ```
2. Make sure it's executable:
   ```bash
   chmod +x /path/to/mihomo
   ```
3. Check CoreManager.swift for expected paths

### System Proxy Not Working

**Problem**: System proxy settings don't apply

**Solutions**:
1. Grant necessary permissions:
   - System Settings > Privacy & Security
   - Allow Clash Party to modify network settings
2. Try manual proxy configuration
3. Check logs for permission errors
4. Restart app after granting permissions

### Build Errors

**Problem**: Xcode build fails

**Solutions**:

1. **"No such module" errors**:
   ```bash
   # Clean build folder
   rm -rf ~/Library/Developer/Xcode/DerivedData
   # Rebuild
   xcodebuild clean build
   ```

2. **Signing errors**:
   - In Xcode: Select project > Signing
   - Choose "Automatically manage signing"
   - Select your team

3. **Swift version issues**:
   ```bash
   swift --version
   # Should be 5.9 or later
   ```

### Connection Issues

**Problem**: Proxy not working

**Solutions**:
1. Verify mihomo is running:
   ```bash
   ps aux | grep mihomo
   ```
2. Check mihomo API:
   ```bash
   curl http://127.0.0.1:9090/version
   ```
3. Verify config file is valid:
   ```bash
   mihomo -t -d ~/Library/Application\ Support/ClashParty/
   ```
4. Check logs in app

### Performance Issues

**Problem**: High CPU or memory usage

**Solutions**:
1. Check Activity Monitor
2. Review number of active connections
3. Reduce log level in Settings
4. Disable unnecessary features
5. Restart core if needed

## Uninstallation

### Remove Application

```bash
rm -rf /Applications/ClashParty.app
```

### Remove Configuration

```bash
rm -rf ~/Library/Application\ Support/ClashParty/
defaults delete party.mihomo.app
```

### Remove Mihomo Core (if desired)

```bash
# If installed via Homebrew
brew uninstall mihomo

# If manually installed
rm /usr/local/bin/mihomo
rm /opt/homebrew/bin/mihomo
```

## Getting Help

### Resources
- **Documentation**: [README-SWIFT.md](README-SWIFT.md)
- **Original Docs**: [clashparty.org](https://clashparty.org)
- **GitHub Issues**: [Create an issue](https://github.com/mihomo-party-org/clash-party/issues)
- **Telegram**: [Mihomo Party Group](https://t.me/mihomo_party_group)

### Reporting Bugs

When reporting issues, include:
1. macOS version: `sw_vers`
2. App version (shown in About)
3. Error messages from Console.app
4. Steps to reproduce
5. Relevant log excerpts

### Debug Mode

Enable debug logging:
1. Build in Debug configuration
2. Logs will show in Xcode console
3. Also available in Console.app

## Next Steps

After installation:
1. Read [README-SWIFT.md](README-SWIFT.md) for features
2. Check [CHANGELOG-SWIFT.md](CHANGELOG-SWIFT.md) for updates
3. Configure your profiles
4. Join the community for support

---

**Note**: This Swift version is under active development. Some features from the Electron version may not yet be available. Check CHANGELOG-SWIFT.md for current status.
