
package com.kaki_rfid.uhf_gold_shop

import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.os.Handler
import android.os.Looper
import android.util.Base64
import android.util.Log
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject

import com.dothantech.lpapi.LPAPI
import com.dothantech.printer.IDzPrinter

// ====================================================================
//  LpElementPos
// ====================================================================
data class LpElementPos(
    val x: Double,
    val y: Double,
    val w: Double,
    val h: Double,
    val fontSize: Double = 3.0,
    val rotation: Int = 0,
    val visible: Boolean = true
)

// ====================================================================
//  LpDefaultLayouts  –  مطابق 100% لـ DefaultLayouts في label_layout_model.dart
//  ⚠️ أي تعديل في الـ Dart لازم يتعكس هنا بنفس الأرقام
// ====================================================================
object LpDefaultLayouts {

    // ── gold ──────────────────────────────────────────────────────────
    val goldStickerW = 60.0
    val goldStickerH = 24.0
    val gold = mapOf(
        "qrCode_text" to LpElementPos(x=42.73, y=14.03,  w=8.50, h=4.00,  fontSize=3.5, rotation=270),
        "weight"      to LpElementPos(x=51.25,  y=3.25,  w=8.00, h=3.0,  fontSize=3.0, rotation=270),
        "carat"       to LpElementPos(x=54.00,  y=5.0,  w=6.0, h=3.0,  fontSize=3.0, rotation=270),
        "size"        to LpElementPos(x=57.0,  y=5.25,  w=6.0, h=3.0,  fontSize=3.0, rotation=270),
        "qr"          to LpElementPos(x=43.24,  y=2.37,  w=7.0,  h=7.0),
        "logo"        to LpElementPos(x=44.75,  y=12.50,   w=12.0, h=10.0),
        "barcode"     to LpElementPos(x=2.0,   y=12.0,  w=17.0, h=7.2,  visible=false),
        "logo_bar"    to LpElementPos(x=31.0,  y=11.0,  w=8.0,  h=8.0,  visible=false),
    )

    // ── bullion ───────────────────────────────────────────────────────
    val bullionStickerW = 60.0
    val bullionStickerH = 24.0
    val bullion = mapOf(
        "qrCode_text" to LpElementPos(x=42.73, y=14.03,  w=8.50, h=4.00,  fontSize=3.5, rotation=270),
        "weight"      to LpElementPos(x=51.25,  y=3.25,  w=8.00, h=3.0,  fontSize=3.0),
        "note1"       to LpElementPos(x=39.0,  y=14.0,  w=11.0, h=4.0,  fontSize=4.0),
        "note2"       to LpElementPos(x=39.0,  y=18.0,  w=11.0, h=4.0,  fontSize=4.0),
        "qr"          to LpElementPos(x=43.24,  y=2.37,  w=7.0,  h=7.0),
        "logo"        to LpElementPos(x=44.75,  y=12.50,   w=12.0, h=10.0),
        "barcode"     to LpElementPos(x=2.0,   y=2.0,   w=17.0, h=7.2,  visible=false),
        "logo_bar"    to LpElementPos(x=1.0,   y=11.0,  w=8.0,  h=8.0,  visible=false),
    )

    // ── gem ───────────────────────────────────────────────────────────
    val gemStickerW = 60.0
    val gemStickerH = 24.0
    val gem = mapOf(
        "qrCode_text" to LpElementPos(x=42.73, y=14.03,  w=8.50, h=4.00,  fontSize=3.5, rotation=270),
        "gemType"     to LpElementPos(x=39.0,  y=11.0,  w=11.0, h=4.0,  fontSize=4.0),
        "note1"       to LpElementPos(x=39.0,  y=15.0,  w=11.0, h=4.0,  fontSize=4.0),
        "note2"       to LpElementPos(x=39.0,  y=19.0,  w=11.0, h=4.0,  fontSize=4.0),
        "qr"          to LpElementPos(x=43.24,  y=2.37,  w=7.0,  h=7.0),
        "logo"        to LpElementPos(x=44.75,  y=12.50,   w=12.0, h=10.0),
        "barcode"     to LpElementPos(x=2.0,   y=2.0,   w=17.0, h=7.2,  visible=false),
        "logo_bar"    to LpElementPos(x=1.0,   y=11.0,  w=8.0,  h=8.0,  visible=false),
    )

