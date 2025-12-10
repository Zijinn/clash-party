#!/bin/bash
# Script to extract version from Xcode project file
# Usage: ./scripts/get-version.sh

set -e

PROJECT_FILE="ClashParty.xcodeproj/project.pbxproj"
DEFAULT_VERSION="1.0.0"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "$DEFAULT_VERSION"
    exit 0
fi

VERSION=$(grep -m1 'MARKETING_VERSION' "$PROJECT_FILE" | sed -e 's/.*= *"\?\([^"]*\)"\?;.*/\1/' | tr -d ' ' || echo "$DEFAULT_VERSION")

if [ -z "$VERSION" ]; then
    echo "$DEFAULT_VERSION"
else
    echo "$VERSION"
fi
