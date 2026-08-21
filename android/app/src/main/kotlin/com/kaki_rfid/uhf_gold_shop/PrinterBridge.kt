//
///*package com.kaki_rfid.uhf_gold_shop
//
//import android.Manifest
//import android.app.Application
//import android.bluetooth.BluetoothAdapter
//import android.bluetooth.BluetoothDevice
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import android.content.IntentFilter
//import android.content.SharedPreferences
//import android.os.Handler
//import android.os.Looper
//import android.util.Log
//import android.graphics.Bitmap
//import android.graphics.BitmapFactory
//import android.graphics.Canvas
//import android.graphics.Color
//import android.graphics.Paint
//import android.graphics.ColorMatrix
//import android.graphics.ColorMatrixColorFilter
//import java.io.ByteArrayOutputStream
//import androidx.annotation.RequiresPermission
//import com.gengcon.www.jcprintersdk.JCPrintApi
//import com.gengcon.www.jcprintersdk.callback.Callback
//import com.gengcon.www.jcprintersdk.callback.PrintCallback
//import com.gengcon.www.jcprintersdk.bean.PaperInfo
//import io.flutter.plugin.common.EventChannel
//import org.json.JSONArray
//import org.json.JSONObject
//import kotlin.text.Charsets
//import java.util.HashMap
//import android.util.Base64
//
//// ====================================================================
////  LabelLayout Helper  –  يقرأ التخطيط المحفوظ من Flutter SharedPrefs
//// ====================================================================
//data class ElementPos(
//    val x: Float, val y: Float,
//    val w: Float, val h: Float,
//    val fontSize: Float = 3f,
//    val rotation: Int = 0,
//    val visible: Boolean = true
//)
//
//class LabelLayoutReader(private val prefs: SharedPreferences) {
//
//    /** يجيب التخطيط الكامل لنوع الاستيكر. لو مفيش محفوظ يرجع null فنستخدم الافتراضي */
//    private fun getLayout(labelType: String): JSONObject? {
//        // Flutter بيحفظها بـ key  "flutter.label_layout_<type>"
//        val raw = prefs.getString("flutter.label_layout_$labelType", null) ?: return null
//        return try { JSONObject(raw) } catch (e: Exception) { null }
//    }
//
//    fun getElement(labelType: String, elementId: String): ElementPos? {
//        val layout = getLayout(labelType) ?: return null
//        val elements = layout.optJSONArray("elements") ?: return null
//        for (i in 0 until elements.length()) {
//            val el = elements.optJSONObject(i) ?: continue
//            if (el.optString("id") == elementId) {
//                return ElementPos(
//                    x        = el.optDouble("x", 0.0).toFloat(),
//                    y        = el.optDouble("y", 0.0).toFloat(),
//                    w        = el.optDouble("w", 10.0).toFloat(),
//                    h        = el.optDouble("h", 5.0).toFloat(),
//                    fontSize = el.optDouble("fontSize", 3.0).toFloat(),
//                    rotation = el.optInt("rotation", 0),
//                    visible  = el.optBoolean("visible", true)
//                )
//            }
//        }
//        return null
//    }
//
//    fun getStickerSize(labelType: String): Pair<Float, Float> {
//        val layout = getLayout(labelType) ?: return Pair(50f, 30f)
//        return Pair(
//            layout.optDouble("stickerW", 50.0).toFloat(),
//            layout.optDouble("stickerH", 30.0).toFloat()
//        )
//    }
//}
//
//class PrinterBridge(private val context: Context) {
//
//    private val TAG = "Niimbot_Original"
//    private var statusSink: EventChannel.EventSink? = null
//    private val api: JCPrintApi
//    private val prefs: SharedPreferences
//    // SharedPrefs الخاصة بـ Flutter (اسمها ثابت)
//    private val flutterPrefs: SharedPreferences by lazy {
//        context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
//    }
//    private val layoutReader: LabelLayoutReader by lazy {
//        LabelLayoutReader(flutterPrefs)
//    }
//    private var isPrinterConnected: Boolean = false
//
//    init {
//        prefs = context.getSharedPreferences("printer_prefs", Context.MODE_PRIVATE)
//
//        val callback = object : Callback {
//            override fun onConnectSuccess(address: String?, type: Int) {
//                isPrinterConnected = true
//                address?.let { saveLastPrinter(it) }
//                sendStatus("connected", "متصل بـ $address")
//            }
//            override fun onDisConnect() {
//                isPrinterConnected = false
//                sendStatus("disconnected", "تم قطع الاتصال")
//            }
//            override fun onElectricityChange(powerLevel: Int) {}
//            override fun onCoverStatus(coverStatus: Int) {}
//            override fun onPaperStatus(paperStatus: Int) {}
//            override fun onRfidReadStatus(rfidReadStatus: Int) {}
//            override fun onRibbonRfidReadStatus(ribbonRfidReadStatus: Int) {}
//            override fun onRibbonStatus(ribbonStatus: Int) {}
//            override fun onFirmErrors() {}
//        }
//
//        api = JCPrintApi.getInstance(callback)
//        api.initSdk(context.applicationContext as Application)
//
//        val fontInitResult = api.initDefaultImageLibrarySettings(
//            "fonts/NotoSansArabic-Bold.ttf",
//            "fonts/NotoSansArabic-Regular.ttf"
//        )
//        if (fontInitResult != 0) {
//            Log.e(TAG, "Failed to init image library: $fontInitResult")
//            sendStatus("error", "فشل تهيئة الخطوط: $fontInitResult")
//        } else {
//            Log.d(TAG, "Image library initialized with Arabic font")
//        }
//
//        sendStatus("initialized", "Niimbot جاهزة 100%")
//    }
//
//    fun setPrintStatusSink(sink: EventChannel.EventSink?) {
//        statusSink = sink
//        val lastMac = getLastPrinter()
//        if (lastMac.isNotEmpty()) {
//            sendStatus("auto_connecting", "جاري الاتصال التلقائي...")
//            connectBluetooth(lastMac)
//        }
//    }
//
//    @RequiresPermission(allOf = [Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.ACCESS_FINE_LOCATION])
//    fun scanBluetoothPrinters(): List<Map<String, String>> {
//        val adapter = BluetoothAdapter.getDefaultAdapter() ?: return emptyList()
//        if (!adapter.isEnabled) return emptyList()
//
//        val discoveredDevices = mutableSetOf<BluetoothDevice>()
//
//        val discoveryReceiver = object : BroadcastReceiver() {
//            override fun onReceive(ctx: Context, intent: Intent) {
//                if (BluetoothDevice.ACTION_FOUND == intent.action) {
//                    val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
//                    device?.let { if (isPrinterDevice(it)) discoveredDevices.add(it) }
//                }
//            }
//        }
//
//        context.registerReceiver(discoveryReceiver, IntentFilter(BluetoothDevice.ACTION_FOUND))
//        adapter.startDiscovery()
//        val startTime = System.currentTimeMillis()
//        while (System.currentTimeMillis() - startTime < 3000) { Thread.sleep(500) }
//        adapter.cancelDiscovery()
//        context.unregisterReceiver(discoveryReceiver)
//
//        val bonded = adapter.bondedDevices
//            .filter { isPrinterDevice(it) }
//            .map { mapOf("name" to (it.name ?: "Niimbot"), "address" to it.address) }
//        val discovered = discoveredDevices.map { mapOf("name" to (it.name ?: "Niimbot"), "address" to it.address) }
//
//        return (bonded + discovered).distinctBy { it["address"] }
//    }
//
//    private fun isPrinterDevice(device: BluetoothDevice): Boolean {
//        val name = device.name ?: return false
//        return listOf("Niimbot","B21","itel","B1","M2","B18","B3S","C1")
//            .any { name.contains(it, ignoreCase = true) }
//    }
//
//    fun connectBluetooth(mac: String): Boolean {
//        if (isPrinterConnected) {
//            sendStatus("already_connected", "الطابعة متصلة بالفعل")
//            return true
//        }
//        sendStatus("connecting", "جاري الاتصال بـ $mac...")
//        val result = api.connectBluetoothPrinter(mac)
//        return if (result == 0) {
//            saveLastPrinter(mac)
//            sendStatus("connected", "تم الاتصال بنجاح")
//            true
//        } else {
//            sendStatus("error", "فشل الاتصال: $result")
//            false
//        }
//    }
//
//    fun isConnected(): Boolean = isPrinterConnected
//
//    private fun saveLastPrinter(mac: String) {
//        prefs.edit().putString("last_printer_mac", mac).apply()
//    }
//
//    private fun getLastPrinter(): String {
//        return prefs.getString("last_printer_mac", "") ?: ""
//    }
//
//    fun disconnectPrinter(): Boolean {
//        return try {
//            api.close()
//            isPrinterConnected = false
//            sendStatus("disconnected", "تم فصل الطابعة")
//            true
//        } catch (e: Exception) {
//            sendStatus("error", "فشل فصل الطابعة: ${e.message}")
//            false
//        }
//    }
//
//    // ====================================================================
//    //  ensureConnected  –  مشترك لكل دوال الطباعة
//    // ====================================================================
//    private fun ensureConnected(): Boolean {
//        if (isConnected()) return true
//        val lastMac = getLastPrinter()
//        if (lastMac.isEmpty()) {
//            sendStatus("error", "لا توجد طابعة محفوظة، اتصل أولاً")
//            return false
//        }
//        api.close()
//        Thread.sleep(300)
//        val result = api.connectBluetoothPrinter(lastMac)
//        if (result != 0) {
//            sendStatus("error", "اتصل بالطباعة يدويا او اعد تشغيل الطابعة")
//            return false
//        }
//        return true
//    }
//
//    // ====================================================================
//    //  printGoldLabel  –  يقرأ الإحداثيات من التخطيط المحفوظ
//    // ====================================================================
//    fun printGoldLabel(
//        weight: String? = null, carat: String? = null,
//        size: String? = null, showQr: String, qrCode: String,
//        customLogoBase64: String? = null
//    ): Boolean {
//        if (!ensureConnected()) return false
//
//        return try {
//            val paperInfo = api.getPaperInfo()
//            if (paperInfo.state != 0) {
//                sendStatus("error", "فشل في قراءة نوع الورق: ${paperInfo.state}")
//                return false
//            }
//
//            val lr = layoutReader
//            val (sW, sH) = lr.getStickerSize("gold")
//
//            api.drawEmptyLabel(sW, sH, 0,
//                listOf("NotoSansArabic-Bold.ttf", "NotoSansArabic-Regular.ttf"))
//
//            // ===== نص رقم الـ QR =====
//            val qrTextEl = lr.getElement("gold", "qrCode_text")
//                ?: ElementPos(13f, 3.2f, 20f, 2.8f, 2.8f)
//            if (qrTextEl.visible) {
//                api.drawLabelText(
//                    qrTextEl.x, qrTextEl.y, qrTextEl.w, qrTextEl.h,
//                    qrCode, "NotoSansArabic-Bold.ttf",
//                    qrTextEl.fontSize, qrTextEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false)
//                )
//            }
//
//            // ===== الوزن =====
//            val weightEl = lr.getElement("gold", "weight")
//                ?: ElementPos(35f, 13f, 12f, 3f, 3f, 270)
//            if (!weight.isNullOrBlank() && weightEl.visible) {
//                api.drawLabelText(
//                    weightEl.x, weightEl.y, weightEl.w, weightEl.h,
//                    " W$weight", "NotoSansArabic-Bold.ttf",
//                    weightEl.fontSize, weightEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false)
//                )
//            }
//
//            // ===== العيار =====
//            val caratEl = lr.getElement("gold", "carat")
//                ?: ElementPos(38f, 13f, 12f, 3f, 3f, 270)
//            if (!carat.isNullOrBlank() && caratEl.visible) {
//                api.drawLabelText(
//                    caratEl.x, caratEl.y, caratEl.w, caratEl.h,
//                    " K$carat", "NotoSansArabic-Bold.ttf",
//                    caratEl.fontSize, caratEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false)
//                )
//            }
//
//            // ===== المقاس =====
//            val sizeEl = lr.getElement("gold", "size")
//                ?: ElementPos(41f, 13f, 12f, 3f, 3f, 270)
//            if (!size.isNullOrBlank() && sizeEl.visible) {
//                api.drawLabelText(
//                    sizeEl.x, sizeEl.y, sizeEl.w, sizeEl.h,
//                    " S$size", "NotoSansArabic-Bold.ttf",
//                    sizeEl.fontSize, sizeEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false)
//                )
//            }
//
//            if (showQr == "true") {
//                // ===== QR =====
//                val qrEl = lr.getElement("gold", "qr")
//                    ?: ElementPos(31f, 12f, 7f, 7f)
//                if (qrEl.visible) {
//                    api.drawLabelQrCode(qrEl.x, qrEl.y, qrEl.w, qrEl.h, qrCode, 31, 2)
//                }
//                // ===== اللوجو (مع QR) =====
//                val logoEl = lr.getElement("gold", "logo")
//                    ?: ElementPos(35f, 0.5f, 12f, 10f)
//                if (!customLogoBase64.isNullOrBlank() && logoEl.visible) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, logoEl.x, logoEl.y, logoEl.w, logoEl.h, 0, 1, 127f)
//                    } catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            } else {
//                // ===== Barcode =====
//                val barcodeEl = lr.getElement("gold", "barcode")
//                    ?: ElementPos(2f, 12f, 17f, 7.2f)
//                if (barcodeEl.visible) {
//                    api.drawLabelBarCode(barcodeEl.x, barcodeEl.y, barcodeEl.w, barcodeEl.h,
//                        20, qrCode, 0.25f, 0, 2f, 2)
//                }
//                // ===== اللوجو (مع Barcode) =====
//                val logoBarEl = lr.getElement("gold", "logo_bar")
//                    ?: ElementPos(31f, 11f, 8f, 8f)
//                if (!customLogoBase64.isNullOrBlank() && logoBarEl.visible) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, logoBarEl.x, logoBarEl.y, logoBarEl.w, logoBarEl.h, 0, 1, 127f)
//                    } catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            }
//
//            val jsonBytes = api.generateLabelJson()
//            startPrinting(String(jsonBytes, Charsets.UTF_8), paperInfo)
//        } catch (e: Exception) {
//            sendStatus("error", "فشل في بناء الليبل: ${e.message}")
//            false
//        }
//    }
//
//    // ====================================================================
//    //  printBullionLabel
//    // ====================================================================
//    fun printBullionLabel(
//        weight: String? = null, note1: String? = null,
//        note2: String? = null, showQr: String, qrCode: String,
//        customLogoBase64: String? = null
//    ): Boolean {
//        if (!ensureConnected()) return false
//
//        return try {
//            val paperInfo = api.getPaperInfo()
//            if (paperInfo.state != 0) {
//                sendStatus("error", "فشل في قراءة نوع الورق: ${paperInfo.state}")
//                return false
//            }
//
//            val lr = layoutReader
//            val (sW, sH) = lr.getStickerSize("bullion")
//
//            api.drawEmptyLabel(sW, sH, 0,
//                listOf("NotoSansArabic-Bold.ttf", "NotoSansArabic-Regular.ttf"))
//
//            // نص QR
//            val qrTextEl = lr.getElement("bullion", "qrCode_text")
//                ?: ElementPos(13f, 3.2f, 20f, 2.8f, 2.8f)
//            if (qrTextEl.visible) {
//                api.drawLabelText(qrTextEl.x, qrTextEl.y, qrTextEl.w, qrTextEl.h,
//                    qrCode, "NotoSansArabic-Bold.ttf",
//                    qrTextEl.fontSize, qrTextEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // الوزن
//            val weightEl = lr.getElement("bullion", "weight")
//                ?: ElementPos(39f, 11f, 11f, 3f, 3f)
//            if (!weight.isNullOrBlank() && weightEl.visible) {
//                api.drawLabelText(weightEl.x, weightEl.y, weightEl.w, weightEl.h,
//                    "W $weight", "NotoSansArabic-Bold.ttf",
//                    weightEl.fontSize, weightEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // note1
//            val note1El = lr.getElement("bullion", "note1")
//                ?: ElementPos(39f, 14f, 11f, 4f, 4f)
//            if (!note1.isNullOrBlank() && note1El.visible) {
//                api.drawLabelText(note1El.x, note1El.y, note1El.w, note1El.h,
//                    note1, "NotoSansArabic-Bold.ttf",
//                    note1El.fontSize, note1El.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // note2
//            val note2El = lr.getElement("bullion", "note2")
//                ?: ElementPos(39f, 18f, 11f, 4f, 4f)
//            if (!note2.isNullOrBlank() && note2El.visible) {
//                api.drawLabelText(note2El.x, note2El.y, note2El.w, note2El.h,
//                    note2, "NotoSansArabic-Bold.ttf",
//                    note2El.fontSize, note2El.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            if (showQr == "true") {
//                val qrEl = lr.getElement("bullion", "qr") ?: ElementPos(31f, 12f, 7f, 7f)
//                if (qrEl.visible) api.drawLabelQrCode(qrEl.x, qrEl.y, qrEl.w, qrEl.h, qrCode, 31, 2)
//
//                val logoEl = lr.getElement("bullion", "logo") ?: ElementPos(35f, 0.5f, 12f, 10f)
//                if (!customLogoBase64.isNullOrBlank() && logoEl.visible) {
//                    try { api.drawLabelImage(customLogoBase64, logoEl.x, logoEl.y, logoEl.w, logoEl.h, 0, 1, 127f) }
//                    catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            } else {
//                val barcodeEl = lr.getElement("bullion", "barcode") ?: ElementPos(2f, 2f, 17f, 7.2f)
//                if (barcodeEl.visible) api.drawLabelBarCode(barcodeEl.x, barcodeEl.y, barcodeEl.w, barcodeEl.h, 20, qrCode, 0.25f, 0, 2f, 2)
//
//                val logoBarEl = lr.getElement("bullion", "logo_bar") ?: ElementPos(1f, 11f, 8f, 8f)
//                if (!customLogoBase64.isNullOrBlank() && logoBarEl.visible) {
//                    try { api.drawLabelImage(customLogoBase64, logoBarEl.x, logoBarEl.y, logoBarEl.w, logoBarEl.h, 0, 1, 127f) }
//                    catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            }
//
//            val jsonBytes = api.generateLabelJson()
//            startPrinting(String(jsonBytes, Charsets.UTF_8), paperInfo)
//        } catch (e: Exception) {
//            sendStatus("error", "فشل في بناء الليبل: ${e.message}")
//            false
//        }
//    }
//
//    // ====================================================================
//    //  printGemLabel
//    // ====================================================================
//    fun printGemLabel(
//        gemType: String? = null, note1: String? = null,
//        note2: String? = null, showQr: String, qrCode: String,
//        customLogoBase64: String? = null
//    ): Boolean {
//        if (!ensureConnected()) return false
//
//        return try {
//            val paperInfo = api.getPaperInfo()
//            if (paperInfo.state != 0) {
//                sendStatus("error", "فشل في قراءة نوع الورق: ${paperInfo.state}")
//                return false
//            }
//
//            val lr = layoutReader
//            val (sW, sH) = lr.getStickerSize("gem")
//
//            api.drawEmptyLabel(sW, sH, 0,
//                listOf("NotoSansArabic-Bold.ttf", "NotoSansArabic-Regular.ttf"))
//
//            // نص QR
//            val qrTextEl = lr.getElement("gem", "qrCode_text") ?: ElementPos(13f, 3.2f, 20f, 2.8f, 2.8f)
//            if (qrTextEl.visible) {
//                api.drawLabelText(qrTextEl.x, qrTextEl.y, qrTextEl.w, qrTextEl.h,
//                    qrCode, "NotoSansArabic-Bold.ttf",
//                    qrTextEl.fontSize, qrTextEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // نوع الحجر
//            val gemEl = lr.getElement("gem", "gemType") ?: ElementPos(39f, 11f, 11f, 4f, 4f)
//            if (!gemType.isNullOrBlank() && gemEl.visible) {
//                api.drawLabelText(gemEl.x, gemEl.y, gemEl.w, gemEl.h,
//                    gemType, "NotoSansArabic-Bold.ttf",
//                    gemEl.fontSize, gemEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // note1
//            val note1El = lr.getElement("gem", "note1") ?: ElementPos(39f, 15f, 11f, 4f, 4f)
//            if (!note1.isNullOrBlank() && note1El.visible) {
//                api.drawLabelText(note1El.x, note1El.y, note1El.w, note1El.h,
//                    note1, "NotoSansArabic-Bold.ttf",
//                    note1El.fontSize, note1El.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // note2
//            val note2El = lr.getElement("gem", "note2") ?: ElementPos(39f, 19f, 11f, 4f, 4f)
//            if (!note2.isNullOrBlank() && note2El.visible) {
//                api.drawLabelText(note2El.x, note2El.y, note2El.w, note2El.h,
//                    note2, "NotoSansArabic-Bold.ttf",
//                    note2El.fontSize, note2El.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            if (showQr == "true") {
//                val qrEl = lr.getElement("gem", "qr") ?: ElementPos(31f, 12f, 7f, 7f)
//                if (qrEl.visible) api.drawLabelQrCode(qrEl.x, qrEl.y, qrEl.w, qrEl.h, qrCode, 31, 2)
//
//                val logoEl = lr.getElement("gem", "logo") ?: ElementPos(35f, 0.5f, 12f, 10f)
//                if (!customLogoBase64.isNullOrBlank() && logoEl.visible) {
//                    try { api.drawLabelImage(customLogoBase64, logoEl.x, logoEl.y, logoEl.w, logoEl.h, 0, 1, 127f) }
//                    catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            } else {
//                val barcodeEl = lr.getElement("gem", "barcode") ?: ElementPos(2f, 2f, 17f, 7.2f)
//                if (barcodeEl.visible) api.drawLabelBarCode(barcodeEl.x, barcodeEl.y, barcodeEl.w, barcodeEl.h, 20, qrCode, 0.25f, 0, 2f, 2)
//
//                val logoBarEl = lr.getElement("gem", "logo_bar") ?: ElementPos(1f, 11f, 8f, 8f)
//                if (!customLogoBase64.isNullOrBlank() && logoBarEl.visible) {
//                    try { api.drawLabelImage(customLogoBase64, logoBarEl.x, logoBarEl.y, logoBarEl.w, logoBarEl.h, 0, 1, 127f) }
//                    catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            }
//
//            val jsonBytes = api.generateLabelJson()
//            startPrinting(String(jsonBytes, Charsets.UTF_8), paperInfo)
//        } catch (e: Exception) {
//            sendStatus("error", "فشل في بناء الليبل: ${e.message}")
//            false
//        }
//    }
//
//    private fun sendStatus(status: String, message: String) {
//        statusSink?.success(mapOf("status" to status, "message" to message))
//        Log.d(TAG, "$status → $message")
//    }
//
//    private fun startPrinting(printData: String, paperInfo: PaperInfo): Boolean {
//        Handler(Looper.getMainLooper()).post {
//            sendStatus("printing", "جاري الطباعة...")
//
//            try { api.setTotalPrintQuantity(1) }
//            catch (e: Exception) {
//                Handler(Looper.getMainLooper()).post { sendStatus("error", "فشل تحديد الكمية: ${e.message}") }
//                return@post
//            }
//            try {
//                api.startPrintJob(4, 1, 0, object : PrintCallback {
//                    override fun onBufferFree(pageIndex: Int, bufferSize: Int) {
//                        val infoJson = """{"printerImageProcessingInfo":{"width":50.0,"height":30.0,"orientation":0,"margin":[0,0,0,0],"horizontalOffset":0,"verticalOffset":0,"printQuantity":1,"epc":""}}"""
//                        try { api.commitData(listOf(printData), listOf(infoJson)) }
//                        catch (ce: Exception) { sendStatus("error", "فشل commitData: ${ce.message}") }
//                    }
//                    override fun onProgress(page: Int, copy: Int, map: HashMap<String, Any>?) {
//                        if (page >= 1 && copy >= 1) sendStatus("success", "تمت الطباعة بنجاح")
//                    }
//                    override fun onError(code: Int) {}
//                    override fun onError(code: Int, state: Int) {}
//                    override fun onCancelJob(success: Boolean) {}
//                })
//            } catch (e: Exception) {
//                sendStatus("error", "استثناء في الطباعة: ${e.message}")
//            }
//        }
//        return true
//    }
//
//    private fun getErrorMessage(code: Int, state: Int? = null): String {
//        val baseMsg = when (code) {
//            -1 -> "فشل عام في الطباعة (تأكد من الاتصال)"
//            -2 -> "بيانات غير صالحة (تحقق من JSON)"
//            -3 -> "الطابعة مشغولة (أعد المحاولة)"
//            -4 -> "نفاد الورق (أعد تحميل الورق)"
//            -5 -> "سخونة زائدة (دع الطابعة تبرد)"
//            -6 -> "بطارية منخفضة (اشحن الطابعة)"
//            -7 -> "غطاء مفتوح (أغلق الغطاء)"
//            else -> "خطأ غير معروف: $code"
//        }
//        return if (state != null) "$baseMsg (الحالة: $state)" else baseMsg
//    }
//}*/
///*package com.kaki_rfid.uhf_gold_shop
//
//import android.Manifest
//import android.app.Application
//import android.bluetooth.BluetoothAdapter
//import android.bluetooth.BluetoothDevice
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import android.content.IntentFilter
//import android.content.SharedPreferences
//import android.os.Handler
//import android.os.Looper
//import android.util.Log
//import android.graphics.Bitmap
//import android.graphics.BitmapFactory
//import android.graphics.Canvas
//import android.graphics.Color
//import android.graphics.Paint
//import android.graphics.ColorMatrix
//import android.graphics.ColorMatrixColorFilter
//import java.io.ByteArrayOutputStream
//import androidx.annotation.RequiresPermission
//import com.gengcon.www.jcprintersdk.JCPrintApi
//import com.gengcon.www.jcprintersdk.callback.Callback
//import com.gengcon.www.jcprintersdk.callback.PrintCallback
//import com.gengcon.www.jcprintersdk.bean.PaperInfo
//import io.flutter.plugin.common.EventChannel
//import org.json.JSONArray
//import org.json.JSONObject
//import kotlin.text.Charsets
//import java.util.HashMap
//import android.util.Base64
//
//
//
//class PrinterBridge(private val context: Context) {
//
//    private val TAG = "Niimbot_Original"
//    private var statusSink: EventChannel.EventSink? = null
//    private val api: JCPrintApi
//    private val prefs: SharedPreferences
//    private var isPrinterConnected: Boolean = false // Flag to track connection state from callbacks
//
//    init {
//        // حفظ آخر طابعة
//        prefs = context.getSharedPreferences("printer_prefs", Context.MODE_PRIVATE)
//
//        val callback = object : Callback {
//            override fun onConnectSuccess(address: String?, type: Int) {
//                isPrinterConnected = true
//                address?.let { saveLastPrinter(it) }
//                sendStatus("connected", "متصل بـ $address")
//            }
//            override fun onDisConnect() {
//                isPrinterConnected = false
//                sendStatus("disconnected", "تم قطع الاتصال")
//            }
//            override fun onElectricityChange(powerLevel: Int) {}
//            override fun onCoverStatus(coverStatus: Int) {} // Use onCoverStatus to match possible older SDK
//            override fun onPaperStatus(paperStatus: Int) {}
//            override fun onRfidReadStatus(rfidReadStatus: Int) {}
//            override fun onRibbonRfidReadStatus(ribbonRfidReadStatus: Int) {}
//            override fun onRibbonStatus(ribbonStatus: Int) {}
//            override fun onFirmErrors() {}
//        }
//
//        api = JCPrintApi.getInstance(callback)
//        api.initSdk(context.applicationContext as Application)
//
//        // Initialize image library with fonts for Arabic support (assume fonts copied to assets or libs)
//        val fontInitResult = api.initDefaultImageLibrarySettings("fonts/NotoSansArabic-Bold.ttf", "fonts/NotoSansArabic-Regular.ttf")
//        if (fontInitResult != 0) {
//            Log.e(TAG, "Failed to init image library: $fontInitResult")
//            sendStatus("error", "فشل تهيئة الخطوط: $fontInitResult")
//        } else {
//            Log.d(TAG, "Image library initialized with Arabic font")
//        }
//
//        sendStatus("initialized", "Niimbot جاهزة 100%")
//        Log.d(TAG, "SDK شغال زي التطبيق الأصلي")
//
//        // اتصال تلقائي بآخر طابعة
//        /*val lastMac = getLastPrinter()
//        if (lastMac.isNotEmpty()) {
//            sendStatus("auto_connecting", "جاري الاتصال التلقائي...")
//            val connectSuccess = connectBluetooth(lastMac)
//            if (!connectSuccess) {
//                sendStatus("error", "فشل الاتصال التلقائي بـ $lastMac")
//            }
//        }*/
//    }
//
//    fun setPrintStatusSink(sink: EventChannel.EventSink?) {
//        statusSink = sink
//        // Auto-connect بعد ما Flutter يستقبل الأحداث
//        val lastMac = getLastPrinter()
//        if (lastMac.isNotEmpty()) {
//            sendStatus("auto_connecting", "جاري الاتصال التلقائي...")
//            connectBluetooth(lastMac)
//        }
//    }
//
//    // 1. البحث عن الطابعات الموجودة حالياً (مش المقترنة فقط) - الآن مع busy wait لجعلها sync دون ANR شديد
//    @RequiresPermission(allOf = [Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.ACCESS_FINE_LOCATION])
//    fun scanBluetoothPrinters(): List<Map<String, String>> {
//        val adapter = BluetoothAdapter.getDefaultAdapter() ?: return emptyList()
//        if (!adapter.isEnabled) return emptyList()
//
//        val discoveredDevices = mutableSetOf<BluetoothDevice>()
//
//        val discoveryReceiver = object : BroadcastReceiver() {
//            override fun onReceive(ctx: Context, intent: Intent) {
//                if (BluetoothDevice.ACTION_FOUND == intent.action) {
//                    val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
//                    device?.let {
//                        if (it.name?.contains("Niimbot", ignoreCase = true) == true ||
//                            it.name?.contains("B21", ignoreCase = true) == true ||
//                            it.name?.contains("itel", ignoreCase = true) == true ||
//                            it.name?.contains("B1", ignoreCase = true) == true ||
//                            it.name?.contains("M2", ignoreCase = true) == true ||
//                            it.name?.contains("B18", ignoreCase = true) == true ||
//                            it.name?.contains("B3S", ignoreCase = true) == true ||
//                            it.name?.contains("C1", ignoreCase = true) == true) {
//                            discoveredDevices.add(it)
//                        }
//                    }
//                }
//            }
//        }
//
//        context.registerReceiver(discoveryReceiver, IntentFilter(BluetoothDevice.ACTION_FOUND))
//        adapter.startDiscovery()
//
//        // Busy wait for 3 seconds with small sleeps to avoid ANR
//        val startTime = System.currentTimeMillis()
//        while (System.currentTimeMillis() - startTime < 3000) {
//            Thread.sleep(500) // Sleep in loops to allow UI thread
//        }
//
//        adapter.cancelDiscovery()
//        context.unregisterReceiver(discoveryReceiver)
//
//        // Return combined bonded + discovered that match
//        val bonded = adapter.bondedDevices
//            .filter { it.name?.contains("Niimbot", ignoreCase = true) == true ||
//                    it.name?.contains("B21", ignoreCase = true) == true ||
//                    it.name?.contains("itel", ignoreCase = true) == true ||
//                    it.name?.contains("B1", ignoreCase = true) == true ||
//                    it.name?.contains("M2", ignoreCase = true) == true ||
//                    it.name?.contains("B18", ignoreCase = true) == true ||
//                    it.name?.contains("B3S", ignoreCase = true) == true ||
//                    it.name?.contains("C1", ignoreCase = true) == true }
//            .map { mapOf("name" to (it.name ?: "Niimbot"), "address" to it.address) }
//        val discovered = discoveredDevices.map { mapOf("name" to (it.name ?: "Niimbot"), "address" to it.address) }
//
//        return (bonded + discovered).distinctBy { it["address"] }
//    }
//
//    // 2. اتصال عادي
//    fun connectBluetooth(mac: String): Boolean {
//        if (isPrinterConnected) {
//            sendStatus("already_connected", "الطابعة متصلة بالفعل")
//            return true
//        }
//        sendStatus("connecting", "جاري الاتصال بـ $mac...")
//        val result = api.connectBluetoothPrinter(mac)
//        return if (result == 0) {
//            saveLastPrinter(mac)
//            sendStatus("connected", "تم الاتصال بنجاح")
//            true
//        } else {
//            sendStatus("error", "فشل الاتصال: $result")
//            false
//        }
//    }
//
//    fun isConnected(): Boolean = isPrinterConnected
//
//    // 3. حفظ آخر طابعة
//    private fun saveLastPrinter(mac: String) {
//        prefs.edit().putString("last_printer_mac", mac).apply()
//    }
//
//    private fun getLastPrinter(): String {
//        return prefs.getString("last_printer_mac", "") ?: ""
//    }
//    fun disconnectPrinter(): Boolean {
//        return try {
//            api.close()   // يقفل الاتصال
//            isPrinterConnected = false
//            sendStatus("disconnected", "تم فصل الطابعة")
//            true
//        } catch (e: Exception) {
//            sendStatus("error", "فشل فصل الطابعة: ${e.message}")
//            false
//        }
//    }
//
//
//    // 4. طباعة الليبل (مضبوطة تمام على 50×30 مم) - الآن باستخدام drawing API بدون wordBreakMode لتوافق أقدم
//    fun printGoldLabel(
//        weight: String? = null, carat: String? = null,
//        size: String? = null, showQr: String, qrCode: String,
//        customLogoBase64: String? = null
//    ): Boolean {
//        if (!isConnected()) {
//            val lastMac = getLastPrinter()
//            if (lastMac.isEmpty()) {
//                sendStatus("error", "لا توجد طابعة محفوظة، اتصل أولاً")
//                return false
//            }
//
//            // أهم 3 أسطر في حياتك دلوقتي
//            api.close()                                    // أغلق أي اتصال قديم
//            Thread.sleep(300)                              // انتظر 300 مللي عشان الـ BLE يرتاح
//            val connectResult = api.connectBluetoothPrinter(lastMac)  // أعد الاتصال من جديد
//
//            if (connectResult != 0) {
//                sendStatus("error", "اتصل بالطباعة يدويا او اعد تشغيل الطابعة")
//                return false
//            }
//        }
//
//        try {
//            // Get paper info to auto-detect type
//            val paperInfo = api.getPaperInfo()
//            if (paperInfo.state != 0) {
//                sendStatus("error", "فشل في قراءة نوع الورق: ${paperInfo.state}")
//                return false
//            }
//
//            api.drawEmptyLabel(50f, 30f, 0, listOf("NotoSansArabic-Bold.ttf", "NotoSansArabic-Regular.ttf"))
//            var y = 11f // in mm
//            if (!weight.isNullOrBlank()) {
//                api.drawLabelText(35f, 13f, 12f, 3f, " W$weight", "NotoSansArabic-Bold.ttf", 3f, 270, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//                y += 3f
//            }
//            if (!carat.isNullOrBlank()) {
//                api.drawLabelText(38f, 13f, 12f, 3f, " K$carat", "NotoSansArabic-Bold.ttf", 3f, 270, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//                y += 3f
//            }
//            if (!size.isNullOrBlank()) {
//                api.drawLabelText(41f, 13f, 12f, 3f, " S$size", "NotoSansArabic-Bold.ttf", 3f, 270, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//
//            }
//
//            api.drawLabelText(13f, 3.2f, 20f, 2.8f, qrCode, "NotoSansArabic-Bold.ttf", 2.8f, 0, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//
//            if (showQr =="true") {
//                // طباعة QR فقط
//                api.drawLabelQrCode(31f, 12f, 7f, 7f, qrCode, 31, 2)
//
//                // هنا بس اللوجو المخصص
//                if (!customLogoBase64.isNullOrBlank()) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, 35f, 0.5f, 12f, 10f, 0, 1, 127f)
//                    } catch (e: Exception) {
//                        Log.e("Printer", "فشل طباعة اللوجو", e)
//                    }
//                }
//            } else {
//                api.drawLabelBarCode(2f, 12f, 17f, 7.2f, 20, qrCode, 0.25f, 0, 2f, 2)
//                // هنا بس اللوجو المخصص
//                if (!customLogoBase64.isNullOrBlank()) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, 31f, 11f, 8f, 8f, 0, 1, 127f)
//                    } catch (e: Exception) {
//                        Log.e("Printer", "فشل طباعة اللوجو", e)
//                    }
//                }
//
//            }
//
//
//
//            val jsonBytes = api.generateLabelJson()
//            val printData = String(jsonBytes, Charsets.UTF_8)
//
//            return startPrinting(printData, paperInfo)
//        } catch (e: Exception) {
//            sendStatus("error", "فشل في بناء الليبل: ${e.message}")
//            return false
//        }
//    }
//    fun printBullionLabel(
//        weight: String? = null, note1: String? = null,
//        note2: String? = null, showQr: String, qrCode: String,
//        customLogoBase64: String? = null
//    ): Boolean {
//        if (!isConnected()) {
//            val lastMac = getLastPrinter()
//            if (lastMac.isEmpty()) {
//                sendStatus("error", "لا توجد طابعة محفوظة، اتصل أولاً")
//                return false
//            }
//
//            // أهم 3 أسطر في حياتك دلوقتي
//            api.close()                                    // أغلق أي اتصال قديم
//            Thread.sleep(300)                              // انتظر 300 مللي عشان الـ BLE يرتاح
//            val connectResult = api.connectBluetoothPrinter(lastMac)  // أعد الاتصال من جديد
//
//            if (connectResult != 0) {
//                sendStatus("error", "اتصل بالطباعة يدويا او اعد تشغيل الطابعة")
//                return false
//            }
//        }
//
//        try {
//            // Get paper info to auto-detect type
//            val paperInfo = api.getPaperInfo()
//            if (paperInfo.state != 0) {
//                sendStatus("error", "فشل في قراءة نوع الورق: ${paperInfo.state}")
//                return false
//            }
//
//            api.drawEmptyLabel(50f, 30f, 0, listOf("NotoSansArabic-Bold.ttf", "NotoSansArabic-Regular.ttf"))
//            var y = 11f // in mm
//            if (!weight.isNullOrBlank()) {
//                api.drawLabelText(39f, y, 11f, 3f, "W $weight", "NotoSansArabic-Bold.ttf", 3f, 0, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//                y += 3f
//            }
//            if (!note1.isNullOrBlank()) {
//                api.drawLabelText(39f, y, 11f, 4f, note1, "NotoSansArabic-Bold.ttf", 4f, 0, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//                y += 3f
//            }
//            if (!note2.isNullOrBlank()) {
//                api.drawLabelText(39f, y, 11f, 4f, note2, "NotoSansArabic-Bold.ttf", 4f, 0, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//
//            }
//            api.drawLabelText(13f, 3.2f, 20f, 2.8f, qrCode, "NotoSansArabic-Bold.ttf", 2.8f, 0, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//
//
//
//
//            if (showQr =="true") {
//                // طباعة QR فقط
//                api.drawLabelQrCode(31f, 12f, 7f, 7f, qrCode, 31, 2)
//
//                // هنا بس اللوجو المخصص
//                if (!customLogoBase64.isNullOrBlank()) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, 35f, 0.5f, 12f, 10f, 0, 1, 127f)
//                    } catch (e: Exception) {
//                        Log.e("Printer", "فشل طباعة اللوجو", e)
//                    }
//                }
//            } else {
//                api.drawLabelBarCode(2f, 2f, 17f, 7.2f, 20, qrCode, 0.25f, 0, 2f, 2)
//                // هنا بس اللوجو المخصص
//                if (!customLogoBase64.isNullOrBlank()) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, 1f, 11f, 8f, 8f, 0, 1, 127f)
//                    } catch (e: Exception) {
//                        Log.e("Printer", "فشل طباعة اللوجو", e)
//                    }
//                }
//
//            }
//
//
//
//            val jsonBytes = api.generateLabelJson()
//            val printData = String(jsonBytes, Charsets.UTF_8)
//
//            return startPrinting(printData, paperInfo)
//        } catch (e: Exception) {
//            sendStatus("error", "فشل في بناء الليبل: ${e.message}")
//            return false
//        }
//    }
//    fun printGemLabel(
//        gemType: String? = null, note1: String? = null,
//        note2: String? = null, showQr: String, qrCode: String,
//        customLogoBase64: String? = null
//    ): Boolean {
//        if (!isConnected()) {
//            val lastMac = getLastPrinter()
//            if (lastMac.isEmpty()) {
//                sendStatus("error", "لا توجد طابعة محفوظة، اتصل أولاً")
//                return false
//            }
//
//            // أهم 3 أسطر في حياتك دلوقتي
//            api.close()                                    // أغلق أي اتصال قديم
//            Thread.sleep(300)                              // انتظر 300 مللي عشان الـ BLE يرتاح
//            val connectResult = api.connectBluetoothPrinter(lastMac)  // أعد الاتصال من جديد
//
//            if (connectResult != 0) {
//                sendStatus("error", "اتصل بالطباعة يدويا او اعد تشغيل الطابعة")
//                return false
//            }
//        }
//
//        try {
//            // Get paper info to auto-detect type
//            val paperInfo = api.getPaperInfo()
//            if (paperInfo.state != 0) {
//                sendStatus("error", "فشل في قراءة نوع الورق: ${paperInfo.state}")
//                return false
//            }
//
//            api.drawEmptyLabel(50f, 30f, 0, listOf("NotoSansArabic-Bold.ttf", "NotoSansArabic-Regular.ttf"))
//            var y = 11f // in mm
//            if (!gemType.isNullOrBlank()) {
//                api.drawLabelText(39f, y, 11f, 4f, gemType, "NotoSansArabic-Bold.ttf", 4f, 0, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//                y += 3f
//            }
//            if (!note1.isNullOrBlank()) {
//                api.drawLabelText(39f, y, 11f, 4f, note1, "NotoSansArabic-Bold.ttf", 4f, 0, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//                y += 3f
//            }
//            if (!note2.isNullOrBlank()) {
//                api.drawLabelText(39f, y, 11f, 4f, note2, "NotoSansArabic-Bold.ttf", 4f, 0, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//
//            }
//            api.drawLabelText(13f, 3.2f, 20f, 2.8f, qrCode, "NotoSansArabic-Bold.ttf", 2.8f, 0, 0, 0, 1, 0f, 1.0f, booleanArrayOf(false, false, false, false))
//
//
//
//
//            if (showQr =="true") {
//                // طباعة QR فقط
//                api.drawLabelQrCode(31f, 12f, 7f, 7f, qrCode, 31, 2)
//
//                // هنا بس اللوجو المخصص
//                if (!customLogoBase64.isNullOrBlank()) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, 35f, 0.5f, 12f, 10f, 0, 1, 127f)
//                    } catch (e: Exception) {
//                        Log.e("Printer", "فشل طباعة اللوجو", e)
//                    }
//                }
//            } else {
//                api.drawLabelBarCode(2f, 2f, 17f, 7.2f, 20, qrCode, 0.25f, 0, 2f, 2)
//                // هنا بس اللوجو المخصص
//                if (!customLogoBase64.isNullOrBlank()) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, 1f, 11f, 8f, 8f, 0, 1, 127f)
//                    } catch (e: Exception) {
//                        Log.e("Printer", "فشل طباعة اللوجو", e)
//                    }
//                }
//
//            }
//
//
//
//            val jsonBytes = api.generateLabelJson()
//            val printData = String(jsonBytes, Charsets.UTF_8)
//
//            return startPrinting(printData, paperInfo)
//        } catch (e: Exception) {
//            sendStatus("error", "فشل في بناء الليبل: ${e.message}")
//            return false
//        }
//    }
//
//
//
//    private fun sendStatus(status: String, message: String) {
//        statusSink?.success(mapOf("status" to status, "message" to message))
//        Log.d(TAG, "$status → $message")
//    }
//
//    private fun startPrinting(printData: String, paperInfo: PaperInfo): Boolean {
//
//        Handler(Looper.getMainLooper()).post {
//            sendStatus("printing", "جاري الطباعة...")
//
//            try {
//                api.setTotalPrintQuantity(1)
//            } catch (e: Exception) {
//                Handler(Looper.getMainLooper()).post {
//                    sendStatus("error", "فشل تحديد الكمية: ${e.message}")
//                }
//                return@post
//            }
//            try {
//                api.startPrintJob(4, 1, 0, object : PrintCallback {
//
//                    override fun onBufferFree(pageIndex: Int, bufferSize: Int) {
//                        val infoJson = """
//                        {
//                            "printerImageProcessingInfo": {
//                                "width": 50.0,
//                                "height": 30.0,
//                                "orientation": 0,
//                                "margin": [0, 0, 0, 0],
//                                "horizontalOffset": 0,
//                                "verticalOffset": 0,
//                                "printQuantity": 1,
//                                "epc": ""
//                            }
//                        }
//                    """.trimIndent()
//
//                        try {
//                            api.commitData(listOf(printData), listOf(infoJson))
//                        } catch (ce: Exception) {
//
//                            sendStatus("error", "فشل commitData: ${ce.message}")
//
//                        }
//                    }
//
//                    override fun onProgress(page: Int, copy: Int, map: HashMap<String, Any>?) {
//
//                        if (page >= 1 && copy >= 1) {
//                            sendStatus("success", "تمت الطباعة بنجاح")
//                        }
//                    }
//
//                    override fun onError(code: Int) {
//                        //sendStatus("error", getErrorMessage(code))
//                    }
//
//                    override fun onError(code: Int, state: Int) {
//                        //sendStatus("error", getErrorMessage(code, state))
//                    }
//
//                    override fun onCancelJob(success: Boolean) {
//                        //sendStatus("cancelled", "تم إلغاء الطباعة")
//                    }
//                })
//
//            } catch (e: Exception) {
//
//                sendStatus("error", "استثناء في الطباعة: ${e.message}")
//
//            }
//        }
//        return true
//    }
//
//    private fun getErrorMessage(code: Int, state: Int? = null): String {
//        val baseMsg = when (code) {
//            -1 -> "فشل عام في الطباعة (تأكد من الاتصال)"
//            -2 -> "بيانات غير صالحة (تحقق من JSON)"
//            -3 -> "الطابعة مشغولة (أعد المحاولة)"
//            -4 -> "نفاد الورق (أعد تحميل الورق)"
//            -5 -> "سخونة زائدة (دع الطابعة تبرد)"
//            -6 -> "بطارية منخفضة (اشحن الطابعة)"
//            -7 -> "غطاء مفتوح (أغلق الغطاء)"
//            else -> "خطأ غير معروف: $code"
//        }
//        val suggestion = when (code) {
//            -4 -> "اقتراح: أعد تحميل لفة الورق وأعد التشغيل."
//            -6 -> "اقتراح: اشحن البطارية إلى 50% على الأقل."
//            -7 -> "اقتراح: تأكد من إغلاق الغطاء جيداً."
//            else -> "اقتراح: أعد الاتصال أو أعد تشغيل الطابعة."
//        }
//        return if (state != null) "$baseMsg (الحالة: $state). $suggestion" else "$baseMsg. $suggestion"
//    }
//}*/
//
//package com.kaki_rfid.uhf_gold_shop
//
//import android.Manifest
//import android.app.Application
//import android.bluetooth.BluetoothAdapter
//import android.bluetooth.BluetoothDevice
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import android.content.IntentFilter
//import android.content.SharedPreferences
//import android.os.Handler
//import android.os.Looper
//import android.util.Log
//import android.graphics.Bitmap
//import android.graphics.BitmapFactory
//import android.graphics.Canvas
//import android.graphics.Color
//import android.graphics.Paint
//import android.graphics.ColorMatrix
//import android.graphics.ColorMatrixColorFilter
//import java.io.ByteArrayOutputStream
//import androidx.annotation.RequiresPermission
//import com.gengcon.www.jcprintersdk.JCPrintApi
//import com.gengcon.www.jcprintersdk.callback.Callback
//import com.gengcon.www.jcprintersdk.callback.PrintCallback
//import com.gengcon.www.jcprintersdk.bean.PaperInfo
//import io.flutter.plugin.common.EventChannel
//import org.json.JSONArray
//import org.json.JSONObject
//import kotlin.text.Charsets
//import java.util.HashMap
//import android.util.Base64
//
//// ====================================================================
////  LabelLayout Helper  –  يقرأ التخطيط المحفوظ من Flutter SharedPrefs
//// ====================================================================
//data class ElementPos(
//    val x: Float, val y: Float,
//    val w: Float, val h: Float,
//    val fontSize: Float = 3f,
//    val rotation: Int = 0,
//    val visible: Boolean = true
//)
//
//class LabelLayoutReader(private val prefs: SharedPreferences) {
//
//    /** يجيب التخطيط الكامل لنوع الاستيكر. لو مفيش محفوظ يرجع null فنستخدم الافتراضي */
//    private fun getLayout(labelType: String): JSONObject? {
//        // Flutter بيحفظها بـ key  "flutter.label_layout_<type>"
//        val raw = prefs.getString("flutter.label_layout_$labelType", null) ?: return null
//        return try { JSONObject(raw) } catch (e: Exception) { null }
//    }
//
//    fun getElement(labelType: String, elementId: String): ElementPos? {
//        val layout = getLayout(labelType) ?: return null
//        val elements = layout.optJSONArray("elements") ?: return null
//        for (i in 0 until elements.length()) {
//            val el = elements.optJSONObject(i) ?: continue
//            if (el.optString("id") == elementId) {
//                return ElementPos(
//                    x        = el.optDouble("x", 0.0).toFloat(),
//                    y        = el.optDouble("y", 0.0).toFloat(),
//                    w        = el.optDouble("w", 10.0).toFloat(),
//                    h        = el.optDouble("h", 5.0).toFloat(),
//                    fontSize = el.optDouble("fontSize", 3.0).toFloat(),
//                    rotation = el.optInt("rotation", 0),
//                    visible  = el.optBoolean("visible", true)
//                )
//            }
//        }
//        return null
//    }
//
//    fun getStickerSize(labelType: String): Pair<Float, Float> {
//        val layout = getLayout(labelType) ?: return Pair(50f, 30f)
//        return Pair(
//            layout.optDouble("stickerW", 50.0).toFloat(),
//            layout.optDouble("stickerH", 30.0).toFloat()
//        )
//    }
//
//    fun getDensity(labelType: String): Int {
//        val layout = getLayout(labelType) ?: return 3
//        return layout.optInt("density", 3).coerceIn(1, 5)
//    }
//}
//
//class PrinterBridge(private val context: Context) {
//
//    private val TAG = "Niimbot_Original"
//    private var statusSink: EventChannel.EventSink? = null
//    private val api: JCPrintApi
//    private val prefs: SharedPreferences
//    // SharedPrefs الخاصة بـ Flutter (اسمها ثابت)
//    private val flutterPrefs: SharedPreferences by lazy {
//        context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
//    }
//    private val layoutReader: LabelLayoutReader by lazy {
//        LabelLayoutReader(flutterPrefs)
//    }
//    private var isPrinterConnected: Boolean = false
//
//    init {
//        prefs = context.getSharedPreferences("printer_prefs", Context.MODE_PRIVATE)
//
//        val callback = object : Callback {
//            override fun onConnectSuccess(address: String?, type: Int) {
//                isPrinterConnected = true
//                address?.let { saveLastPrinter(it) }
//                sendStatus("connected", "متصل بـ $address")
//            }
//            override fun onDisConnect() {
//                isPrinterConnected = false
//                sendStatus("disconnected", "تم قطع الاتصال")
//            }
//            override fun onElectricityChange(powerLevel: Int) {}
//            override fun onCoverStatus(coverStatus: Int) {}
//            override fun onPaperStatus(paperStatus: Int) {}
//            override fun onRfidReadStatus(rfidReadStatus: Int) {}
//            override fun onRibbonRfidReadStatus(ribbonRfidReadStatus: Int) {}
//            override fun onRibbonStatus(ribbonStatus: Int) {}
//            override fun onFirmErrors() {}
//        }
//
//        api = JCPrintApi.getInstance(callback)
//        api.initSdk(context.applicationContext as Application)
//
//        val fontInitResult = api.initDefaultImageLibrarySettings(
//            "fonts/NotoSansArabic-Bold.ttf",
//            "fonts/NotoSansArabic-Regular.ttf"
//        )
//        if (fontInitResult != 0) {
//            Log.e(TAG, "Failed to init image library: $fontInitResult")
//            sendStatus("error", "فشل تهيئة الخطوط: $fontInitResult")
//        } else {
//            Log.d(TAG, "Image library initialized with Arabic font")
//        }
//
//        sendStatus("initialized", "Niimbot جاهزة 100%")
//    }
//
//    fun setPrintStatusSink(sink: EventChannel.EventSink?) {
//        statusSink = sink
//        val lastMac = getLastPrinter()
//        if (lastMac.isNotEmpty()) {
//            sendStatus("auto_connecting", "جاري الاتصال التلقائي...")
//            connectBluetooth(lastMac)
//        }
//    }
//
//    @RequiresPermission(allOf = [Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.ACCESS_FINE_LOCATION])
//    fun scanBluetoothPrinters(): List<Map<String, String>> {
//        val adapter = BluetoothAdapter.getDefaultAdapter() ?: return emptyList()
//        if (!adapter.isEnabled) return emptyList()
//
//        val discoveredDevices = mutableSetOf<BluetoothDevice>()
//
//        val discoveryReceiver = object : BroadcastReceiver() {
//            override fun onReceive(ctx: Context, intent: Intent) {
//                if (BluetoothDevice.ACTION_FOUND == intent.action) {
//                    val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
//                    device?.let { if (isPrinterDevice(it)) discoveredDevices.add(it) }
//                }
//            }
//        }
//
//        context.registerReceiver(discoveryReceiver, IntentFilter(BluetoothDevice.ACTION_FOUND))
//        adapter.startDiscovery()
//        val startTime = System.currentTimeMillis()
//        while (System.currentTimeMillis() - startTime < 3000) { Thread.sleep(500) }
//        adapter.cancelDiscovery()
//        context.unregisterReceiver(discoveryReceiver)
//
//        val bonded = adapter.bondedDevices
//            .filter { isPrinterDevice(it) }
//            .map { mapOf("name" to (it.name ?: "Niimbot"), "address" to it.address) }
//        val discovered = discoveredDevices.map { mapOf("name" to (it.name ?: "Niimbot"), "address" to it.address) }
//
//        return (bonded + discovered).distinctBy { it["address"] }
//    }
//
//    private fun isPrinterDevice(device: BluetoothDevice): Boolean {
//        val name = device.name ?: return false
//        return listOf("Niimbot","B21","itel","B1","M2","B18","B3S","C1")
//            .any { name.contains(it, ignoreCase = true) }
//    }
//
//    fun connectBluetooth(mac: String): Boolean {
//        if (isPrinterConnected) {
//            sendStatus("already_connected", "الطابعة متصلة بالفعل")
//            return true
//        }
//        sendStatus("connecting", "جاري الاتصال بـ $mac...")
//        val result = api.connectBluetoothPrinter(mac)
//        return if (result == 0) {
//            saveLastPrinter(mac)
//            sendStatus("connected", "تم الاتصال بنجاح")
//            true
//        } else {
//            sendStatus("error", "فشل الاتصال: $result")
//            false
//        }
//    }
//
//    fun isConnected(): Boolean = isPrinterConnected
//
//    private fun saveLastPrinter(mac: String) {
//        prefs.edit().putString("last_printer_mac", mac).apply()
//    }
//
//    private fun getLastPrinter(): String {
//        return prefs.getString("last_printer_mac", "") ?: ""
//    }
//
//    fun disconnectPrinter(): Boolean {
//        return try {
//            api.close()
//            isPrinterConnected = false
//            sendStatus("disconnected", "تم فصل الطابعة")
//            true
//        } catch (e: Exception) {
//            sendStatus("error", "فشل فصل الطابعة: ${e.message}")
//            false
//        }
//    }
//
//    // ====================================================================
//    //  ensureConnected  –  مشترك لكل دوال الطباعة
//    // ====================================================================
//    private fun ensureConnected(): Boolean {
//        if (isConnected()) return true
//        val lastMac = getLastPrinter()
//        if (lastMac.isEmpty()) {
//            sendStatus("error", "لا توجد طابعة محفوظة، اتصل أولاً")
//            return false
//        }
//        api.close()
//        Thread.sleep(300)
//        val result = api.connectBluetoothPrinter(lastMac)
//        if (result != 0) {
//            sendStatus("error", "اتصل بالطباعة يدويا او اعد تشغيل الطابعة")
//            return false
//        }
//        return true
//    }
//
//    // ====================================================================
//    //  printGoldLabel  –  يقرأ الإحداثيات من التخطيط المحفوظ
//    // ====================================================================
//    fun printGoldLabel(
//        weight: String? = null, carat: String? = null,
//        size: String? = null, showQr: String, qrCode: String,
//        customLogoBase64: String? = null
//    ): Boolean {
//        if (!ensureConnected()) return false
//
//        return try {
//            val paperInfo = api.getPaperInfo()
//            if (paperInfo.state != 0) {
//                sendStatus("error", "فشل في قراءة نوع الورق: ${paperInfo.state}")
//                return false
//            }
//
//            val lr = layoutReader
//            val (sW, sH) = lr.getStickerSize("gold")
//
//            api.drawEmptyLabel(sW, sH, 0,
//                listOf("NotoSansArabic-Bold.ttf", "NotoSansArabic-Regular.ttf"))
//
//            // ===== نص رقم الـ QR =====
//            val qrTextEl = lr.getElement("gold", "qrCode_text")
//                ?: ElementPos(13f, 3.2f, 20f, 2.8f, 2.8f)
//            if (qrTextEl.visible) {
//                api.drawLabelText(
//                    qrTextEl.x, qrTextEl.y, qrTextEl.w, qrTextEl.h,
//                    qrCode, "NotoSansArabic-Bold.ttf",
//                    qrTextEl.fontSize, qrTextEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false)
//                )
//            }
//
//            // ===== الوزن =====
//            val weightEl = lr.getElement("gold", "weight")
//                ?: ElementPos(35f, 13f, 12f, 3f, 3f, 270)
//            if (!weight.isNullOrBlank() && weightEl.visible) {
//                api.drawLabelText(
//                    weightEl.x, weightEl.y, weightEl.w, weightEl.h,
//                    " W$weight", "NotoSansArabic-Bold.ttf",
//                    weightEl.fontSize, weightEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false)
//                )
//            }
//
//            // ===== العيار =====
//            val caratEl = lr.getElement("gold", "carat")
//                ?: ElementPos(38f, 13f, 12f, 3f, 3f, 270)
//            if (!carat.isNullOrBlank() && caratEl.visible) {
//                api.drawLabelText(
//                    caratEl.x, caratEl.y, caratEl.w, caratEl.h,
//                    " K$carat", "NotoSansArabic-Bold.ttf",
//                    caratEl.fontSize, caratEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false)
//                )
//            }
//
//            // ===== المقاس =====
//            val sizeEl = lr.getElement("gold", "size")
//                ?: ElementPos(41f, 13f, 12f, 3f, 3f, 270)
//            if (!size.isNullOrBlank() && sizeEl.visible) {
//                api.drawLabelText(
//                    sizeEl.x, sizeEl.y, sizeEl.w, sizeEl.h,
//                    " S$size", "NotoSansArabic-Bold.ttf",
//                    sizeEl.fontSize, sizeEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false)
//                )
//            }
//
//            if (showQr == "true") {
//                // ===== QR =====
//                val qrEl = lr.getElement("gold", "qr")
//                    ?: ElementPos(31f, 12f, 7f, 7f)
//                if (qrEl.visible) {
//                    api.drawLabelQrCode(qrEl.x, qrEl.y, qrEl.w, qrEl.h, qrCode, 31, qrEl.rotation)
//                }
//                // ===== اللوجو (مع QR) =====
//                val logoEl = lr.getElement("gold", "logo")
//                    ?: ElementPos(35f, 0.5f, 12f, 10f)
//                if (!customLogoBase64.isNullOrBlank() && logoEl.visible) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, logoEl.x, logoEl.y, logoEl.w, logoEl.h, logoEl.rotation, 1, 127f)
//                    } catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            } else {
//                // ===== Barcode =====
//                val barcodeEl = lr.getElement("gold", "barcode")
//                    ?: ElementPos(2f, 12f, 17f, 7.2f)
//                if (barcodeEl.visible) {
//                    api.drawLabelBarCode(barcodeEl.x, barcodeEl.y, barcodeEl.w, barcodeEl.h,
//                        20, qrCode, 0.25f, barcodeEl.rotation, 2f, 2)
//                }
//                // ===== اللوجو (مع Barcode) =====
//                val logoBarEl = lr.getElement("gold", "logo_bar")
//                    ?: ElementPos(31f, 11f, 8f, 8f)
//                if (!customLogoBase64.isNullOrBlank() && logoBarEl.visible) {
//                    try {
//                        api.drawLabelImage(customLogoBase64, logoBarEl.x, logoBarEl.y, logoBarEl.w, logoBarEl.h, logoBarEl.rotation, 1, 127f)
//                    } catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            }
//
//            val jsonBytes = api.generateLabelJson()
//            startPrinting(String(jsonBytes, Charsets.UTF_8), paperInfo, lr.getDensity("gold"))
//        } catch (e: Exception) {
//            sendStatus("error", "فشل في بناء الليبل: ${e.message}")
//            false
//        }
//    }
//
//    // ====================================================================
//    //  printBullionLabel
//    // ====================================================================
//    fun printBullionLabel(
//        weight: String? = null, note1: String? = null,
//        note2: String? = null, showQr: String, qrCode: String,
//        customLogoBase64: String? = null
//    ): Boolean {
//        if (!ensureConnected()) return false
//
//        return try {
//            val paperInfo = api.getPaperInfo()
//            if (paperInfo.state != 0) {
//                sendStatus("error", "فشل في قراءة نوع الورق: ${paperInfo.state}")
//                return false
//            }
//
//            val lr = layoutReader
//            val (sW, sH) = lr.getStickerSize("bullion")
//
//            api.drawEmptyLabel(sW, sH, 0,
//                listOf("NotoSansArabic-Bold.ttf", "NotoSansArabic-Regular.ttf"))
//
//            // نص QR
//            val qrTextEl = lr.getElement("bullion", "qrCode_text")
//                ?: ElementPos(13f, 3.2f, 20f, 2.8f, 2.8f)
//            if (qrTextEl.visible) {
//                api.drawLabelText(qrTextEl.x, qrTextEl.y, qrTextEl.w, qrTextEl.h,
//                    qrCode, "NotoSansArabic-Bold.ttf",
//                    qrTextEl.fontSize, qrTextEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // الوزن
//            val weightEl = lr.getElement("bullion", "weight")
//                ?: ElementPos(39f, 11f, 11f, 3f, 3f)
//            if (!weight.isNullOrBlank() && weightEl.visible) {
//                api.drawLabelText(weightEl.x, weightEl.y, weightEl.w, weightEl.h,
//                    "W $weight", "NotoSansArabic-Bold.ttf",
//                    weightEl.fontSize, weightEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // note1
//            val note1El = lr.getElement("bullion", "note1")
//                ?: ElementPos(39f, 14f, 11f, 4f, 4f)
//            if (!note1.isNullOrBlank() && note1El.visible) {
//                api.drawLabelText(note1El.x, note1El.y, note1El.w, note1El.h,
//                    note1, "NotoSansArabic-Bold.ttf",
//                    note1El.fontSize, note1El.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // note2
//            val note2El = lr.getElement("bullion", "note2")
//                ?: ElementPos(39f, 18f, 11f, 4f, 4f)
//            if (!note2.isNullOrBlank() && note2El.visible) {
//                api.drawLabelText(note2El.x, note2El.y, note2El.w, note2El.h,
//                    note2, "NotoSansArabic-Bold.ttf",
//                    note2El.fontSize, note2El.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            if (showQr == "true") {
//                val qrEl = lr.getElement("bullion", "qr") ?: ElementPos(31f, 12f, 7f, 7f)
//                if (qrEl.visible) api.drawLabelQrCode(qrEl.x, qrEl.y, qrEl.w, qrEl.h, qrCode, 31, qrEl.rotation)
//
//                val logoEl = lr.getElement("bullion", "logo") ?: ElementPos(35f, 0.5f, 12f, 10f)
//                if (!customLogoBase64.isNullOrBlank() && logoEl.visible) {
//                    try { api.drawLabelImage(customLogoBase64, logoEl.x, logoEl.y, logoEl.w, logoEl.h, logoEl.rotation, 1, 127f) }
//                    catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            } else {
//                val barcodeEl = lr.getElement("bullion", "barcode") ?: ElementPos(2f, 2f, 17f, 7.2f)
//                if (barcodeEl.visible) api.drawLabelBarCode(barcodeEl.x, barcodeEl.y, barcodeEl.w, barcodeEl.h, 20, qrCode, 0.25f, barcodeEl.rotation, 2f, 2)
//
//                val logoBarEl = lr.getElement("bullion", "logo_bar") ?: ElementPos(1f, 11f, 8f, 8f)
//                if (!customLogoBase64.isNullOrBlank() && logoBarEl.visible) {
//                    try { api.drawLabelImage(customLogoBase64, logoBarEl.x, logoBarEl.y, logoBarEl.w, logoBarEl.h, logoBarEl.rotation, 1, 127f) }
//                    catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            }
//
//            val jsonBytes = api.generateLabelJson()
//            startPrinting(String(jsonBytes, Charsets.UTF_8), paperInfo, lr.getDensity("bullion"))
//        } catch (e: Exception) {
//            sendStatus("error", "فشل في بناء الليبل: ${e.message}")
//            false
//        }
//    }
//
//    // ====================================================================
//    //  printGemLabel
//    // ====================================================================
//    fun printGemLabel(
//        gemType: String? = null, note1: String? = null,
//        note2: String? = null, showQr: String, qrCode: String,
//        customLogoBase64: String? = null
//    ): Boolean {
//        if (!ensureConnected()) return false
//
//        return try {
//            val paperInfo = api.getPaperInfo()
//            if (paperInfo.state != 0) {
//                sendStatus("error", "فشل في قراءة نوع الورق: ${paperInfo.state}")
//                return false
//            }
//
//            val lr = layoutReader
//            val (sW, sH) = lr.getStickerSize("gem")
//
//            api.drawEmptyLabel(sW, sH, 0,
//                listOf("NotoSansArabic-Bold.ttf", "NotoSansArabic-Regular.ttf"))
//
//            // نص QR
//            val qrTextEl = lr.getElement("gem", "qrCode_text") ?: ElementPos(13f, 3.2f, 20f, 2.8f, 2.8f)
//            if (qrTextEl.visible) {
//                api.drawLabelText(qrTextEl.x, qrTextEl.y, qrTextEl.w, qrTextEl.h,
//                    qrCode, "NotoSansArabic-Bold.ttf",
//                    qrTextEl.fontSize, qrTextEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // نوع الحجر
//            val gemEl = lr.getElement("gem", "gemType") ?: ElementPos(39f, 11f, 11f, 4f, 4f)
//            if (!gemType.isNullOrBlank() && gemEl.visible) {
//                api.drawLabelText(gemEl.x, gemEl.y, gemEl.w, gemEl.h,
//                    gemType, "NotoSansArabic-Bold.ttf",
//                    gemEl.fontSize, gemEl.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // note1
//            val note1El = lr.getElement("gem", "note1") ?: ElementPos(39f, 15f, 11f, 4f, 4f)
//            if (!note1.isNullOrBlank() && note1El.visible) {
//                api.drawLabelText(note1El.x, note1El.y, note1El.w, note1El.h,
//                    note1, "NotoSansArabic-Bold.ttf",
//                    note1El.fontSize, note1El.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            // note2
//            val note2El = lr.getElement("gem", "note2") ?: ElementPos(39f, 19f, 11f, 4f, 4f)
//            if (!note2.isNullOrBlank() && note2El.visible) {
//                api.drawLabelText(note2El.x, note2El.y, note2El.w, note2El.h,
//                    note2, "NotoSansArabic-Bold.ttf",
//                    note2El.fontSize, note2El.rotation, 0, 0, 1, 0f, 1.0f,
//                    booleanArrayOf(false, false, false, false))
//            }
//
//            if (showQr == "true") {
//                val qrEl = lr.getElement("gem", "qr") ?: ElementPos(31f, 12f, 7f, 7f)
//                if (qrEl.visible) api.drawLabelQrCode(qrEl.x, qrEl.y, qrEl.w, qrEl.h, qrCode, 31, qrEl.rotation)
//
//                val logoEl = lr.getElement("gem", "logo") ?: ElementPos(35f, 0.5f, 12f, 10f)
//                if (!customLogoBase64.isNullOrBlank() && logoEl.visible) {
//                    try { api.drawLabelImage(customLogoBase64, logoEl.x, logoEl.y, logoEl.w, logoEl.h, logoEl.rotation, 1, 127f) }
//                    catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            } else {
//                val barcodeEl = lr.getElement("gem", "barcode") ?: ElementPos(2f, 2f, 17f, 7.2f)
//                if (barcodeEl.visible) api.drawLabelBarCode(barcodeEl.x, barcodeEl.y, barcodeEl.w, barcodeEl.h, 20, qrCode, 0.25f, barcodeEl.rotation, 2f, 2)
//
//                val logoBarEl = lr.getElement("gem", "logo_bar") ?: ElementPos(1f, 11f, 8f, 8f)
//                if (!customLogoBase64.isNullOrBlank() && logoBarEl.visible) {
//                    try { api.drawLabelImage(customLogoBase64, logoBarEl.x, logoBarEl.y, logoBarEl.w, logoBarEl.h, logoBarEl.rotation, 1, 127f) }
//                    catch (e: Exception) { Log.e("Printer", "فشل طباعة اللوجو", e) }
//                }
//            }
//
//            val jsonBytes = api.generateLabelJson()
//            startPrinting(String(jsonBytes, Charsets.UTF_8), paperInfo, lr.getDensity("gem"))
//        } catch (e: Exception) {
//            sendStatus("error", "فشل في بناء الليبل: ${e.message}")
//            false
//        }
//    }
//
//    private fun sendStatus(status: String, message: String) {
//        statusSink?.success(mapOf("status" to status, "message" to message))
//        Log.d(TAG, "$status → $message")
//    }
//
//    private fun startPrinting(printData: String, paperInfo: PaperInfo, density: Int = 3): Boolean {
//        Handler(Looper.getMainLooper()).post {
//            sendStatus("printing", "جاري الطباعة...")
//
//            try { api.setTotalPrintQuantity(1) }
//            catch (e: Exception) {
//                Handler(Looper.getMainLooper()).post { sendStatus("error", "فشل تحديد الكمية: ${e.message}") }
//                return@post
//            }
//            try {
//                val clampedDensity = density.coerceIn(1, 5)
//                api.startPrintJob(clampedDensity, 1, 0, object : PrintCallback {
//                    override fun onBufferFree(pageIndex: Int, bufferSize: Int) {
//                        val infoJson = """{"printerImageProcessingInfo":{"width":50.0,"height":30.0,"orientation":0,"margin":[0,0,0,0],"horizontalOffset":0,"verticalOffset":0,"printQuantity":1,"epc":""}}"""
//                        try { api.commitData(listOf(printData), listOf(infoJson)) }
//                        catch (ce: Exception) { sendStatus("error", "فشل commitData: ${ce.message}") }
//                    }
//                    override fun onProgress(page: Int, copy: Int, map: HashMap<String, Any>?) {
//                        if (page >= 1 && copy >= 1) sendStatus("success", "تمت الطباعة بنجاح")
//                    }
//                    override fun onError(code: Int) {}
//                    override fun onError(code: Int, state: Int) {}
//                    override fun onCancelJob(success: Boolean) {}
//                })
//            } catch (e: Exception) {
//                sendStatus("error", "استثناء في الطباعة: ${e.message}")
//            }
//        }
//        return true
//    }
//
//    private fun getErrorMessage(code: Int, state: Int? = null): String {
//        val baseMsg = when (code) {
//            -1 -> "فشل عام في الطباعة (تأكد من الاتصال)"
//            -2 -> "بيانات غير صالحة (تحقق من JSON)"
//            -3 -> "الطابعة مشغولة (أعد المحاولة)"
//            -4 -> "نفاد الورق (أعد تحميل الورق)"
//            -5 -> "سخونة زائدة (دع الطابعة تبرد)"
//            -6 -> "بطارية منخفضة (اشحن الطابعة)"
//            -7 -> "غطاء مفتوح (أغلق الغطاء)"
//            else -> "خطأ غير معروف: $code"
//        }
//        return if (state != null) "$baseMsg (الحالة: $state)" else baseMsg
//    }
//}