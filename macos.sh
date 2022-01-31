#!/usr/bin/env bash

ask () {
    # https://djm.me/ask
    local prompt default reply

    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -en "[${color_fg_light_blue} ${symbol_question}${color_clean}] $1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read reply </dev/tty

        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
echo "We close System Preferences to ensure that nothing will be overriden during execution."
osascript -e 'tell application "System Preferences" to quit'

echo "Please enter your administrator password upfront"
sudo -v

#
# System
#

echo "[System] Disable boot sound effects"
sudo nvram SystemAudioVolume=" "

if ask "[System] Do you want to set your computer's hostname (as done via System Preferences >> Sharing)?"; then
    local hostname
    while true; do
        echo -n "Hostname: "
        read hostname
        if [[ -z "$hostname" ]]; then
            echo "Invalid hostname"
            continue
        fi

        sudo scutil --set ComputerName $hostname
        sudo scutil --set HostName $hostname
        sudo scutil --set LocalHostName $hostname
        sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $hostname
        break
    done
fi

#
# General Settings
#

echo "[General Settings] Set language and text formata"
defaults write NSGlobalDomain AppleLanguages -array "en" "de"
defaults write NSGlobalDomain AppleLocale -string "en_DE@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

echo "[General Settings] Disable smart quotes and smart dashes"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool "false"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool "false"

echo "[General Settings] Disable automatic capitalization as it's annoying when typing code"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool "false"

echo "[General Settings] Disable automatic period substitution as it's annoying when typing code"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool "false"

echo "[General Settings] Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "[General Settings] Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

#
# Dock
#

echo "[Dock] Set position to \"bottom\""
defaults write com.apple.dock "orientation" -string "bottom"

echo "[Dock] Hide recent apps fromt the dock"
defaults write com.apple.dock "show-recents" -bool "false"

echo "[Dock] Set small tiles"
defaults write com.apple.dock "tilesize" -int "36"

echo "[Dock] Enable auto-hide"
defaults write com.apple.dock "autohide" -bool "true"

echo "[Dock] Set short autohide time"
defaults write com.apple.dock "autohide-time-modifier" -float "0.5"

echo "[Dock] Remove autohide delay - dock appears instantly"
defaults write com.apple.dock "autohide-delay" -float "0"

echo "[Dock] Don't group windows by application in Mission Control"
defaults write com.apple.dock "expose-group-by-app" -bool "false"

#
# Screenshots
#

echo "[Screenshot] Include data in filename"
defaults write com.apple.screencapture "include-date" -bool "true"

echo "[Screenshot] Set screenshot format to PNG"
defaults write com.apple.screencapture "type" -string "png"

#
# Finder
#

echo "[Finder] Set default save location to Disk, not iCloud:"
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"

echo "[Finder] Expand save panel by default"
defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode" -bool "true"
defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode2" -bool "true"

echo "[Finder] Expand print panel by default"
defaults write NSGlobalDomain "PMPrintingExpandedStateForPrint" -bool "true"
defaults write NSGlobalDomain "PMPrintingExpandedStateForPrint2" -bool "true"

echo "[Finder] Show all filename extensions in Finder"
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"

echo "[Finder] Show small icons in the sidebar"
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1"

echo "[Finder] Disable creation of icons on desktop"
defaults write com.apple.finder CreateDesktop -bool "false"

echo "[Finder] Disable icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool "false"

echo "[Finder] Show pathbar"
defaults write com.apple.finder ShowPathbar -bool "true"

echo "[Finder] Hide recent tags"
defaults write com.apple.finder ShowRecentTags -bool "false"

echo "[Finder] Hide iCloud items in sidebar"
defaults write com.apple.finder FXICloudDriveEnabled -bool "false"
defaults write com.apple.finder FXICloudDriveDesktop -bool "false"
defaults write com.apple.finder FXICloudDriveDocuments -bool "false"
defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool "false"
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool "false"

echo "[Finder] Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool "false"

echo "[Finder] Set list view as default view type"
defaults write com.apple.Finder FXPreferredViewStyle "Nlsv"

echo "[Finder] Allow text selection in Quick Look/Preview in Finder by default"
defaults write com.apple.finder QLEnableTextSelection -bool "true"

echo "[Finder] Disable creation of .DS_Store files for network stores"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"

echo "[Finder] Show the ~/Library folder"
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

echo "[Finder] Show the /Volumes folder"
sudo chflags nohidden /Volumes

#
# TextEdit
#

echo "[TextEdit] Disable \"Rich Text\""
defaults write com.apple.TextEdit "RichText" -bool "false"

echo "[TextEdit] Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

#
# Spotlight
#

echo "[Spotlight] Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before"
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

echo "[Spotlight] Disable local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal

#
# Time Machine
#

echo "[Time Machine] Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

#
# Other
#

echo "[Screensaver] Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "[UI] Disable transparency in the menu bar and elsewhere on Yosemite"
defaults write com.apple.universalaccess reduceTransparency -bool true

echo "[UI] Hide language menu in the top right corner of the boot screen"
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool "false"

echo "[Keyboard] Enable full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "[Photos] Disable Photos.app from starting everytime a device is plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool "true"

echo "[Printer] Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

#
# Chrome
#

echo "[Chrome] Disable the all too sensitive backswipe on trackpads"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.beta AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

echo "[Chrome] Disable the all too sensitive backswipe on Magic Mouse"
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.beta AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

echo "[Chrome] Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.beta DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

echo "[Chrome] Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.beta PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

#
# iTerm2
#

echo "[iTerm2] Don't display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

#
# Post-Process
#

echo "Kill affected applications"
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Google Chrome Canary" \
    "Google Chrome" \
    "Mail" \
    "Messages" \
    "Opera" \
    "Photos" \
    "Safari" \
    "SystemUIServer" \
    "Terminal" \
    "Transmission" \
    "Tweetbot" \
    "Twitter" \
    "iCal"; do
    killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