    // ── الكثافة الافتراضية: المستوى 4 من 5 = 13 في LPAPI ──
    const val DEFAULT_DENSITY_UI = 4   // المستوى الرابع في الـ UI (1-5)
    const val DEFAULT_DENSITY_LP = 13  // القيمة المقابلة في LPAPI (7,9,11,13,15)
}

// ====================================================================
//  LpLayoutReader  –  يقرأ من FlutterSharedPreferences أولاً
//  لو مش لاقي → يرجع من LpDefaultLayouts
// ====================================================================
class LpLayoutReader(private val prefs: SharedPreferences) {

    private fun getLayout(labelType: String): JSONObject? {
        val raw = prefs.getString("flutter.label_layout_$labelType", null) ?: return null
        return try { JSONObject(raw) } catch (e: Exception) { null }
    }

    fun getElement(labelType: String, elementId: String): LpElementPos? {
        val layout = getLayout(labelType)
        if (layout != null) {
            val elements = layout.optJSONArray("elements") ?: return defaultElement(labelType, elementId)
            for (i in 0 until elements.length()) {
                val el = elements.optJSONObject(i) ?: continue
                if (el.optString("id") == elementId) {
                    return LpElementPos(
                        x        = el.optDouble("x",        0.0),
                        y        = el.optDouble("y",        0.0),
                        w        = el.optDouble("w",        10.0),
                        h        = el.optDouble("h",        5.0),
                        fontSize = el.optDouble("fontSize", 3.0),
                        rotation = el.optInt("rotation",    0),
                        visible  = el.optBoolean("visible", true)
                    )
                }
            }
        }
        return defaultElement(labelType, elementId)
    }

    fun getStickerSize(labelType: String): Pair<Double, Double> {
        val layout = getLayout(labelType)
        if (layout != null) {
            return Pair(
                layout.optDouble("stickerW", defaultStickerW(labelType)),
                layout.optDouble("stickerH", defaultStickerH(labelType))
            )
        }
        return Pair(defaultStickerW(labelType), defaultStickerH(labelType))
    }

    // ────────────────────────────────────────────────────────────────
    //  getDensity
    //  يقرأ الكثافة المحفوظة في الـ layout (1-5 من الـ UI)
    //  ويترجمها لقيمة LPAPI حسب الجدول:
    //    UI 1 → LP 7   (خفيف جداً)
    //    UI 2 → LP 9   (خفيف)
    //    UI 3 → LP 11  (متوسط)
    //    UI 4 → LP 13  (غامق)       ← الافتراضي
    //    UI 5 → LP 15  (غامق جداً)
    // ────────────────────────────────────────────────────────────────
    fun getDensity(labelType: String): Int {
        val layout = getLayout(labelType)
        val uiDensity = layout?.optInt("density", LpDefaultLayouts.DEFAULT_DENSITY_UI)
            ?: LpDefaultLayouts.DEFAULT_DENSITY_UI
        return uiDensityToLp(uiDensity)
    }

    private fun uiDensityToLp(uiDensity: Int): Int = when (uiDensity.coerceIn(1, 5)) {
        1    -> 7
        2    -> 9
        3    -> 11
        4    -> 13
        5    -> 15
        else -> LpDefaultLayouts.DEFAULT_DENSITY_LP
    }

    private fun defaultElement(labelType: String, id: String) = when (labelType) {
        "gold"    -> LpDefaultLayouts.gold[id]
        "bullion" -> LpDefaultLayouts.bullion[id]
        "gem"     -> LpDefaultLayouts.gem[id]
        else      -> null
    }

    private fun defaultStickerW(t: String) = when (t) {
        "gold"    -> LpDefaultLayouts.goldStickerW
        "bullion" -> LpDefaultLayouts.bullionStickerW
        "gem"     -> LpDefaultLayouts.gemStickerW
        else      -> 60.0
    }

    private fun defaultStickerH(t: String) = when (t) {
        "gold"    -> LpDefaultLayouts.goldStickerH
        "bullion" -> LpDefaultLayouts.bullionStickerH
        "gem"     -> LpDefaultLayouts.gemStickerH
        else      -> 24.0
    }
}

