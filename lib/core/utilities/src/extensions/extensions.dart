import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

/// Enum for supported platforms
enum PlatformType { android, ios, windows, linux, macos, fuchsia, web, unknown }

PlatformType getCurrentPlatform() {
  if (kIsWeb) return PlatformType.web;

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return PlatformType.android;
    case TargetPlatform.iOS:
      return PlatformType.ios;
    case TargetPlatform.macOS:
      return PlatformType.macos;
    case TargetPlatform.windows:
      return PlatformType.windows;
    case TargetPlatform.linux:
      return PlatformType.linux;
    case TargetPlatform.fuchsia:
      return PlatformType.fuchsia;
    }
}

bool get isAndroid => getCurrentPlatform() == PlatformType.android;
bool get isIos => getCurrentPlatform() == PlatformType.ios;
bool get isWeb => getCurrentPlatform() == PlatformType.web;
bool get isDesktop =>
    getCurrentPlatform() == PlatformType.windows ||
        getCurrentPlatform() == PlatformType.macos ||
        getCurrentPlatform() == PlatformType.linux;
