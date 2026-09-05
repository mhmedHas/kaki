import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:uhf_gold_shop/pages/report_opening_page.dart';
import 'print_page.dart';
//import 'printer_page.dart';
import '../services/firestore_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'scrap_page.dart';
import 'PdfReportsPage.dart';
import 'cash_box_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Total_Report.dart';
import 'daily_transactions_page.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/new_printer_api.dart';
import 'label_layout_model.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with TickerProviderStateMixin {
  late final TabController _tab = TabController(length: 5, vsync: this);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(_t("التقارير", "Reports")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // شبكة الأزرار (2×2)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 1, // زرار واحد في السطر
                  mainAxisSpacing: 12,
                  childAspectRatio: 4, // كل ما الرقم كبر الزرار يبقى أطول
                  children: [
                    _buildMenuCard(
                      context,
                      icon: Icons.print,
                      label: _t("pdf", "PDF"),
                      page: const printPage(),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.desktop_windows_sharp,
                      label: _t("عرض التقارير", "View Reports"),
                      page: const partPage(),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.analytics_outlined,
                      label: _t("الرصيد العام", "General Balance"),
                      page: const GeneralBalancePage(), // الصفحة الجديدة
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? page,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              );
            }
          },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: const Color(0xFFD4AF37).withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(width: 20),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class printPage extends StatefulWidget {
  const printPage({super.key});

  @override
  State<printPage> createState() => _printPageState();
}

