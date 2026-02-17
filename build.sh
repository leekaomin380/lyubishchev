#!/bin/bash
# Build script for Lyubishchev
# Uses Xcode's Swift toolchain for SwiftData macro support

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
XCODE_DEVELOPER="/Applications/Xcode.app/Contents/Developer"
XCODE_TOOLCHAIN="${XCODE_DEVELOPER}/Toolchains/XcodeDefault.xctoolchain"
MACOS_SDK="${XCODE_DEVELOPER}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

APP_NAME="Lyubishchev"
APP_BUNDLE="${SCRIPT_DIR}/${APP_NAME}.app"
BUILD_DMG=false

# Parse our flags, pass the rest to swift build
SWIFT_ARGS=()
for arg in "$@"; do
    if [ "$arg" = "--dmg" ]; then
        BUILD_DMG=true
    else
        SWIFT_ARGS+=("$arg")
    fi
done

# Step 1: Compile
echo "==> Building ${APP_NAME}..."
SDKROOT="${MACOS_SDK}" \
DEVELOPER_DIR="${XCODE_DEVELOPER}" \
TOOLCHAINS=com.apple.dt.toolchain.XcodeDefault \
"${XCODE_TOOLCHAIN}/usr/bin/swift" build \
    --package-path "${SCRIPT_DIR}" \
    -Xswiftc -sdk -Xswiftc "${MACOS_SDK}" \
    "${SWIFT_ARGS[@]}"

if [ $? -ne 0 ]; then
    echo "Build failed."
    exit 1
fi

# Step 2: Create .app bundle
echo "==> Packaging ${APP_NAME}.app..."
rm -rf "${APP_BUNDLE}"
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"

cp "${SCRIPT_DIR}/.build/debug/${APP_NAME}" "${APP_BUNDLE}/Contents/MacOS/${APP_NAME}"
cp "${SCRIPT_DIR}/Info.plist" "${APP_BUNDLE}/Contents/"

echo "==> Done: ${APP_BUNDLE}"
echo "    Run with: open ${APP_BUNDLE}"

# Step 3: Create DMG (optional, pass --dmg flag)
if [ "$BUILD_DMG" = true ]; then
    DMG_NAME="${APP_NAME}.dmg"
    DMG_PATH="${SCRIPT_DIR}/${DMG_NAME}"
    DMG_TEMP="${SCRIPT_DIR}/dmg_temp"

    echo "==> Creating ${DMG_NAME}..."
    rm -rf "${DMG_TEMP}" "${DMG_PATH}"
    mkdir -p "${DMG_TEMP}"
    cp -R "${APP_BUNDLE}" "${DMG_TEMP}/"
    ln -s /Applications "${DMG_TEMP}/Applications"

    hdiutil create -volname "${APP_NAME}" \
        -srcfolder "${DMG_TEMP}" \
        -ov -format UDZO \
        "${DMG_PATH}" > /dev/null 2>&1

    rm -rf "${DMG_TEMP}"
    echo "==> DMG created: ${DMG_PATH}"
fi
