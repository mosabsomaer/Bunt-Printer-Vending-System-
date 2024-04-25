import 'package:flutter_test/flutter_test.dart';
import 'package:printpaper/printpaper.dart';
import 'package:printpaper/printpaper_platform_interface.dart';
import 'package:printpaper/printpaper_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPrintpaperPlatform
    with MockPlatformInterfaceMixin
    implements PrintpaperPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PrintpaperPlatform initialPlatform = PrintpaperPlatform.instance;

  test('$MethodChannelPrintpaper is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPrintpaper>());
  });

  test('getPlatformVersion', () async {
    Printpaper printpaperPlugin = Printpaper();
    MockPrintpaperPlatform fakePlatform = MockPrintpaperPlatform();
    PrintpaperPlatform.instance = fakePlatform;

    expect(await printpaperPlugin.getPlatformVersion(), '42');
  });
}