class _printPageState extends State<printPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("ملفات pdf", "PDF Files")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildReportButton(
                context,
                icon: Icons.picture_as_pdf,
                label: _t("تقارير PDF", "PDF Reports"),
                onTap: () async {
                  DateTime? start = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: _t('اختر تاريخ البداية', 'Select start date'),
                  );
                  if (start == null) return;
                  start = DateTime(start.year, start.month, start.day, 0, 0, 0);

                  DateTime? end = await showDatePicker(
                    context: context,
                    initialDate: start,
                    firstDate: start,
                    lastDate: DateTime(2100),
                    helpText: _t('اختر تاريخ النهاية', 'Select end date'),
                  );
                  if (end == null) return;
                  end = DateTime(end.year, end.month, end.day, 23, 59, 59);

                  await PdfReport.printReport(start, end);
                },
              ),
              const SizedBox(height: 20),
              _buildReportButton(
                context,
                icon: Icons.summarize,
                label: _t("تقارير الإجماليات", "Total Reports"),
                onTap: () async {
                  DateTime? start = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: _t('اختر تاريخ البداية', 'Select start date'),
                  );
                  if (start == null) return;
                  start = DateTime(start.year, start.month, start.day, 0, 0, 0);

                  DateTime? end = await showDatePicker(
                    context: context,
                    initialDate: start,
                    firstDate: start,
                    lastDate: DateTime(2100),
                    helpText: _t('اختر تاريخ النهاية', 'Select end date'),
                  );
                  if (end == null) return;
                  end = DateTime(end.year, end.month, end.day, 23, 59, 59);

                  await PdfReport.printReportTotal(start, end);
                },
              ),
              const SizedBox(height: 20),
              _buildReportButton(
                context,
                icon: Icons.folder_open,
                label: _t("التقارير السابقة", "Previous Reports"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PdfReportsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class partPage extends StatefulWidget {
  const partPage({super.key});

  @override
  State<partPage> createState() => _partPageState();
}

class _partPageState extends State<partPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("الاقسام", "Sections")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.7,
                    children: [
                      _buildMenuCard(
                        context,
                        icon: Icons.add_box,
                        label: _t("الادخال", "Input"),
                        page: const _ItemsList(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.account_balance_wallet,
                        label: _t("ر.الافتتاحي", "O.Balance"),
                        page: const OpeningBalanceDisplayPage(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.inventory,
                        label: _t("الجرد", "Inventory"),
                        page: const _InventoryList(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.shopping_cart,
                        label: _t("البيع", "Sales"),
                        page: const _SalesList(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.report_problem,
                        label: _t("المفقود", "Missing"),
                        page: const _MissingList(),
                      ),
                      // _buildMenuCard(
                      //   context,
                      //   icon: Icons.inventory_2_outlined,
                      //   label: _t("بقايا الأطقم", "Set Remainders"),
                      //   page: const _SetRemaindersList(),
                      // ),
                      _buildMenuCard(
                        context,
                        icon: Icons.handyman,
                        label: _t("الكسر", "Scrap"),
                        page: const ScrapReports(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.edit,
                        label: _t("التعديلات", "Updates"),
                        page: const _UpdatedList(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.mail_rounded,
                        label: _t("التحويلات", "Transfers"),
                        page: const _TransfersList(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.monetization_on,
                        label: _t("المصروفات", "Expenses"),
                        page: const _ExpensesList(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.people,
                        label: _t("الموردين", "Suppliers List"),
                        page: const SuppliersPage(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.download,
                        label: _t("الاستيراد", "Imports"),
                        page: const _ImportsList(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.upload,
                        label: _t("التوريد", "Deposits"),
                        page: const _DepositsList(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.account_balance_wallet,
                        label: _t("الصندوق", "Cash Box"),
                        page: const CashBoxPage(),
                      ),
                      _buildMenuCard(
                        context,
                        icon: Icons.person,
                        label: _t("البائعين", "Salers"),
                        page: const _SalerList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? page,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              );
            }
          },
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          color: const Color(0xFFD4AF37).withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 25, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPage(BuildContext context, Widget page) async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

Widget _buildBarChart(Map<String, dynamic> totals,
    {bool showPrice = false, String lang = 'ar'}) {
  String t(String ar, String en) => lang == 'ar' ? ar : en;

  final colorMap = <String, Color>{
    t('عيار 18', 'Carat 18'): Colors.green,
    t('عيار 21', 'Carat 21'): Colors.blue,
    t('عيار 22', 'Carat 22'): Colors.orange,
    t('سبائك', 'Bullion'): Colors.brown,
    t('أحجار', 'Gems'): Colors.purple,
  };

  const allLabelsAr = [
    'عيار 18',
    'عيار 21',
    'عيار 22',
    'سبائك',
    'أحجار',
  ];
  const allLabelsEn = [
    'Carat 18',
    'Carat 21',
    'Carat 22',
    'Bullion',
    'Gems',
  ];

  final allLabels = lang == 'ar' ? allLabelsAr : allLabelsEn;

  final counts = <double>[];
  final weights = <double>[];
  final prices = <double>[];

  for (final label in allLabels) {
    switch (label) {
      case 'عيار 18':
      case 'Carat 18':
        counts.add((totals['carat18Count'] ?? 0).toDouble());
        weights.add((totals['carat18'] ?? 0.0) as double);
        prices.add((totals['carat18Price'] ?? 0.0) as double);
        break;
      case 'عيار 21':
      case 'Carat 21':
        counts.add((totals['carat21Count'] ?? 0).toDouble());
        weights.add((totals['carat21'] ?? 0.0) as double);
        prices.add((totals['carat21Price'] ?? 0.0) as double);
        break;
      case 'عيار 22':
      case 'Carat 22':
        counts.add((totals['carat22Count'] ?? 0).toDouble());
        weights.add((totals['carat22'] ?? 0.0) as double);
        prices.add((totals['carat22Price'] ?? 0.0) as double);
        break;
      case 'سبائك':
      case 'Bullion':
        counts.add((totals['bullionCount'] ?? 0).toDouble());
        weights.add((totals['bullionWeight'] ?? 0.0) as double);
        prices.add((totals['bullionPrice'] ?? 0.0) as double);
        break;
      case 'أحجار':
      case 'Gems':
        counts.add((totals['gemsCount'] ?? 0).toDouble());
        weights.add(0.0);
        prices.add((totals['gemsPrice'] ?? 0.0) as double);
        break;
      default:
        counts.add(0.0);
        weights.add(0.0);
        prices.add(0.0);
    }
  }

  final maxCount = counts.reduce((a, b) => a > b ? a : b);
  final maxWeight = weights.reduce((a, b) => a > b ? a : b);
  final safeMaxCount = maxCount > 0 ? maxCount : 1;
  final safeMaxWeight = maxWeight > 0 ? maxWeight : 1;

  String formatWeight(double grams) {
    final kilos = grams ~/ 1000;
    final remainingGrams = grams % 1000;
    final gramsInt = remainingGrams.toInt();
    final millis = ((remainingGrams - gramsInt) * 1000).round();

    String result = '';
    if (kilos > 0) result += '$kilos K ';
    if (gramsInt > 0) result += '$gramsInt G ';
    if (millis > 0) result += '$millis M';
    if (result.isEmpty) result = '0 G';
    return result.trim();
  }

  final barGroups = <BarChartGroupData>[];
  const double rodWidth = 14;
  const double barsSpace = 4;

  for (var i = 0; i < allLabels.length; i++) {
    final label = allLabels[i];
    final c = counts[i];
    final w = weights[i];
    final baseColor = colorMap[label] ?? Colors.grey;
    final countColor = baseColor;
    final weightColor = baseColor.withOpacity(0.60);

    final rods = <BarChartRodData>[];
    rods.add(BarChartRodData(
      toY: c / safeMaxCount,
      width: rodWidth,
      borderRadius: BorderRadius.circular(6),
      color: countColor,
    ));
    if (label != t('أحجار', 'Gems')) {
      rods.add(BarChartRodData(
        toY: w / safeMaxWeight,
        width: rodWidth,
        borderRadius: BorderRadius.circular(6),
        color: weightColor,
      ));
    }

    barGroups.add(BarChartGroupData(
      x: i,
      barsSpace: barsSpace,
      barRods: rods,
      showingTooltipIndicators: [],
    ));
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DataTable(
            columnSpacing: 14,
            headingRowHeight: 44,
            dataRowHeight: 40,
            border: TableBorder.all(
              color: Colors.grey.shade300,
              width: 0.8,
              borderRadius: BorderRadius.circular(12),
            ),
            headingRowColor: WidgetStateProperty.all(
              Colors.blue.shade50,
            ),
            columns: [
              DataColumn(
                label: Row(
                  children: [
                    const Icon(Icons.category, size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(t("القسم", "Part"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              DataColumn(
                label: Row(
                  children: [
                    const Icon(Icons.format_list_numbered,
                        size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(t("العدد", "Count"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              DataColumn(
                label: Row(
                  children: [
                    const Icon(Icons.scale, size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(t("الوزن", "Weight"),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              if (showPrice)
                DataColumn(
                  label: Row(
                    children: [
                      const Icon(Icons.price_change,
                          size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(t("السعر", "Price"),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ],
            rows: [
              for (var i = 0; i < allLabels.length; i++)
                DataRow(
                  color: WidgetStateProperty.all(
                    i.isEven ? Colors.white : Colors.grey.shade50,
                  ),
                  cells: [
                    DataCell(Text(allLabels[i],
                        style: const TextStyle(fontSize: 11))),
                    DataCell(Text(counts[i].toInt().toString(),
                        style: const TextStyle(fontSize: 11))),
                    DataCell(Text(formatWeight(weights[i]),
                        style: const TextStyle(fontSize: 11))),
                    if (showPrice)
                      DataCell(Text(prices[i].toStringAsFixed(2),
                          style: const TextStyle(fontSize: 11))),
                  ],
                ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _TransfersList extends StatefulWidget {
  const _TransfersList();

  @override
  State<_TransfersList> createState() => _TransfersListState();
}

class _TransfersListState extends State<_TransfersList> {
  DateTimeRange? _selectedRange;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  List<QueryDocumentSnapshot> _currentTransfers = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    // افتراضيًا: عرض تحويلات اليوم الحالي
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _selectedRange = DateTimeRange(start: startOfDay, end: endOfDay);
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _printTransfersReport() async {
    if (_currentTransfers.isEmpty) return;

    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    final totalTransfers = _currentTransfers.length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text(
            "تقرير التحويلات",
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(0.8),
              6: pw.FlexColumnWidth(1.2),
              7: pw.FlexColumnWidth(1.2),
              8: pw.FlexColumnWidth(1.5),
              9: pw.FlexColumnWidth(1.5),
            },
            children: [
              /// HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "التاريخ",
                  "الفرع",
                  "المندوب",
                  "وزن",
                  "أجر",
                  "عيار",
                  "نوع",
                  "تكلفة",
                  "مكونات",
                  "ملاحظات",
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// DATA
              ..._currentTransfers.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final payload = (data['payload'] ?? {}) as Map<String, dynamic>;
                final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
                final formattedDate = createdAt != null
                    ? DateFormat('yyyy/MM/dd HH:mm').format(createdAt)
                    : "—";

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(formattedDate,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 8)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(data['branchName'] ?? "—",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 8)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(data['rep'] ?? "—",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 8)),
                    ),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        payload['type']?.toString().isNotEmpty == true
                            ? payload['type'].toString()
                            : (payload['kind']?.toString() ?? "—"),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 15),

          /// ملخص
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "عدد التحويلات:",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  totalTransfers.toString(),
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Query q = FirebaseFirestore.instance
        .collection('users')
        .doc(FS.uid)
        .collection('branchTransfers')
        .orderBy('createdAt', descending: true);

    // تطبيق الفلترة حسب التاريخ
    if (_selectedRange != null) {
      final startDate = DateTime(
        _selectedRange!.start.year,
        _selectedRange!.start.month,
        _selectedRange!.start.day,
      );
      final endDate = DateTime(
        _selectedRange!.end.year,
        _selectedRange!.end.month,
        _selectedRange!.end.day,
        23,
        59,
        59,
      );

      q = q
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير التحويلات", "Transfers Reports")),
        backgroundColor: const Color(0xFFD4AF37), // دهبي
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentTransfers.isEmpty ? null : _printTransfersReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Color(0xFF2196F3), Color(0xFF1565C0)],
              icon: Icons.compare_arrows,
            ),

            // عرض التحويلات
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: q.snapshots(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.compare_arrows,
                      title: _t('لا يوجد تحويلات', 'No Transfers'),
                      subtitle: _t('لا توجد تحويلات في الفترة المحددة',
                          'No transfers in selected range'),
                    );
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentTransfers = docs;
                      });
                    }
                  });

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: docs.length,
                    itemBuilder: (ctx, i) {
                      final data = docs[i].data() as Map<String, dynamic>;
                      final createdAt =
                          (data['createdAt'] as Timestamp?)?.toDate();
                      final branch =
                          data['branchName'] ?? _t('غير معروف', 'Unknown');
                      final rep = data['rep'] ?? _t('غير معروف', 'Unknown');
                      final payload =
                          data['payload'] as Map<String, dynamic>? ?? {};

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: const Icon(Icons.compare_arrows,
                              color: Colors.blueAccent),
                          title: Text(
                            "${_t("تحويل إلى", "Transfer to")}: $branch",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${_t("المندوب", "Representative")}: $rep"),
                              Text(
                                  "${_t("الوقت", "Time")}: ${createdAt ?? _t('غير متوفر', 'Not Available')}"),
                            ],
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(
                                    _t("تفاصيل التحويل", "Transfer Details")),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...payload.entries.map((e) {
                                        return Text("${e.key}: ${e.value}");
                                      }),
                                      const SizedBox(height: 16),
                                      if (payload['qrCode'] != null)
                                        Center(
                                          child: Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(8),
                                            child: (payload['showQr'] == true)
                                                ? SizedBox(
                                                    width: 150,
                                                    height: 150,
                                                    child: QrImageView(
                                                      data: payload['qrCode']
                                                          .toString(),
                                                      version: QrVersions.min,
                                                      backgroundColor:
                                                          Colors.white,
                                                      errorStateBuilder:
                                                          (cxt, err) =>
                                                              const Center(
                                                        child: Text(
                                                          'QR غير صالح',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : BarcodeWidget(
                                                    barcode: Barcode.code128(),
                                                    data: payload['qrCode']
                                                        .toString(),
                                                    width: 150,
                                                    height: 60,
                                                  ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(_t("إغلاق", "Close")),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensesList extends StatefulWidget {
  const _ExpensesList();

  @override
  State<_ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<_ExpensesList> {
  DateTimeRange? _selectedRange;
  String? _selectedType;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  List<Map<String, dynamic>> _currentExpenses = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    final now = DateTime.now();
    _selectedRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _printExpensesReport() async {
    if (_currentExpenses.isEmpty) return;

    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    double totalAmount = 0;

    for (var e in _currentExpenses) {
      totalAmount += (e['amount'] is num ? e['amount'].toDouble() : 0);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text(
            "تقرير المصروفات",
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(1.5),
              3: pw.FlexColumnWidth(2),
            },
            children: [
              /// HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "التاريخ",
                  "نوع المصروف",
                  "المبلغ",
                  "الملاحظة",
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// DATA
              ..._currentExpenses.map((e) {
                final date = (e['date'] as Timestamp?)?.toDate();
                final formattedDate = date != null
                    ? DateFormat('yyyy/MM/dd HH:mm').format(date)
                    : "—";

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(formattedDate,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 8)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(e['type'] ?? "—",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 8)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        (e['amount'] ?? 0).toString(),
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        e['note'] ?? "",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 15),

          /// إجمالي
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "إجمالي المصروفات:",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  totalAmount.toStringAsFixed(2),
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير المصروفات", "Expenses Reports")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentExpenses.isEmpty ? null : _printExpensesReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Color(0xFFD4AF37), Color(0xFFB8860B)],
              icon: Icons.money_off,
            ),

            // فلترة بنوع المصروف
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: StreamBuilder<List<String>>(
                stream: FS.expenseTypesStream(),
                builder: (context, snapshot) {
                  final types = snapshot.data ?? [];
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    hint: Text(_t("اختر نوع المصروف", "Select Expense Type")),
                    items: [
                      DropdownMenuItem(
                          value: null, child: Text(_t("الكل", "All"))),
                      ...types.map(
                          (t) => DropdownMenuItem(value: t, child: Text(t))),
                    ],
                    onChanged: (val) => setState(() => _selectedType = val),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                },
              ),
            ),

            // عرض المصروفات
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: FS.expensesStream(
                  typeFilter: _selectedType,
                  dateRange: _selectedRange,
                ),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final expenses = snap.data!;
                  if (expenses.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.money_off,
                      title: _t('لا يوجد مصروفات', 'No Expenses'),
                      subtitle: _t('لا توجد مصروفات في الفترة المحددة',
                          'No expenses in selected range'),
                    );
                  }

                  // حساب إجمالي المبالغ
                  final totalAmount = expenses.fold<double>(
                    0,
                    (sum, e) =>
                        sum + (e['amount'] is num ? e['amount'].toDouble() : 0),
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentExpenses = expenses;
                      });
                    }
                  });

                  return Column(
                    children: [
                      // عرض المجموع الكلي
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD4AF37)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _t('إجمالي المبلغ:', 'Total Amount:'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '${totalAmount.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // عرض قائمة المصروفات
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: expenses.length,
                          itemBuilder: (ctx, i) {
                            final e = expenses[i];
                            final date = (e['date'] as Timestamp?)?.toDate();
                            final type =
                                e['type'] ?? _t('غير محدد', 'Undefined');
                            final note = e['note'] ?? '';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: const Icon(Icons.receipt_long,
                                    color: Colors.green),
                                title: Text(type,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${_t('المبلغ', 'Amount')}: ${e['amount']} ${_t('ريال', 'SAR')}"),
                                    if (note.isNotEmpty)
                                      Text(
                                          "${_t('سبب الصرف', 'Reason')}: $note"),
                                    Text(
                                        "${_t('التاريخ', 'Date')}: ${date ?? _t('غير متوفر', 'Not Available')}"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalerList extends StatefulWidget {
  const _SalerList();

  @override
  State<_SalerList> createState() => _SalerListState();
}

class _SalerListState extends State<_SalerList> {
  DateTimeRange? _selectedRange;
  String? _selectedType;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  List<Map<String, dynamic>> _currentSales = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    final now = DateTime.now();
    _selectedRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _printSalesReport() async {
    if (_currentSales.isEmpty) return;

    final arabicFont = pw.Font.ttf(
        await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"));
    final arabicFontBold = pw.Font.ttf(
        await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"));

    final pdf = pw.Document();

    double totalCash = 0;
    double totalVisa = 0;
    double totalAmount = 0;

    final items = _currentSales.map((s) {
      final total = (s['payment']?['total'] ?? 0).toDouble();
      final cash = (s['payment']?['cash'] ?? 0).toDouble();
      final visa = (s['payment']?['visa'] ?? 0).toDouble();

      totalAmount += total;
      totalCash += cash;
      totalVisa += visa;

      return s;
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("تقرير المبيعات",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1.2),
              2: pw.FlexColumnWidth(1.2),
              3: pw.FlexColumnWidth(1.2),
              4: pw.FlexColumnWidth(1.2),
            },
            children: [
              /// HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: ["التاريخ", "البائع", "كاش", "شبكة", "الإجمالي"]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                        ))
                    .toList(),
              ),

              /// DATA
              ...items.map((s) {
                final date = (s['soldAt'] as Timestamp?)?.toDate();
                final formattedDate = date != null
                    ? DateFormat('yyyy/MM/dd HH:mm').format(date)
                    : "—";
                final soldBy = s['payment']?['soldBy'] ?? "—";
                final cash = (s['payment']?['cash'] ?? 0).toString();
                final visa = (s['payment']?['visa'] ?? 0).toString();
                final total = (s['payment']?['total'] ?? 0).toString();

                return pw.TableRow(
                  children: [
                    pw.Text(formattedDate,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(soldBy,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(cash,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(visa,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(total,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 15),

          /// الإجماليات
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("إجماليات التقرير",
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Bullet(
                  text: "إجمالي الكاش : ${totalCash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي الشبكة : ${totalVisa.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي السعر : ${totalAmount.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير البائعين", "Expenses Reports")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentSales.isEmpty ? null : _printSalesReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) {
                  setState(() {
                    _selectedRange = DateTimeRange(
                      start: DateTime(
                        picked.start.year,
                        picked.start.month,
                        picked.start.day,
                      ),
                      end: DateTime(
                        picked.end.year,
                        picked.end.month,
                        picked.end.day,
                        23,
                        59,
                        59,
                      ),
                    );
                  });
                }
              },
              range: _selectedRange,
              gradientColors: const [Color(0xFFD4AF37), Color(0xFFB8860B)],
              icon: Icons.money_off,
            ),

            // فلترة بنوع المصروف
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: StreamBuilder<List<String>>(
                stream: FS.soldByStream(),
                builder: (context, snapshot) {
                  final sellers = snapshot.data ?? [];
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    hint: Text(_t("اختر البائع", "Select Seller")),
                    items: [
                      DropdownMenuItem(
                          value: null, child: Text(_t("الكل", "All"))),
                      ...sellers.map(
                        (s) => DropdownMenuItem(value: s, child: Text(s)),
                      ),
                    ],
                    onChanged: (val) => setState(() => _selectedType = val),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                },
              ),
            ),

            // عرض المصروفات
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: FS.salesStream(
                  soldByFilter: _selectedType,
                  dateRange: _selectedRange,
                ),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final sales = snap.data!;
                  if (sales.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.point_of_sale,
                      title: _t('لا توجد مبيعات', 'No Sales'),
                      subtitle: _t('لا توجد مبيعات في الفترة المحددة',
                          'No sales in selected range'),
                    );
                  }

                  final totalAmount = sales.fold<double>(
                    0,
                    (sum, s) =>
                        sum +
                        ((s['payment']?['total'] ?? 0) is num
                            ? (s['payment']['total'] as num).toDouble()
                            : 0),
                  );
                  final cashAmount = sales.fold<double>(
                    0,
                    (sum, s) =>
                        sum +
                        ((s['payment']?['cash'] ?? 0) is num
                            ? (s['payment']['cash'] as num).toDouble()
                            : 0),
                  );
                  final visaAmount = sales.fold<double>(
                    0,
                    (sum, s) =>
                        sum +
                        ((s['payment']?['visa'] ?? 0) is num
                            ? (s['payment']['visa'] as num).toDouble()
                            : 0),
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _currentSales = sales);
                  });

                  return Column(
                    children: [
                      // عرض المجموع الكلي
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFD4AF37)),
                        ),
                        child: Column(
                          children: [
                            _totalRow(
                              _t('إجمالي المبيعات', 'Total Sales'),
                              totalAmount,
                              Colors.green,
                            ),
                            const Divider(),
                            _totalRow(
                              _t('كاش', 'Cash'),
                              cashAmount,
                              Colors.blue,
                            ),
                            _totalRow(
                              _t('شبكة', 'Network'),
                              visaAmount,
                              Colors.purple,
                            ),
                          ],
                        ),
                      ),

                      // عرض قائمة المصروفات
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: sales.length,
                          itemBuilder: (ctx, i) {
                            final s = sales[i];
                            final date = (s['soldAt'] as Timestamp?)?.toDate();
                            final soldBy = s['payment']?['soldBy'] ??
                                _t('غير معروف', 'Unknown');
                            final total = s['payment']?['total'] ?? 0;
                            final cash = s['payment']?['cash'] ?? 0;
                            final visa = s['payment']?['visa'] ?? 0;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading:
                                    const Icon(Icons.sell, color: Colors.green),
                                title: Text(
                                  soldBy,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${_t('الإجمالي', 'Total')}: $total"),
                                    Text("${_t('الكاش', 'cash')}: $cash"),
                                    Text("${_t('الشبكة', 'Network')}: $visa"),
                                    Text(
                                        "${_t('التاريخ', 'Date')}: ${date ?? '--'}"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalRow(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class VouchersListPage extends StatefulWidget {
  const VouchersListPage({super.key});

  @override
  State<VouchersListPage> createState() => _VouchersListPageState();
}

class _VouchersListPageState extends State<VouchersListPage> {
  DateTimeRange? _selectedRange;
  String? _selectedSupplierId;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  List<QueryDocumentSnapshot> _currentDocs = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    final now = DateTime.now();
    _selectedRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _printVouchersReport() async {
    if (_currentDocs.isEmpty) return;

    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    double totalCash = 0;
    double totalNetwork = 0;
    double totalWeight = 0;
    double totalAll = 0;

    final items = _currentDocs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      final type = data['type'];
      final cash = (data['cash'] ?? 0).toDouble();
      final network = (data['network'] ?? 0).toDouble();
      final weight = (data['weight'] ?? 0).toDouble();
      final total = (data['total'] ?? 0).toDouble();

      totalCash += cash;
      totalNetwork += network;
      totalAll += total;

      if (type == 'payment') {
        totalWeight -= weight;
      } else if (type == 'receipt') {
        totalWeight += weight;
      }

      return data;
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text(
            "تقرير السندات",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1.2),
              2: pw.FlexColumnWidth(1.2),
              3: pw.FlexColumnWidth(1.2),
              4: pw.FlexColumnWidth(1.2),
              5: pw.FlexColumnWidth(2),
            },
            children: [
              /// HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "التاريخ",
                  "المورد",
                  "كاش",
                  "شبكة",
                  "الوزن",
                  "الإجمالي",
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// DATA
              ...items.map((data) {
                final date = (data['date'] as Timestamp?)?.toDate();
                final formattedDate = date != null
                    ? DateFormat('yyyy/MM/dd HH:mm').format(date)
                    : "—";
                final supplierName = data['supplierName'] ?? "—";

                return pw.TableRow(
                  children: [
                    pw.Text(formattedDate,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(supplierName,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text((data['cash'] ?? 0).toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text((data['network'] ?? 0).toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text((data['weight'] ?? 0).toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text((data['total'] ?? 0).toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 15),

          /// الإجماليات
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "إجماليات التقرير",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 8),
                pw.Bullet(
                    text: "إجمالي الكاش : ${totalCash.toStringAsFixed(2)}"),
                pw.Bullet(
                    text: "إجمالي الشبكة : ${totalNetwork.toStringAsFixed(2)}"),
                pw.Bullet(
                    text:
                        "إجمالي الوزن : ${totalWeight.toStringAsFixed(2)} جم"),
                pw.Bullet(
                    text: "إجمالي السعر : ${totalAll.toStringAsFixed(2)}"),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير السندات", "Vouchers Reports")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentDocs.isEmpty ? null : _printVouchersReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // مكون اختيار التاريخ
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Color(0xFFD4AF37), Color(0xFFB8860B)],
              icon: Icons.receipt,
            ),

            // فلترة حسب المورد
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: FS.suppliersStream(),
                builder: (context, snapshot) {
                  final suppliers = snapshot.data ?? [];
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedSupplierId,
                    hint: Text(_t("اختر المورد", "Select Supplier")),
                    items: [
                      DropdownMenuItem(
                          value: null, child: Text(_t("الكل", "All"))),
                      ...suppliers.map((s) => DropdownMenuItem(
                            value: s['id'],
                            child: Text(s['name']),
                          )),
                    ],
                    onChanged: (val) =>
                        setState(() => _selectedSupplierId = val),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                },
              ),
            ),

            // عرض السندات
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _buildVouchersQuery(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.receipt_long,
                      title: _t('لا يوجد سندات', 'No Vouchers'),
                      subtitle: _t('لا توجد سندات في الفترة المحددة',
                          'No vouchers in selected range'),
                    );
                  }

                  double totalCash = 0;
                  double totalNetwork = 0;
                  double totalWeight = 0;
                  double totalAll = 0;

                  for (var d in docs) {
                    final data = d.data() as Map<String, dynamic>;
                    final type = data['type'];
                    final cash = (data['cash'] ?? 0).toDouble();
                    final network = (data['network'] ?? 0).toDouble();
                    final weight = (data['weight'] ?? 0).toDouble();
                    final total = (data['total'] ?? 0).toDouble();

                    totalCash += cash;
                    totalNetwork += network;
                    totalAll += total;

                    if (type == 'payment') {
                      totalWeight -= weight;
                    } else if (type == 'receipt') {
                      totalWeight += weight;
                    }
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentDocs = docs;
                      });
                    }
                  });

                  return Column(
                    children: [
                      // الإجماليات
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD4AF37)),
                        ),
                        child: Column(
                          children: [
                            _buildTotalRow(_t("إجمالي الكاش", "Total Cash"),
                                totalCash, Colors.green),
                            _buildTotalRow(_t("إجمالي الشبكة", "Total Network"),
                                totalNetwork, Colors.blue),
                            _buildTotalRow(_t("إجمالي الوزن", "Total Weight"),
                                totalWeight, Colors.orange),
                            const Divider(),
                            _buildTotalRow(_t("إجمالي السعر", "Total Amount"),
                                totalAll, Colors.black),
                          ],
                        ),
                      ),

                      // قائمة السندات
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: docs.length,
                          itemBuilder: (ctx, i) {
                            final data = docs[i].data() as Map<String, dynamic>;
                            final date = (data['date'] as Timestamp?)?.toDate();
                            final formattedDate = date != null
                                ? DateFormat('yyyy-MM-dd HH:mm:ss').format(date)
                                : _t('غير متوفر', 'Not Available');
                            final supplierName = data['supplierName'] ??
                                _t('غير محدد', 'Undefined');
                            final type = data['type'];
                            final typeLabel = type == 'payment'
                                ? _t('سند صرف', 'Payment')
                                : _t('سند قبض', 'Receipt');
                            final total = (data['total'] ?? 0).toDouble();

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: Icon(
                                  type == 'receipt'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: type == 'receipt'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: Text(
                                  "$typeLabel - $supplierName",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (data['cash'] != null)
                                      Text(
                                          "${_t("كاش", "Cash")}: ${data['cash']} ${_t("ريال", "SAR")}"),
                                    if (data['network'] != null)
                                      Text(
                                          "${_t("شبكة", "Network")}: ${data['network']} ${_t("ريال", "SAR")}"),
                                    if (data['weight'] != null)
                                      Text(
                                          "${_t("الوزن", "Weight")}: ${data['weight']} جم"),
                                    Text(
                                        "${_t("الإجمالي", "Total")}: $total ${_t("ريال", "SAR")}"),
                                    Text(
                                        "${_t("التاريخ", "Date")}: $formattedDate"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// استعلام Firestore حسب الفلترة
  Stream<QuerySnapshot> _buildVouchersQuery() {
    Query q = FS.vouchersCol();

    if (_selectedSupplierId != null) {
      q = q.where('supplierId', isEqualTo: _selectedSupplierId);
    }
    if (_selectedRange != null) {
      q = q
          .where('date', isGreaterThanOrEqualTo: _selectedRange!.start)
          .where('date', isLessThanOrEqualTo: _selectedRange!.end);
    }

    return q.orderBy('date', descending: true).snapshots();
  }

  /// صف الإجمالي
  Widget _buildTotalRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  /// حالة فارغة
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey, size: 64),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _DepositsList extends StatefulWidget {
  const _DepositsList();

  @override
  State<_DepositsList> createState() => _DepositsListState();
}

class _DepositsListState extends State<_DepositsList> {
  DateTimeRange? _selectedRange;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  List<QueryDocumentSnapshot> _currentDocs = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    final now = DateTime.now();
    _selectedRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _printReport() async {
    if (_currentDocs.isEmpty) return;

    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    double totalCash = 0;
    double totalVisa = 0;
    double totalAll = 0;

    final items = _currentDocs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      totalCash += (data['cash'] is num ? data['cash'].toDouble() : 0);
      totalVisa += (data['visa'] is num ? data['visa'].toDouble() : 0);
      totalAll += (data['total'] is num ? data['total'].toDouble() : 0);
      return data;
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text(
            "تقرير التوريد",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1.2),
              2: pw.FlexColumnWidth(1.2),
              3: pw.FlexColumnWidth(1.2),
              4: pw.FlexColumnWidth(1.5),
              5: pw.FlexColumnWidth(2),
            },
            children: [
              /// HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "التاريخ",
                  "كاش",
                  "شبكة",
                  "الإجمالي",
                  "النوع",
                  "ملاحظة",
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// DATA
              ...items.map((data) {
                final date = (data['date'] as Timestamp?)?.toDate();

                return pw.TableRow(
                  children: [
                    pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd HH:mm').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      (data['cash'] ?? 0).toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      (data['visa'] ?? 0).toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      (data['total'] ?? 0).toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      data['type']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      data['note']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 15),

          /// الإجماليات
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "إجماليات التقرير",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Bullet(
                  text: "إجمالي الكاش : ${totalCash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي الشبكة : ${totalVisa.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "الإجمالي الكلي : ${totalAll.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير التوريد", "Deposits Reports")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentDocs.isEmpty ? null : _printReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              icon: Icons.attach_money,
            ),

            // عرض بيانات التوريد
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getDepositsStream(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.attach_money,
                      title: _t('لا يوجد توريد', 'No Deposits'),
                      subtitle: _t('لا توجد عمليات توريد في الفترة المحددة',
                          'No deposits in selected range'),
                    );
                  }

                  double totalCash = 0;
                  double totalVisa = 0;
                  double totalAll = 0;

                  for (var d in docs) {
                    final data = d.data() as Map<String, dynamic>;
                    totalCash +=
                        (data['cash'] is num ? data['cash'].toDouble() : 0);
                    totalVisa +=
                        (data['visa'] is num ? data['visa'].toDouble() : 0);
                    totalAll +=
                        (data['total'] is num ? data['total'].toDouble() : 0);
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentDocs = docs;
                      });
                    }
                  });

                  return Column(
                    children: [
                      // عرض الإجمالي
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryRow(
                                _lang,
                                _t('إجمالي الكاش:', 'Total Cash:'),
                                totalCash,
                                Colors.brown),
                            _buildSummaryRow(
                                _lang,
                                _t('إجمالي الشبكة:', 'Total Network:'),
                                totalVisa,
                                Colors.blue),
                            const Divider(),
                            _buildSummaryRow(
                                _lang,
                                _t('الإجمالي الكلي:', 'Total Amount:'),
                                totalAll,
                                Colors.green),
                          ],
                        ),
                      ),

                      // قائمة التوريد
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: docs.length,
                          itemBuilder: (ctx, i) {
                            final data = docs[i].data() as Map<String, dynamic>;
                            final date = (data['date'] as Timestamp?)?.toDate();
                            final cash = (data['cash'] is num)
                                ? data['cash'].toDouble()
                                : 0.0;
                            final visa = (data['visa'] is num)
                                ? data['visa'].toDouble()
                                : 0.0;
                            final total = (data['total'] is num)
                                ? data['total'].toDouble()
                                : 0.0;
                            final type = data['type'] ?? '';
                            final note = data['note'] ?? '';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: const Icon(Icons.attach_money,
                                    color: Colors.green),
                                title: Text(
                                  "${_t("إجمالي التوريد:", "Total Deposit:")} ${total.toStringAsFixed(2)} ${_t("ريال", "SAR")}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${_t("كاش", "Cash")}: ${cash.toStringAsFixed(2)} ${_t("ريال", "SAR")}",
                                          style: const TextStyle(
                                              color: Colors.brown)),
                                      Text(
                                          "${_t("شبكة", "Network")}: ${visa.toStringAsFixed(2)} ${_t("ريال", "SAR")}",
                                          style: const TextStyle(
                                              color: Colors.blue)),
                                      const SizedBox(height: 4),
                                      if (type.isNotEmpty)
                                        Text("${_t("النوع", "Type")}: $type"),
                                      if (note.isNotEmpty)
                                        Text("${_t("ملاحظة", "Note")}: $note"),
                                      Text(
                                        "${_t("التاريخ", "Date")}: ${date != null ? date.toString().split('.')[0] : _t('غير متوفر', 'Not Available')}",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getDepositsStream() {
    Query q = FS.depositsCol().orderBy('date', descending: true);

    if (_selectedRange != null) {
      final startDate = DateTime(
        _selectedRange!.start.year,
        _selectedRange!.start.month,
        _selectedRange!.start.day,
      );
      final endDate = DateTime(
        _selectedRange!.end.year,
        _selectedRange!.end.month,
        _selectedRange!.end.day,
        23,
        59,
        59,
      );

      q = q
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate);
    }

    return q.snapshots();
  }
}

class _ImportsList extends StatefulWidget {
  const _ImportsList();

  @override
  State<_ImportsList> createState() => _ImportsListState();
}

class _ImportsListState extends State<_ImportsList> {
  DateTimeRange? _selectedRange;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  List<QueryDocumentSnapshot> _currentDocs = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    final now = DateTime.now();
    _selectedRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _printReport() async {
    if (_currentDocs.isEmpty) return;

    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    double totalCash = 0;
    double totalVisa = 0;
    double totalAll = 0;

    final items = _currentDocs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      totalCash += (data['cash'] is num ? data['cash'].toDouble() : 0);
      totalVisa += (data['visa'] is num ? data['visa'].toDouble() : 0);
      totalAll += (data['total'] is num ? data['total'].toDouble() : 0);
      return data;
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text(
            "تقرير الاستيراد",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1.2),
              2: pw.FlexColumnWidth(1.2),
              3: pw.FlexColumnWidth(1.2),
              4: pw.FlexColumnWidth(1.5),
              5: pw.FlexColumnWidth(2),
            },
            children: [
              /// HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "التاريخ",
                  "كاش",
                  "شبكة",
                  "الإجمالي",
                  "النوع",
                  "ملاحظة",
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// DATA
              ...items.map((data) {
                final date = (data['date'] as Timestamp?)?.toDate();

                return pw.TableRow(
                  children: [
                    pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd HH:mm').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      (data['cash'] ?? 0).toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      (data['visa'] ?? 0).toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      (data['total'] ?? 0).toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      data['type']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      data['note']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 15),

          /// الإجماليات
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "إجماليات التقرير",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Bullet(
                  text: "إجمالي الكاش : ${totalCash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي الشبكة : ${totalVisa.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "الإجمالي الكلي : ${totalAll.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير الاستيراد", "Imports Reports")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentDocs.isEmpty ? null : _printReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              icon: Icons.attach_money,
            ),

            // عرض بيانات التوريد
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getImportsStream(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.attach_money,
                      title: _t('لا يوجد استيراد', 'No Imports'),
                      subtitle: _t('لا توجد عمليات استيراد في الفترة المحددة',
                          'No Imports in selected range'),
                    );
                  }

                  double totalCash = 0;
                  double totalVisa = 0;
                  double totalAll = 0;

                  for (var d in docs) {
                    final data = d.data() as Map<String, dynamic>;
                    totalCash +=
                        (data['cash'] is num ? data['cash'].toDouble() : 0);
                    totalVisa +=
                        (data['visa'] is num ? data['visa'].toDouble() : 0);
                    totalAll +=
                        (data['total'] is num ? data['total'].toDouble() : 0);
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentDocs = docs;
                      });
                    }
                  });

                  return Column(
                    children: [
                      // عرض الإجمالي
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryRow(
                                _lang,
                                _t('إجمالي الكاش:', 'Total Cash:'),
                                totalCash,
                                Colors.brown),
                            _buildSummaryRow(
                                _lang,
                                _t('إجمالي الشبكة:', 'Total Network:'),
                                totalVisa,
                                Colors.blue),
                            const Divider(),
                            _buildSummaryRow(
                                _lang,
                                _t('الإجمالي الكلي:', 'Total Amount:'),
                                totalAll,
                                Colors.green),
                          ],
                        ),
                      ),

                      // قائمة الاستيراد
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: docs.length,
                          itemBuilder: (ctx, i) {
                            final data = docs[i].data() as Map<String, dynamic>;
                            final date = (data['date'] as Timestamp?)?.toDate();
                            final cash = (data['cash'] is num)
                                ? data['cash'].toDouble()
                                : 0.0;
                            final visa = (data['visa'] is num)
                                ? data['visa'].toDouble()
                                : 0.0;
                            final total = (data['total'] is num)
                                ? data['total'].toDouble()
                                : 0.0;
                            final type = data['type'] ?? '';
                            final note = data['note'] ?? '';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: const Icon(Icons.attach_money,
                                    color: Colors.green),
                                title: Text(
                                  "${_t("إجمالي الاستيراد:", "Total Imports:")} ${total.toStringAsFixed(2)} ${_t("ريال", "SAR")}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${_t("كاش", "Cash")}: ${cash.toStringAsFixed(2)} ${_t("ريال", "SAR")}",
                                          style: const TextStyle(
                                              color: Colors.brown)),
                                      Text(
                                          "${_t("شبكة", "Network")}: ${visa.toStringAsFixed(2)} ${_t("ريال", "SAR")}",
                                          style: const TextStyle(
                                              color: Colors.blue)),
                                      const SizedBox(height: 4),
                                      if (type.isNotEmpty)
                                        Text("${_t("النوع", "Type")}: $type"),
                                      if (note.isNotEmpty)
                                        Text("${_t("ملاحظة", "Note")}: $note"),
                                      Text(
                                        "${_t("التاريخ", "Date")}: ${date != null ? date.toString().split('.')[0] : _t('غير متوفر', 'Not Available')}",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getImportsStream() {
    Query q = FS.ImportedCol().orderBy('date', descending: true);

    if (_selectedRange != null) {
      final startDate = DateTime(
        _selectedRange!.start.year,
        _selectedRange!.start.month,
        _selectedRange!.start.day,
      );
      final endDate = DateTime(
        _selectedRange!.end.year,
        _selectedRange!.end.month,
        _selectedRange!.end.day,
        23,
        59,
        59,
      );

      q = q
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate);
    }

    return q.snapshots();
  }
}

Widget _buildSummaryRow(String lang, String title, double value, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(
          '${value.toStringAsFixed(2)} ${lang == 'ar' ? 'ريال' : 'SAR'}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}

class _UpdatedList extends StatefulWidget {
  const _UpdatedList();

  @override
  State<_UpdatedList> createState() => _UpdatedListState();
}

class _UpdatedListState extends State<_UpdatedList> {
  DateTimeRange? _selectedRange;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  // New Features
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedKinds = {};
  final Set<String> _selectedTypes = {};
  bool _isTypeExpanded = false;
  List<QueryDocumentSnapshot> _currentDocs = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    _selectedRange = DateTimeRange(start: startOfDay, end: endOfDay);
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  static String translateCategory(String? category) {
    switch (category) {
      case 'bullion':
        return "سبائك";
      case 'gem':
        return "أحجار";
      case 'gold':
        return "ذهب";
      default:
        return "غير محدد";
    }
  }

  Future<void> _printReport() async {
    if (_currentDocs.isEmpty) return;
    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    // تحويل docs إلى List<Map>
    final items =
        _currentDocs.map((e) => e.data() as Map<String, dynamic>).toList();

    // حساب الإجماليات من نفس البيانات المعروضة
    double totalWeight = 0;
    double totalWage = 0;
    double totalCost = 0;

    int totalCount = 0;
    int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
    double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

    for (var doc in _currentDocs) {
      final item = doc.data() as Map<String, dynamic>;
      final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      final carat = payload['carat']?.toString();
      final category = item['category']?.toString();
      totalCount++;
      totalWeight += weight;
      totalWage += wage;
      totalCost += cost;

      if (carat == "18") {
        count18++;
        weight18 += weight;
      }
      if (carat == "21") {
        count21++;
        weight21 += weight;
      }
      if (carat == "22") {
        count22++;
        weight22 += weight;
      }
      if (category == "bullion") {
        countBullion++;
        weightBullion += weight;
      }
      if (category == "gem") {
        countGem++;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (context) => [
          pw.Text(
            "تقارير التعديلات",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1.5),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(0.8),
              6: pw.FlexColumnWidth(1.2),
              7: pw.FlexColumnWidth(1.2),
              8: pw.FlexColumnWidth(1.5),
              9: pw.FlexColumnWidth(1.5),
            },
            children: [
              /// 🔹 HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "قسم",
                  "تاريخ",
                  "وزن",
                  "أجر",
                  "عيار",
                  "نوع",
                  "تكلفة",
                  "مكونات",
                  "ملاحظات"
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// 🔹 DATA ROWS (من نفس الفلترة)
              ...items.map((item) {
                final date = (item['updatedAt'] as Timestamp?)?.toDate();
                final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

                /// 🔸 كود + QR
                pw.Widget codeWidget;

                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: payload['qrCode'],
                            width: 20,
                            height: 20),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: payload['qrCode'],
                            width: 40,
                            height: 15,
                            drawText: false),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: codeWidget,
                    ),
                    pw.Text(translateCategory(item['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        payload['type']?.toString().isNotEmpty == true
                            ? payload['type'].toString()
                            : (payload['kind']?.toString() ?? "—"),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 15),

          /*pw.Text(
            "عدد العناصر: ${items.length}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),*/
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "إجماليات التقرير",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Bullet(
                  text: "إجمالي عدد الشرائح: $totalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "عدد الأحجار الكريمة : $countGem",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الوزن الكلي : ${totalWeight.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي الأجر الكلي : ${totalWage.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي التكلفة الكلية : ${totalCost.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Query q = FS
        .itemsCol()
        .where('updatedAt', isNotEqualTo: null)
        .orderBy('updatedAt', descending: true);

    if (_selectedRange != null) {
      final startDate = DateTime(
        _selectedRange!.start.year,
        _selectedRange!.start.month,
        _selectedRange!.start.day,
      );

      final endDate = DateTime(
        _selectedRange!.end.year,
        _selectedRange!.end.month,
        _selectedRange!.end.day,
        23,
        59,
        59,
      );

      q = q
          .where('updatedAt', isGreaterThanOrEqualTo: startDate)
          .where('updatedAt', isLessThanOrEqualTo: endDate);
    }
    if (_selectedCategories.isNotEmpty) {
      q = q.where('category', whereIn: _selectedCategories.toList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير التعديلات", "Updates Reports")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentDocs.isEmpty ? null : _printReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              icon: Icons.edit,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: q.snapshots(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.edit,
                      title: _t('لا يوجد تعديلات', 'No Updates'),
                      subtitle: _t('لا توجد عناصر معدلة في الفترة المحددة',
                          'No updated items in selected range'),
                    );
                  }
                  List<QueryDocumentSnapshot> filteredDocs = docs;

                  if (_selectedKinds.isNotEmpty) {
                    filteredDocs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final kind = data['payload']?['kind'];
                      return _selectedKinds.contains(kind);
                    }).toList();
                  }
                  if (_selectedTypes.isNotEmpty) {
                    filteredDocs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final kind = data['payload']?['type'];
                      return _selectedTypes.contains(kind);
                    }).toList();
                  }

                  final totals = _calcTotalsFromDocs(filteredDocs);
                  final allCategories = docs
                      .map(
                          (e) => (e.data() as Map<String, dynamic>)['category'])
                      .whereType<String>()
                      .toSet()
                      .toList();

                  final allKinds = docs
                      .map((e) => (e.data() as Map<String, dynamic>)['payload']
                          ?['kind'])
                      .whereType<String>()
                      .toSet()
                      .toList();
                  final allTypes = docs
                      .map((e) => (e.data() as Map<String, dynamic>)['payload']
                          ?['type'])
                      .whereType<String>()
                      .toSet()
                      .toList();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentDocs = filteredDocs;
                      });
                    }
                  });

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      if (allCategories.isNotEmpty)
                        Text(
                          _t('اختر القسم', 'Select Type'),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: allCategories.map((cat) {
                          final selected = _selectedCategories.contains(cat);
                          return FilterChip(
                            label: Text(cat),
                            selected: selected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _selectedCategories.add(cat);
                                } else {
                                  _selectedCategories.remove(cat);
                                }
                                // لما القسم يتغير نمسح اختيار النوع
                                _selectedKinds.clear();
                                _selectedTypes.clear();
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),
                      // ✅ فلتر النوع
                      if (_selectedCategories.isNotEmpty &&
                          (allKinds.isNotEmpty || allTypes.isNotEmpty)) ...[
                        // 🔹 العنوان مع السهم
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isTypeExpanded = !_isTypeExpanded;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _t('اختر النوع', 'Select Type'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                _isTypeExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🔹 يظهر فقط لو مفتوح
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: _isTypeExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              // ✅ KINDS
                              ...allKinds.map((kind) {
                                final selected = _selectedKinds.contains(kind);
                                return FilterChip(
                                  label: Text(kind),
                                  selected: selected,
                                  onSelected: (val) {
                                    setState(() {
                                      val
                                          ? _selectedKinds.add(kind)
                                          : _selectedKinds.remove(kind);
                                    });
                                  },
                                );
                              }),

                              // ✅ TYPES
                              ...allTypes.map((type) {
                                final selected = _selectedTypes.contains(type);
                                return FilterChip(
                                  label: Text(type),
                                  selected: selected,
                                  onSelected: (val) {
                                    setState(() {
                                      val
                                          ? _selectedTypes.add(type)
                                          : _selectedTypes.remove(type);
                                    });
                                  },
                                );
                              }),
                            ],
                          ),
                          secondChild: const SizedBox(),
                        ),

                        const SizedBox(height: 12),
                      ],
                      _buildBarChart(totals, lang: _lang),
                      const SizedBox(height: 12),
                      _TotalsCard(totals: totals, lang: _lang),
                      const SizedBox(height: 12),
                      ...filteredDocs.map((d) {
                        final data = d.data() as Map<String, dynamic>;
                        return Material(
                          color: Colors.transparent,
                          child: _buildItemCard(
                              context: context,
                              epcHex: data['epcHex'] ?? '',
                              category: data['category'] as String?,
                              createdAt:
                                  (data['updatedAt'] as Timestamp?)?.toDate(),
                              payload: data['payload'] as Map<String, dynamic>?,
                              payment: data['payment'] as Map<String, dynamic>?,
                              theme: theme,
                              showPrice: false,
                              lang: _lang),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemsList extends StatefulWidget {
  const _ItemsList();

  @override
  State<_ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<_ItemsList> {
  DateTimeRange? _selectedRange;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  // New Features
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedKinds = {};
  final Set<String> _selectedTypes = {};
  bool _isTypeExpanded = false;
  List<QueryDocumentSnapshot> _currentDocs = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    // ✅ تعيين اليوم الحالي كـ default range
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    _selectedRange = DateTimeRange(start: startOfDay, end: endOfDay);
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  static String translateCategory(String? category) {
    switch (category) {
      case 'bullion':
        return "سبائك";
      case 'gem':
        return "أحجار";
      case 'gold':
        return "ذهب";
      default:
        return "غير محدد";
    }
  }

  Future<void> _printReport() async {
    if (_currentDocs.isEmpty) return;
    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    // تحويل docs إلى List<Map>
    final items =
        _currentDocs.map((e) => e.data() as Map<String, dynamic>).toList();

    // حساب الإجماليات من نفس البيانات المعروضة
    double totalWeight = 0;
    double totalWage = 0;
    double totalCost = 0;

    int totalCount = 0;
    int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
    double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

    for (var doc in _currentDocs) {
      final item = doc.data() as Map<String, dynamic>;
      final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      final carat = payload['carat']?.toString();
      final category = item['category']?.toString();
      totalCount++;
      totalWeight += weight;
      totalWage += wage;
      totalCost += cost;

      if (carat == "18") {
        count18++;
        weight18 += weight;
      }
      if (carat == "21") {
        count21++;
        weight21 += weight;
      }
      if (carat == "22") {
        count22++;
        weight22 += weight;
      }
      if (category == "bullion") {
        countBullion++;
        weightBullion += weight;
      }
      if (category == "gem") {
        countGem++;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (context) => [
          pw.Text(
            "تقارير الإدخال",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1.5),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(0.8),
              6: pw.FlexColumnWidth(1.2),
              7: pw.FlexColumnWidth(1.2),
              8: pw.FlexColumnWidth(1.5),
              9: pw.FlexColumnWidth(1.5),
            },
            children: [
              /// 🔹 HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "قسم",
                  "تاريخ",
                  "وزن",
                  "أجر",
                  "عيار",
                  "نوع",
                  "تكلفة",
                  "مكونات",
                  "ملاحظات"
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// 🔹 DATA ROWS (من نفس الفلترة)
              ...items.map((item) {
                final date = (item['createdAt'] as Timestamp?)?.toDate();
                final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

                /// 🔸 كود + QR
                pw.Widget codeWidget;

                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: payload['qrCode'],
                            width: 20,
                            height: 20),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: payload['qrCode'],
                            width: 40,
                            height: 15,
                            drawText: false),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: codeWidget,
                    ),
                    pw.Text(translateCategory(item['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        payload['type']?.toString().isNotEmpty == true
                            ? payload['type'].toString()
                            : (payload['kind']?.toString() ?? "—"),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 15),

          /*pw.Text(
            "عدد العناصر: ${items.length}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),*/
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "إجماليات التقرير",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Bullet(
                  text: "إجمالي عدد الشرائح: $totalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "عدد الأحجار الكريمة : $countGem",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الوزن الكلي : ${totalWeight.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي الأجر الكلي : ${totalWage.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي التكلفة الكلية : ${totalCost.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Query q = FS.itemsCol().orderBy('createdAt', descending: true);

    if (_selectedRange != null) {
      final startDate = DateTime(
        _selectedRange!.start.year,
        _selectedRange!.start.month,
        _selectedRange!.start.day,
      );

      final endDate = DateTime(
        _selectedRange!.end.year,
        _selectedRange!.end.month,
        _selectedRange!.end.day,
        23,
        59,
        59,
      );

      q = q
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate);
    }
    // ✅ فلترة category
    if (_selectedCategories.isNotEmpty) {
      q = q.where('category', whereIn: _selectedCategories.toList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير الادخال", "Entry Reports")),
        backgroundColor: const Color(0xFFD4AF37), // دهبي
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentDocs.isEmpty ? null : _printReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Color(0xFFD4AF37), Color(0xFFB8860B)],
              icon: Icons.add_box_rounded,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: q.snapshots(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.add_box_outlined,
                      title: _t('لا توجد عناصر مدخلة', 'No items entered'),
                      subtitle: _t('ابدأ بإدخال عناصر جديدة',
                          'Start by entering new items'),
                    );
                  }
                  List<QueryDocumentSnapshot> filteredDocs = docs;

                  if (_selectedKinds.isNotEmpty) {
                    filteredDocs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final kind = data['payload']?['kind'];
                      return _selectedKinds.contains(kind);
                    }).toList();
                  }
                  if (_selectedTypes.isNotEmpty) {
                    filteredDocs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final kind = data['payload']?['type'];
                      return _selectedTypes.contains(kind);
                    }).toList();
                  }

                  final totals = _calcTotalsFromDocs(filteredDocs);
                  final allCategories = docs
                      .map(
                          (e) => (e.data() as Map<String, dynamic>)['category'])
                      .whereType<String>()
                      .toSet()
                      .toList();

                  final allKinds = docs
                      .map((e) => (e.data() as Map<String, dynamic>)['payload']
                          ?['kind'])
                      .whereType<String>()
                      .toSet()
                      .toList();
                  final allTypes = docs
                      .map((e) => (e.data() as Map<String, dynamic>)['payload']
                          ?['type'])
                      .whereType<String>()
                      .toSet()
                      .toList();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentDocs = filteredDocs;
                      });
                    }
                  });

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      if (allCategories.isNotEmpty)
                        Text(
                          _t('اختر القسم', 'Select Type'),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: allCategories.map((cat) {
                          final selected = _selectedCategories.contains(cat);
                          return FilterChip(
                            label: Text(cat),
                            selected: selected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _selectedCategories.add(cat);
                                } else {
                                  _selectedCategories.remove(cat);
                                }
                                // لما القسم يتغير نمسح اختيار النوع
                                _selectedKinds.clear();
                                _selectedTypes.clear();
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),
                      // ✅ فلتر النوع
                      if (_selectedCategories.isNotEmpty &&
                          (allKinds.isNotEmpty || allTypes.isNotEmpty)) ...[
                        // 🔹 العنوان مع السهم
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isTypeExpanded = !_isTypeExpanded;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _t('اختر النوع', 'Select Type'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                _isTypeExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🔹 يظهر فقط لو مفتوح
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: _isTypeExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              // ✅ KINDS
                              ...allKinds.map((kind) {
                                final selected = _selectedKinds.contains(kind);
                                return FilterChip(
                                  label: Text(kind),
                                  selected: selected,
                                  onSelected: (val) {
                                    setState(() {
                                      val
                                          ? _selectedKinds.add(kind)
                                          : _selectedKinds.remove(kind);
                                    });
                                  },
                                );
                              }),

                              // ✅ TYPES
                              ...allTypes.map((type) {
                                final selected = _selectedTypes.contains(type);
                                return FilterChip(
                                  label: Text(type),
                                  selected: selected,
                                  onSelected: (val) {
                                    setState(() {
                                      val
                                          ? _selectedTypes.add(type)
                                          : _selectedTypes.remove(type);
                                    });
                                  },
                                );
                              }),
                            ],
                          ),
                          secondChild: const SizedBox(),
                        ),

                        const SizedBox(height: 12),
                      ],
                      _buildBarChart(totals, lang: _lang),
                      const SizedBox(height: 12),
                      _TotalsCard(totals: totals, lang: _lang),
                      const SizedBox(height: 12),
                      ...filteredDocs.map((d) {
                        final data = d.data() as Map<String, dynamic>;
                        return Material(
                          color: Colors.transparent,
                          child: _buildItemCard(
                              context: context,
                              epcHex: data['epcHex'] ?? '',
                              category: data['category'] as String?,
                              createdAt:
                                  (data['createdAt'] as Timestamp?)?.toDate(),
                              payload: data['payload'] as Map<String, dynamic>?,
                              payment: data['payment'] as Map<String, dynamic>?,
                              theme: theme,
                              showPrice: false,
                              lang: _lang),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryList extends StatefulWidget {
  const _InventoryList();
  @override
  State<_InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<_InventoryList> {
  DateTimeRange? _selectedRange;
  // New Features
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedKinds = {};
  final Set<String> _selectedTypes = {};
  bool _isTypeExpanded = false;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  List<QueryDocumentSnapshot> _currentDocs = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    // ✅ لو لسه ماحددش أي range نحط Range اليوم الحالي
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    _selectedRange = DateTimeRange(start: startOfDay, end: endOfDay);
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  static String translateCategory(String? category) {
    switch (category) {
      case 'bullion':
        return "سبائك";
      case 'gem':
        return "أحجار";
      case 'gold':
        return "ذهب";
      default:
        return "غير محدد";
    }
  }

  Future<void> _printReport() async {
    if (_currentDocs.isEmpty) return;
    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    // تحويل docs إلى List<Map>
    final items =
        _currentDocs.map((e) => e.data() as Map<String, dynamic>).toList();

    // حساب الإجماليات من نفس البيانات المعروضة
    double totalWeight = 0;
    double totalWage = 0;
    double totalCost = 0;

    int totalCount = 0;
    int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
    double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

    for (var doc in _currentDocs) {
      final item = doc.data() as Map<String, dynamic>;
      final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      final carat = payload['carat']?.toString();
      final category = item['category']?.toString();
      totalCount++;
      totalWeight += weight;
      totalWage += wage;
      totalCost += cost;

      if (carat == "18") {
        count18++;
        weight18 += weight;
      }
      if (carat == "21") {
        count21++;
        weight21 += weight;
      }
      if (carat == "22") {
        count22++;
        weight22 += weight;
      }
      if (category == "bullion") {
        countBullion++;
        weightBullion += weight;
      }
      if (category == "gem") {
        countGem++;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (context) => [
          pw.Text(
            "تقارير الجرد",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1.5),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(0.8),
              6: pw.FlexColumnWidth(1.2),
              7: pw.FlexColumnWidth(1.2),
              8: pw.FlexColumnWidth(1.5),
              9: pw.FlexColumnWidth(1.5),
            },
            children: [
              /// 🔹 HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "قسم",
                  "تاريخ",
                  "وزن",
                  "أجر",
                  "عيار",
                  "نوع",
                  "تكلفة",
                  "مكونات",
                  "ملاحظات"
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// 🔹 DATA ROWS (من نفس الفلترة)
              ...items.map((item) {
                final date = (item['lastSeenAt'] as Timestamp?)?.toDate();
                final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

                /// 🔸 كود + QR
                pw.Widget codeWidget;

                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: payload['qrCode'],
                            width: 20,
                            height: 20),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: payload['qrCode'],
                            width: 40,
                            height: 15,
                            drawText: false),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: codeWidget,
                    ),
                    pw.Text(translateCategory(item['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        payload['type']?.toString().isNotEmpty == true
                            ? payload['type'].toString()
                            : (payload['kind']?.toString() ?? "—"),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 15),

          /*pw.Text(
            "عدد العناصر: ${items.length}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),*/
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "إجماليات التقرير",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Bullet(
                  text: "إجمالي عدد الشرائح: $totalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "عدد الأحجار الكريمة : $countGem",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الوزن الكلي : ${totalWeight.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي الأجر الكلي : ${totalWage.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي التكلفة الكلية : ${totalCost.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Query q = FS.invCol().orderBy('lastSeenAt', descending: true);

    if (_selectedRange != null) {
      final startDate = DateTime(
        _selectedRange!.start.year,
        _selectedRange!.start.month,
        _selectedRange!.start.day,
      );

      final endDate = DateTime(
        _selectedRange!.end.year,
        _selectedRange!.end.month,
        _selectedRange!.end.day,
        23,
        59,
        59,
      );

      q = q
          .where('lastSeenAt', isGreaterThanOrEqualTo: startDate)
          .where('lastSeenAt', isLessThanOrEqualTo: endDate);
    }
    // ✅ فلترة category
    if (_selectedCategories.isNotEmpty) {
      q = q.where('category', whereIn: _selectedCategories.toList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير الجرد", "Inventory Reports")),
        backgroundColor: const Color(0xFFD4AF37), // دهبي
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentDocs.isEmpty ? null : _printReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Colors.blue, Color(0xFF64B5F6)],
              icon: Icons.inventory_2_rounded,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: q.snapshots(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: _t('لا توجد عمليات جرد', 'No inventory actions'),
                      subtitle: _t('ابدأ بعملية جرد جديدة',
                          'Start a new inventory action'),
                    );
                  }
                  List<QueryDocumentSnapshot> filteredDocs = docs;

                  if (_selectedKinds.isNotEmpty) {
                    filteredDocs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final kind = data['payload']?['kind'];
                      return _selectedKinds.contains(kind);
                    }).toList();
                  }
                  if (_selectedTypes.isNotEmpty) {
                    filteredDocs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final kind = data['payload']?['type'];
                      return _selectedTypes.contains(kind);
                    }).toList();
                  }

                  final totals = _calcTotalsFromDocs(filteredDocs);
                  final allCategories = docs
                      .map(
                          (e) => (e.data() as Map<String, dynamic>)['category'])
                      .whereType<String>()
                      .toSet()
                      .toList();

                  final allKinds = docs
                      .map((e) => (e.data() as Map<String, dynamic>)['payload']
                          ?['kind'])
                      .whereType<String>()
                      .toSet()
                      .toList();
                  final allTypes = docs
                      .map((e) => (e.data() as Map<String, dynamic>)['payload']
                          ?['type'])
                      .whereType<String>()
                      .toSet()
                      .toList();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentDocs = filteredDocs;
                      });
                    }
                  });

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      // ✅ فلتر الأقسام

                      if (allCategories.isNotEmpty)
                        Text(
                          _t('اختر القسم', 'Select Type'),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: allCategories.map((cat) {
                          final selected = _selectedCategories.contains(cat);
                          return FilterChip(
                            label: Text(cat),
                            selected: selected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _selectedCategories.add(cat);
                                } else {
                                  _selectedCategories.remove(cat);
                                }
                                // لما القسم يتغير نمسح اختيار النوع
                                _selectedKinds.clear();
                                _selectedTypes.clear();
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),
                      // ✅ فلتر النوع
                      if (_selectedCategories.isNotEmpty &&
                          (allKinds.isNotEmpty || allTypes.isNotEmpty)) ...[
                        // 🔹 العنوان مع السهم
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isTypeExpanded = !_isTypeExpanded;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _t('اختر النوع', 'Select Type'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                _isTypeExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🔹 يظهر فقط لو مفتوح
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: _isTypeExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              // ✅ KINDS
                              ...allKinds.map((kind) {
                                final selected = _selectedKinds.contains(kind);
                                return FilterChip(
                                  label: Text(kind),
                                  selected: selected,
                                  onSelected: (val) {
                                    setState(() {
                                      val
                                          ? _selectedKinds.add(kind)
                                          : _selectedKinds.remove(kind);
                                    });
                                  },
                                );
                              }),

                              // ✅ TYPES
                              ...allTypes.map((type) {
                                final selected = _selectedTypes.contains(type);
                                return FilterChip(
                                  label: Text(type),
                                  selected: selected,
                                  onSelected: (val) {
                                    setState(() {
                                      val
                                          ? _selectedTypes.add(type)
                                          : _selectedTypes.remove(type);
                                    });
                                  },
                                );
                              }),
                            ],
                          ),
                          secondChild: const SizedBox(),
                        ),

                        const SizedBox(height: 12),
                      ],

                      const SizedBox(height: 12),
                      _buildBarChart(totals, lang: _lang),
                      const SizedBox(height: 12),
                      _TotalsCard(totals: totals, lang: _lang),
                      const SizedBox(height: 12),
                      ...filteredDocs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return Material(
                          color: Colors.transparent,
                          child: _buildItemCard(
                              context: context,
                              epcHex: data['epcHex'] ?? '',
                              category: data['category'] as String?,
                              createdAt:
                                  (data['createdAt'] as Timestamp?)?.toDate(),
                              payload: data['payload'] as Map<String, dynamic>?,
                              payment: data['payment'] as Map<String, dynamic>?,
                              theme: theme,
                              showPrice: false,
                              lang: _lang),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesList extends StatefulWidget {
  const _SalesList();
  @override
  State<_SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<_SalesList> {
  DateTimeRange? _selectedRange;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  // New Features
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedKinds = {};
  final Set<String> _selectedTypes = {};
  bool _isTypeExpanded = false;
  List<QueryDocumentSnapshot> _currentDocs = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    // ✅ تعيين اليوم الحالي كـ default range
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    _selectedRange = DateTimeRange(start: startOfDay, end: endOfDay);
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  List<List<QueryDocumentSnapshot>> _groupSalesDocs(
      List<QueryDocumentSnapshot> docs) {
    final grouped = <String, List<QueryDocumentSnapshot>>{};
    final order = <String>[];

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final saleGroupId = (data['saleGroupId'] as String?)?.trim();
      final key = (saleGroupId?.isNotEmpty == true) ? saleGroupId! : doc.id;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
        order.add(key);
      }
      grouped[key]!.add(doc);
    }

    return order.map((key) => grouped[key]!).toList();
  }

  List<Widget> _buildSalesReportWidgets(
      List<QueryDocumentSnapshot> docs, ThemeData theme) {
    final groups = _groupSalesDocs(docs);
    return groups.map((group) {
      if (group.length == 1) {
        final data = group.first.data() as Map<String, dynamic>;
        return Material(
          color: Colors.transparent,
          child: _buildItemCard(
            context: context,
            epcHex: data['payload']?['qrCode']?.toString() ??
                data['epcHex']?.toString() ??
                '',
            category: data['category'] as String?,
            createdAt: (data['soldAt'] as Timestamp?)?.toDate(),
            payload: data['payload'] as Map<String, dynamic>?,
            payment: data['payment'] as Map<String, dynamic>?,
            theme: theme,
            showPrice: true,
            lang: _lang,
          ),
        );
      }
      return _buildGroupedSaleCard(group, theme);
    }).toList();
  }

  Widget _buildGroupedSaleCard(
      List<QueryDocumentSnapshot> group, ThemeData theme) {
    final first = group.first.data() as Map<String, dynamic>;
    final soldAt = (first['soldAt'] as Timestamp?)?.toDate();
    final soldByValues = group
        .map((doc) =>
            ((doc.data() as Map<String, dynamic>)['payment']
                    as Map<String, dynamic>?)?['soldBy']
                ?.toString() ??
            '')
        .where((value) => value.isNotEmpty)
        .toSet();
    final groupSoldBy =
        soldByValues.length == 1 ? soldByValues.first : _t('متعدد', 'Multiple');

    final totalWeight = group.fold<double>(0, (sum, doc) {
      final payload = ((doc.data() as Map<String, dynamic>)['payload'] ?? {})
          as Map<String, dynamic>;
      return sum + (double.tryParse(payload['weight']?.toString() ?? '0') ?? 0);
    });
    final totalWage = group.fold<double>(0, (sum, doc) {
      final payload = ((doc.data() as Map<String, dynamic>)['payload'] ?? {})
          as Map<String, dynamic>;
      return sum + (double.tryParse(payload['wage']?.toString() ?? '0') ?? 0);
    });
    final totalCost = group.fold<double>(0, (sum, doc) {
      final payload = ((doc.data() as Map<String, dynamic>)['payload'] ?? {})
          as Map<String, dynamic>;
      return sum + (double.tryParse(payload['cost']?.toString() ?? '0') ?? 0);
    });
    final totalPaid = group.fold<double>(0, (sum, doc) {
      final payment = ((doc.data() as Map<String, dynamic>)['payment'] ?? {})
          as Map<String, dynamic>;
      return sum + (double.tryParse(payment['total']?.toString() ?? '0') ?? 0);
    });

    return Material(
      color: Colors.transparent,
      child: Card(
        color: Colors.yellow.shade50,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_t('مجموعة بيع', 'Sale group')} (${group.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (groupSoldBy.isNotEmpty)
                        Text('${_t('بواسطة', 'Sold by')}: $groupSoldBy'),
                      if (soldAt != null)
                        Text(DateFormat('yyyy/MM/dd HH:mm').format(soldAt)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // كل قطعة تعرض بتفاصيلها العادية
              ...group.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: _buildItemCard(
                      context: context,
                      epcHex: data['payload']?['qrCode']?.toString() ??
                          data['epcHex']?.toString() ??
                          '',
                      category: data['category'] as String?,
                      createdAt: (data['soldAt'] as Timestamp?)?.toDate(),
                      payload: data['payload'] as Map<String, dynamic>?,
                      payment: data['payment'] as Map<String, dynamic>?,
                      theme: theme,
                      showPrice: true,
                      lang: _lang,
                    ),
                  ),
                );
              }),

              const SizedBox(height: 6),
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, right: 6),
                  child: Text(
                    '${_t('المجموع الكلي للمجموعة', 'Group Total')}: ${totalPaid.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String translateCategory(String? category) {
    switch (category) {
      case 'bullion':
        return "سبائك";
      case 'gem':
        return "أحجار";
      case 'gold':
        return "ذهب";
      default:
        return "غير محدد";
    }
  }

  Future<void> _printReport() async {
    if (_currentDocs.isEmpty) return;
    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    // تحويل docs إلى List<Map>
    final items =
        _currentDocs.map((e) => e.data() as Map<String, dynamic>).toList();

    // حساب الإجماليات من نفس البيانات المعروضة
    double totalWeight = 0;
    double totalWage = 0;
    double totalCost = 0;

    int totalCount = 0;
    int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
    double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

    for (var doc in _currentDocs) {
      final item = doc.data() as Map<String, dynamic>;
      final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      final carat = payload['carat']?.toString();
      final category = item['category']?.toString();
      totalCount++;
      totalWeight += weight;
      totalWage += wage;
      totalCost += cost;

      if (carat == "18") {
        count18++;
        weight18 += weight;
      }
      if (carat == "21") {
        count21++;
        weight21 += weight;
      }
      if (carat == "22") {
        count22++;
        weight22 += weight;
      }
      if (category == "bullion") {
        countBullion++;
        weightBullion += weight;
      }
      if (category == "gem") {
        countGem++;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (context) => [
          pw.Text(
            "تقارير البيع",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1.5),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(0.8),
              6: pw.FlexColumnWidth(1.2),
              7: pw.FlexColumnWidth(1.2),
              8: pw.FlexColumnWidth(1.5),
              9: pw.FlexColumnWidth(1.5),
            },
            children: [
              /// 🔹 HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "قسم",
                  "تاريخ",
                  "وزن",
                  "أجر",
                  "عيار",
                  "نوع",
                  "تكلفة",
                  "مكونات",
                  "ملاحظات"
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// 🔹 DATA ROWS (من نفس الفلترة)
              ...items.map((item) {
                final date = (item['soldAt'] as Timestamp?)?.toDate();
                final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

                /// 🔸 كود + QR
                pw.Widget codeWidget;

                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: payload['qrCode'],
                            width: 20,
                            height: 20),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: payload['qrCode'],
                            width: 40,
                            height: 15,
                            drawText: false),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: codeWidget,
                    ),
                    pw.Text(translateCategory(item['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        payload['type']?.toString().isNotEmpty == true
                            ? payload['type'].toString()
                            : (payload['kind']?.toString() ?? "—"),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 15),

          /*pw.Text(
            "عدد العناصر: ${items.length}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),*/
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "إجماليات التقرير",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Bullet(
                  text: "إجمالي عدد الشرائح: $totalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "عدد الأحجار الكريمة : $countGem",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الوزن الكلي : ${totalWeight.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي الأجر الكلي : ${totalWage.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي التكلفة الكلية : ${totalCost.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Query q = FS.salesCol().orderBy('soldAt', descending: true);

    if (_selectedRange != null) {
      final startDate = DateTime(
        _selectedRange!.start.year,
        _selectedRange!.start.month,
        _selectedRange!.start.day,
      );

      final endDate = DateTime(
        _selectedRange!.end.year,
        _selectedRange!.end.month,
        _selectedRange!.end.day,
        23,
        59,
        59,
      );

      q = q
          .where('soldAt', isGreaterThanOrEqualTo: startDate)
          .where('soldAt', isLessThanOrEqualTo: endDate);
    }
    // ✅ فلترة category
    if (_selectedCategories.isNotEmpty) {
      q = q.where('category', whereIn: _selectedCategories.toList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير المبيعات", "Sales Reports")),
        backgroundColor: const Color(0xFFD4AF37), // دهبي
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentDocs.isEmpty ? null : _printReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Colors.green, Color(0xFF81C784)],
              icon: Icons.sell_rounded,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: q.snapshots(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.sell_outlined,
                      title: _t('لا توجد مبيعات', 'No Sales'),
                      subtitle: _t('ابدأ بعملية بيع جديدة', 'Start a new sale'),
                    );
                  }

                  List<QueryDocumentSnapshot> filteredDocs = docs;

                  if (_selectedKinds.isNotEmpty) {
                    filteredDocs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final kind = data['payload']?['kind'];
                      return _selectedKinds.contains(kind);
                    }).toList();
                  }
                  if (_selectedTypes.isNotEmpty) {
                    filteredDocs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final kind = data['payload']?['type'];
                      return _selectedTypes.contains(kind);
                    }).toList();
                  }

                  final totals = _calcTotalsFromDocs(filteredDocs);
                  final allCategories = docs
                      .map(
                          (e) => (e.data() as Map<String, dynamic>)['category'])
                      .whereType<String>()
                      .toSet()
                      .toList();

                  final allKinds = docs
                      .map((e) => (e.data() as Map<String, dynamic>)['payload']
                          ?['kind'])
                      .whereType<String>()
                      .toSet()
                      .toList();
                  final allTypes = docs
                      .map((e) => (e.data() as Map<String, dynamic>)['payload']
                          ?['type'])
                      .whereType<String>()
                      .toSet()
                      .toList();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentDocs = filteredDocs;
                      });
                    }
                  });

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      if (allCategories.isNotEmpty)
                        Text(
                          _t('اختر القسم', 'Select Type'),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: allCategories.map((cat) {
                          final selected = _selectedCategories.contains(cat);
                          return FilterChip(
                            label: Text(cat),
                            selected: selected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _selectedCategories.add(cat);
                                } else {
                                  _selectedCategories.remove(cat);
                                }
                                // لما القسم يتغير نمسح اختيار النوع
                                _selectedKinds.clear();
                                _selectedTypes.clear();
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),
                      // ✅ فلتر النوع
                      if (_selectedCategories.isNotEmpty &&
                          (allKinds.isNotEmpty || allTypes.isNotEmpty)) ...[
                        // 🔹 العنوان مع السهم
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isTypeExpanded = !_isTypeExpanded;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _t('اختر النوع', 'Select Type'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                _isTypeExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🔹 يظهر فقط لو مفتوح
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: _isTypeExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              // ✅ KINDS
                              ...allKinds.map((kind) {
                                final selected = _selectedKinds.contains(kind);
                                return FilterChip(
                                  label: Text(kind),
                                  selected: selected,
                                  onSelected: (val) {
                                    setState(() {
                                      val
                                          ? _selectedKinds.add(kind)
                                          : _selectedKinds.remove(kind);
                                    });
                                  },
                                );
                              }),

                              // ✅ TYPES
                              ...allTypes.map((type) {
                                final selected = _selectedTypes.contains(type);
                                return FilterChip(
                                  label: Text(type),
                                  selected: selected,
                                  onSelected: (val) {
                                    setState(() {
                                      val
                                          ? _selectedTypes.add(type)
                                          : _selectedTypes.remove(type);
                                    });
                                  },
                                );
                              }),
                            ],
                          ),
                          secondChild: const SizedBox(),
                        ),

                        const SizedBox(height: 12),
                      ],
                      _buildBarChart(totals, showPrice: true, lang: _lang),
                      const SizedBox(height: 12),
                      _TotalsCard(totals: totals, showPrice: true, lang: _lang),
                      const SizedBox(height: 12),
                      ..._buildSalesReportWidgets(filteredDocs, theme),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingList extends StatefulWidget {
  const _MissingList();

  @override
  State<_MissingList> createState() => _MissingListState();
}

class _MissingListState extends State<_MissingList> {
  DateTimeRange? _selectedRange;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  // New Features
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedKinds = {};
  final Set<String> _selectedTypes = {};
  bool _isTypeExpanded = false;
  List<QueryDocumentSnapshot> _currentDocs = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    // ✅ تعيين اليوم الحالي كـ default range
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    _selectedRange = DateTimeRange(start: startOfDay, end: endOfDay);
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  static String translateCategory(String? category) {
    switch (category) {
      case 'bullion':
        return "سبائك";
      case 'gem':
        return "أحجار";
      case 'gold':
        return "ذهب";
      default:
        return "غير محدد";
    }
  }

  Future<void> _printReport() async {
    if (_currentDocs.isEmpty) return;
    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
    );

    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
    );

    final pdf = pw.Document();

    // تحويل docs إلى List<Map>
    final items =
        _currentDocs.map((e) => e.data() as Map<String, dynamic>).toList();

    // حساب الإجماليات من نفس البيانات المعروضة
    double totalWeight = 0;
    double totalWage = 0;
    double totalCost = 0;

    int totalCount = 0;
    int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
    double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

    for (var doc in _currentDocs) {
      final item = doc.data() as Map<String, dynamic>;
      final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      final carat = payload['carat']?.toString();
      final category = item['category']?.toString();
      totalCount++;
      totalWeight += weight;
      totalWage += wage;
      totalCost += cost;

      if (carat == "18") {
        count18++;
        weight18 += weight;
      }
      if (carat == "21") {
        count21++;
        weight21 += weight;
      }
      if (carat == "22") {
        count22++;
        weight22 += weight;
      }
      if (category == "bullion") {
        countBullion++;
        weightBullion += weight;
      }
      if (category == "gem") {
        countGem++;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (context) => [
          pw.Text(
            "تقارير المفقود",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1.5),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(0.8),
              6: pw.FlexColumnWidth(1.2),
              7: pw.FlexColumnWidth(1.2),
              8: pw.FlexColumnWidth(1.5),
              9: pw.FlexColumnWidth(1.5),
            },
            children: [
              /// 🔹 HEADER
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "قسم",
                  "تاريخ",
                  "وزن",
                  "أجر",
                  "عيار",
                  "نوع",
                  "تكلفة",
                  "مكونات",
                  "ملاحظات"
                ]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              /// 🔹 DATA ROWS (من نفس الفلترة)
              ...items.map((item) {
                final date = (item['createdAt'] as Timestamp?)?.toDate();
                final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

                /// 🔸 كود + QR
                pw.Widget codeWidget;

                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: payload['qrCode'],
                            width: 20,
                            height: 20),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: payload['qrCode'],
                            width: 40,
                            height: 15,
                            drawText: false),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: codeWidget,
                    ),
                    pw.Text(translateCategory(item['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        payload['type']?.toString().isNotEmpty == true
                            ? payload['type'].toString()
                            : (payload['kind']?.toString() ?? "—"),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 15),

          /*pw.Text(
            "عدد العناصر: ${items.length}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),*/
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "إجماليات التقرير",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Bullet(
                  text: "إجمالي عدد الشرائح: $totalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "عدد الأحجار الكريمة : $countGem",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الوزن الكلي : ${totalWeight.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي الأجر الكلي : ${totalWage.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي التكلفة الكلية : ${totalCost.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final itemsStream = FS.itemsCol().snapshots();
    final salesStream = FS.salesCol().snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تقارير المفقود", "Missing Reports")),
        backgroundColor: const Color(0xFFD4AF37), // دهبي
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _currentDocs.isEmpty ? null : _printReport,
        child: const Icon(Icons.print),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _HeaderWithRangePicker(
              title: '',
              onPick: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedRange,
                );
                if (picked != null) setState(() => _selectedRange = picked);
              },
              range: _selectedRange,
              gradientColors: const [Colors.red, Color(0xFFE57373)],
              icon: Icons.warning_amber_rounded,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: itemsStream,
                builder: (ctx, itemsSnap) {
                  if (!itemsSnap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // ✅ الحالة الأولى: مفيش فترة مختارة → المفقود نهائياً
                  if (_selectedRange == null) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: salesStream,
                      builder: (ctx, salesSnap) {
                        if (!salesSnap.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final soldEpcs = salesSnap.data!.docs
                            .map((d) => d['epcHex'] as String)
                            .toSet();

                        final allInvStream = FS.invCol().snapshots();

                        return StreamBuilder<QuerySnapshot>(
                          stream: allInvStream,
                          builder: (ctx, allInvSnap) {
                            if (!allInvSnap.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final invAll = allInvSnap.data!.docs
                                .map((d) => d['epcHex'] as String)
                                .toSet();

                            final items = itemsSnap.data!.docs;

                            // المفقود نهائياً = items - invAll - sold
                            final missingDocs = items.where((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final epc = data['epcHex'];
                              return !invAll.contains(epc) &&
                                  !soldEpcs.contains(epc);
                            }).toList();

                            if (missingDocs.isEmpty) {
                              return _buildEmptyState(
                                icon: Icons.report_problem,
                                title: _t('لا يوجد مفقود', 'No Missing'),
                                subtitle: _t('كل العناصر تم جردها أو مباعة',
                                    'All items are inventoried or sold'),
                              );
                            }

                            final totals = _calcTotalsFromDocs(missingDocs);

                            return ListView(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 24),
                              children: [
                                _buildBarChart(totals, lang: _lang),
                                const SizedBox(height: 12),
                                _TotalsCard(totals: totals, lang: _lang),
                                const SizedBox(height: 12),
                                ...missingDocs.map((d) {
                                  final data = d.data() as Map<String, dynamic>;
                                  return _buildItemCard(
                                      context: context,
                                      epcHex: data['epcHex'] ?? '',
                                      category: data['category'] as String?,
                                      createdAt:
                                          (data['createdAt'] as Timestamp?)
                                              ?.toDate(),
                                      payload: data['payload']
                                          as Map<String, dynamic>?,
                                      payment: data['payment']
                                          as Map<String, dynamic>?,
                                      theme: theme,
                                      showPrice: false,
                                      lang: _lang);
                                }),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }

                  // ✅ الحالة الثانية: فترة محددة → المفقود في الفترة
                  final invStream = FS
                      .invCol()
                      .where('lastSeenAt',
                          isGreaterThanOrEqualTo: _selectedRange!.start)
                      .where('lastSeenAt',
                          isLessThanOrEqualTo: _selectedRange!.end)
                      .snapshots();

                  return StreamBuilder<QuerySnapshot>(
                    stream: invStream,
                    builder: (ctx, invSnap) {
                      if (!invSnap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return StreamBuilder<QuerySnapshot>(
                        stream: salesStream,
                        builder: (ctx, salesSnap) {
                          if (!salesSnap.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final items = itemsSnap.data!.docs;
                          final invInRange = invSnap.data!.docs
                              .map((d) => d['epcHex'] as String)
                              .toSet();

                          /*final soldEpcs = salesSnap.data!.docs
                              .map((d) => d['epcHex'] as String)
                              .toSet();*/

                          // المفقود في الفترة = items - invInRange - sold
                          final missingDocs = items.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final epc = data['epcHex'];
                            return !invInRange.contains(epc);
                          }).toList();

                          if (missingDocs.isEmpty) {
                            return _buildEmptyState(
                              icon: Icons.warning_amber_outlined,
                              title: _t('لا يوجد مفقود', 'No Missing'),
                              subtitle: _t('كل العناصر تم جردها أو مباعة',
                                  'All items are inventoried or sold'),
                            );
                          }
                          List<QueryDocumentSnapshot> filteredDocs =
                              missingDocs;

                          if (_selectedCategories.isNotEmpty) {
                            filteredDocs = missingDocs.where((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return _selectedCategories
                                  .contains(data['category']);
                            }).toList();
                          }

                          if (_selectedKinds.isNotEmpty) {
                            filteredDocs = missingDocs.where((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final kind = data['payload']?['kind'];
                              return _selectedKinds.contains(kind);
                            }).toList();
                          }
                          if (_selectedTypes.isNotEmpty) {
                            filteredDocs = missingDocs.where((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final kind = data['payload']?['type'];
                              return _selectedTypes.contains(kind);
                            }).toList();
                          }

                          final totals = _calcTotalsFromDocs(filteredDocs);
                          final allCategories = missingDocs
                              .map((e) => (e.data()
                                  as Map<String, dynamic>)['category'])
                              .whereType<String>()
                              .toSet()
                              .toList();

                          final allKinds = missingDocs
                              .map((e) => (e.data()
                                  as Map<String, dynamic>)['payload']?['kind'])
                              .whereType<String>()
                              .toSet()
                              .toList();
                          final allTypes = missingDocs
                              .map((e) => (e.data()
                                  as Map<String, dynamic>)['payload']?['type'])
                              .whereType<String>()
                              .toSet()
                              .toList();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _currentDocs = filteredDocs;
                              });
                            }
                          });

                          return ListView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            children: [
                              if (allCategories.isNotEmpty)
                                Text(
                                  _t('اختر القسم', 'Select Type'),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: allCategories.map((cat) {
                                  final selected =
                                      _selectedCategories.contains(cat);
                                  return FilterChip(
                                    label: Text(cat),
                                    selected: selected,
                                    onSelected: (val) {
                                      setState(() {
                                        if (val) {
                                          _selectedCategories.add(cat);
                                        } else {
                                          _selectedCategories.remove(cat);
                                        }
                                        // لما القسم يتغير نمسح اختيار النوع
                                        _selectedKinds.clear();
                                        _selectedTypes.clear();
                                      });
                                    },
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 8),
                              // ✅ فلتر النوع
                              if (_selectedCategories.isNotEmpty &&
                                  (allKinds.isNotEmpty ||
                                      allTypes.isNotEmpty)) ...[
                                // 🔹 العنوان مع السهم
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isTypeExpanded = !_isTypeExpanded;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _t('اختر النوع', 'Select Type'),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        _isTypeExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // 🔹 يظهر فقط لو مفتوح
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 200),
                                  crossFadeState: _isTypeExpanded
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      /// ✅ لو فيها gold → اعرض allKinds
                                      if (_selectedCategories.contains("gold"))
                                        ...allKinds.map((kind) {
                                          final selected =
                                              _selectedKinds.contains(kind);
                                          return FilterChip(
                                            label: Text(kind),
                                            selected: selected,
                                            onSelected: (val) {
                                              setState(() {
                                                val
                                                    ? _selectedKinds.add(kind)
                                                    : _selectedKinds
                                                        .remove(kind);
                                              });
                                            },
                                          );
                                        }),

                                      /// ✅ لو فيها gem → اعرض allTypes
                                      if (_selectedCategories.contains("gem"))
                                        ...allTypes.map((type) {
                                          final selected =
                                              _selectedTypes.contains(type);
                                          return FilterChip(
                                            label: Text(type),
                                            selected: selected,
                                            onSelected: (val) {
                                              val
                                                  ? _selectedTypes.add(type)
                                                  : _selectedTypes.remove(type);
                                            },
                                          );
                                        }),
                                    ],
                                  ),
                                  secondChild: const SizedBox(),
                                ),

                                const SizedBox(height: 12),
                              ],
                              _buildBarChart(totals, lang: _lang),
                              const SizedBox(height: 12),
                              _TotalsCard(totals: totals, lang: _lang),
                              const SizedBox(height: 12),
                              ...filteredDocs.map((d) {
                                final data = d.data() as Map<String, dynamic>;
                                return _buildItemCard(
                                    context: context,
                                    epcHex: data['epcHex'] ?? '',
                                    category: data['category'] as String?,
                                    createdAt: (data['createdAt'] as Timestamp?)
                                        ?.toDate(),
                                    payload: data['payload']
                                        as Map<String, dynamic>?,
                                    payment: data['payment']
                                        as Map<String, dynamic>?,
                                    theme: theme,
                                    showPrice: false,
                                    lang: _lang);
                              }),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _SetRemaindersList extends StatefulWidget {
//   const _SetRemaindersList();

//   @override
//   State<_SetRemaindersList> createState() => _SetRemaindersListState();
// }

// class _SetRemaindersListState extends State<_SetRemaindersList> {
//   DateTimeRange? _selectedRange;
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   Set<String> _selectedCategories = {};
//   Set<String> _selectedKinds = {};
//   Set<String> _selectedTypes = {};
//   bool _isTypeExpanded = false;
//   List<QueryDocumentSnapshot> _currentDocs = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   static String translateCategory(String? category) {
//     switch (category) {
//       case 'bullion':
//         return "سبائك";
//       case 'gem':
//         return "أحجار";
//       case 'gold':
//         return "ذهب";
//       default:
//         return "غير محدد";
//     }
//   }

//   Future<void> _printReport() async {
//     if (_currentDocs.isEmpty) return;
//     final arabicFont = pw.Font.ttf(
//       await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"),
//     );

//     final arabicFontBold = pw.Font.ttf(
//       await rootBundle.load("assets/fonts/NotoSansArabic-Bold.ttf"),
//     );

//     final pdf = pw.Document();

//     final items =
//         _currentDocs.map((e) => e.data() as Map<String, dynamic>).toList();

//     double totalWeight = 0;
//     double totalWage = 0;
//     double totalCost = 0;

//     int totalCount = 0;
//     int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
//     double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

//     for (var doc in _currentDocs) {
//       final item = doc.data() as Map<String, dynamic>;
//       final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

//       final carat = payload['carat']?.toString();
//       final category = item['category']?.toString();
//       totalCount++;
//       totalWeight += weight;
//       totalWage += wage;
//       totalCost += cost;

//       if (carat == "18") {
//         count18++;
//         weight18 += weight;
//       }
//       if (carat == "21") {
//         count21++;
//         weight21 += weight;
//       }
//       if (carat == "22") {
//         count22++;
//         weight22 += weight;
//       }
//       if (category == "bullion") {
//         countBullion++;
//         weightBullion += weight;
//       }
//       if (category == "gem") {
//         countGem++;
//       }
//     }

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(
//           base: arabicFont,
//           bold: arabicFontBold,
//         ),
//         build: (context) => [
//           pw.Text(
//             "تقارير بقايا الأطقم",
//             style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//           ),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(
//               color: PdfColors.grey300,
//               width: 0.5,
//             ),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(2),
//               1: pw.FlexColumnWidth(1),
//               2: pw.FlexColumnWidth(1.5),
//               3: pw.FlexColumnWidth(1),
//               4: pw.FlexColumnWidth(1),
//               5: pw.FlexColumnWidth(0.8),
//               6: pw.FlexColumnWidth(1.2),
//               7: pw.FlexColumnWidth(1.2),
//               8: pw.FlexColumnWidth(1.5),
//               9: pw.FlexColumnWidth(1.5),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "كود",
//                   "قسم",
//                   "تاريخ",
//                   "وزن متبقي",
//                   "أجر متبقي",
//                   "عيار",
//                   "نوع",
//                   "وزن مباع",
//                   "مكونات متبقية",
//                   "ملاحظات"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(
//                             e,
//                             textAlign: pw.TextAlign.center,
//                             style: pw.TextStyle(
//                               fontSize: 10,
//                               fontWeight: pw.FontWeight.bold,
//                             ),
//                           ),
//                         ))
//                     .toList(),
//               ),
//               ...items.map((item) {
//                 final date = (item['createdAt'] as Timestamp?)?.toDate();
//                 final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

//                 pw.Widget codeWidget;

//                 if (payload['qrCode'] != null) {
//                   if (payload['showQr'] == true) {
//                     codeWidget = pw.Column(
//                       mainAxisSize: pw.MainAxisSize.min,
//                       children: [
//                         pw.BarcodeWidget(
//                             barcode: pw.Barcode.qrCode(),
//                             data: payload['qrCode'],
//                             width: 20,
//                             height: 20),
//                         pw.SizedBox(height: 1),
//                         pw.Text(payload['qrCode']?.toString() ?? "—",
//                             style: pw.TextStyle(fontSize: 6)),
//                       ],
//                     );
//                   } else {
//                     codeWidget = pw.Column(
//                       mainAxisSize: pw.MainAxisSize.min,
//                       children: [
//                         pw.BarcodeWidget(
//                             barcode: pw.Barcode.code128(),
//                             data: payload['qrCode'],
//                             width: 40,
//                             height: 15,
//                             drawText: false),
//                         pw.SizedBox(height: 1),
//                         pw.Text(payload['qrCode']?.toString() ?? "—",
//                             style: pw.TextStyle(fontSize: 6)),
//                       ],
//                     );
//                   }
//                 } else {
//                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
//                 }

//                 return pw.TableRow(
//                   children: [
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Center(child: codeWidget),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(
//                         translateCategory(item['category']?.toString()),
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(fontSize: 8),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(
//                         date != null
//                             ? "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
//                             : "—",
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(fontSize: 8),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(
//                         payload['weight']?.toString() ?? "0",
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(fontSize: 8),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(
//                         payload['wage']?.toString() ?? "0",
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(fontSize: 8),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(
//                         payload['carat']?.toString() ?? "—",
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(fontSize: 8),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(
//                         payload['kind']?.toString() ??
//                             payload['type']?.toString() ??
//                             "—",
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(fontSize: 8),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(
//                         payload['soldWeight']?.toString() ?? "—",
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(fontSize: 8, color: PdfColors.red),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(
//                         (item['remainingComponents'] as List<dynamic>?)
//                                 ?.join(", ") ??
//                             "—",
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(fontSize: 7),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(
//                         payload['notes']?.toString() ?? "—",
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(fontSize: 7),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text(
//             "الإجماليات: العدد: $totalCount | الوزن: ${totalWeight.toStringAsFixed(2)} | الأجر: ${totalWage.toStringAsFixed(2)} | التكلفة: ${totalCost.toStringAsFixed(2)}",
//             style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//             textAlign: pw.TextAlign.center,
//           ),
//         ],
//       ),
//     );

//     await Printing.layoutPdf(
//       onLayout: (format) async => pdf.save(),
//     );
//   }

//   Future<void> _restoreRemainderToBalance({
//     required QueryDocumentSnapshot doc,
//     required String newStickerCode,
//   }) async {
//     final data = doc.data() as Map<String, dynamic>;
//     final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//     final category = data['category']?.toString();

//     if (category == null || category.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('لا يمكن استعادة هذا العنصر بدون نوع')),
//       );
//       return;
//     }

//     final updatedPayload = Map<String, dynamic>.from(payload)
//       ..['qrCode'] = newStickerCode
//       ..['showQr'] = payload['showQr'] ?? true;

//     try {
//       await FS.saveItem(
//         epcHex: newStickerCode,
//         category: category,
//         date: DateTime.now(),
//         payload: updatedPayload,
//         fromOpeningBalance: false,
//       );

//       await doc.reference.delete();
//       await _printLabelForCategory(
//         category: category,
//         payload: updatedPayload,
//       );

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('تمت استعادة العنصر وطباعة الاستيكر بنجاح')),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('فشل استعادة العنصر: ${e.toString()}')),
//       );
//     }
//   }

//   Future<void> _printLabelForCategory({
//     required String category,
//     required Map<String, dynamic> payload,
//   }) async {
//     final qrCode = payload['qrCode']?.toString().trim() ?? '';
//     final showQr = (payload['showQr'] == false) ? 'false' : 'true';

//     final layoutType = switch (category) {
//       'gold' => 'gold',
//       'bullion' => 'bullion',
//       'gem' => 'gem',
//       _ => 'gold'
//     };
//     final layout = await LabelLayoutStorage.load(layoutType);
//     final prefs = await SharedPreferences.getInstance();
//     final logo = prefs.getString('custom_logo_base64');

//     switch (category) {
//       case 'gold':
//         await NewPrinterAPI.printGoldLabel(
//           weight: payload['weight']?.toString(),
//           carat: payload['carat']?.toString(),
//           size: payload['size']?.toString(),
//           showQr: showQr,
//           qrCode: qrCode,
//           customLogoBase64: logo,
//           labelLayout: layout.toJson(),
//         );
//         break;
//       case 'bullion':
//         await NewPrinterAPI.printBullionLabel(
//           weight: payload['weight']?.toString(),
//           note1: payload['notes']?.toString() ?? payload['kind']?.toString(),
//           note2: payload['type']?.toString(),
//           showQr: showQr,
//           qrCode: qrCode,
//           customLogoBase64: logo,
//           labelLayout: layout.toJson(),
//         );
//         break;
//       case 'gem':
//         await NewPrinterAPI.printGemLabel(
//           gemType: payload['type']?.toString() ?? payload['kind']?.toString(),
//           note1: payload['notes']?.toString(),
//           note2: payload['carat']?.toString(),
//           showQr: showQr,
//           qrCode: qrCode,
//           customLogoBase64: logo,
//           labelLayout: layout.toJson(),
//         );
//         break;
//       default:
//         break;
//     }
//   }

//   Future<void> _showRestoreDialog({
//     required QueryDocumentSnapshot doc,
//   }) async {
//     final controller = TextEditingController();
//     final data = doc.data() as Map<String, dynamic>;
//     final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//     final currentCode = payload['qrCode']?.toString() ?? '';

//     await showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: Directionality(
//             textDirection: ui.TextDirection.rtl,
//             child: const Text('إدخال كود الاستيكر الجديد'),
//           ),
//           content: Directionality(
//             textDirection: ui.TextDirection.rtl,
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText:
//                     currentCode.isEmpty ? 'أدخل الكود الجديد' : currentCode,
//                 labelText: 'الكود الجديد',
//               ),
//               textDirection: ui.TextDirection.rtl,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext),
//               child: const Text('إلغاء'),
//             ),
//             FilledButton(
//               onPressed: () async {
//                 final newCode = controller.text.trim();
//                 if (newCode.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('يرجى إدخال كود الاستيكر')),
//                   );
//                   return;
//                 }
//                 Navigator.pop(dialogContext);
//                 await _restoreRemainderToBalance(
//                   doc: doc,
//                   newStickerCode: newCode,
//                 );
//               },
//               child: const Text('حفظ وطباعة'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     Query q = FS.setRemaindersCol().orderBy('createdAt', descending: true);

//     if (_selectedRange != null) {
//       final startDate = DateTime(
//         _selectedRange!.start.year,
//         _selectedRange!.start.month,
//         _selectedRange!.start.day,
//       );

//       final endDate = DateTime(
//         _selectedRange!.end.year,
//         _selectedRange!.end.month,
//         _selectedRange!.end.day,
//         23,
//         59,
//         59,
//       );

//       q = q
//           .where('createdAt', isGreaterThanOrEqualTo: startDate)
//           .where('createdAt', isLessThanOrEqualTo: endDate);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("تقارير بقايا الأطقم", "Set Remainders Reports")),
//         backgroundColor: const Color(0xFFD4AF37),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFD4AF37),
//         child: const Icon(Icons.print),
//         onPressed: _currentDocs.isEmpty ? null : _printReport,
//       ),
//       body: Container(
//         margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             _HeaderWithRangePicker(
//               title: '',
//               onPick: () async {
//                 final picked = await showDateRangePicker(
//                   context: context,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime.now(),
//                   initialDateRange: _selectedRange,
//                 );
//                 if (picked != null) setState(() => _selectedRange = picked);
//               },
//               range: _selectedRange,
//               gradientColors: const [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
//               icon: Icons.inventory_2_outlined,
//             ),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: q.snapshots(),
//                 builder: (ctx, snap) {
//                   if (!snap.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   final docs = snap.data!.docs;
//                   if (docs.isEmpty) {
//                     return _buildEmptyState(
//                       icon: Icons.inventory_2_outlined,
//                       title: _t('لا يوجد بقايا أطقم', 'No Set Remainders'),
//                       subtitle: _t('لم يتم تسجيل أي بيع جزئي للأطقم',
//                           'No partial set sales recorded'),
//                     );
//                   }

//                   List<QueryDocumentSnapshot> filteredDocs = docs;

//                   if (_selectedCategories.isNotEmpty) {
//                     filteredDocs = docs.where((doc) {
//                       final data = doc.data() as Map<String, dynamic>;
//                       return _selectedCategories.contains(data['category']);
//                     }).toList();
//                   }

//                   if (_selectedKinds.isNotEmpty) {
//                     filteredDocs = filteredDocs.where((doc) {
//                       final data = doc.data() as Map<String, dynamic>;
//                       final kind = data['payload']?['kind'];
//                       return _selectedKinds.contains(kind);
//                     }).toList();
//                   }

//                   if (_selectedTypes.isNotEmpty) {
//                     filteredDocs = filteredDocs.where((doc) {
//                       final data = doc.data() as Map<String, dynamic>;
//                       final type = data['payload']?['type'];
//                       return _selectedTypes.contains(type);
//                     }).toList();
//                   }

//                   final totals = _calcTotalsFromDocs(filteredDocs);

//                   final allCategories = docs
//                       .map(
//                           (e) => (e.data() as Map<String, dynamic>)['category'])
//                       .whereType<String>()
//                       .toSet()
//                       .toList();

//                   final allKinds = docs
//                       .map((e) => (e.data() as Map<String, dynamic>)['payload']
//                           ?['kind'])
//                       .whereType<String>()
//                       .toSet()
//                       .toList();

//                   final allTypes = docs
//                       .map((e) => (e.data() as Map<String, dynamic>)['payload']
//                           ?['type'])
//                       .whereType<String>()
//                       .toSet()
//                       .toList();

//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     if (mounted) {
//                       setState(() {
//                         _currentDocs = filteredDocs;
//                       });
//                     }
//                   });

//                   return ListView(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//                     children: [
//                       if (allCategories.isNotEmpty)
//                         Text(
//                           _t('اختر القسم', 'Select Category'),
//                           style: const TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 4,
//                         children: allCategories.map((cat) {
//                           final selected = _selectedCategories.contains(cat);
//                           return FilterChip(
//                             label: Text(cat),
//                             selected: selected,
//                             onSelected: (val) {
//                               setState(() {
//                                 if (val) {
//                                   _selectedCategories.add(cat);
//                                 } else {
//                                   _selectedCategories.remove(cat);
//                                 }
//                                 _selectedKinds.clear();
//                                 _selectedTypes.clear();
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ),
//                       const SizedBox(height: 8),
//                       if (_selectedCategories.isNotEmpty &&
//                           (allKinds.isNotEmpty || allTypes.isNotEmpty)) ...[
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               _isTypeExpanded = !_isTypeExpanded;
//                             });
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 _t('اختر النوع', 'Select Type'),
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Icon(
//                                 _isTypeExpanded
//                                     ? Icons.keyboard_arrow_up
//                                     : Icons.keyboard_arrow_down,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         AnimatedCrossFade(
//                           duration: const Duration(milliseconds: 200),
//                           crossFadeState: _isTypeExpanded
//                               ? CrossFadeState.showFirst
//                               : CrossFadeState.showSecond,
//                           firstChild: Wrap(
//                             spacing: 8,
//                             runSpacing: 4,
//                             children: [
//                               if (_selectedCategories.contains("gold"))
//                                 ...allKinds.map((kind) {
//                                   final selected =
//                                       _selectedKinds.contains(kind);
//                                   return FilterChip(
//                                     label: Text(kind),
//                                     selected: selected,
//                                     onSelected: (val) {
//                                       setState(() {
//                                         val
//                                             ? _selectedKinds.add(kind)
//                                             : _selectedKinds.remove(kind);
//                                       });
//                                     },
//                                   );
//                                 }),
//                               if (_selectedCategories.contains("gem"))
//                                 ...allTypes.map((type) {
//                                   final selected =
//                                       _selectedTypes.contains(type);
//                                   return FilterChip(
//                                     label: Text(type),
//                                     selected: selected,
//                                     onSelected: (val) {
//                                       val
//                                           ? _selectedTypes.add(type)
//                                           : _selectedTypes.remove(type);
//                                     },
//                                   );
//                                 }),
//                             ],
//                           ),
//                           secondChild: const SizedBox(),
//                         ),
//                         const SizedBox(height: 12),
//                       ],
//                       _buildBarChart(totals, lang: _lang),
//                       const SizedBox(height: 12),
//                       _TotalsCard(totals: totals, lang: _lang),
//                       const SizedBox(height: 12),
//                       ...filteredDocs.map((d) {
//                         final data = d.data() as Map<String, dynamic>;
//                         return _buildItemCard(
//                             context: context,
//                             epcHex: data['epcHex'] ?? '',
//                             category: data['category'] as String?,
//                             createdAt:
//                                 (data['createdAt'] as Timestamp?)?.toDate(),
//                             payload: data['payload'] as Map<String, dynamic>?,
//                             payment: data['payment'] as Map<String, dynamic>?,
//                             theme: theme,
//                             showPrice: false,
//                             lang: _lang,
//                             extraAction: IconButton(
//                               tooltip:
//                                   _t('إدخال استيكر جديد', 'Enter new sticker'),
//                               icon: const Icon(Icons.add_box_outlined,
//                                   color: Colors.white),
//                               onPressed: () => _showRestoreDialog(doc: d),
//                             ));
//                       }),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/* =========================
 * عناصر مشتركة
 * ========================= */

class _HeaderWithRangePicker extends StatelessWidget {
  final String title;
  final VoidCallback onPick;
  final DateTimeRange? range;
  final List<Color> gradientColors;
  final IconData icon;

  const _HeaderWithRangePicker({
    required this.title,
    required this.onPick,
    required this.range,
    required this.gradientColors,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColors.first.withOpacity(0.10),
            gradientColors.last.withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(icon, color: gradientColors.first, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: gradientColors.first,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.date_range),
            label: Text(
              range == null
                  ? 'select range'
                  : '${range!.start.toString().split(" ").first} → ${range!.end.toString().split(" ").first}',
            ),
          ),
        ],
      ),
    );
  }
}

/// يحسب الإجماليات بنفس منطق صفحة الجرد
Map<String, dynamic> _calcTotalsFromDocs(List<QueryDocumentSnapshot> docs) {
  double totalWeight = 0;
  double totalWage = 0;
  double totalCost = 0;

  double totalPrice = 0; // ✅ جديد (إجمالي كل المبيعات)
  double totalvisa = 0;
  double totalcash = 0;

  double bullionWeight = 0;
  double bullionWage = 0;
  int bullionCount = 0;
  double totalPriceBullion = 0; // ✅ جديد
  double totalvisaBullion = 0;
  double totalcashBullion = 0;

  double carat18 = 0, carat18Wage = 0;
  int carat18Count = 0;
  double totalPrice18 = 0; // ✅ جديد
  double totalvisa18 = 0;
  double totalcash18 = 0;

  double carat21 = 0, carat21Wage = 0;
  int carat21Count = 0;
  double totalPrice21 = 0; // ✅ جديد
  double totalvisa21 = 0;
  double totalcash21 = 0;

  double carat22 = 0, carat22Wage = 0;
  int carat22Count = 0;
  double totalPrice22 = 0; // ✅ جديد
  double totalvisa22 = 0;
  double totalcash22 = 0;

  int gemsCount = 0;
  double gemsCost = 0;
  double totalPriceGems = 0; // ✅ جديد (لو عايز ثمن الأحجار كمان)
  double totalvisaGems = 0;
  double totalcashGems = 0;

  for (final doc in docs) {
    final map = doc.data() as Map<String, dynamic>;
    final payload = (map['payload'] as Map<String, dynamic>?) ?? {};
    final category = map['category'] as String?;
    final payment = (map['payment'] as Map<String, dynamic>?) ?? {}; // ✅ جديد
    final price = _asDouble(payment['total']); // ✅ جديد (السعر من بيانات الدفع)
    final visa = _asDouble(payment['visa']);
    final cash = _asDouble(payment['cash']);

    totalPrice += price; // ✅ جديد (تجميع السعر الكلي)
    totalvisa += visa;
    totalcash += cash;

    if (category == 'gold') {
      final weight = _asDouble(payload['weight']);
      final wage = _asDouble(payload['wage']);
      final carat = payload['carat']?.toString();

      totalWeight += weight;
      totalWage += wage;

      if (carat == '18') {
        carat18 += weight;
        carat18Wage += wage;
        carat18Count++;
        totalPrice18 += price; // ✅ جديد
        totalvisa18 += visa;
        totalcash18 += cash;
      } else if (carat == '21') {
        carat21 += weight;
        carat21Wage += wage;
        carat21Count++;
        totalPrice21 += price; // ✅ جديد
        totalvisa21 += visa;
        totalcash21 += cash;
      } else if (carat == '22') {
        carat22 += weight;
        carat22Wage += wage;
        carat22Count++;
        totalPrice22 += price; // ✅ جديد
        totalvisa22 += visa;
        totalcash22 += cash;
      }
    } else if (category == 'gem') {
      final cost = _asDouble(payload['cost']);
      totalCost += cost;
      gemsCost += cost;
      gemsCount++;
      totalPriceGems += price; // ✅ جديد
      totalvisaGems += visa;
      totalcashGems += cash;
    } else if (category == 'bullion') {
      final weight = _asDouble(payload['weight']);
      final wage = _asDouble(payload['wage']);
      totalWeight += weight;
      totalWage += wage;
      bullionWeight += weight;
      bullionWage += wage;
      bullionCount++;
      totalPriceBullion += price; // ✅ جديد
      totalvisaBullion += visa;
      totalcashBullion += cash;
    }
  }

  return {
    'count': docs.length,
    'totalWeight': totalWeight,
    'totalWage': totalWage,
    'totalCost': totalCost,
    'totalPrice': totalPrice,
    'totalvisa': totalvisa,
    'totalcash': totalcash,

    'bullionWeight': bullionWeight,
    'bullionWage': bullionWage,
    'bullionCount': bullionCount,
    'bullionPrice': totalPriceBullion, // ✅ مظبوط
    'totalvisaBullion': totalvisaBullion,
    'totalcashBullion': totalcashBullion,

    'carat18': carat18,
    'carat18Wage': carat18Wage,
    'carat18Count': carat18Count,
    'carat18Price': totalPrice18, // ✅ مظبوط
    'totalvisa18': totalvisa18,
    'totalcash18': totalcash18,

    'carat21': carat21,
    'carat21Wage': carat21Wage,
    'carat21Count': carat21Count,
    'carat21Price': totalPrice21, // ✅ مظبوط
    'totalvisa21': totalvisa21,
    'totalcash21': totalcash21,

    'carat22': carat22,
    'carat22Wage': carat22Wage,
    'carat22Count': carat22Count,
    'carat22Price': totalPrice22, // ✅ مظبوط
    'totalvisa22': totalvisa22,
    'totalcash22': totalcash22,

    'gemsCount': gemsCount,
    'gemsCost': gemsCost,
    'gemsPrice': totalPriceGems, // ✅ مظبوط
    'totalvisaGems': totalvisaGems,
    'totalcashGems': totalcashGems,
  };
}

double _asDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  final s = v.toString().trim();
  if (s.isEmpty) return 0;
  return double.tryParse(s) ?? 0;
}

class _TotalsCard extends StatelessWidget {
  final Map<String, dynamic> totals;
  final bool showPrice;
  final String lang; // 'ar' أو 'en'
  const _TotalsCard(
      {required this.totals, this.showPrice = false, this.lang = 'ar'});

  String t(String ar, String en) => lang == 'ar' ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📊 ${t("الإجماليات", "Totals")}",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const Divider(color: Colors.white24),
            Text("⭐ ${t("عيار 18", "18 Carat")}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white)),
            _summaryRow(Icons.format_list_numbered, t('عدد الشرائح', 'Count'),
                totals['carat18Count'].toString()),
            _summaryRow(Icons.scale, t('إجمالي الوزن', 'Total Weight'),
                '${(totals['carat18'] as double).toStringAsFixed(2)} جم'),
            _summaryRow(Icons.attach_money, t('إجمالي الأجر', 'Total Wage'),
                (totals['carat18Wage'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الكاش', 'Total Cash'),
                  (totals['totalcash18'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الشبكة', 'Total Visa'),
                  (totals['totalvisa18'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي السعر', 'Total Price'),
                  (totals['carat18Price'] as double).toStringAsFixed(2)),
            const Divider(color: Colors.white24),
            Text("⭐ ${t("عيار 21", "21 Carat")}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white)),
            _summaryRow(Icons.format_list_numbered, t('عدد الشرائح', 'Count'),
                totals['carat21Count'].toString()),
            _summaryRow(Icons.scale, t('إجمالي الوزن', 'Total Weight'),
                '${(totals['carat21'] as double).toStringAsFixed(2)} جم'),
            _summaryRow(Icons.attach_money, t('إجمالي الأجر', 'Total Wage'),
                (totals['carat21Wage'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الكاش', 'Total Cash'),
                  (totals['totalcash21'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الشبكة', 'Total Visa'),
                  (totals['totalvisa21'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي السعر', 'Total Price'),
                  (totals['carat21Price'] as double).toStringAsFixed(2)),
            const Divider(color: Colors.white24),
            Text("⭐ ${t("عيار 22", "22 Carat")}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white)),
            _summaryRow(Icons.format_list_numbered, t('عدد الشرائح', 'Count'),
                totals['carat22Count'].toString()),
            _summaryRow(Icons.scale, t('إجمالي الوزن', 'Total Weight'),
                '${(totals['carat22'] as double).toStringAsFixed(2)} جم'),
            _summaryRow(Icons.attach_money, t('إجمالي الأجر', 'Total Wage'),
                (totals['carat22Wage'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الكاش', 'Total Cash'),
                  (totals['totalcash22'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الشبكة', 'Total Visa'),
                  (totals['totalvisa22'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي السعر', 'Total Price'),
                  (totals['carat22Price'] as double).toStringAsFixed(2)),
            const Divider(color: Colors.white24),
            Text("🏅 ${t("السبائك", "Bullions")}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white)),
            _summaryRow(Icons.format_list_numbered, t('عدد الشرائح', 'Count'),
                totals['bullionCount'].toString()),
            _summaryRow(Icons.scale, t('إجمالي الوزن', 'Total Weight'),
                '${(totals['bullionWeight'] as double).toStringAsFixed(2)} جم'),
            _summaryRow(Icons.attach_money, t('إجمالي الأجر', 'Total Wage'),
                (totals['bullionWage'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الكاش', 'Total Cash'),
                  (totals['totalcashBullion'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الشبكة', 'Total Visa'),
                  (totals['totalvisaBullion'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي السعر', 'Total Price'),
                  (totals['bullionPrice'] as double).toStringAsFixed(2)),
            const Divider(color: Colors.white24),
            Text("💎 ${t("الأحجار", "Gems")}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white)),
            _summaryRow(
                Icons.format_list_numbered,
                t('عدد الشرائح (أحجار)', 'Count (Gems)'),
                totals['gemsCount'].toString()),
            _summaryRow(Icons.attach_money, t('إجمالي التكلفة', 'Total Cost'),
                (totals['gemsCost'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الكاش', 'Total Cash'),
                  (totals['totalcashGems'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الشبكة', 'Total Visa'),
                  (totals['totalvisaGems'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي السعر', 'Total Price'),
                  (totals['gemsPrice'] as double).toStringAsFixed(2)),
            const Divider(color: Colors.white24),
            Text("📌 ${t("الملخص العام", "General Summary")}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white)),
            _summaryRow(
                Icons.format_list_numbered,
                t('إجمالي عدد الشرائح', 'Total Count'),
                totals['count'].toString()),
            _summaryRow(Icons.scale, t('إجمالي الوزن الكلي', 'Total Weight'),
                '${(totals['totalWeight'] as double).toStringAsFixed(2)} جم'),
            _summaryRow(
                Icons.attach_money,
                t('إجمالي الأجر الكلي', 'Total Wage'),
                (totals['totalWage'] as double).toStringAsFixed(2)),
            _summaryRow(
                Icons.attach_money,
                t('إجمالي التكلفة الكلية', 'Total Cost'),
                (totals['totalCost'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الكاش', 'Total Cash'),
                  (totals['totalcash'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي الشبكة', 'Total Visa'),
                  (totals['totalvisa'] as double).toStringAsFixed(2)),
            if (showPrice)
              _summaryRow(Icons.attach_money, t('إجمالي السعر', 'Total Price'),
                  (totals['totalPrice'] as double).toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  static Widget _summaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Color(0xFFD4AF37)),
          const SizedBox(width: 8),
          const SizedBox(width: 4),
          Text('$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildEmptyState({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: 48,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildItemCard({
  required BuildContext context,
  required String epcHex,
  required String? category,
  required DateTime? createdAt,
  required Map<String, dynamic>? payload,
  required Map<String, dynamic>? payment,
  required ThemeData theme,
  required bool showPrice,
  required String lang, // 'ar' أو 'en'
  Widget? extraAction,
}) {
  String t(String ar, String en) => lang == 'ar' ? ar : en;

  IconData categoryIcon;
  Color categoryColor;
  String categoryName;

  switch (category) {
    case 'gold':
      categoryIcon = Icons.workspace_premium_rounded;
      categoryColor = const Color(0xFFD4AF37);
      categoryName = t('ذهب', 'Gold');
      break;
    case 'gem':
      categoryIcon = Icons.diamond_rounded;
      categoryColor = Colors.purple;
      categoryName = t('أحجار كريمة', 'Gems');
      break;
    case 'scrap':
      categoryIcon = Icons.recycling_rounded;
      categoryColor = Colors.orange;
      categoryName = t('كسر', 'Scrap');
      break;
    case 'bullion':
      categoryIcon = Icons.account_balance;
      categoryColor = const Color(0xFFD4AF37);
      categoryName = t('سبائك', 'Bullion');
      break;
    default:
      categoryIcon = Icons.help_outline_rounded;
      categoryColor = Colors.grey;
      categoryName = t('غير محدد', 'Unknown');
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: categoryColor.withOpacity(0.2)),
    ),
    child: ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(categoryIcon, color: categoryColor, size: 20),
      ),
      title: Text(
        epcHex,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              categoryName,
              style: TextStyle(
                color: categoryColor.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            createdAt?.toString().split('.').first ?? '',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      children: [
        if (payload != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العمود الأول: البيانات
                Expanded(
                  flex: 2,
                  child: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 عرض payload
                        ...payload.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  _getPayloadIcon(entry.key),
                                  size: 16,
                                  color: categoryColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: RichText(
                                    textDirection: ui.TextDirection.rtl,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${t(entry.key, entry.key)}: ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: entry.value.toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        // 🔹 عرض payment لو showPrice = true
                        if (payment != null && showPrice) ...[
                          const Divider(color: Colors.white24),
                          ...payment.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.payment_rounded,
                                    size: 16,
                                    color: Colors.greenAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: RichText(
                                      textDirection: ui.TextDirection.rtl,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${t(entry.key, entry.key)}: ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: entry.value.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
                if (extraAction != null) ...[
                  const SizedBox(width: 8),
                  extraAction,
                ],
                const SizedBox(width: 5),

                // العمود التاني: الكيوار أو الباركود + زرار عرض الصور تحتها
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (payload['qrCode'] != null)
                        Center(
                          child: (payload['showQr'] == true)
                              ? QrImageView(
                                  data: payload['qrCode'],
                                  version: QrVersions.auto,
                                  size: 100.0,
                                  backgroundColor: Colors.white,
                                )
                              : Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(4.0),
                                  child: BarcodeWidget(
                                    barcode: Barcode.code128(),
                                    data: payload['qrCode'],
                                    width: 100,
                                    height: 40,
                                  ),
                                ),
                        ),
                      if (payment == null && !showPrice) ...[
                        const SizedBox(height: 8),

                        // زرار عرض الصور دا هيظهر مهما كان في QR أو باركود
                        GestureDetector(
                          onTap: () async {
                            final uid = FirebaseAuth.instance.currentUser!.uid;
                            final storageRef = FirebaseStorage.instance
                                .ref()
                                .child('images')
                                .child('users')
                                .child(uid)
                                .child(epcHex);

                            try {
                              final ListResult result =
                                  await storageRef.listAll();
                              if (result.items.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(t('لا يوجد صور محفوظة',
                                          'No saved images'))),
                                );
                                return;
                              }

                              final urls = await Future.wait(
                                result.items.map((ref) => ref.getDownloadURL()),
                              );

                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          t('صورة الشريحة', 'Chip Images'),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 400,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: urls.length,
                                            itemBuilder: (_, i) => Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Image.network(urls[i]),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(t('إغلاق', 'Close')),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(t('فشل تحميل الصور',
                                        'Failed to load images'))),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.image,
                                    color: Colors.white, size: 30),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                t('عرض الصور', 'View Images'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

IconData _getPayloadIcon(String key) {
  switch (key) {
    case 'carat':
      return Icons.grade_rounded;
    case 'weight':
      return Icons.scale_rounded;
    case 'wage':
    case 'cost':
      return Icons.attach_money_rounded;
    case 'kind':
    case 'type':
      return Icons.category_rounded;
    case 'notes':
      return Icons.note_rounded;
    default:
      return Icons.info_outline_rounded;
  }
}
