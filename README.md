# grayscale

An app that makes your Mac grayscale/color via accessibility with one click

**Compatible with macOS 10.14 Mojave through macOS 15.x Sequoia**

## Features

- **Silent toggle**: When Python 3 is available, the app toggles grayscale silently in the background without opening System Settings
- **Universal compatibility**: Falls back to GUI automation for systems without Python 3
- **One-click operation**: Simply run the app to toggle between grayscale and color

## Setup

1. Go to **System Settings > Accessibility > Display > Color Filters** and make sure the filter type is set to **Grayscale**
2. For the best experience (silent operation), ensure Python 3 is installed:
   - It comes pre-installed with Xcode Command Line Tools (`xcode-select --install`)
   - Or install via [python.org](https://python.org) or Homebrew (`brew install python3`)

## Requirements

- macOS 10.14 Mojave or later
- For GUI fallback mode: Accessibility permissions for the app in System Settings > Privacy & Security > Accessibility
