import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmpl_025/services/platform_channel_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.example.app/battery');
  const service = PlatformChannelService();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('returns the native battery level', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'getBatteryLevel');
      return 82;
    });

    expect(await service.getBatteryLevel(), 82);
  });

  test('sends the toast message and duration flag to native', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'showToast');
      expect(call.arguments, {'message': 'NIM - Nama Uji', 'isLong': true});
      return true;
    });

    await service.showNativeToast(message: ' NIM - Nama Uji ', isLong: true);
  });

  test('rejects an unavailable battery result', () async {
    messenger.setMockMethodCallHandler(channel, (call) async => -1);

    await expectLater(
      service.getBatteryLevel(),
      throwsA(
        isA<PlatformException>().having(
          (error) => error.code,
          'code',
          'UNAVAILABLE',
        ),
      ),
    );
  });
}
