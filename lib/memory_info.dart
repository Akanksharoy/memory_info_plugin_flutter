import 'dart:async';

import 'package:flutter/services.dart';

class MemoryInfo {
  static const MethodChannel _channel = const MethodChannel('memory_info');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<double> get getFreeMemoryInGB async {
    final double freeMemory = await _channel.invokeMethod('getFreeMemoryInGB');
    return freeMemory;
  }

  static Future<double> get getUsedMemoryInGB async {
    final double usedMemory = await _channel.invokeMethod('getUsedMemoryInGB');
    return usedMemory;
  }
}
