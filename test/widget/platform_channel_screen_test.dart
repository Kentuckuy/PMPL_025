import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan_3/screens/platform_channel_screen.dart';
import 'package:pertemuan_3/services/platform_channel_service.dart';

class _FakePlatformChannelService extends PlatformChannelService {
  _FakePlatformChannelService({this.batteryLevel = 75});

  final int batteryLevel;
  String? sentMessage;
  bool? sentIsLong;

  @override
  Future<int> getBatteryLevel() async => batteryLevel;

  @override
  Future<void> showNativeToast({
    required String message,
    required bool isLong,
  }) async {
    sentMessage = message;
    sentIsLong = isLong;
  }
}

void main() {
  testWidgets('shows the battery level returned by the platform service', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlatformChannelScreen(
          service: _FakePlatformChannelService(batteryLevel: 63),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('batteryButton')));
    await tester.pumpAndSettle();

    expect(find.text('Level baterai saat ini: 63%'), findsOneWidget);
  });

  testWidgets('sends the entered identity and selected toast duration', (
    tester,
  ) async {
    final service = _FakePlatformChannelService();
    await tester.pumpWidget(
      MaterialApp(home: PlatformChannelScreen(service: service)),
    );
    await tester.enterText(
      find.byKey(const ValueKey('toastMessageField')),
      'NIM - Nama Uji',
    );
    await tester.tap(find.byKey(const ValueKey('isLongToastCheckbox')));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('showToastButton')));
    await tester.pumpAndSettle();

    expect(service.sentMessage, 'NIM - Nama Uji');
    expect(service.sentIsLong, isTrue);
    expect(find.text('Native Toast berhasil dikirim.'), findsOneWidget);
  });

  testWidgets('requires a message before calling the native channel', (
    tester,
  ) async {
    final service = _FakePlatformChannelService();
    await tester.pumpWidget(
      MaterialApp(home: PlatformChannelScreen(service: service)),
    );

    await tester.tap(find.byKey(const ValueKey('showToastButton')));
    await tester.pump();

    expect(find.text('Isi pesan dengan NIM dan nama Anda.'), findsOneWidget);
    expect(service.sentMessage, isNull);
  });
}