// ====================================================================
//  NewPrinterBridge
// ====================================================================
class NewPrinterBridge(private val context: Context) {

    companion object {
        private const val TAG = "NewPrinterBridge"
        const val METHOD_CHANNEL = "new_printer"
        const val EVENT_CHANNEL  = "new_printer_status"
    }

    private var statusSink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    private val prefs: SharedPreferences =
        context.getSharedPreferences("new_printer_prefs", Context.MODE_PRIVATE)

    private val flutterPrefs: SharedPreferences by lazy {
        context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
    }

    private val layoutReader: LpLayoutReader by lazy {
        LpLayoutReader(flutterPrefs)
    }

    @Volatile private var isPrinterConnected: Boolean = false
    private val api: LPAPI

    private val lpCallback = object : LPAPI.Callback {
        override fun onStateChange(address: IDzPrinter.PrinterAddress?, state: IDzPrinter.PrinterState?) {
            when (state) {
                IDzPrinter.PrinterState.Connected,
                IDzPrinter.PrinterState.Connected2 -> {
                    isPrinterConnected = true
                    val mac = address?.macAddress ?: ""
                    if (mac.isNotBlank()) saveLastPrinter(mac)
                    sendStatus("connected", "متصل")
                }
                IDzPrinter.PrinterState.Disconnected -> {
                    isPrinterConnected = false
                    sendStatus("disconnected", "تم فصل الطابعة")
                }
                else -> sendStatus("connecting", "جاري الاتصال...")
            }
        }
        override fun onProgressInfo(info: IDzPrinter.ProgressInfo?, extra: Any?) {
            sendStatus("printing", "جاري الطباعة...")
        }
        override fun onPrinterDiscovery(address: IDzPrinter.PrinterAddress?, info: Any?) {}
        override fun onPrintProgress(
            address: IDzPrinter.PrinterAddress?,
            data: IDzPrinter.PrintData?,
            progress: IDzPrinter.PrintProgress?,
            extra: Any?
        ) {
            when (progress) {
                IDzPrinter.PrintProgress.Success -> sendStatus("success", "تمت الطباعة")
                IDzPrinter.PrintProgress.Failed  -> sendStatus("error", "فشل الطباعة")
                else -> {}
            }
        }
    }

    init { api = LPAPI.Factory.createInstance(lpCallback) }

    fun setStatusSink(sink: EventChannel.EventSink?) { statusSink = sink }

    fun scanBluetoothPrinters(): List<Map<String, String>> {
        val adapter = BluetoothAdapter.getDefaultAdapter() ?: return emptyList()
        if (!adapter.isEnabled) return emptyList()
        return adapter.bondedDevices.mapNotNull {
            val name = it.name ?: return@mapNotNull null
            val mac  = it.address ?: return@mapNotNull null
            mapOf("name" to name, "address" to mac)
        }
    }

    fun connectBluetooth(mac: String): Boolean {
        if (isPrinterConnected) return true
        return try {
            val ok = api.openPrinterByAddress(IDzPrinter.PrinterAddress(mac, IDzPrinter.AddressType.BLE))
            if (ok) { saveLastPrinter(mac); isPrinterConnected = true }
            ok
        } catch (e: Exception) { sendStatus("error", e.message ?: "error"); false }
    }

    fun disconnect(): Boolean {
        return try {
            api.closePrinter(); isPrinterConnected = false
            sendStatus("disconnected", "تم فصل الطابعة"); true
        } catch (e: Exception) { sendStatus("error", "فشل فصل الطابعة: ${e.message}"); false }
    }

    fun isConnected(): Boolean = isPrinterConnected

    fun printText(text: String): Boolean {
        if (!isPrinterConnected) return false
        return try {
            api.startJob(40.0, 30.0, 0)
            api.drawText(text, 5.0, 5.0, 20.0, 20.0, 3.0)
            api.commitJob()
            true
        } catch (e: Exception) { false }
    }

