# DMG Packaging Guide for Clash Party Swift

This document provides detailed information about the DMG packaging system for the Swift macOS version of Clash Party.

## Overview

The DMG packaging system creates distributable disk images (.dmg) from the compiled ClashParty.app bundle. The system is designed to work both locally and in CI/CD environments.

## Components

### 1. create-dmg.sh

The main script for creating DMG files.

**Location:** `create-dmg.sh` (root directory)

**Usage:**
```bash
./create-dmg.sh [app_path] [version]
```

**Parameters:**
- `app_path` (optional): Path to the .app bundle. Default: `.build/Build/Products/Release/ClashParty.app`
- `version` (optional): Version string for the DMG filename. Default: `1.0.0`

**Features:**
- Automatic disk image sizing
- Applications symlink for easy installation
- Optional DMG appearance configuration (local only)
- UDZO compression for smaller file sizes
- SHA256 checksum generation
- Code signing support (via CODE_SIGN_IDENTITY environment variable)
- CI detection (skips GUI operations in CI)

**Output:**
- `.build/ClashParty-{version}-macOS.dmg`
- `.build/ClashParty-{version}-macOS.dmg.sha256`

### 2. scripts/get-version.sh

Extracts the version from the Xcode project.

**Location:** `scripts/get-version.sh`

**Usage:**
```bash
./scripts/get-version.sh
```

**Output:** Version string (e.g., `1.8.9`)

**Features:**
- Reads MARKETING_VERSION from `ClashParty.xcodeproj/project.pbxproj`
- Handles both quoted and unquoted values
- Falls back to `1.0.0` on errors

### 3. Makefile Targets

**make dmg**
- Creates DMG from existing build
- Automatically extracts version
- Requires app to be already built

**make release-dmg**
- Builds the app and creates DMG in one command
- Recommended for releases
- Equivalent to: `make build && make dmg`

### 4. GitHub Actions Integration

**Workflow:** `.github/workflows/build-swift.yml`

**Triggers:**
- Push to main, develop, or feature/swift-* branches
- Pull requests to main or develop
- Tags matching v* (e.g., v1.8.9)

**Steps:**
1. Build the Swift app
2. Extract version
3. Create DMG
4. Verify DMG creation
5. Upload artifacts (non-tag pushes)
6. Publish to releases (tag pushes)

## Local Development

### Building a DMG

**Option 1: All-in-one command**
```bash
make release-dmg
```

**Option 2: Step by step**
```bash
# Build first
make build

# Then create DMG
make dmg
```

**Option 3: Manual**
```bash
# Build
./build-swift.sh

# Get version
VERSION=$(./scripts/get-version.sh)

# Create DMG
./create-dmg.sh .build/Build/Products/Release/ClashParty.app $VERSION
```

### Testing the DMG

After creation:
```bash
# Open the DMG
open .build/ClashParty-*-macOS.dmg

# Verify checksum
cat .build/ClashParty-*-macOS.dmg.sha256
shasum -a 256 .build/ClashParty-*-macOS.dmg
```

### Code Signing

To sign the DMG:
```bash
export CODE_SIGN_IDENTITY="Developer ID Application: Your Name (TEAM_ID)"
make dmg
```

## CI/CD Usage

### Automatic DMG Creation

DMG is automatically created on:
- Every push to tracked branches
- Every pull request
- Every tag push

### Artifacts

For non-tag pushes, artifacts are uploaded:
- `ClashParty-macOS-ZIP-{sha}`: Contains .app.zip
- `ClashParty-macOS-DMG-{sha}`: Contains .dmg and .sha256

Retention: 7 days

### Releases

For tag pushes (v*):
- DMG and checksum are published to GitHub releases
- No artifacts uploaded (files go directly to release)

## DMG Appearance

The DMG is configured with:
- Volume name: "Clash Party"
- Window size: 600x400 pixels
- Icon size: 128 pixels
- Layout: App icon on left (150, 200), Applications link on right (450, 200)

**Note:** Appearance configuration only works in local builds with GUI access. In CI, the DMG is created without custom appearance but is still fully functional.

## Customization

### Adding a Background Image

1. Create a background image (e.g., `resources/dmg-background.png`)
   - Recommended size: 600x400 pixels
   - Format: PNG

2. Modify `create-dmg.sh`:
```bash
# Create .background directory
mkdir -p "$MOUNT_DIR/.background"
cp resources/dmg-background.png "$MOUNT_DIR/.background/background.png"

# Update AppleScript
set background picture of theViewOptions to file ".background:background.png"
```

### Changing DMG Layout

Modify the icon positions in `create-dmg.sh`:
```bash
set position of item "$APP_NAME.app" of container window to {x, y}
set position of item "Applications" of container window to {x, y}
```

### Changing Compression

Edit `create-dmg.sh`:
```bash
hdiutil convert "$DMG_TEMP_PATH" \
    -format UDZO \
    -imagekey zlib-level=9 \  # 9 = maximum compression
    -o "$DMG_PATH"
```

## Troubleshooting

### DMG Creation Fails

1. Check that the app exists:
   ```bash
   ls -la .build/Build/Products/Release/ClashParty.app
   ```

2. Check for mounted volumes:
   ```bash
   hdiutil info | grep "Clash Party"
   ```

3. Force unmount if needed:
   ```bash
   hdiutil detach "/Volumes/Clash Party" -force
   ```

4. Check disk space:
   ```bash
   df -h .build
   ```

### Version Extraction Fails

1. Check the project file:
   ```bash
   grep MARKETING_VERSION ClashParty.xcodeproj/project.pbxproj
   ```

2. Test the script:
   ```bash
   ./scripts/get-version.sh
   ```

3. Check script permissions:
   ```bash
   chmod +x scripts/get-version.sh
   ```

### CI Build Fails

1. Check workflow run logs
2. Verify all scripts are executable:
   ```bash
   git ls-files --stage | grep '100755'
   ```

3. Test locally in a clean environment

## Best Practices

1. **Always test locally** before pushing DMG changes
2. **Version bump** in Xcode project when releasing
3. **Tag releases** following semantic versioning (v1.2.3)
4. **Test installation** from the DMG on a clean system
5. **Verify checksums** match after download

## Version History

- **v1.0 (2025-12)**: Initial DMG packaging implementation
  - Basic DMG creation
  - CI/CD integration
  - Checksum generation
  - Release publishing

## Related Documentation

- [BUILD-MACOS.md](BUILD-MACOS.md) - General macOS build guide
- [README-SWIFT.md](README-SWIFT.md) - Swift version overview
- [INSTALL-SWIFT.md](INSTALL-SWIFT.md) - Installation instructions

## Support

For issues with DMG packaging:
1. Check this documentation
2. Review workflow logs in GitHub Actions
3. Open an issue with:
   - macOS version
   - Xcode version
   - Complete error messages
   - Steps to reproduce
