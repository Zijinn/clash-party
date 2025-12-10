#!/bin/bash

# Extract version from Xcode project file
VERSION=$(grep -m 1 "MARKETING_VERSION" ClashParty.xcodeproj/project.pbxproj | sed 's/.*MARKETING_VERSION = \(.*\);/\1/' | tr -d ' ')

if [ -z "$VERSION" ]; then
    echo "1.8.9"
else
    echo "$VERSION"
fi
