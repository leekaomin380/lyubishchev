#!/bin/bash
# Build script for Lyubishchev
# Uses Xcode's Swift toolchain for SwiftData macro support

XCODE_DEVELOPER="/Applications/Xcode.app/Contents/Developer"
XCODE_TOOLCHAIN="${XCODE_DEVELOPER}/Toolchains/XcodeDefault.xctoolchain"
MACOS_SDK="${XCODE_DEVELOPER}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

SDKROOT="${MACOS_SDK}" \
DEVELOPER_DIR="${XCODE_DEVELOPER}" \
TOOLCHAINS=com.apple.dt.toolchain.XcodeDefault \
"${XCODE_TOOLCHAIN}/usr/bin/swift" build \
    --package-path "$(dirname "$0")" \
    -Xswiftc -sdk -Xswiftc "${MACOS_SDK}" \
    "$@"
