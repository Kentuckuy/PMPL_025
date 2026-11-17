import 'package:flutter/services.dart';

class PlatformChannelService {
  const PlatformChannelService();

  static const MethodChannel _channel = MethodChannel(
    'com.example.app/battery',
  );

  Future<int> getBatteryLevel() async {
    final level = await _channel.invokeMethod<int>('getBatteryLevel');
    if (level == null || level < 0 || level > 100) {
      throw PlatformException(
        code: 'UNAVAILABLE',
        message: 'Level baterai tidak tersedia.',
      );
    }
    return level;
  }

  Future<void> showNativeToast({
    required String message,
    required bool isLong,
  }) async {
    final cleanMessage = message.trim();
    if (cleanMessage.isEmpty) {
      throw ArgumentError.value(
        message,
        'message',
        'Pesan tidak boleh kosong.',
      );
    }

    final shown = await _channel.invokeMethod<bool>('showToast', {
      'message': cleanMessage,
      'isLong': isLong,
    });
    if (shown != true) {
      throw PlatformException(
        code: 'TOAST_FAILED',
        message: 'Native Toast tidak dapat ditampilkan.',
      );
    }
  }
}
