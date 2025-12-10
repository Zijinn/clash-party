#!/bin/bash
# Script to create a DMG for the Clash Party Swift macOS application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Clash Party DMG Creator${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Variables
APP_NAME="ClashParty"
APP_PATH="${1:-.build/Build/Products/Release/ClashParty.app}"
VERSION="${2:-1.0.0}"
VOLUME_NAME="Clash Party"
DMG_NAME="ClashParty-${VERSION}-macOS"
DMG_PATH=".build/${DMG_NAME}.dmg"
DMG_TEMP_PATH=".build/${DMG_NAME}-temp.dmg"

# Check if app exists
if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}Error: Application not found at $APP_PATH${NC}"
    echo "Please build the application first or provide the app path as the first argument."
    exit 1
fi

echo -e "${BLUE}App Path:${NC} $APP_PATH"
echo -e "${BLUE}Version:${NC} $VERSION"
echo -e "${BLUE}DMG Name:${NC} $DMG_NAME.dmg"
echo ""

# Create a temporary directory for DMG contents
echo -e "${YELLOW}Creating temporary directory...${NC}"
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Copy the app to temp directory
echo -e "${YELLOW}Copying application...${NC}"
cp -R "$APP_PATH" "$TMP_DIR/"

# Create a symbolic link to /Applications
echo -e "${YELLOW}Creating Applications symlink...${NC}"
ln -s /Applications "$TMP_DIR/Applications"

# Calculate the size of the content
echo -e "${YELLOW}Calculating DMG size...${NC}"
SIZE=$(du -sk "$TMP_DIR" | cut -f1)
SIZE=$((SIZE / 1024 + 50))  # Add 50MB for padding

# Remove old DMG if exists
if [ -f "$DMG_TEMP_PATH" ]; then
    echo -e "${YELLOW}Removing old temporary DMG...${NC}"
    rm -f "$DMG_TEMP_PATH"
fi

if [ -f "$DMG_PATH" ]; then
    echo -e "${YELLOW}Removing old DMG...${NC}"
    rm -f "$DMG_PATH"
fi

# Create the DMG
echo -e "${YELLOW}Creating temporary DMG...${NC}"
hdiutil create -srcfolder "$TMP_DIR" \
    -volname "$VOLUME_NAME" \
    -fs HFS+ \
    -fsargs "-c c=64,a=16,e=16" \
    -format UDRW \
    -size ${SIZE}m \
    "$DMG_TEMP_PATH"

# Mount the DMG
echo -e "${YELLOW}Mounting DMG...${NC}"
MOUNT_DIR=$(hdiutil attach "$DMG_TEMP_PATH" -readwrite -noverify -noautoopen | grep -E '^/dev/' | sed 1q | awk '{print $3}')

if [ -z "$MOUNT_DIR" ]; then
    echo -e "${RED}Error: Failed to mount DMG${NC}"
    exit 1
fi

echo -e "${BLUE}Mounted at:${NC} $MOUNT_DIR"

# Configure the DMG appearance using AppleScript (only if not in CI)
if [ -z "$CI" ]; then
    echo -e "${YELLOW}Configuring DMG appearance...${NC}"
    osascript <<EOT
tell application "Finder"
    tell disk "$VOLUME_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, 700, 500}
        set theViewOptions to the icon view options of container window
        set arrangement of theViewOptions to not arranged
        set icon size of theViewOptions to 128
        
        -- Position the app icon
        set position of item "$APP_NAME.app" of container window to {150, 200}
        
        -- Position the Applications link
        set position of item "Applications" of container window to {450, 200}
        
        close
        open
        update without registering applications
        delay 2
    end tell
end tell
EOT

    # Give the system time to finish
    sleep 3
else
    echo -e "${YELLOW}Skipping DMG appearance configuration (CI environment)${NC}"
    sleep 1
fi

# Unmount the DMG
echo -e "${YELLOW}Unmounting DMG...${NC}"
hdiutil detach "$MOUNT_DIR" -force || true
sync
sleep 2

# Convert to compressed read-only DMG
echo -e "${YELLOW}Converting to compressed DMG...${NC}"
hdiutil convert "$DMG_TEMP_PATH" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$DMG_PATH"

# Remove temporary DMG
rm -f "$DMG_TEMP_PATH"

# Sign the DMG if code signing identity is available
if [ -n "$CODE_SIGN_IDENTITY" ]; then
    echo -e "${YELLOW}Signing DMG with identity: $CODE_SIGN_IDENTITY${NC}"
    codesign --sign "$CODE_SIGN_IDENTITY" \
        --force \
        --timestamp \
        --options runtime \
        "$DMG_PATH" || echo -e "${YELLOW}Warning: Code signing failed, continuing...${NC}"
fi

# Calculate checksum
echo -e "${YELLOW}Generating checksum...${NC}"
if command -v shasum &> /dev/null; then
    CHECKSUM=$(shasum -a 256 "$DMG_PATH" | awk '{print $1}')
    echo "$CHECKSUM  $(basename "$DMG_PATH")" > "$DMG_PATH.sha256"
    echo -e "${BLUE}SHA256:${NC} $CHECKSUM"
fi

echo ""
echo -e "${GREEN}✓ DMG created successfully!${NC}"
echo ""
echo -e "${BLUE}DMG Location:${NC} $DMG_PATH"
if [ -f "$DMG_PATH.sha256" ]; then
    echo -e "${BLUE}Checksum File:${NC} $DMG_PATH.sha256"
fi

# Get file size
if command -v stat &> /dev/null; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        SIZE_BYTES=$(stat -f%z "$DMG_PATH")
    else
        SIZE_BYTES=$(stat -c%s "$DMG_PATH")
    fi
    SIZE_MB=$((SIZE_BYTES / 1024 / 1024))
    echo -e "${BLUE}File Size:${NC} ${SIZE_MB}MB"
fi

echo ""
echo -e "${GREEN}You can now test the DMG by opening it:${NC}"
echo -e "  open $DMG_PATH"
echo ""
