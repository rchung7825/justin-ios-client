# Apple Developer Program Setup

Artistic Icons (from Gemini) is in doc/ directory.
  - commit ca0b549378aaf3636b0b1edeef15cb68fa4d978f


## Step 1: Enroll in Apple Developer Program

1. Go to https://developer.apple.com/programs/enroll/
2. Sign in with your Apple ID
3. Complete enrollment ($99/year)
4. Wait for approval (usually 24-48 hours)

## Step 2: Configure Your App for Distribution

Once approved:

**In Xcode:**
1. Open `justin-ios-client2.xcodeproj`
2. Select project → Signing & Capabilities
3. Team: Select your developer account
4. Change Bundle Identifier if needed: `com.yourname.justin-ios-client2`

## Step 3: Choose Distribution Method

### Option A: TestFlight (Recommended for family/testers)

Build archive for TestFlight:

```bash
# Command line approach
xcodebuild -project justin-ios-client2.xcodeproj \
  -scheme justin-ios-client2 \
  -archivePath build/justin-ios-client2.xcarchive \
  archive
```

Or use Xcode GUI:
- Product → Archive
- Upload to App Store Connect
- TestFlight → Invite testers via email
- Up to 10,000 external testers
- No App Review required for internal testing

### Option B: App Store (Public distribution)

- Same archive process as TestFlight
- Submit for App Review (takes 1-3 days)
- Requires:
  - App description
  - Screenshots (various device sizes)
  - Privacy policy
  - App icon
  - Keywords and category

## Step 4: Building for Distribution

### Archive via Xcode GUI
1. Product → Archive
2. Window → Organizer
3. Select archive → Distribute App
4. Choose method (TestFlight or App Store)

### Archive via Command Line
```bash
# Clean build
xcodebuild clean -project justin-ios-client2.xcodeproj -scheme justin-ios-client2

# Archive
xcodebuild archive \
  -project justin-ios-client2.xcodeproj \
  -scheme justin-ios-client2 \
  -archivePath build/justin-ios-client2.xcarchive

# Export for TestFlight/App Store
xcodebuild -exportArchive \
  -archivePath build/justin-ios-client2.xcarchive \
  -exportPath build \
  -exportOptionsPlist ExportOptions.plist
```

## Next Steps After Enrollment

1. **Update Bundle ID**: Change from `rchung.justin-ios-client2` to your own
2. **App Icon**: Ensure Assets.xcassets has all required icon sizes
3. **Privacy Info**: Add privacy descriptions if app uses camera/microphone
4. **Screenshots**: Take screenshots for App Store listing
5. **App Description**: Write description for TestFlight/App Store

## Useful Links

- **App Store Connect**: https://appstoreconnect.apple.com
- **TestFlight**: https://developer.apple.com/testflight/
- **App Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/
- **Human Interface Guidelines**: https://developer.apple.com/design/human-interface-guidelines/
