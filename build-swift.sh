#!/bin/bash
# Build script for Clash Party Swift version

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Clash Party Swift Build Script${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}Error: xcodebuild not found. Please install Xcode.${NC}"
    exit 1
fi

# Check if project exists
if [ ! -d "ClashParty.xcodeproj" ]; then
    echo -e "${RED}Error: ClashParty.xcodeproj not found.${NC}"
    exit 1
fi

# Configuration
SCHEME="ClashParty"
PROJECT="ClashParty.xcodeproj"
CONFIGURATION="${1:-Release}"
DERIVED_DATA=".build"

echo -e "${YELLOW}Configuration: ${CONFIGURATION}${NC}"
echo ""

# Clean previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
rm -rf "${DERIVED_DATA}"

# Build
echo -e "${YELLOW}Building Clash Party...${NC}"
xcodebuild -project "${PROJECT}" \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}" \
    -derivedDataPath "${DERIVED_DATA}" \
    build

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo ""
    echo -e "App location: ${DERIVED_DATA}/Build/Products/${CONFIGURATION}/ClashParty.app"
    echo ""
    
    # Ask if user wants to run the app
    read -p "Do you want to run the app now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "${DERIVED_DATA}/Build/Products/${CONFIGURATION}/ClashParty.app"
    fi
else
    echo ""
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
fi
