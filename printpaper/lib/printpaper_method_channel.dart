import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'printpaper_platform_interface.dart';

/// An implementation of [PrintpaperPlatform] that uses method channels.
class MethodChannelPrintpaper extends PrintpaperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('printpaper');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
