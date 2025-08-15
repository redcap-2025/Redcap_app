# RedCap App Icon Setup Guide

## Overview
This guide explains how to set up the RedCap logo as the app icon for both Android and iOS platforms.

## Logo Files Created
- `assets/images/redcap_logo.svg` - Main logo for in-app use
- `assets/images/redcap_icon.svg` - Square icon for app store icons
- `assets/images/redcap_logo.png` - PNG version (placeholder)

## App Icon Requirements

### Android Icons
Required sizes for Android:
- `mipmap-mdpi/ic_launcher.png` - 48x48 px
- `mipmap-hdpi/ic_launcher.png` - 72x72 px
- `mipmap-xhdpi/ic_launcher.png` - 96x96 px
- `mipmap-xxhdpi/ic_launcher.png` - 144x144 px
- `mipmap-xxxhdpi/ic_launcher.png` - 192x192 px

### iOS Icons
Required sizes for iOS:
- 20x20, 29x29, 40x40, 58x58, 60x60, 76x76, 80x80, 87x87, 120x120, 152x152, 167x167, 180x180 px

## Setup Instructions

### Step 1: Generate PNG from SVG
1. Convert `assets/images/redcap_icon.svg` to PNG at 512x512 resolution
2. Ensure the PNG has a transparent background
3. Save as `assets/images/redcap_icon.png`

### Step 2: Generate App Icons
Use one of these methods:

#### Option A: Online Tool (Recommended)
1. Go to https://appicon.co/
2. Upload the 512x512 PNG icon
3. Download the generated icon set
4. Extract and place in appropriate folders

#### Option B: Flutter Icon Package
1. Install flutter_launcher_icons:
   ```bash
   flutter pub add --dev flutter_launcher_icons
   ```

2. Add configuration to pubspec.yaml:
   ```yaml
   dev_dependencies:
     flutter_launcher_icons: ^0.13.1

   flutter_launcher_icons:
     android: "launcher_icon"
     ios: true
     image_path: "assets/images/redcap_icon.png"
     min_sdk_android: 21
   ```

3. Generate icons:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   ```

### Step 3: Verify Installation
1. Clean and rebuild the app:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

2. Install on device to verify the icon appears correctly

## Current Implementation
- ✅ Logo integrated in splash screen
- ✅ Logo integrated in home screen welcome section
- ✅ App name updated to "RedCap"
- ✅ Google Maps API key placeholder added
- ⏳ App icons need to be generated and placed

## Notes
- The logo design features a red delivery vehicle with integrated "red" text
- The design is minimalist and recognizable at small sizes
- The color scheme uses red (#FF0000) on black background
- The logo is already integrated into the app UI components

## Troubleshooting
- If icons don't appear, ensure the PNG file is properly generated
- Check that icon files are placed in the correct directories
- Verify that the Android manifest references the correct icon name
- For iOS, ensure all required sizes are generated