    // ====================================================================
    //  drawLabelText
    //  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    //  الإحداثيات x,y بتيجي مباشرة من الـ editor بدون أي قلب أو mirror
    //
    //  لما rotation=90 أو 270:
    //    الـ LPAPI بيستخدم w و h بعد الدوران (معكوسين)
    //    يعني لازم نبعت: w=el.h, h=el.w  (swap)
    //    مثال: weight w=12, h=3, rot=270 → نبعت w=3, h=12
    // ====================================================================
    private fun drawLabelText(text: String, el: LpElementPos) {
        try {
            api.setItemOrientation(convertRotation(el.rotation))
            when (el.rotation) {
                90, 270 -> api.drawText(text, el.x, el.y, el.h, el.w, el.fontSize)
                else    -> api.drawText(text, el.x, el.y, el.w, el.h, el.fontSize)
            }
            api.setItemOrientation(0)
        } catch (e: Exception) { Log.e(TAG, "drawText error: ${e.message}") }
    }

    private fun convertRotation(r: Int): Int = when (r) { 90->1; 180->2; 270->3; else->0 }

    private fun drawBase64Image(base64: String, el: LpElementPos) {
        try {
            val bytes = Base64.decode(base64, Base64.DEFAULT)
            val bmp = BitmapFactory.decodeByteArray(bytes, 0, bytes.size) ?: return
            api.drawBitmap(bmp, el.x, el.y, el.w, el.h)
        } catch (e: Exception) { Log.e(TAG, "drawBitmap error: ${e.message}") }
    }

    // ====================================================================
    //  setPrintDarkness - يضبط كثافة الطباعة قبل startJob
    //  LPAPI بيقبل قيم من 6 لـ 15، بنستخدم 7,9,11,13,15 فقط
    // ====================================================================
    private fun applyDensity(labelType: String) {
        val lpDensity = layoutReader.getDensity(labelType)
        try {
            api.setPrintDarkness(lpDensity)
        } catch (e: Exception) {
            Log.e(TAG, "setPrintDarkness error: ${e.message}")
        }
    }

    // ====================================================================
    //  printGoldLabel
    // ====================================================================
    fun printGoldLabel(
        weight: String? = null, carat: String? = null,
        size: String? = null, showQr: String, qrCode: String,
        customLogoBase64: String? = null, labelLayout: Any? = null
    ): Boolean {
        if (!isPrinterConnected) return false
        val lr = layoutReader
        val (sW, sH) = lr.getStickerSize("gold")

        return try {
            // ✅ تطبيق الكثافة قبل startJob
            applyDensity("gold")
            api.startJob(sW, sH, 0)

            lr.getElement("gold", "qrCode_text")?.let { if (it.visible) drawLabelText(qrCode, it) }
            lr.getElement("gold", "weight")?.let      { if (!weight.isNullOrBlank() && it.visible) drawLabelText("W$weight", it) }
            lr.getElement("gold", "carat")?.let       { if (!carat.isNullOrBlank()  && it.visible) drawLabelText("K$carat",  it) }
            lr.getElement("gold", "size")?.let        { if (!size.isNullOrBlank()   && it.visible) drawLabelText("S$size",   it) }

            if (showQr == "true") {
                lr.getElement("gold", "qr")?.let   { if (it.visible) api.draw2DQRCode(qrCode, it.x, it.y, minOf(it.w, it.h)) }
                lr.getElement("gold", "logo")?.let { if (!customLogoBase64.isNullOrBlank() && it.visible) drawBase64Image(customLogoBase64, it) }
            } else {
                lr.getElement("gold", "barcode")?.let  { if (it.visible) api.draw1DBarcode(qrCode, LPAPI.BarcodeType.CODE128, it.x, it.y, it.w, it.h, 0.5) }
                lr.getElement("gold", "logo_bar")?.let { if (!customLogoBase64.isNullOrBlank() && it.visible) drawBase64Image(customLogoBase64, it) }
            }

            api.commitJob()
            sendStatus("success", "تمت الطباعة بنجاح")
            true
        } catch (e: Exception) { sendStatus("error", "خطأ: ${e.message}"); false }
    }

