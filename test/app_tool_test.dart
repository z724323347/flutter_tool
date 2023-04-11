import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_tool/app_tool.dart';

void main() {
  const MethodChannel channel = MethodChannel('app_tool');

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
    expect(await AppTool.platformVersion, '42');
  });
}
