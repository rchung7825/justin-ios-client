# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI iOS application built as an assistive communication device (AAC). It provides a button-based interface that plays audio files to help users communicate their needs and preferences.

## Build and Run

**Building the project:**
```bash
xcodebuild -project justin-ios-client2.xcodeproj -scheme justin-ios-client2 build
```

**Running tests:**
```bash
xcodebuild test -project justin-ios-client2.xcodeproj -scheme justin-ios-client2
```

**Opening in Xcode:**
```bash
open justin-ios-client2.xcodeproj
```

The project is configured to run on iOS devices and can be built/run directly from Xcode using the standard build (⌘B) and run (⌘R) commands.

## Architecture

### Core Components

**ContentView.swift** - The entire application is implemented in a single file containing:
- `ContentViewModel`: Manages pages, audio playback, and state
- `RingBuffer<T>`: Detects repeated button presses to trigger page navigation
- `ContentView`: Main view with page grid and navigation controls
- `NavigationButtons`: Left sidebar with up/down/top-menu navigation
- `PageGrid`: 2x4 button grid displaying current page items
- `GridStack`: Generic grid layout helper

### Application Flow

The app uses a **page-based navigation system** where:
- Pages are defined as 2D arrays in `ContentViewModel.pages`
- Current page index is tracked in `ContentView.currentPage`
- Default start page is page 2 (index 2), considered the "Top Menu"
- Users navigate between pages via:
  - Up/Down buttons (linear navigation through pages 0-5)
  - Long-press on certain buttons (e.g., "music" → page 1, "eat" → page 3)
  - Repeated short-presses (4 identical presses via RingBuffer detection)

### RingBuffer Pattern

The `RingBuffer` is used to detect when a user taps the same button 4 times in succession:
- When full and containing a single unique element, it triggers page navigation
- This provides an alternative to long-press for users with motor difficulties
- Buffer is cleared when returning to Top Menu

### Audio Resources

MP3 files are stored directly in the project root (not in a subdirectory) and must be:
- Named exactly as referenced in the `pages` array
- Included in the Xcode project's resource bundle
- Have the `.mp3` extension

Navigation sounds (up.mp3, down.mp3, top-menu.mp3) are special cases handled separately.

## Key Implementation Details

**Page Structure:**
- Page 0: Empty placeholder
- Page 1: Music options (super-simple-songs, coco-melon, etc.)
- Page 2: Top Menu - main navigation hub (eat, music, bathroom, drink, stop, toy, go, different)
- Page 3: Eat submenu (meal, snack, candy)
- Page 4: Drink submenu (water, juice)
- Page 5: Games (mario-kart, asphalt-6, mario-party)

**Gesture Handling:**
- Short press: Plays audio for the button
- Long press: Plays audio AND navigates to associated page (if configured)
- Both gestures use `simultaneousGesture` to avoid conflicts

**Version Tracking:**
The `build_version` constant in ContentViewModel tracks feature changes, displayed on the "Top Menu" button.

## Adding New Features

**Adding a new button/audio:**
1. Add the MP3 file to project root
2. Add to Xcode project (File → Add Files)
3. Add label to appropriate page in `ContentViewModel.pages`
4. Optionally add icon mapping to `imageNames` dictionary

**Adding a new page:**
1. Add new array to `ContentViewModel.pages`
2. Configure navigation logic in `playMP3AndSwitchPage` or ringBuffer detection
3. Ensure page index is accessible via up/down or button navigation

**Modifying navigation:**
Update the switch statements in:
- `ContentView.playMP3()` for ringBuffer-triggered navigation
- `ContentView.playMP3AndSwitchPage()` for long-press navigation
