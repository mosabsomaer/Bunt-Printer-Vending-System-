
import 'printpaper_platform_interface.dart';

class Printpaper {
  Future<String?> getPlatformVersion() {
    return PrintpaperPlatform.instance.getPlatformVersion();
  }
}
