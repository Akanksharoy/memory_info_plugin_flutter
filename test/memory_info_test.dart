import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_info/memory_info.dart';

void main() {
  const MethodChannel channel = MethodChannel('memory_info');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await MemoryInfo.platformVersion, '42');
  });
}
