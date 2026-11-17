import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/platform_channel_service.dart';

class PlatformChannelScreen extends StatefulWidget {
  const PlatformChannelScreen({
    super.key,
    this.service = const PlatformChannelService(),
  });

  final PlatformChannelService service;

  @override
  State<PlatformChannelScreen> createState() => _PlatformChannelScreenState();
}

class _PlatformChannelScreenState extends State<PlatformChannelScreen> {
  final TextEditingController _messageController = TextEditingController();
  String _batteryStatus = 'Belum diketahui';
  bool _isLoadingBattery = false;
  bool _isShowingToast = false;
  bool _isLongToast = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _getBatteryLevel() async {
    setState(() {
      _isLoadingBattery = true;
      _batteryStatus = 'Membaca level baterai...';
    });

    try {
      final level = await widget.service.getBatteryLevel();
      if (!mounted) return;
      setState(() {
        _batteryStatus = 'Level baterai saat ini: $level%';
      });
    } on PlatformException catch (error) {
      if (!mounted) return;
      setState(() {
        _batteryStatus =
            'Gagal mengambil level baterai: ${error.message ?? error.code}';
      });
    } on MissingPluginException {
      if (!mounted) return;
      setState(() {
        _batteryStatus =
            'Platform Channel tidak tersedia. Jalankan aplikasi di Android.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingBattery = false);
      }
    }
  }

  Future<void> _showNativeToast() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      _showFeedback('Isi pesan dengan NIM dan nama Anda.', isError: true);
      return;
    }

    setState(() => _isShowingToast = true);
    try {
      await widget.service.showNativeToast(
        message: message,
        isLong: _isLongToast,
      );
      _showFeedback('Native Toast berhasil dikirim.', isError: false);
    } on PlatformException catch (error) {
      _showFeedback(
        'Gagal menampilkan Native Toast: ${error.message ?? error.code}',
        isError: true,
      );
    } on MissingPluginException {
      _showFeedback(
        'Platform Channel tidak tersedia. Jalankan aplikasi di Android.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isShowingToast = false);
      }
    }
  }

  void _showFeedback(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pertemuan 10: Platform Channel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.battery_charging_full,
                      size: 48,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _batteryStatus,
                      key: const ValueKey('batteryStatus'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      key: const ValueKey('batteryButton'),
                      onPressed: _isLoadingBattery ? null : _getBatteryLevel,
                      icon: _isLoadingBattery
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: const Text('Cek Level Baterai (Native)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Kirim Pesan ke Native Toast',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const ValueKey('toastMessageField'),
                      controller: _messageController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pesan Toast (isi NIM dan nama)',
                        hintText: 'Contoh: NIM - Nama Anda',
                      ),
                    ),
                    CheckboxListTile(
                      key: const ValueKey('isLongToastCheckbox'),
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Tampilkan lebih lama'),
                      value: _isLongToast,
                      onChanged: (value) {
                        setState(() => _isLongToast = value ?? false);
                      },
                    ),
                    FilledButton.icon(
                      key: const ValueKey('showToastButton'),
                      onPressed: _isShowingToast ? null : _showNativeToast,
                      icon: const Icon(Icons.notifications_active),
                      label: const Text('Tampilkan Native Toast'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
