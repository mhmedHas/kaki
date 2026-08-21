package com.kaki_rfid.uhf_gold_shop

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import com.seuic.uhf.UHFService

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat


class MainActivity : FlutterActivity() {

    private var eventsSink: EventChannel.EventSink? = null
    private var receiver: BroadcastReceiver? = null
    private var uhfService: UHFService? = null

    private val CHANNEL_SCANNER = "seuic/scanner"
    private val CHANNEL_UHF = "com.seuic.uhf"
    private val CHANNEL_SCANNER_SDK = "com.seuic.scanner"
    private val CHANNEL_DEBUG = "debug/scanner"

    private val newPrinterBridge by lazy { NewPrinterBridge(this) }
    //private val printerBridge by lazy { PrinterBridge(this) }


    /*private lateinit var debugChannel: MethodChannel
    private fun debug(message: String) {
        Log.d("DEBUG_UI", message)

        runOnUiThread {
            try {
                debugChannel.invokeMethod("debug", message)
            } catch (_: Exception) {
            }
        }
    }*/

    private val scannerActions = listOf(
        "com.seuic.uhf.inventory.result",
        "com.seuic.uhf.read.result",
        "com.seuic.uhf.write.result",
        "com.seuic.uhf.tag.found",
        "com.seuic.uhf.epc.read",
        "android.intent.action.UHF_TAG_READ",
        "android.intent.action.UHF_INVENTORY",
        "com.android.server.scannerservice.broadcast",
        "com.seuic.scanner.decode",
        "com.android.scanner.service.scan",
        "com.seuic.scan.decode",
        "ACTION_BARCODE_SCAN",
        "com.seuic.scanner.action.DECODE",
        "com.seuic.scanner.broadcast",
        "com.seuic.uhf.scan",
        "com.seuic.uhf.ACTION",
        "seuic.intent.action.uhf.scan",
        "com.seuic.uhf.broadcast",
        "com.seuic.uhf.decode",
        "uhf.scan.result",
        "com.seuic.uhf.inventory",
        "com.seuic.uhf.tag.read",
        "com.seuic.uhf.action.INVENTORY",
        "com.seuic.uhf.action.READ",
        "com.seuic.broadcast",
        "com.seuic.decode",
        "seuic.broadcast.action",
        "android.intent.action.DECODE_DATA"
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val permissions = arrayOf(
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH_SCAN
            )

            val notGranted = permissions.filter {
                ActivityCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
            }

            if (notGranted.isNotEmpty()) {
                ActivityCompat.requestPermissions(this, notGranted.toTypedArray(), 1)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        /*debugChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "debug/channel"
        )

        debug("FlutterEngine Configured")*/

        // ✅ تهيئة UHF
        try {
            uhfService = UHFService.getInstance(this)
            val opened = uhfService?.open() ?: false

            if (opened) {
                //debug("✅ UHF Open Success")
                Log.d("UHF_INIT", "✅ UHFService initialized successfully")
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.seuic.uhf_status")
                    .invokeMethod("initStatus", "success")
            } else {
                //debug("❌ UHF Open Failed")
                Log.e("UHF_INIT", "❌ UHFService failed to open")
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.seuic.uhf_status")
                    .invokeMethod("initStatus", "failed")
            }
        } catch (e: Exception) {
            Log.e("UHF_INIT", "Failed to initialize UHFService: ${e.message}")
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.seuic.uhf_status")
                .invokeMethod("initStatus", "error")
        }

        // ✅ UHF Method Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_UHF)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "open" -> {
                        try {
                            val ok = uhfService?.open() ?: false
                            if (ok) {
                                Log.d("UHF_OPEN", "✅ UHFService opened successfully via SDK")
                            } else {
                                Log.w("UHF_OPEN", "⚠️ SDK open failed")
                            }
                            result.success(true)
                        } catch (e: Exception) {
                            Log.e("UHF_OPEN", "❌ Exception: ${e.message}")
                            result.success(false)
                        }
                    }
                    "close" -> {
                        uhfService?.close()
                        result.success(null)
                    }
                    "getPower" -> {
                        try {
                            val pwr = uhfService?.power ?: 0
                            result.success(pwr)
                        } catch (e: Exception) {
                            result.error("ERR", "Failed to get power: ${e.message}", null)
                        }
                    }
                    "setPower" -> {
                        Thread {
                            try {
                                val power = call.argument<Int>("power") ?: 0
                                var success = false

                                try {
                                    uhfService?.inventoryStop()
                                    Thread.sleep(200)
                                } catch (_: Exception) {}

                                if (uhfService?.isOpen != true) {
                                    uhfService?.open()
                                    Thread.sleep(200)
                                }

                                try {
                                    success = uhfService?.setPower(power) ?: false
                                    Log.d("UHF_POWER", "SDK setPower($power) => $success")
                                } catch (e: Exception) {
                                    Log.e("UHF_POWER", "SDK setPower failed", e)
                                }

                                runOnUiThread { result.success(success) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("ERR", "setPower failed", e.message) }
                            }
                        }.start()
                    }
                    else -> result.notImplemented()
                }
            }

        // ✅ Scanner SDK Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SCANNER_SDK)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "open" -> result.success(true)
                    "close" -> result.success(null)
                    "startScan" -> result.success(null)
                    "stopScan" -> result.success(null)
                    else -> result.notImplemented()
                }
            }

        // ✅ Scanner Event Channel (RFID/Barcode broadcasts)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SCANNER)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    Log.d("UHF_SCANNER", "EventChannel listener attached")
                    eventsSink = events
                    //debug("✅ EventChannel Listener Attached")
                }
                override fun onCancel(arguments: Any?) {
                    Log.d("UHF_SCANNER", "EventChannel listener cancelled")
                    eventsSink = null
                    //debug("❌ EventChannel Cancelled")
                }
            })


        // ✅ New Printer Bridge (NewPrinterBridge)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, NewPrinterBridge.EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    Log.d("NEW_PRINTER", "New printer status listener attached")
                    newPrinterBridge.setStatusSink(events)
                }
                override fun onCancel(arguments: Any?) {
                    Log.d("NEW_PRINTER", "New printer status listener cancelled")
                    newPrinterBridge.setStatusSink(null)
                }
            })

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NewPrinterBridge.METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scanBluetoothPrinters" -> result.success(newPrinterBridge.scanBluetoothPrinters())
                    "connectBluetooth" -> {
                        val mac = call.argument<String>("mac") ?: ""
                        result.success(newPrinterBridge.connectBluetooth(mac))
                    }
                    "printGoldLabel" -> {
                        val weight      = call.argument<String>("weight")
                        val carat       = call.argument<String>("carat")
                        val size        = call.argument<String>("size")
                        val showQr      = call.argument<String>("showQr")   ?: ""
                        val qrCode      = call.argument<String>("qrCode")   ?: ""
                        val customLogo  = call.argument<String>("customLogoBase64")
                        val labelLayout = call.argument<Any>("labelLayout")
                        result.success(newPrinterBridge.printGoldLabel(weight, carat, size, showQr, qrCode, customLogo, labelLayout))
                    }
                    "printBullionLabel" -> {
                        val weight      = call.argument<String>("weight")
                        val note1       = call.argument<String>("note1")
                        val note2       = call.argument<String>("note2")
                        val showQr      = call.argument<String>("showQr")   ?: ""
                        val qrCode      = call.argument<String>("qrCode")   ?: ""
                        val customLogo  = call.argument<String>("customLogoBase64")
                        val labelLayout = call.argument<Any>("labelLayout")
                        result.success(newPrinterBridge.printBullionLabel(weight, note1, note2, showQr, qrCode, customLogo, labelLayout))
                    }
                    "printGemLabel" -> {
                        val gemType     = call.argument<String>("gemType")
                        val note1       = call.argument<String>("note1")
                        val note2       = call.argument<String>("note2")
                        val showQr      = call.argument<String>("showQr")   ?: ""
                        val qrCode      = call.argument<String>("qrCode")   ?: ""
                        val customLogo  = call.argument<String>("customLogoBase64")
                        val labelLayout = call.argument<Any>("labelLayout")
                        result.success(newPrinterBridge.printGemLabel(gemType, note1, note2, showQr, qrCode, customLogo, labelLayout))
                    }
                    "disconnect" -> result.success(newPrinterBridge.disconnect())
                    "isConnected" -> result.success(newPrinterBridge.isConnected())
                    else -> result.notImplemented()
                }
            }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onStart() {
        super.onStart()
        Log.d("UHF_SCANNER", "Registering BroadcastReceiver with ${scannerActions.size} actions")

        if (receiver == null) {
            receiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent?) {
                    //debug("📩 Broadcast Received")
                    Log.d("UHF_SCANNER", "=== BROADCAST RECEIVED ===")
                    Log.d("UHF_SCANNER", "Action: ${intent?.action}")
                    //debug("Action = ${intent?.action}")
                    Log.d("UHF_SCANNER", "Package: ${intent?.`package`}")
                    Log.d("UHF_SCANNER", "Data: ${intent?.dataString}")

                    intent?.extras?.let { bundle ->
                        Log.d("UHF_SCANNER", "Extras found: ${bundle.size()}")
                        //debug("Extras Count = ${bundle.size()}")
                        for (key in bundle.keySet()) {
                            val value = bundle.get(key)
                            //debug("$key = $value")
                            Log.d("UHF_SCANNER", "  $key = $value (${value?.javaClass?.simpleName})")
                        }
                    } ?: Log.d("UHF_SCANNER","No Extras Found")

                    val code = extractCodeFromIntent(intent)
                    if (!code.isNullOrBlank()) {
                        Log.d("UHF_SCANNER", "✓ Extracted code: '$code'")
                        //debug("Extract Result = ${code ?: "NULL"}")
                        //debug("Sending EPC To Flutter")
                        eventsSink?.success(code)
                        //debug("EPC Sent")
                    } else {
                        //debug("❌ No EPC Found")
                        Log.w("UHF_SCANNER", "✗ No valid code found in broadcast")
                    }
                    Log.d("UHF_SCANNER", "=== END BROADCAST ===")
                }
            }

            val filter = IntentFilter().apply {
                scannerActions.forEach { action -> addAction(action) }
                priority = IntentFilter.SYSTEM_HIGH_PRIORITY
            }

            /*try {
                registerReceiver(receiver, filter)
                debug("✅ BroadcastReceiver Registered")
                Log.d("UHF_SCANNER", "✓ BroadcastReceiver registered successfully")
            } catch (e: Exception) {
                debug("❌ RegisterReceiver Failed : ${e.message}")
                Log.e("UHF_SCANNER", "✗ Failed to register BroadcastReceiver: ${e.message}")
            }*/
            try {
                val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {  // API 34
                    Context.RECEIVER_EXPORTED   // أو RECEIVER_EXPORTED حسب الحالة
                } else {
                    0
                }

                registerReceiver(receiver, filter, flags)

                //debug("✅ BroadcastReceiver Registered")
                Log.d("UHF_SCANNER", "✓ BroadcastReceiver registered successfully")
            } catch (e: Exception) {
                //debug("❌ RegisterReceiver Failed : ${e.message}")
                Log.e("UHF_SCANNER", "✗ Failed to register BroadcastReceiver: ${e.message}")
            }
        }
    }

    override fun onStop() {
        super.onStop()
        if (receiver != null) {
            unregisterReceiver(receiver)
            receiver = null
        }
    }

    private fun extractCodeFromIntent(intent: Intent?): String? {
        if (intent == null) return null

        val keys = listOf(
            "tag_epc", "epc_data", "uhf_epc", "inventory_epc", "read_epc",
            "tag_id", "uhf_tag_id", "inventory_tag", "read_tag",
            "scannerdata", "barcode_string", "barcodedata", "barcode", "data", "scan_data",
            "epc", "EPC", "tag_data", "uhf_data", "uhf_tag", "inventory_data", "read_data",
            "decode_data", "scan_result", "barcode_data", "scanner_data",
            "result", "content", "text", "value", "code", "scan_code", "barcode_result"
        )

        for (key in keys) {
            val value = intent.getStringExtra(key)
            if (!value.isNullOrBlank()) return value.trim()
        }

        for (key in keys) {
            val byteArray = intent.getByteArrayExtra(key)
            if (byteArray != null && byteArray.isNotEmpty()) {
                val value = String(byteArray).trim()
                if (value.isNotBlank()) return value
            }
        }

        intent.dataString?.let {
            if (it.isNotBlank()) return it.trim()
        }

        return null
    }
}