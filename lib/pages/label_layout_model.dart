
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ======== نموذج عنصر واحد على الاستيكر ========
class LabelElement {
  final String id;       // مثلاً: 'weight', 'carat', 'qr', 'logo', 'barcode'
  final String label;    // الاسم اللي يظهر للمستخدم
  double x;             // بالمللي متر من يسار الاستيكر
  double y;             // بالمللي متر من أعلى الاستيكر
  double w;             // العرض بالمللي متر
  double h;             // الارتفاع بالمللي متر
  double fontSize;      // حجم الخط (للنصوص فقط)
  int rotation;         // الدوران: 0, 90, 180, 270
  bool visible;

  LabelElement({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    this.fontSize = 3.0,
    this.rotation = 0,
    this.visible = true,
  });

  LabelElement copyWith({
    double? x, double? y, double? w, double? h,
    double? fontSize, int? rotation, bool? visible,
  }) => LabelElement(
    id: id, label: label,
    x: x ?? this.x, y: y ?? this.y,
    w: w ?? this.w, h: h ?? this.h,
    fontSize: fontSize ?? this.fontSize,
    rotation: rotation ?? this.rotation,
    visible: visible ?? this.visible,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'label': label,
    'x': x, 'y': y, 'w': w, 'h': h,
    'fontSize': fontSize, 'rotation': rotation, 'visible': visible,
  };

  factory LabelElement.fromJson(Map<String, dynamic> j) => LabelElement(
    id: j['id'], label: j['label'],
    x: (j['x'] as num).toDouble(), y: (j['y'] as num).toDouble(),
    w: (j['w'] as num).toDouble(), h: (j['h'] as num).toDouble(),
    fontSize: (j['fontSize'] as num?)?.toDouble() ?? 3.0,
    rotation: (j['rotation'] as num?)?.toInt() ?? 0,
    visible: j['visible'] as bool? ?? true,
  );
}

// ======== نموذج تخطيط الاستيكر كامل ========
class LabelLayout {
  final String labelType;   // 'gold', 'bullion', 'gem'
  double stickerW;          // عرض الاستيكر بالمللي متر
  double stickerH;          // ارتفاع الاستيكر بالمللي متر
  int density;              // كثافة الطباعة: 1-5 (الافتراضي 3)
  List<LabelElement> elements;

  LabelLayout({
    required this.labelType,
    required this.stickerW,
    required this.stickerH,
    this.density = 4,
    required this.elements,
  });

  Map<String, dynamic> toJson() => {
    'labelType': labelType,
    'stickerW': stickerW,
    'stickerH': stickerH,
    'density': density,
    'elements': elements.map((e) => e.toJson()).toList(),
  };

