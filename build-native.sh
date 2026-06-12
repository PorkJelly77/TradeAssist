#!/bin/bash
# TradeAssist Capacitor build script
# Run from the TradeAssist-working-dashboard folder

set -e

PROJECT_DIR="$(dirname "$0")"
CAP_DIR="$PROJECT_DIR/capacitor-app"
WWW_DIR="$CAP_DIR/www"

echo "=== TradeAssist Build ==="

# Step 1: Copy updated web files
echo "[1/4] Copying web files..."
cp "$PROJECT_DIR/index.html" "$WWW_DIR/"
cp "$PROJECT_DIR/app.js" "$WWW_DIR/"
cp "$PROJECT_DIR/styles.css" "$WWW_DIR/"
cp "$PROJECT_DIR/manifest.json" "$WWW_DIR/"
cp "$PROJECT_DIR/icon-192.png" "$WWW_DIR/"
cp "$PROJECT_DIR/icon-512.png" "$WWW_DIR/"
echo "  Done"

# Step 2: Sync Capacitor
echo "[2/4] Syncing Capacitor..."
cd "$CAP_DIR"
npx cap sync 2>&1 | tail -5
echo "  Done"

# Step 3: Build Android APK
echo "[3/4] Building Android APK..."
cd "$CAP_DIR/android"
if command -v ./gradlew &> /dev/null; then
  ./gradlew assembleDebug 2>&1 | tail -5
  APK_PATH=$(find . -name "*.apk" -path "*/build/outputs/*" | head -1)
  if [ -n "$APK_PATH" ]; then
    echo "  APK created at: $APK_PATH"
    cp "$APK_PATH" "$PROJECT_DIR/TradeAssist.apk"
    echo "  Copied to: $PROJECT_DIR/TradeAssist.apk"
  fi
else
  echo "  gradlew not found — open in Android Studio to build"
fi

# Step 4: Done
echo "[4/4] Build complete!"
echo ""
echo "=== Files ==="
echo "Android project: $CAP_DIR/android/"
echo "iOS project:    $CAP_DIR/ios/"
echo "Web source:     $WWW_DIR/"
echo ""
echo "To build APK:"
echo "  Option A: Open $CAP_DIR/android/ in Android Studio → Build → Build APK"
echo "  Option B: cd $CAP_DIR/android && ./gradlew assembleDebug"
echo ""
echo "To build iOS:"
echo "  Open $CAP_DIR/ios/  in Xcode on a Mac"
