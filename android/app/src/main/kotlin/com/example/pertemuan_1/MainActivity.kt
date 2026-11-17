package com.example.pertemuan_1

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.example.app/battery"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel in 0..100) {
                        result.success(batteryLevel)
                    } else {
                        result.error(
                            "UNAVAILABLE",
                            "Level baterai tidak tersedia.",
                            null
                        )
                    }
                }

                "showToast" -> {
                    val arguments = call.arguments as? Map<*, *>
                    val message = arguments?.get("message") as? String
                    val isLong = arguments?.get("isLong") as? Boolean ?: false

                    if (message.isNullOrBlank()) {
                        result.error(
                            "INVALID_ARGUMENT",
                            "Pesan Toast tidak boleh kosong.",
                            null
                        )
                    } else {
                        val duration = if (isLong) {
                            Toast.LENGTH_LONG
                        } else {
                            Toast.LENGTH_SHORT
                        }
                        Toast.makeText(applicationContext, message, duration).show()
                        result.success(true)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager =
                getSystemService(Context.BATTERY_SERVICE) as? BatteryManager
                    ?: return -1
            return batteryManager.getIntProperty(
                BatteryManager.BATTERY_PROPERTY_CAPACITY
            )
        }

        val batteryIntent = registerReceiver(
            null,
            IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        ) ?: return -1
        val level = batteryIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        val scale = batteryIntent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)

        if (level < 0 || scale <= 0) return -1
        return level * 100 / scale
    }
}
