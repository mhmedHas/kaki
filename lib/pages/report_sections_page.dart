// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'print_page.dart';

// class ReportSectionsPage extends StatefulWidget {
//   final DateTime start;
//   final DateTime end;
//   final bool isTotalReport;

//   const ReportSectionsPage({
//     super.key,
//     required this.start,
//     required this.end,
//     this.isTotalReport = false,
//   });

//   @override
//   State<ReportSectionsPage> createState() => _ReportSectionsPageState();
// }

// class _ReportSectionsPageState extends State<ReportSectionsPage> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
//   late Set<ReportSection> _selected;

//   static const Map<ReportSection, IconData> _icons = {
//     ReportSection.openingBalance: Icons.account_balance_wallet,
//     ReportSection.entry: Icons.add_box,
//     ReportSection.missing: Icons.report_problem,
//     ReportSection.inventory: Icons.inventory,
//     ReportSection.updates: Icons.edit,
//     ReportSection.sales: Icons.shopping_cart,
//     ReportSection.sellersTotals: Icons.people,
//     ReportSection.transfers: Icons.mail_rounded,
//     ReportSection.scrap: Icons.handyman,
//     ReportSection.vouchers: Icons.receipt,
//     ReportSection.expenses: Icons.money_off,
//     ReportSection.deposits: Icons.upload,
//     ReportSection.imports: Icons.download,
//     ReportSection.safeTotals: Icons.account_balance,
// ReportSection.generalBalance: Icons.assessment_outlined,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     _selected = ReportSection.values.toSet();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!mounted) return;
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   bool get _allSelected => _selected.length == ReportSection.values.length;

//   void _toggleAll() {
//     setState(() {
//       if (_allSelected) {
//         _selected.clear();
//       } else {
//         _selected = ReportSection.values.toSet();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t('اختر أقسام التقرير', 'Select Report Sections')),
//         backgroundColor: const Color(0xFFD4AF37),
//       ),
//       body: Directionality(
//         textDirection: _lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               color: const Color(0xFFD4AF37).withOpacity(0.12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(children: [
//                     const Icon(Icons.date_range, color: Color(0xFFD4AF37)),
//                     const SizedBox(width: 8),
//                     Text(_t('الفترة المحددة', 'Selected Period'),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16)),
//                   ]),
//                   const SizedBox(height: 6),
//                   Padding(
//                     padding: const EdgeInsetsDirectional.only(start: 32),
//                     child: Text(
//                       '${widget.start.toString().split(' ').first}  →  ${widget.end.toString().split(' ').first}',
//                       style:
//                           const TextStyle(fontSize: 14, color: Colors.black54),
//                     ),
//                   ),
//                   if (widget.isTotalReport)
//                     Padding(
//                       padding:
//                           const EdgeInsetsDirectional.only(start: 32, top: 4),
//                       child: Text(
//                         _t('تقرير الإجماليات', 'Totals Report'),
//                         style: const TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             CheckboxListTile(
//               value: _allSelected,
//               onChanged: (_) => _toggleAll(),
//               title: Text(_t('تحديد الكل', 'Select All'),
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 17)),
//               secondary: const Icon(Icons.select_all, color: Color(0xFFD4AF37)),
//               activeColor: const Color(0xFFD4AF37),
//             ),
//             const Divider(height: 1),
//             Expanded(
//               child: ListView.separated(
//                 itemCount: ReportSection.values.length,
//                 separatorBuilder: (_, __) => const Divider(height: 1),
//                 itemBuilder: (_, i) {
//                   final section = ReportSection.values[i];
//                   return CheckboxListTile(
//                     value: _selected.contains(section),
//                     onChanged: (val) {
//                       setState(() {
//                         if (val == true) {
//                           _selected.add(section);
//                         } else {
//                           _selected.remove(section);
//                         }
//                       });
//                     },
//                     title: Text(section.getLabel(_lang)),
//                     secondary:
//                         Icon(_icons[section], color: const Color(0xFFD4AF37)),
//                     activeColor: const Color(0xFFD4AF37),
//                   );
//                 },
//               ),
//             ),
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: _selected.isEmpty
//                         ? null
//                         : () => Navigator.pop(context, _selected),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFD4AF37),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     icon: const Icon(Icons.print, color: Colors.white),
//                     label: Text(
//                       '${_t('طباعة', 'Print')} (${_selected.length}/${ReportSection.values.length})',
//                       style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'print_page.dart';

class ReportSectionsPage extends StatefulWidget {
  final DateTime start;
  final DateTime end;
  final bool isTotalReport;

  const ReportSectionsPage({
    super.key,
    required this.start,
    required this.end,
    this.isTotalReport = false,
  });

  @override
  State<ReportSectionsPage> createState() => _ReportSectionsPageState();
}

class _ReportSectionsPageState extends State<ReportSectionsPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  late Set<ReportSection> _selected;

  static const Map<ReportSection, IconData> _icons = {
    ReportSection.openingBalance: Icons.account_balance_wallet,
    ReportSection.entry: Icons.add_box,
    ReportSection.missing: Icons.report_problem,
    ReportSection.inventory: Icons.inventory,
    ReportSection.updates: Icons.edit,
    ReportSection.sales: Icons.shopping_cart,
    ReportSection.sellersTotals: Icons.people,
    ReportSection.transfers: Icons.mail_rounded,
    ReportSection.scrap: Icons.handyman,
    ReportSection.vouchers: Icons.receipt,
    ReportSection.expenses: Icons.money_off,
    ReportSection.deposits: Icons.upload,
    ReportSection.imports: Icons.download,
    ReportSection.safeTotals: Icons.account_balance,
    ReportSection.generalBalance: Icons.assessment_outlined, // ✅ جديد
  };

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _selected = ReportSection.values.toSet();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  bool get _allSelected => _selected.length == ReportSection.values.length;

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selected.clear();
      } else {
        _selected = ReportSection.values.toSet();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t('اختر أقسام التقرير', 'Select Report Sections')),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Directionality(
        textDirection: _lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            // فترة التقرير
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFD4AF37).withOpacity(0.12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.date_range, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 8),
                    Text(_t('الفترة المحددة', 'Selected Period'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ]),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 32),
                    child: Text(
                      '${widget.start.toString().split(' ').first}  →  ${widget.end.toString().split(' ').first}',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  if (widget.isTotalReport)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 32, top: 4),
                      child: Text(
                        _t('تقرير الإجماليات', 'Totals Report'),
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),

            // تحديد الكل
            CheckboxListTile(
              value: _allSelected,
              onChanged: (_) => _toggleAll(),
              title: Text(_t('تحديد الكل', 'Select All'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17)),
              secondary: const Icon(Icons.select_all, color: Color(0xFFD4AF37)),
              activeColor: const Color(0xFFD4AF37),
            ),
            const Divider(height: 1),

            // الأقسام
            Expanded(
              child: ListView.separated(
                itemCount: ReportSection.values.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final section = ReportSection.values[i];
                  return CheckboxListTile(
                    value: _selected.contains(section),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selected.add(section);
                        } else {
                          _selected.remove(section);
                        }
                      });
                    },
                    title: Text(section.getLabel(_lang)),
                    secondary:
                        Icon(_icons[section], color: const Color(0xFFD4AF37)),
                    activeColor: const Color(0xFFD4AF37),
                  );
                },
              ),
            ),

            // زر الطباعة
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _selected.isEmpty
                        ? null
                        : () => Navigator.pop(context, _selected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.print, color: Colors.white),
                    label: Text(
                      '${_t('طباعة', 'Print')} (${_selected.length}/${ReportSection.values.length})',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
