import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'printpaper_method_channel.dart';

abstract class PrintpaperPlatform extends PlatformInterface {
  /// Constructs a PrintpaperPlatform.
  PrintpaperPlatform() : super(token: _token);

  static final Object _token = Object();

  static PrintpaperPlatform _instance = MethodChannelPrintpaper();

  /// The default instance of [PrintpaperPlatform] to use.
  ///
  /// Defaults to [MethodChannelPrintpaper].
  static PrintpaperPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PrintpaperPlatform] when
  /// they register themselves.
  static set instance(PrintpaperPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
