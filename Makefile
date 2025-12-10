# Makefile for Clash Party Swift
# Build automation for the macOS Swift version

.PHONY: all build clean run test archive install dmg release-dmg help

# Variables
SCHEME = ClashParty
PROJECT = ClashParty.xcodeproj
CONFIGURATION = Release
DERIVED_DATA = .build
VERSION = $(shell ./scripts/get-version.sh)

# Default target
all: build

# Build the application
build:
	@echo "Building Clash Party for macOS..."
	xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-derivedDataPath $(DERIVED_DATA) \
		build

# Build for release
release:
	@echo "Building release version..."
	xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Release \
		-derivedDataPath $(DERIVED_DATA) \
		archive -archivePath $(DERIVED_DATA)/ClashParty.xcarchive

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(DERIVED_DATA)
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) clean

# Run the application
run: build
	@echo "Running Clash Party..."
	open $(DERIVED_DATA)/Build/Products/$(CONFIGURATION)/ClashParty.app

# Run tests (if any)
test:
	@echo "Running tests..."
	xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Debug \
		test

# Create archive for distribution
archive:
	@echo "Creating archive..."
	xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Release \
		archive -archivePath $(DERIVED_DATA)/ClashParty.xcarchive
	@echo "Archive created at: $(DERIVED_DATA)/ClashParty.xcarchive"

# Install to Applications folder
install: build
	@echo "Installing to /Applications..."
	cp -R $(DERIVED_DATA)/Build/Products/$(CONFIGURATION)/ClashParty.app /Applications/
	@echo "Installed successfully!"

# Create DMG package
dmg:
	@echo "Creating DMG package..."
	./create-dmg.sh $(DERIVED_DATA)/Build/Products/$(CONFIGURATION)/ClashParty.app $(VERSION)

# Build and create DMG in one command
release-dmg: build dmg
	@echo "Release DMG build complete!"

# Show help
help:
	@echo "Clash Party Swift - Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  all         - Build the application (default)"
	@echo "  build       - Build the application"
	@echo "  release     - Build release version"
	@echo "  clean       - Clean build artifacts"
	@echo "  run         - Build and run the application"
	@echo "  test        - Run tests"
	@echo "  archive     - Create archive for distribution"
	@echo "  install     - Install to /Applications"
	@echo "  dmg         - Create DMG package (requires built app)"
	@echo "  release-dmg - Build and create DMG in one step"
	@echo "  help        - Show this help message"
	@echo ""
	@echo "Usage:"
	@echo "  make [target]"
