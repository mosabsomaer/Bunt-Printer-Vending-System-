import 'package:flutter/services.dart';

final MethodChannel _printingChannel = MethodChannel('123');

Future<void> printDocument() async {
  try {
    await _printingChannel.invokeMethod('printDocument');
  } catch (e) {
    // Handle any errors
  }
}