    // ====================================================================
    //  printBullionLabel
    // ====================================================================
    fun printBullionLabel(
        weight: String? = null, note1: String? = null,
        note2: String? = null, showQr: String, qrCode: String,
        customLogoBase64: String? = null, labelLayout: Any? = null
    ): Boolean {
        if (!isPrinterConnected) return false
        val lr = layoutReader
        val (sW, sH) = lr.getStickerSize("bullion")

        return try {
            applyDensity("bullion")
            api.startJob(sW, sH, 0)

            lr.getElement("bullion", "qrCode_text")?.let { if (it.visible) drawLabelText(qrCode, it) }
            lr.getElement("bullion", "weight")?.let      { if (!weight.isNullOrBlank() && it.visible) drawLabelText("W $weight", it) }
            lr.getElement("bullion", "note1")?.let       { if (!note1.isNullOrBlank()  && it.visible) drawLabelText(note1, it) }
            lr.getElement("bullion", "note2")?.let       { if (!note2.isNullOrBlank()  && it.visible) drawLabelText(note2, it) }

            if (showQr == "true") {
                lr.getElement("bullion", "qr")?.let    { if (it.visible) api.draw2DQRCode(qrCode, it.x, it.y, minOf(it.w, it.h)) }
                lr.getElement("bullion", "logo")?.let  { if (!customLogoBase64.isNullOrBlank() && it.visible) drawBase64Image(customLogoBase64, it) }
            } else {
                lr.getElement("bullion", "barcode")?.let  { if (it.visible) api.draw1DBarcode(qrCode, LPAPI.BarcodeType.CODE128, it.x, it.y, it.w, it.h, 0.5) }
                lr.getElement("bullion", "logo_bar")?.let { if (!customLogoBase64.isNullOrBlank() && it.visible) drawBase64Image(customLogoBase64, it) }
            }

            api.commitJob()
            sendStatus("success", "تمت الطباعة بنجاح")
            true
        } catch (e: Exception) { sendStatus("error", "خطأ: ${e.message}"); false }
    }

    // ====================================================================
    //  printGemLabel
    // ====================================================================
    fun printGemLabel(
        gemType: String? = null, note1: String? = null,
        note2: String? = null, showQr: String, qrCode: String,
        customLogoBase64: String? = null, labelLayout: Any? = null
    ): Boolean {
        if (!isPrinterConnected) return false
        val lr = layoutReader
        val (sW, sH) = lr.getStickerSize("gem")

        return try {
            applyDensity("gem")
            api.startJob(sW, sH, 0)

            lr.getElement("gem", "qrCode_text")?.let { if (it.visible) drawLabelText(qrCode, it) }
            lr.getElement("gem", "gemType")?.let     { if (!gemType.isNullOrBlank() && it.visible) drawLabelText(gemType, it) }
            lr.getElement("gem", "note1")?.let       { if (!note1.isNullOrBlank()   && it.visible) drawLabelText(note1, it) }
            lr.getElement("gem", "note2")?.let       { if (!note2.isNullOrBlank()   && it.visible) drawLabelText(note2, it) }

            if (showQr == "true") {
                lr.getElement("gem", "qr")?.let    { if (it.visible) api.draw2DQRCode(qrCode, it.x, it.y, minOf(it.w, it.h)) }
                lr.getElement("gem", "logo")?.let  { if (!customLogoBase64.isNullOrBlank() && it.visible) drawBase64Image(customLogoBase64, it) }
            } else {
                lr.getElement("gem", "barcode")?.let  { if (it.visible) api.draw1DBarcode(qrCode, LPAPI.BarcodeType.CODE128, it.x, it.y, it.w, it.h, 0.5) }
                lr.getElement("gem", "logo_bar")?.let { if (!customLogoBase64.isNullOrBlank() && it.visible) drawBase64Image(customLogoBase64, it) }
            }

            api.commitJob()
            sendStatus("success", "تمت الطباعة بنجاح")
            true
        } catch (e: Exception) { sendStatus("error", "خطأ: ${e.message}"); false }
    }

    private fun sendStatus(status: String, message: String) {
        mainHandler.post { statusSink?.success(mapOf("status" to status, "message" to message)) }
    }

    private fun saveLastPrinter(mac: String) {
        prefs.edit().putString("last_printer_mac", mac).apply()
    }
}