  factory LabelLayout.fromJson(Map<String, dynamic> j) => LabelLayout(
    labelType: j['labelType'],
    stickerW: (j['stickerW'] as num).toDouble(),
    stickerH: (j['stickerH'] as num).toDouble(),
    density: (j['density'] as num?)?.toInt() ?? 3,
    elements: (j['elements'] as List)
        .map((e) => LabelElement.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  LabelElement? getElement(String id) {
    try { return elements.firstWhere((e) => e.id == id); }
    catch (_) { return null; }
  }
}

// ======== الـ Layouts الافتراضية مطابقة لـ PrinterBridge.kt ========
class DefaultLayouts {
  static LabelLayout goldLabel() => LabelLayout(
    labelType: 'gold',
    stickerW: 60, stickerH: 24,
    elements: [
      LabelElement(id: 'qrCode_text', label: 'الكود', x: 42.73, y: 14.03, w: 8.50, h: 4.00, fontSize: 3.5, rotation: 270),
      LabelElement(id: 'weight',      label: 'الوزن',        x: 51, y: 3.25,  w: 8, h: 3,   fontSize: 3.0, rotation: 270),
      LabelElement(id: 'carat',       label: 'العيار',       x: 54, y: 5,  w: 6, h: 3,   fontSize: 3.0, rotation: 270),
      LabelElement(id: 'size',        label: 'المقاس',       x: 57, y: 5.25,  w: 6, h: 3,   fontSize: 3.0, rotation: 270),
      LabelElement(id: 'qr',         label: 'QR Code',      x: 43.24, y: 2.37,  w: 7,  h: 7),
      LabelElement(id: 'logo',       label: 'اللوجو',       x: 44.75, y: 12.50, w: 12.00, h: 10.00),
      LabelElement(id: 'barcode',    label: 'Barcode',      x: 2,  y: 12,  w: 17, h: 7.2, visible: false),
      LabelElement(id: 'logo_bar',   label: 'لوجو (باركود)', x: 31, y: 11, w: 8, h: 8,   visible: false),
    ],
  );

  static LabelLayout bullionLabel() => LabelLayout(
    labelType: 'bullion',
    stickerW: 60, stickerH: 24,
    elements: [
      LabelElement(id: 'qrCode_text', label: 'الكود',x: 42.73, y: 14.3, w: 8.50, h: 4.00, fontSize: 3.5, rotation: 270),
      LabelElement(id: 'weight',      label: 'الوزن',       x: 51, y: 3.25,  w: 8, h: 3,   fontSize: 3.0),
      LabelElement(id: 'note1',       label: 'ملاحظة 1',     x: 39, y: 14,  w: 11, h: 4,   fontSize: 4.0),
      LabelElement(id: 'note2',       label: 'ملاحظة 2',     x: 39, y: 18,  w: 11, h: 4,   fontSize: 4.0),
      LabelElement(id: 'qr',         label: 'QR Code',      x: 43.24, y: 2.37,  w: 7,  h: 7),
      LabelElement(id: 'logo',       label: 'اللوجو',       x: 44.75, y: 12.50, w: 12.00, h: 10.00),
      LabelElement(id: 'barcode',    label: 'Barcode',      x: 2,  y: 2,   w: 17, h: 7.2, visible: false),
      LabelElement(id: 'logo_bar',   label: 'لوجو (باركود)', x: 31, y: 11, w: 8, h: 8,   visible: false),
    ],
  );

  static LabelLayout gemLabel() => LabelLayout(
    labelType: 'gem',
    stickerW: 60, stickerH: 24,
    elements: [
      LabelElement(id: 'qrCode_text', label: 'الكود', x: 42.73, y: 14.3, w: 8.50, h: 4.00, fontSize: 3.5, rotation: 270),
      LabelElement(id: 'gemType',     label: 'نوع الحجر',   x: 39, y: 11,  w: 11, h: 4,   fontSize: 4.0),
      LabelElement(id: 'note1',       label: 'ملاحظة 1',    x: 39, y: 15,  w: 11, h: 4,   fontSize: 4.0),
      LabelElement(id: 'note2',       label: 'ملاحظة 2',    x: 39, y: 19,  w: 11, h: 4,   fontSize: 4.0),
      LabelElement(id: 'qr',         label: 'QR Code',     x: 43.24, y: 2.37,  w: 7,  h: 7),
      LabelElement(id: 'logo',       label: 'اللوجو',      x: 44.75, y: 12.50, w: 12.00, h: 10.00),
      LabelElement(id: 'barcode',    label: 'Barcode',     x: 2,  y: 2,   w: 17, h: 7.2, visible: false),
      LabelElement(id: 'logo_bar',   label: 'لوجو (باركود)', x: 31, y: 11, w: 8, h: 8,   visible: false),
    ],
  );
}


// ======== نموذج الـ Profile ========
class LabelProfile {
  final String id;          // UUID فريد
  final String name;        // اسم يختاره المستخدم
  final String labelType;   // 'gold' | 'bullion' | 'gem'
  final DateTime savedAt;
  final LabelLayout layout;

  LabelProfile({
    required this.id,
    required this.name,
    required this.labelType,
    required this.savedAt,
    required this.layout,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'labelType': labelType,
    'savedAt': savedAt.toIso8601String(),
    'layout': layout.toJson(),
  };

  factory LabelProfile.fromJson(Map<String, dynamic> j) => LabelProfile(
    id: j['id'],
    name: j['name'],
    labelType: j['labelType'],
    savedAt: DateTime.parse(j['savedAt']),
    layout: LabelLayout.fromJson(j['layout']),
  );
}

// ======== حفظ وتحميل الـ Profiles ========
class LabelProfileStorage {
  // key لقائمة الـ profiles لكل نوع
  static String _listKey(String labelType) => 'label_profiles_$labelType';

  // تحميل كل الـ profiles لنوع معين
  static Future<List<LabelProfile>> loadAll(String labelType) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_listKey(labelType));
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => LabelProfile.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt)); // الأحدث أولاً
    } catch (_) {
      return [];
    }
  }

  // حفظ profile جديد (أو استبداله لو نفس الـ id)
  static Future<void> save(LabelProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadAll(profile.labelType);
    final idx = all.indexWhere((p) => p.id == profile.id);
    if (idx >= 0) {
      all[idx] = profile;
    } else {
      all.insert(0, profile);
    }
    await prefs.setString(
      _listKey(profile.labelType),
      jsonEncode(all.map((p) => p.toJson()).toList()),
    );
  }

  // حذف profile بالـ id
  static Future<void> delete(String labelType, String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadAll(labelType);
    all.removeWhere((p) => p.id == profileId);
    await prefs.setString(
      _listKey(labelType),
      jsonEncode(all.map((p) => p.toJson()).toList()),
    );
  }

  // إنشاء id فريد بسيط
  static String generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  // حفظ الـ Profile النشط (آخر اختيار)
  static Future<void> saveActive(String labelType, String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('label_active_profile_$labelType', profileId);
  }

// تحميل الـ Profile النشط
  static Future<LabelProfile?> loadActive(String labelType) async {
    final prefs = await SharedPreferences.getInstance();
    final activeId = prefs.getString('label_active_profile_$labelType');
    if (activeId == null) return null;

    final all = await loadAll(labelType);
    try {
      return all.firstWhere((p) => p.id == activeId);
    } catch (_) {
      // لو الـ profile اتحذف قبل كده
      await prefs.remove('label_active_profile_$labelType');
      return null;
    }
  }

// مسح الـ Profile النشط (اختياري)
  static Future<void> clearActive(String labelType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('label_active_profile_$labelType');
  }
}

// ======== حفظ وتحميل من SharedPreferences ========
class LabelLayoutStorage {
  static String _key(String type) => 'label_layout_$type';

  static Future<void> save(LabelLayout layout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(layout.labelType), jsonEncode(layout.toJson()));
  }

  static Future<LabelLayout> load(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(type));
    if (raw != null) {
      try { return LabelLayout.fromJson(jsonDecode(raw)); }
      catch (_) {}
    }
    // رجوع للافتراضي
    return _default(type);
  }

  static LabelLayout _default(String type) {
    switch (type) {
      case 'bullion': return DefaultLayouts.bullionLabel();
      case 'gem':     return DefaultLayouts.gemLabel();
      default:        return DefaultLayouts.goldLabel();
    }
  }

  static Future<void> reset(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(type));
  }
}
