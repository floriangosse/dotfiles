#!/usr/bin/env bash

# Disable creation of .DS_Store files for network stores
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable creation of icons on desktop
defaults write com.apple.finder CreateDesktop -bool false

# Show pathbar
defaults write com.apple.finder ShowPathbar -bool true

# Set default save location to Disk, not iCloud:
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Hide recent tags
defaults write com.apple.finder ShowRecentTags -bool false

# Hide iCloud items in sidebar
defaults write com.apple.finder FXICloudDriveEnabled -bool false
defaults write com.apple.finder FXICloudDriveDesktop -bool false
defaults write com.apple.finder FXICloudDriveDocuments -bool false
defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool false
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool false

# Show all filename extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Kill affected applications
for app in Finder Dock SystemUIServer; do
    killall "$app" >/dev/null 2>&1;
done
